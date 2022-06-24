import os
import argparse as ap
import numpy as np
import sys

from ortools.linear_solver import pywraplp
from pyswip import Prolog
from colorama import Fore, init
from tabulate import tabulate

# todo normalization costs cij - cmin / cmax - cmin
QUERY = "preprocess({app_name}, Compatibles)"
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

	compatibles = get_compatibles(app_name, app.file, infr.file)
	
	for k, v in compatibles.items():
		if not len(v):
			print(Fore.LIGHTRED_EX + "No compatibles for '{}'.".format(k))
			return
		else:
			print(Fore.LIGHTGREEN_EX + "Compatibles for '{}': {}".format(k, v))
	
	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('SCIP')
	solver.SetNumThreads(32)

	# Create the variables for binpack B.
	# b = {j: solver.IntVar(0, 1, '') for j in range(N)}
	b = {j: solver.BoolVar(f'b_{nids[j]}') for j in range(N)}

	# Create bool vars matrix X.
	# at the same time, create costs matrix C
	costs = np.zeros((S, N))
	x = {(i, j): 0 for i in range(S) for j in range(N)}
	for i, s in enumerate(instances):
		for j, n in enumerate(nids):
			if n in compatibles[s.id]:
				x[i, j] = solver.BoolVar(f'{s.id}_{n}')
				costs[i, j] = compatibles[s.id][n]
	
	# Constraint: one instance at most in one node.
	for i in range(S):
		solver.Add(solver.Sum([x[i, j] for j in range(N)]) == 1, name=f'one_node_{instances[i].id}')

	# Constraint: cannot exceed the hw capacity of a node.
	coeffs = [s.comp.hwreqs for s in instances]
	bounds = [a['hwcaps'] for _, a in nodes]

	for j in range(N):
		solver.Add(solver.Sum([coeffs[i] * x[i, j] for i in range(S)]) <= b[j] * (bounds[j] - infr.hwTh), name=f'hw_{nids[j]}')

	# Budgeting: no more than MAX_BIN nodes are used.
	solver.Add(solver.Sum([b[j] for j in range(N)]) <= MAX_BIN, name='budget')

	# Constraints:
	# - cannot exceed the bandwidth of a link. (FeatBW >= sum(ReqBW))
	# - satisfy latency requirements of data flows. (FeatLat <= ReqLat)
	tmp = {(d, l): 0 for d in range(DF) for l in range(L+N)}
	for n, n1, a in links:  # foreach link
		# bw_constraint = solver.RowConstraint(0, a['bw']-infr.bwTh, f'{n}_{n1}_bw')
		coeffs = {}
		j = nids.index(n)
		j1 = nids.index(n1)
		lidx=-1
		for didx, df in enumerate(dfs):  # foreach data flow
			
			lidx += 1
			sec_reqs = set(df.sec_reqs) 
			if (not sec_reqs.issubset(set(infr.nodes[n]['seccaps']))) or (not sec_reqs.issubset(set(infr.nodes[n1]['seccaps']))):
				continue			
			
			# i = instances.index(df.source) if type(df.source) != ThingInstance else None
			# i1 = instances.index(df.target) if type(df.target) != ThingInstance else None

			if isinstance(df.source, ThingInstance):
				if df.source.node == n:
					i = -1
				else:
					#print("no thg source {}".format(f"{df.source.id}_{n}_{df.target.id}_{n1}"))
					continue
			else:
				if n in compatibles[df.source.id]:
					i = instances.index(df.source)
				else:
					#print("no comp source {}".format(f"{df.source.id}_{n}_{df.target.id}_{n1}"))
					continue

			if isinstance(df.target, ThingInstance):
				if df.target.node == n1:
					i1 = -1
				else:
					#print("no thg dest {}".format(f"{df.source.id}_{n}_{df.target.id}_{n1}"))
					continue
			else:
				if n1 in compatibles[df.target.id]:
					i1 = instances.index(df.target)
				else:
					#print("no comp dest {}".format(f"{df.source.id}_{n}_{df.target.id}_{n1}"))
					continue

			xij = x[i, j] if i != -1 else 1
			xi1j1 = x[i1, j1] if i1 != -1 else 1

			# linearize the constraint
			tmp[didx, lidx] = solver.BoolVar(f"{df.source.id}_{n}_{df.target.id}_{n1}")
			c = tmp[didx, lidx]
			solver.Add(c <= xij, name=f'lin_1_{c.name()}')
			solver.Add(c <= xi1j1, name=f'lin_2_{c.name()}')
			solver.Add(c >= xij + xi1j1 - 1, name=f'lin_3_{c.name()}')
			solver.Add(c * a['lat'] <= df.latency, name=f'{c.name()}_lat')

			#bw_constraint.SetCoefficient(c, df.bw)
			coeffs[c] = df.bw

		if len(coeffs):
			bw_constraint = solver.RowConstraint(0, a['bw']-infr.bwTh, f'{n}_{n1}_bw')
			for c, b in coeffs.items():
				bw_constraint.SetCoefficient(c, df.bw)


	for d, df in enumerate(dfs):
		c_src = list(compatibles[df.source.id]) if not isinstance(df.source, ThingInstance) else [df.source.node]
		c_trg = list(compatibles[df.target.id]) if not isinstance(df.target, ThingInstance) else [df.target.node]
		ccomp = list(set(c_src).intersection(c_trg))
		for n in ccomp:
			nidx = nids.index(n)
			nidx += L
			tmp[didx, nidx] = solver.BoolVar(f"{df.source.id}_{n}_{df.target.id}_{n}")
		solver.Add(solver.Sum([tmp[d, l] for l in range(L+N)]) == 1, name=f'one_link_{df.source.id}_{df.target.id}')

	# costs = np.random.uniform(low=1, high=50, size=(S, N))
	# OBJECTIVE FUNCTION
	obj_expr = [costs[i, j] * x[i, j] for i in range(S) for j in range(N)]
	solver.Minimize(solver.Sum(obj_expr))

	# print(solver.constraint(11).name())

	if model:
		with open(join(MODELS_DIR,f'model_{app_name}_{infr_name}_{dummy}.lp'), 'w') as f:
			print(solver.ExportModelAsLpFormat(obfuscated=False), file=f)

	status = solver.Solve()

	'''
	print("LENGTH:", len(lecci))
	for c in lecci:
		if c.solution_value() == 1:
			print(c.name(), end='\n')
	'''
	
	tot_time = 0
	n_distinct = set()
	placement = {}
	res = {}
	if status == pywraplp.Solver.OPTIMAL:# or status == pywraplp.Solver.FEASIBLE:
		for i in range(S):
			row = [x[i,j].solution_value() if not isinstance(x[i,j], int) else 0 for j in range(N)]
			j = row.index(max(row))
			s = instances[i].id
			n = nodes[j][0]
			placement[s] = n
			n_distinct.add(n)
			# tot_cost += costs[i, j]

		str_pl = "[" + ", ".join(["({}, {})".format(s, n) for s, n in placement.items()]) + "]"
		print(str_pl)

		if show_placement:
			print(tabulate(placement.items(), tablefmt='fancy_grid', stralign='center'))

		tot_cost = solver.Objective().Value() # if only cost in Objective function
		tot_time = solver.WallTime() / 1000  # in seconds
		res = {'App': app_name, 'Time': tot_time, 'Cost': round(tot_cost, 4), 'NDistinct': len(n_distinct), 'Constraints': solver.NumConstraints()}

		print(Fore.LIGHTGREEN_EX + tabulate(res.items(), numalign='right'))
	else:
		print('The problem does not have a solution.')
	

	if type(result) != str and res:  # if set, send or-tools results to "compare.py"
		res['Placement'] = placement, 
		del res['Constraints']
		result['ortools-pre'] = res


if __name__ == '__main__':
	
	# relative import
	from classes import *

	# reset color after every "print"
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	or_solver(app_name=args.app, infr_name=args.infr, show_placement=args.placement, dummy=args.dummy, model=True)

	# absolute import
else:
	from .classes import *
