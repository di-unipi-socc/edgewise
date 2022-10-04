import os
import argparse as ap
import numpy as np
import sys

from ortools.linear_solver import pywraplp
from pyswip import Prolog
from colorama import Fore, init
from tabulate import tabulate

QUERY = "cost({ntype}, {compid}, Cost)"
MAX_BIN = 20


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

	p = Prolog()
	p.consult(app)
	p.consult(infr)
	p.consult(join(ROOT_DIR, "costs.pl"))

	costs = np.zeros((len(instances), len(nodes)))
	for i, s in enumerate(instances):
		for j, (_, a) in enumerate(nodes):
			try:
				q = p.query(QUERY.format(ntype=a['type'], compid=s.id))
				r = next(q)
				costs[i][j] = r['Cost']
				q.close()
			except StopIteration:
				raise ValueError("No cost for {} in {}".format(a['type'], s.id))

	return costs


def or_solver(app_name, infr_name, dummy=False, show_placement=False, model=False, result=""):
	
	if type(result) != str:  # if result is not a string, redirect output tu /dev/null
		sys.stdout = open(os.devnull, 'w')

	app = Application(app_name)
	infr = Infrastructure(infr_name, dummy=dummy)

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

	info = [['Instances', S], ['Nodes', N], ['Links', L], ['Data Flows', DF]]
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('BOP')
	solver.SetNumThreads(32)

	# Create the variables for placement X.
	x = {(i, j): solver.BoolVar(f'{s.id}_{n}') for i, s in enumerate(instances) for j, n in enumerate(nids)}

	# Create the variables for binpack B.
	b = {j: solver.BoolVar(f'b_{nids[j]}') for j in range(N)}

	# Budgeting: no more than MAX_BIN nodes can be used
	for i in range(S):
		for j in range(N):
			solver.Add(x[i, j] <= b[j])

	solver.Add(solver.Sum(b[j] for j in range(N)) <= MAX_BIN)

	# Constraint: one instance at most in one node.
	for i in range(S):
		solver.Add(solver.Sum([x[i, j] for j in range(N)]) == 1)

	# Constraint: cannot exceed the hw capacity of a node.
	coeffs = [s.comp.hwreqs for s in instances]
	bounds = [a['hwcaps'] for _, a in nodes]

	for j in range(N):
		solver.Add(solver.Sum([coeffs[i] * x[i, j] for i in range(S)]) <= (bounds[j] - infr.hwTh))

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
			sec_reqs = set(df.sec_reqs) 
			if (a['lat'] > df.latency) or (not (sec_reqs.issubset(set(infr.nodes[n]['seccaps'])) and sec_reqs.issubset(set(infr.nodes[n1]['seccaps'])))):
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
	costs = get_costs(app.file, infr.file, instances, nodes)
	obj_expr = [costs[i, j] * x[i, j] for i in range(S) for j in range(N)]
	solver.Minimize(solver.Sum(obj_expr))

	if model:
		with open(join(MODELS_DIR,f'model_{app_name}_{infr_name}_{"dummy" if dummy else ""}.lp'), 'w') as f:
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

		str_pl = "[" + ", ".join(["({}, {})".format(s, n) for s, n in placement.items()]) + "]"
		print(Fore.LIGHTGREEN_EX + f"Prolog: {str_pl}")

		if show_placement:
			print(tabulate(placement.items(), tablefmt='fancy_grid', stralign='center'))

		tot_cost = solver.Objective().Value() # if only cost in Objective function
		tot_time = solver.WallTime() / 1000  # in seconds
		res = {'App': app_name, 'Time': tot_time, 'Cost': round(tot_cost, 4), 'NDistinct': len(n_distinct), 'Infs': solver.NumConstraints(), 'Size': N}

		print(Fore.LIGHTGREEN_EX + tabulate(res.items(), numalign='right'))
	else:
		print(Fore.LIGHTRED_EX + 'The problem does not have a solution.')
	
	if type(result) != str and res:  # if set, send or-tools results to "compare.py"
		res['Placement'] = placement, 
		# del res['Constraints']
		result['ortools'] = res


if __name__ == '__main__':
	
	# relative import
	from classes import *

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	or_solver(app_name=args.app, infr_name=args.infr, dummy=args.dummy, show_placement=args.placement, model=args.model)

	# absolute import
else:
	from .classes import *