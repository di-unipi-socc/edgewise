import argparse as ap
from multiprocessing import Process, Manager
from os.path import basename, splitext
from googleOR import or_solver_pre, or_solver

import os
import pandas as pd
from colorama import Fore, init
from pyswip import Prolog
from tabulate import tabulate

from googleOR.classes.utils import check_files

QUERY = "once(stats(App, Placement, Cost, NDistinct, Infs, Time, {budget}))"


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-p", "--placement", action="store_true", help="if set, shows the obtained placement"),
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw)."),
	p.add_argument("-o", "--ortools", action="store_true", help="if set, compares also with Google OR-Tools model."),
	p.add_argument("-op", "--ortools-pre", action="store_true", help="if set, compares also with Google OR-Tools model (with Prolog pre-processing)."),
	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")
	p.add_argument("budget", type=int, help="Maximum budget.")
	p.add_argument("versions", nargs='*',
	               help="List of the versions to compare. Valid ones can be found in \"versions/\" folder.")

	return p


def print_result(result, show_placement):
	# remove None results (not shown in the table)
	not_none = {k: v for k, v in result.items() if v is not None}
	result.clear()
	result.update(not_none)
	
	if result:
		result = pd.DataFrame.from_dict(result, orient='index')
		result.drop(columns=['App'], inplace=True)

		result.rename(columns={"NDistinct": "# Distinct Nodes", "Infs": "# Inferences", "Time": "Time(s)"}, inplace=True)
		placements = result.pop('Placement')

		if show_placement:
			n_distinct = result.pop('# Distinct Nodes')
			# transform list of strings into a dict in the form {service: node}
			placements = pd.DataFrame.from_records(placements.values, index=placements.index)
			placements.insert(0, '# Distinct nodes', n_distinct)

			p_tab = tabulate(placements, headers='keys', tablefmt='fancy_grid', numalign='center', stralign='center')
			print(Fore.LIGHTRED_EX + "\nPLACEMENTS:")
			print(Fore.LIGHTRED_EX + p_tab)

		if 'ortools' in result.index:
			opt_cost = float(result.loc[['ortools']]['Cost'])
			result['Change'] = result['Cost'].apply(lambda x: get_change(x, opt_cost)).round(2).astype(str) + " %"

		if 'ortools-pre' in result.index:
			opt_cost = float(result.loc[['ortools-pre']]['Cost'])
			result['Change (pre)'] = result['Cost'].apply(lambda x: get_change(x, opt_cost)).round(2).astype(str) + " %"


		result.sort_values(by='Cost', ascending=True, inplace=True)

		tab = tabulate(result, headers="keys", tablefmt="fancy_grid", numalign="center", stralign="center")  
		print(Fore.LIGHTYELLOW_EX + "\nCOMPARISON:")
		print(Fore.LIGHTYELLOW_EX + tab)

def format_placement(q):
	placement = q['Placement']
	placement = [i[2:-1].split(', ') for i in placement]
	q['Placement'] = dict(placement)

	return q


def get_change(current, optimal):
	if current == optimal:
		return 0
	try:
		return (abs(current - optimal) / current) * 100.0
	except ZeroDivisionError:
		return float('inf')


def pl_query(p: Prolog, s: str):
	q = p.query(s)
	return next(q)


def pl_process(version, app, budget, infr, result):
	p = Prolog()
	p.consult(version)
	p.consult(app)
	p.consult(infr)

	try:
		q = pl_query(p, QUERY.format(budget=budget))
		q = format_placement(q)
	except StopIteration:
		print(Fore.LIGHTRED_EX + "No PL solution found for {}.".format(basename(version)))
		q = None

	result[basename(version)] = q


def main(app, infr, budget, versions, show_placement=False, ortools=False, ortools_pre=False, dummy=False):
	manager = Manager()
	result = manager.dict()
	processes = []

	for v in versions:
		p = Process(target=pl_process, args=(v, app, budget, infr, result))
		p.start()
		processes.append(p)

	# add OR-Tools process
	if ortools:
		app_name = splitext(basename(app))[0]
		infr_name = splitext(basename(infr))[0][4:]

		p = Process(target=or_solver, args=(app_name, infr_name, dummy, show_placement, result))
		p.start()
		processes.append(p)

	for p in processes:
		p.join()

	# add OR-Tools(pre) process
	if ortools_pre:
		app_name = splitext(basename(app))[0]
		infr_name = splitext(basename(infr))[0][4:]

		p = Process(target=or_solver_pre, args=(app_name, infr_name, dummy, show_placement, result))
		p.start()
		processes.append(p)

	for p in processes:
		p.join()

	print_result(result, show_placement)


if __name__ == "__main__":
	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	app, infr, vs = check_files(app=args.app, infr=args.infr, dummy_infr=args.dummy, versions=args.versions)

	info = [['APPLICATION:', basename(app)],
			['INFRASTRUCTURE:', ("dummy" + os.sep if args.dummy else "") + basename(infr)],
			['BUDGET:', args.budget],
			['OR-TOOLS:', "YES" if args.ortools else "NO"],
			['OR-TOOLS (pre):', "YES" if args.ortools_pre else "NO"],
			['PL VERSIONS:', [basename(v) for v in vs]]]
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	main(app=app, infr=infr, versions=vs, budget=args.budget, show_placement=args.placement, ortools=args.ortools, ortools_pre=args.ortools_pre, dummy=args.dummy)
