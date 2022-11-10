import os
import sys
import argparse as ap
import pandas as pd

from colorama import Fore, init
from multiprocessing import Process, Manager
from tabulate import tabulate

from googleOR import or_solver_pre as or_solver
from googleOR.classes import Application
from googleOR.classes.utils import DATA_DIR


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

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


def print_results(results):
    df = pd.DataFrame.from_dict(results, orient='index')
    df.index.name = 'MaxBins'
    df.sort_index(inplace=True)
    # df = df[['App', 'Cost', 'Time', 'NDistinct', 'Size']]
    tab = tabulate(df, headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
    print(Fore.LIGHTYELLOW_EX + tab)
    
    best = [find_best(df).to_dict()]
    best_tab = tabulate(best, headers='keys', tablefmt='fancy_grid', numalign="center", stralign="center")
    print(Fore.LIGHTGREEN_EX + best_tab)

    # save results on csv
    '''filename = os.path.join(DATA_DIR, 'budgets.csv')
    if not os.path.isfile(filename):
        df.to_csv(filename)
    else:
        df.to_csv(filename, mode='a', header=False)
    '''

def main(app_name, infr_name):
    app = Application(app_name)
    S = len(app.services + app.functions)

    manager = Manager()
    result = manager.dict()
    processes = []
    for i in range(S):
        p = Process(target=or_solver, args=(app_name, infr_name, i+1, False, False, False, False, result))
        p.start()
        processes.append(p)

    for p in processes:
        p.join()

    print_results(result)


if __name__ == '__main__':

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	main(app_name=args.app, infr_name=args.infr)