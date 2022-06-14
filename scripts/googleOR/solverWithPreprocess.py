import os
import argparse as ap
from sqlite3 import complete_statement
import numpy as np
import sys

from ortools.linear_solver import pywraplp
from pyswip import Prolog
from colorama import Fore, init
from tabulate import tabulate

# todo normalization costs cij - cmin / cmax - cmin
QUERY = "preprocess({app_name}, Compatibles)"
L_COST = 0
L_BINPACK = 1

assert L_COST + L_BINPACK == 1, "Lambdas must be summed to 1."


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-p", "--placement", action="store_true", help="if set, shows the obtained placement"),
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw)."),
	p.add_argument("app", help="Application name.")
	p.add_argument("infr", help="Infrastructure name.")

	return p


def get_compatibles(app_name, app, infr):
	prolog = Prolog()
	prolog.consult(app)
	prolog.consult(infr)
	prolog.consult(join(VERSIONS_DIR, "preprocessing.pl"))
	
	try:
		q = prolog.query(QUERY.format(app_name=app_name))
		r = next(q)['Compatibles']
		q.close()
	except StopIteration:
		raise ValueError("Error in preprocessing.pl")

	return parse_compatibles(r)

# bug in pyswip when retrieving lists/tuples with format ",(...)"
def parse_compatibles(r):
	compatibles = {}
	for i in r:
		i = i[2:-1].replace(",(", "(").split(", ", 1)
		s = i[0]
		comps = eval(i[1])
		comps2 = {}
		for c in comps:
			c = c[1:-1].split(", ", 1)
			comps2[c[0]] = round(float(c[1]), 4)

		compatibles[s] = comps2
	
	return compatibles
		
def or_solver(app_name, infr_name, dummy=False, show_placement=False, result=""):

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

	compatibles = get_compatibles(app_name, app.file, infr.file)
	# app.set_compatibles(compatibles)
	print([(k,len(v)) for k,v in compatibles.items()])

	info = [['Infrastructure', infr_name], ['Instances', S], ['Nodes', N], ['Links', L], ['Data Flows', DF]]
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('GLOP')
	solver.SetNumThreads(32)

	# Create the variables for binpack B.
	b = {j: solver.IntVar(0, 1, '') for j in range(N)}

	# Create bool vars matrix X.
	# at the same time, create costs matrix C
	costs = np.zeros((S, N))
	# x = {(i, j): solver.IntVar(0, 1, '') for i in range(S) for j in range(N)}
	x = {(i, j): 0 for i in range(S) for j in range(N)}
	for i, s in enumerate(instances):
		for j, n in enumerate(nids):
			if n in compatibles[s.id]:
				x[i, j] = solver.IntVar(0, 1, '')
				costs[i, j] = compatibles[s.id][n]

	# Constraint: one instance at most in one node.
	for i in range(S):
		solver.Add(solver.Sum([x[i, j] for j in range(N)]) == 1)

	# Constraint: cannot exceed the hw capacity of a node.
	coeffs = [s.comp.hwreqs for s in instances]
	bounds = [a['hwcaps'] for _, a in nodes]

	for j in range(N):
		solver.Add(solver.Sum([coeffs[i] * x[i, j] for i in range(S)]) <= b[j] * (bounds[j] - infr.hwTh))

	# Constraints:
	# - cannot exceed the bandwidth of a link. (FeatBW >= sum(ReqBW))
	# - satisfy latency requirements of data flows. (FeatLat <= ReqLat)
	for n, n1, a in links:  # foreach link
		bw_constraint = solver.RowConstraint(0, a['bw']-infr.bwTh, '')
		j = nids.index(n)
		j1 = nids.index(n1)
		for df in dfs:  # foreach data flow

			i = instances.index(df.source) if type(df.source) != ThingInstance else None
			i1 = instances.index(df.target) if type(df.target) != ThingInstance else None

			xij = x[i, j] if i else 1
			xi1j1 = x[i1, j1] if i1 else 1

			# linearize the constraint
			c = solver.IntVar(0, 1, '')
			solver.Add(c <= xij)
			solver.Add(c <= xi1j1)
			solver.Add(c >= xij + xi1j1 - 1)

			solver.Add(c * a['lat'] <= df.latency)

			bw_constraint.SetCoefficient(c, df.bw)

	# costs = np.random.uniform(low=1, high=50, size=(S, N))

	# OBJECTIVE FUNCTION
	cmin = np.sum([np.min(row[np.nonzero(row)]) for row in costs])
	cmax = np.sum(costs.max(axis=1))

	bmin = 1
	bmax = S

	min_cost_expr = [L_COST * cmax / (cmax-cmin)] + [(L_COST * costs[i, j] * x[i, j]) / (cmin-cmax) for i in range(S) for j in range(N)]
	binpack_expr = [L_BINPACK * bmax / (bmax-bmin)] + [(L_BINPACK * b[j]) / (bmin-bmax) for j in range(N)]

	# min_cost_expr = [L_COST * costs[i, j] * x[i, j] for i in range(S) for j in range(N)]
	# binpack_expr = [L_BINPACK * b[j] for j in range(N)]

	obj_expr = min_cost_expr + binpack_expr
	solver.Minimize(solver.Sum(obj_expr))
	status = solver.Solve()
	
	tot_cost = 0
	tot_time = 0
	n_distinct = set()
	placement = {}

	str_res = ""

	if status == pywraplp.Solver.OPTIMAL or status == pywraplp.Solver.FEASIBLE:
		for i in range(S):
			row = [x[i,j].solution_value() if not isinstance(x[i,j], int) else 0 for j in range(N)]
			j = row.index(max(row))
			s = instances[i].id
			n = nodes[j][0]
			placement[s] = n
			n_distinct.add(n)
			tot_cost += costs[i, j]


		res = {'App': app_name, 'Time': tot_time, 'Cost': round(tot_cost, 4), 'NDistinct': len(n_distinct), 'Constraints': solver.NumConstraints()}
		if show_placement:
			print(tabulate(placement.items(), tablefmt='fancy_grid', stralign='center'))
		# tot_cost = solver.Objective().Value()
		tot_time = solver.WallTime() / 1000  # in seconds

		print(Fore.LIGHTGREEN_EX + tabulate(res.items(), numalign='right'))

	else:
		print('The problem does not have a solution.')
	

	if type(result) != str and res:  # if set, send or-tools results to "compare.py"
		res['Placement'] = placement, 
		del res['Constraints']
		result['ortools'] = res


if __name__ == '__main__':
	
	# relative import
	from classes import *

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	or_solver(app_name=args.app, infr_name=args.infr, show_placement=args.placement, dummy=args.dummy)

	# absolute import
else:
	from .classes import *
