import argparse as ap
import shutil
import tempfile
from multiprocessing import Manager, Process
from os.path import basename, join

from classes import Infrastructure
from classes.utils import check_files, EDGEWISE
from colorama import Fore, init
from compare import compute_allocated_resources, or_budgeting, pl_process

# 1h in seconds
TIMEOUT = 3600


def init_parser() -> ap.ArgumentParser:
	description = "Perform several experiments on a given application and infrastructure"
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw).")

	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")

	return p


def create_tmp_copy(path, tmp_dir, tool='or'):
    tmp_path = join(tmp_dir, f'{tool}_{basename(path)}')
    shutil.copyfile(path, tmp_path)
    return tmp_path


def exp_replace_same_app(app, pl_infr_path, or_infr_path, pl_version):

    pl_sol = or_sol = True
    manager = Manager()
    result = manager.dict()

    pl_key = basename(pl_version)
    or_key = EDGEWISE

    infr_pl = Infrastructure(pl_infr_path)
    infr_or = Infrastructure(or_infr_path)

    iteration = 1
    while pl_sol or or_sol:
        print(Fore.LIGHTCYAN_EX + f"Start iteration {iteration}")

        process_pl = Process(target=pl_process, args=(pl_version, app, pl_infr_path, result))
        process_pl.start()
            
        process_or = Process(target=or_budgeting, args=(app, or_infr_path, False, result))
        process_or.start()

        process_pl.join(TIMEOUT)
        process_or.join(TIMEOUT)

        process_pl.terminate() if process_pl.is_alive() else None
        process_or.terminate() if process_or.is_alive() else None

        if result:
            result = dict(result)
            if pl_key in result:
                print(Fore.LIGHTGREEN_EX + "Found solution with PL")
                result[pl_key].update(compute_allocated_resources(app, pl_infr_path, result[pl_key]['Placement']))
                infr_pl.update_allocated_resources(result[pl_key]['AllocHW'], result[pl_key]['AllocBW'])
                infr_pl.upload()
            else:
                pl_sol = False

            if or_key in result:
                print(Fore.LIGHTGREEN_EX + "Found solution with OR")
                result[or_key].update(compute_allocated_resources(app, or_infr_path, result[or_key]['Placement']))
                infr_or.update_allocated_resources(result[or_key]['AllocHW'], result[or_key]['AllocBW'])
                infr_or.upload()
            else:
                or_sol = False

            print(Fore.LIGHTCYAN_EX + f"End iteration {iteration}\n")
            iteration += 1
        else:
            print(Fore.LIGHTRED_EX + "No solution found.")
            break
        
if __name__ == '__main__':

    init(autoreset=True)
    
    parser = init_parser()
    args = parser.parse_args()

    app, infr, vs = check_files(app=args.app, infr=args.infr, versions=['binpack'], dummy_infr=args.dummy)

    with tempfile.TemporaryDirectory() as tmp_dir:
        print(Fore.LIGHTCYAN_EX + f"Temporary directory: {tmp_dir}", end='\n\n')
        pl_infr_path = create_tmp_copy(infr, tmp_dir, tool='pl')
        or_infr_path = create_tmp_copy(infr, tmp_dir, tool='or')

        exp_replace_same_app(app=app, pl_infr_path=pl_infr_path, or_infr_path=or_infr_path, pl_version=vs[0])