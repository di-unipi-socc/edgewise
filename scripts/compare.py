import argparse as ap
import os
from multiprocessing import Manager, Process
from os.path import basename, join

import pandas as pd
from budgeting import or_budgeting
from classes import Infrastructure
from classes.utils import (ALLOC_QUERY, COMPARISON_FILE, MAIN_QUERY, TIMEOUT,
                           PL_UTILS_DIR, check_files, df_to_file)
from colorama import Fore, init
from orsolver import or_solver
from orsolver_num import or_solver_num
from swiplserver import PrologMQI, prolog_args
from tabulate import tabulate


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-p", "--placement", action="store_true", help="if set, shows the obtained placement")	
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw).")
	p.add_argument("-b", "--budgeting", action="store_true", help="use budgeting for OR-Tools models.")
	p.add_argument("-o", "--ortools", action="store_true", help="if set, compares also with Google OR-Tools model (with PL pre-processing).")
	p.add_argument("-on", "--ortools-num", action="store_true", help="if set, compares also with Google OR-Tools model (only numeric constraints).")
	p.add_argument("-s", "--save", action="store_true", help="if set, saves the results in csv format.")
	p.add_argument("-t", "--timeout", type=int, default=TIMEOUT, help="Timeout for both OR-Tools and Prolog processes.")

	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")
	p.add_argument("versions", nargs='*',
	               help="List of the versions to compare. Valid ones can be found in \"versions/\" folder.")

	return p


def print_result(result, show_placement, save_results):

	result = pd.DataFrame.from_dict(result, orient='index')
	result.index.name = 'Version'

	if 'ortools' in result.index:
		opt_cost = float(result.loc[['ortools']]['Cost'])
		result['Change'] = result['Cost'].apply(lambda x: get_change(x, opt_cost))

	placements = result.pop('Placement')

	if save_results:
		df_to_file(result, COMPARISON_FILE)

	result.drop(columns=['App', 'Size', 'AllocHW', 'AllocBW'], inplace=True)
	result.rename(columns={"Bins": "Distinct Nodes", "Infs": "Dimension", "Time": "Time(s)"}, inplace=True)

	if show_placement:
		n_distinct = result.pop('Distinct Nodes')
		# transform list of strings into a dict in the form {service: node}
		placements = pd.DataFrame.from_records(placements.values, index=placements.index)
		placements.insert(0, 'Distinct Nodes', n_distinct)

		p_tab = tabulate(placements, headers='keys', tablefmt='fancy_grid', numalign='center', stralign='center')
		print(Fore.LIGHTRED_EX + "\nPLACEMENTS:")
		print(Fore.LIGHTRED_EX + p_tab)
	
	result.sort_values(by='Cost', ascending=True, inplace=True)

	tab = tabulate(result, headers="keys", tablefmt="fancy_grid", numalign="center", stralign="center")  
	print(Fore.LIGHTYELLOW_EX + "\nCOMPARISON (only found solutions):")
	print(Fore.LIGHTYELLOW_EX + tab)


def prolog_to_dict(p):
	return dict(list(map((lambda x: prolog_args(x)), p)))

def prolog_to_dict2(p):
	a = list(map((lambda x: prolog_args(x)), p))
	return dict(list(map((lambda x: (tuple(prolog_args(x[0])), x[1])), a)))


def compute_allocated_resources(app, infr, placement):
	allocs = {}
	str_pl = "[" + ", ".join(["({}, {})".format(s, n) for s, n in placement.items()]) + "]"
	with PrologMQI() as mqi:
		with mqi.create_thread() as prolog:
			prolog.query(f"consult('{app}')")
			prolog.query(f"consult('{infr}')")
			prolog.query(f"consult('{join(PL_UTILS_DIR, 'allocation.pl')}')")
			prolog.query_async(ALLOC_QUERY.format(placement=str_pl))
			q = prolog.query_async_result()[0]
			allocs['AllocHW'] = prolog_to_dict(q['AllocHW'])
			allocs['AllocBW'] = prolog_to_dict2(q['AllocBW'])

	return allocs


def get_change(current, optimal):
	if current == optimal:
		return 0
	try:
		return (current - optimal) / current * 100.0
	except ZeroDivisionError:
		return float('inf')


def pl_process(version, app, infr, result):
	with PrologMQI() as mqi:
		with mqi.create_thread() as prolog:
			prolog.query(f"consult('{version}')")
			prolog.query(f"consult('{app}')")
			prolog.query(f"consult('{infr}')")

			prolog.query_async(MAIN_QUERY)
			q = prolog.query_async_result()
			if q:
				q = q[0]
				q['Placement'] = prolog_to_dict(q['Placement'])
				q['Size'] = Infrastructure(infr).get_size()
				result[basename(version)] = q
			else:
				print(Fore.LIGHTRED_EX + "No PL solution found for {}".format(basename(version)))


def main(app, infr, versions, budgeting=False, show_placement=False, ortools=False, ortools_num=False, dummy=False, save=False):
	manager = Manager()
	result = manager.dict()
	processes = []

	for v in versions:
		p = Process(name=v, target=pl_process, args=(v, app, infr, result))
		p.start()
		processes.append(p)

	# add OR-Tools(pre) process
	if ortools:
		if budgeting:
			p = Process(name='budgeting', target=or_budgeting, args=(app, infr, 'pre', False, result))
		else:
			p = Process(name='ortools', target=or_solver, args=(app, infr, None, dummy, show_placement, False, False, result))
					
		p.start()
		processes.append(p)

	# add OR-Tools(num) process
	if ortools_num:
		if budgeting:
			p = Process(name='budgeting_num', target=or_budgeting, args=(app, infr, 'num', False, result))
		else:
			p = Process(name='ortools_num', target=or_solver_num, args=(app, infr, None, dummy, show_placement, False, result))
					
		p.start()
		processes.append(p)

	for p in processes:
		p.join(TIMEOUT)

	for p in processes:
		if p.is_alive():
			p.terminate()
	
	if result:
		result = dict(result)
		for k, v in result.items():
			if v:
				allocs = compute_allocated_resources(app, infr, v['Placement'])
				result[k].update(allocs)
		
		print_result(result, show_placement, save)
	else:
		print(Fore.LIGHTRED_EX + "No solution found!")

if __name__ == "__main__":
	# reset color after every "print"
	
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()
	
	TIMEOUT = args.timeout
	app, infr, vs = check_files(app=args.app, infr=args.infr, dummy_infr=args.dummy, versions=args.versions)
	
	info = [['APPLICATION:', basename(app)],
			['INFRASTRUCTURE:', ("dummy" + os.sep if args.dummy else "") + basename(infr)],
			['NODE BUDGETING:', "YES" if args.budgeting else "NO"],
			['OR-TOOLS-NUM:', "YES" if args.ortools_num else "NO"],
			['OR-TOOLS:', "YES" if args.ortools else "NO"],
			['PL VERSIONS:', [basename(v) for v in vs]],
			['SAVE RESULTS:', "YES" if args.save else "NO"]]
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	main(app=app, infr=infr, versions=vs, show_placement=args.placement, 
    	budgeting=args.budgeting, ortools=args.ortools, ortools_num=args.ortools_num, dummy=args.dummy, save=args.save)