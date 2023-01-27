import argparse as ap
import os
import sys
from multiprocessing import Manager, Process

import pandas as pd
from classes import Application
from classes.utils import OUTPUT_DIR
from colorama import Fore, init
from orsolver import or_solver
from tabulate import tabulate


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-s", "--save", action="store_true", help="if set, saves the results in csv format.")
	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")

	return p


def find_best(results: pd.DataFrame):
    # get row with min # bins at the min cost
    best = None
    if not results.empty:
        min_cost = results['Cost'].min()
        best = results.loc[(results['Cost'] == min_cost)]
        best = best.iloc[0]
    return best


def get_best(results, save_results):
    df = pd.DataFrame.from_dict(results, orient='index')
    df.index.name = 'MaxBins'
    df.sort_index(inplace=True)
    
    tab = tabulate(df, headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
    print(Fore.LIGHTYELLOW_EX + tab)
    
    best = find_best(df).to_dict()
    best_tab = tabulate([best], headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
    print(Fore.LIGHTGREEN_EX + best_tab)
	
    if save_results:
        filename = os.path.join(OUTPUT_DIR, 'budgets.csv')
        if not os.path.isfile(filename):
            df.to_csv(filename)
        else:
            df.to_csv(filename, mode='a', header=False)

    return best

def or_budgeting(app_name, infr_name, save=False, result=""):

    if type(result) != str:  # if result is not a string, redirect output tu /dev/null
        sys.stdout = open(os.devnull, 'w')
    
    app = Application(app_name)
    S = len(app.services + app.functions)

    manager = Manager()
    bdg_result = manager.dict()
    processes = []
    for i in range(S):
        p = Process(target=or_solver, args=(app_name, infr_name, i+1, False, False, False, False, bdg_result))
        p.start()
        processes.append(p)

    for p in processes:
        p.join()

    result['ortools'] = get_best(bdg_result)


if __name__ == '__main__':

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	or_budgeting(app_name=args.app, infr_name=args.infr, save=args.save)