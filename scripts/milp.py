import argparse as ap
import os
import sys
from os.path import exists, join

import numpy as np
from classes import Application, Infrastructure
from classes.components import ThingInstance
from classes.utils import (COST_QUERY, MODELS_DIR, PL_UTILS_DIR, check_app,
                           check_infr)
from colorama import Fore, init
from ortools.linear_solver import pywraplp
from swiplserver import PrologMQI
from tabulate import tabulate


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-p", "--placement", action="store_true", help="if set, shows the obtained placement"),
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw)."),
	p.add_argument("-m", "--model", action="store_true", help="if set, saves the model in LP format."),
	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")

	return p


def get_costs(app, infr, instances, nodes):
	with PrologMQI() as mqi:
		with mqi.create_thread() as prolog:
			prolog.query(f"consult('{app}')")
			prolog.query(f"consult('{infr}')")
			prolog.query(f"consult('{join(PL_UTILS_DIR, 'costs.pl')}')")

			costs = np.zeros((len(instances), len(nodes)))
			for i, s in enumerate(instances):
				for j, (_, a) in enumerate(nodes):
					prolog.query_async(COST_QUERY.format(ntype=a['nodeType'], compid=s.id), find_all=False)
					r = prolog.query_async_result()
					if r:
						costs[i][j] = r[0]['Cost']
					else:
						raise ValueError("No cost for {} in {}".format(a['nodeType'], s.id))

			return costs


def milp(app, infr, max_bin=None, dummy=False, show_placement=False, model=False, result=""):
	
	if type(result) != str:  # if result is not a string, redirect output tu /dev/null
		sys.stdout = open(os.devnull, 'w')

	app = Application(app)
	infr = Infrastructure(infr)

	# Set ThingInstance nodes, knowing the infrastructure
	app.set_things_from_infr(infr)

	instances = app.services + app.functions
	nodes = list(infr.nodes(data=True))  # (nid, {attrs})
	links = list(infr.edges(data=True))  # (scripts, dst, {attrs})
	dfs = app.data_flows

	nids = list(infr.nodes())  # list of node ids

	S = len(instances)
	N = len(nodes)
	L = len(links)
	DF = len(dfs)

	# set max bins to the number of services if not specified
	MAX_BIN = max_bin if max_bin else S

	info = [['Instances', S], ['Nodes', N], ['Links', L], ['Data Flows', DF]]
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('SCIP')

	# Create the variables for placement X.
	x = {(i, j): solver.BoolVar(f'{s.id}_{n}') for i, s in enumerate(instances) for j, n in enumerate(nids)}

	# Create the variables for binpack B.
	b = {j: solver.BoolVar(f'b_{nids[j]}') for j in range(N)}

	# Budgeting: no more than MAX_BIN nodes can be used
	[solver.Add(x[i, j] <= b[j], name=f'bin_{instances[i].id}_{nids[j]}') for j in range(N) for i in range(S)]
	solver.Add(solver.Sum(b[j] for j in range(N)) <= MAX_BIN)

	# Constraint: one instance at most in one node
	[solver.Add(solver.Sum([x[i, j] for j in range(N)]) == 1) for i in range(S)]

	# Constraint: cannot exceed the hw capacity of a node.
	coeffs = [s.comp.hwreqs for s in instances]
	bounds = [a['hwcaps'] for _, a in nodes]

	[solver.Add(solver.Sum([coeffs[i] * x[i, j] for i in range(S)]) <= (bounds[j] - infr.hwTh)) for j in range(N)]

	# Constraints:
	# - cannot exceed the bandwidth of a link. (FeatBW >= sum(ReqBW))
	# - satisfy latency requirements of data flows. (FeatLat <= ReqLat)
	for n, n1, a in links:  # foreach link
		coeffs = {}
		j = nids.index(n)
		j1 = nids.index(n1)
		for df in dfs:  # foreach data flow

			name = f"{df.source.id}_{df.target.id}_{n}_{n1}"

			if isinstance(df.source, ThingInstance):
				if df.source.node == n:
					i = -1
				else:
					continue
			else:
				i = instances.index(df.source)

			if isinstance(df.target, ThingInstance):
				if df.target.node == n1:
					i1 = -1
				else:
					continue
			else:
				i1 = instances.index(df.target)

			xij = x[i, j] if i != -1 else 1
			xi1j1 = x[i1, j1] if i1 != -1 else 1

			# FRANGIO 
			if (a['lat'] > df.latency):
				solver.Add(xij + xi1j1 <= 1, name=f'{name}_no_reqs')
			else:
				# linearize the constraint
				c = solver.BoolVar(name)
				solver.Add(c >= xij + xi1j1 - 1, name=f'lin_3_{c.name()}')

				coeffs[c] = df.bw
				

		if len(coeffs):
			bw_constraint = solver.RowConstraint(0, a['bw']-infr.bwTh, f'{n}_{n1}_bw')
			for c, b in coeffs.items():
				bw_constraint.SetCoefficient(c, df.bw)

	#  OBJECTIVE FUNCTION
	costs = get_costs(app.get_file(), infr.get_file(), instances, nodes)
	obj_expr = [costs[i, j] * x[i, j] for i in range(S) for j in range(N)]
	solver.Minimize(solver.Sum(obj_expr))

	if model:
		os.makedirs(MODELS_DIR) if not exists(MODELS_DIR) else None
		filename = join(MODELS_DIR, f'model_num_{app.name}_{infr.get_size()}{"_dummy" if dummy else ""}.lp')
		with open(filename, 'w') as f:
			print(solver.ExportModelAsLpFormat(obfuscated=False), file=f)

	print(Fore.LIGHTYELLOW_EX + "Model created. Starting solving...")
	status = solver.Solve()
	
	n_distinct = set()
	placement = {}
	res = {}
	if status == pywraplp.Solver.OPTIMAL:
		for i in range(S):
			row = [x[i,j].solution_value() if not isinstance(x[i,j], int) else 0 for j in range(N)]
			j = row.index(max(row))
			s = instances[i].id
			n = nodes[j][0]
			placement[s] = n
			n_distinct.add(n)

		if show_placement:
			print(tabulate(placement.items(), tablefmt='fancy_grid', stralign='center'))

		tot_cost = solver.Objective().Value() # if only cost in Objective function
		tot_time = solver.WallTime() / 1000  # in seconds
		res = {'App': app.name, 'Time': tot_time, 'Cost': round(tot_cost, 4), 'Bins': len(n_distinct), 'Infs': solver.NumConstraints(), 'Size': N}

		print(Fore.LIGHTYELLOW_EX + 'Found solution:')
		print(Fore.LIGHTGREEN_EX + tabulate(res.items(), numalign='right'))

		str_pl = "[" + ", ".join(["({}, {})".format(s, n) for s, n in placement.items()]) + "]"
		print(Fore.LIGHTWHITE_EX + f"Prolog: {str_pl}\n")
	else:
		print(Fore.LIGHTRED_EX + 'The problem does not have a solution.')
	
	if type(result) != str and res:
		res['Placement'] = placement
		name = f'ortools_num_{max_bin}' if max_bin else 'ortools_num'
		result[name] = res


if __name__ == '__main__':
	# relative import
	from classes import *

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	app = check_app(args.app)
	infr = check_infr(args.infr, dummy=args.dummy)

	milp(app=app, infr=infr, dummy=args.dummy, show_placement=args.placement, model=args.model)