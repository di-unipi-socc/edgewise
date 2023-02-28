import argparse as ap
import os
import sys
from multiprocessing import Manager, Process

import pandas as pd
from classes import Application
from classes.utils import BUDGETS_FILE, check_app, check_infr, df_to_file
from colorama import Fore, init
from orsolver import or_solver
from orsolver_num import or_solver_num
from tabulate import tabulate


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-s", "--save", action="store_true", help="if set, saves the results in csv format.")
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw).")
	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")

	return p


def find_best(results: pd.DataFrame):
    # get row with min # bins at the min cost
    min_cost = results['Cost'].min()
    best = results.loc[(results['Cost'] == min_cost)]
    best = best.iloc[0]
    return best


def get_best(results, save_results=False):
    df = pd.DataFrame.from_dict(results, orient='index')
    df.index.name = 'MaxBins'
    df.sort_index(inplace=True)
    
    tab = tabulate(df, headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
    print(Fore.LIGHTYELLOW_EX + tab)
    
    best = None
    if not df.empty:
        best = find_best(df).to_dict()
        best_tab = tabulate([best], headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
        print(Fore.LIGHTGREEN_EX + best_tab)

        df_to_file(df, BUDGETS_FILE) if save_results else None

    return best

def or_budgeting(app, infr, version='pre', save_results=False, result=""):
	
	if type(result) != str:  # if result is not a string, redirect output tu /dev/null
		sys.stdout = open(os.devnull, 'w')

	app = Application(app)
	S = len(app.services + app.functions)

	manager = Manager()
	bdg_result = manager.dict()
	processes = []
	for i in range(S):
		if version == 'pre':
			p = Process(target=or_solver, args=(app.get_file(), infr, i+1, False, False, False, False, bdg_result))
		else:
			p = Process(target=or_solver_num, args=(app.get_file(), infr, i+1, False, False, False, bdg_result))
		p.start()
		processes.append(p)

	for p in processes:
		p.join()

	res = get_best(bdg_result, save_results=save_results)
	if type(result) != str and res:
		name = 'ortools' if version == 'pre' else 'ortools-num'
		result[name] = res


if __name__ == '__main__':

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()
    
	app = check_app(args.app)
	infr = check_infr(args.infr, args.dummy)

	or_budgeting(app=app, infr=infr, save_results=args.save)