import argparse as ap
import shutil
import tempfile
from os.path import basename, join
from multiprocessing import Manager, Process

from classes import Application, Infrastructure
from classes.utils import PL_UTILS_DIR, check_files
from swiplserver import PrologError, PrologMQI, prolog_args
from compare import main as cmp

def init_parser() -> ap.ArgumentParser:
	description = "Perform several experiments on a given application and infrastructure"
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw).")

	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")
	p.add_argument("budget", type=int, help="Maximum budget.")
	p.add_argument("versions", nargs='*',
	               help="List of the versions to compare. Valid ones can be found in \"versions/\" folder.")

	return p


def create_tmp_copy(path):
    # create a temporary copy file of the infrastructure
    tmp_dir = tempfile.gettempdir()
    tmp_path = join(tmp_dir, basename(path))
    shutil.copyfile(path, tmp_path)
    return tmp_path

def main(app, infr, budget, versions):

    pl_sol = or_sol = True
    # while pl_sol or or_sol:
    r = cmp(app, infr, budget, versions, ortools=True, budgeting=True)
    

if __name__ == '__main__':
    
    parser = init_parser()
    args = parser.parse_args()

    app, infr, vs = check_files(app=args.app, infr=args.infr, versions=args.versions, dummy_infr=args.dummy)
    infr = create_tmp_copy(infr)

    main(app=app, infr=infr, versions=vs, budget=args.budget)
