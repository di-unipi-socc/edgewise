import os
import argparse as ap
import numpy as np
import sys

from ortools.linear_solver import pywraplp
from pyswip import Prolog
from colorama import Fore, init
from tabulate import tabulate

QUERY = "cost({ntype}, {compid}, Cost)"
MAX_BIN = 5


def init_parser() -> ap.ArgumentParser:
	description = "Compare several placement strategies."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-p", "--placement", action="store_true", help="if set, shows the obtained placement"),
	p.add_argument("-d", "--dummy", action="store_true",
	               help="if set, uses an infrastructure with dummy links (low lat, high bw)."),
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


def or_solver(app_name, infr_name, dummy=False, show_placement=False, result=""):

	if type(result) != str:  # if result is not a string, redirect output tu /dev/null
		sys.stdout = open(os.devnull, 'w')

	app = Application(app_name)
	infr = Infrastructure(infr_name, dummy=dummy)

	# Set ThingInstance nodes, knowing the infrastructure
	#app.set_things_from_infr(infr)

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

	# Create the variables.
	x = {(i, j): solver.BoolVar('') for i in range(S) for j in range(N)}
	b = {j: solver.BoolVar('') for j in range(N)}

	# Budgeting: no more than MAX_BIN nodes can be used
	solver.Add(solver.Sum(b[j] for j in range(N)) <= MAX_BIN)

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

			sec_reqs = set(df.sec_reqs) 
			if (not sec_reqs.issubset(set(infr.nodes[n]['seccaps']))) or (not sec_reqs.issubset(set(infr.nodes[n1]['seccaps']))):
				continue


			i = instances.index(df.source) if type(df.source) != ThingInstance else None
			i1 = instances.index(df.target) if type(df.target) != ThingInstance else None

			xij = x[i, j] if i else 1
			xi1j1 = x[i1, j1] if i1 else 1

			# linearize the constraint
			c = solver.BoolVar('')
			solver.Add(c <= xij)
			solver.Add(c <= xi1j1)
			solver.Add(c >= xij + xi1j1 - 1)

			solver.Add(c * a['lat'] <= df.latency)

			bw_constraint.SetCoefficient(c, df.bw)

	#  OBJECTIVE FUNCTION
	costs = get_costs(app.file, infr.file, instances, nodes)
	objective = solver.Objective()
	for i in range(S):
		for j in range(N):
			objective.SetCoefficient(x[i, j], costs[i, j])
	objective.SetMinimization()

	status = solver.Solve()
	
	tot_time = 0
	n_distinct = set()
	placement = {}

	if status == pywraplp.Solver.OPTIMAL:# or status == pywraplp.Solver.FEASIBLE:
		for i in range(S):
			row = [x[i,j].solution_value() for j in range(N)]
			j = row.index(max(row))
			s = instances[i].id
			n = nodes[j][0]
			placement[s] = n
			n_distinct.add(n)
			# tot_cost += costs[i, j]


		if show_placement:
			print(tabulate(placement.items(), tablefmt='fancy_grid', stralign='center'))
		tot_cost = solver.Objective().Value()
		tot_time = solver.WallTime() / 1000  # in seconds

		res = {'App': app_name, 'Time': tot_time, 'Cost': round(tot_cost, 4), 'NDistinct': len(n_distinct), 'Constraints': solver.NumConstraints()}

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