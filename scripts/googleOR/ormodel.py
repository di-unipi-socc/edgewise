from ortools.linear_solver import pywraplp
import numpy as np


def or_process(app_name, size, dummy=False, result=None):

	app = Application(app_name)
	infr = Infrastructure(size, dummy=dummy)

	# Set ThingInstance nodes, knowing the infrastructure
	app.set_things_from_infr(infr)

	instances = app.services + app.functions
	nodes = list(infr.nodes(data=True))  # (nid, {attrs})
	links = list(infr.edges(data=True))  # (src, dst, {attrs})
	dfs = app.data_flows

	nids = list(infr.nodes())  # list of node ids

	S = len(instances)
	N = len(nodes)
	L = len(links)
	DF = len(dfs)

	print("# Instances (S):", S)
	print(f"# Nodes (N):", N)
	print(f"# Links (L):", L)
	print(f"# Data Flows (DF):", DF)

	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('GLOP')

	# Create the variables.
	x = {(i, j): solver.IntVar(0, 1, '') for i in range(S) for j in range(N)}

	# Constraint: one instance at most in one node.
	for i in range(S):
		solver.Add(solver.Sum([x[i, j] for j in range(N)]) == 1)  # solver.AddExactlyOne

	# Constraint: cannot exceed the hw capacity of a node.
	# TODO add infr.hwTh
	coeffs = [s.comp.hwreqs for s in instances]
	bounds = [a['hwcaps'] for _, a in nodes]

	for j in range(N):
		constraint = solver.RowConstraint(0, bounds[j]-infr.hwTh, '')
		for i in range(S):
			constraint.SetCoefficient(x[i, j], coeffs[i])

	# Constraints:
	# TODO add infr.hwTh
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

	#  OBJECTIVE FUNCTION
	# TODO get costs from Prolog (now random for testing)
	costs = np.random.uniform(low=1, high=100, size=(S, N))

	objective = solver.Objective()
	for i in range(S):
		for j in range(N):
			objective.SetCoefficient(x[i, j], costs[i][j])
	objective.SetMinimization()

	status = solver.Solve()

	if status == pywraplp.Solver.OPTIMAL or status == pywraplp.Solver.FEASIBLE:
		print('\nTotal Cost = {:.4f}\n'.format(solver.Objective().Value()))
		for i, j in x:
			if x[i, j].solution_value() >= 0.5:
				print(f"on({instances[i].id}, {nodes[j][0]})")

		print('\nProblem solved in {} milliseconds'.format(solver.WallTime()))
		print("\nNumber of constraints:", solver.NumConstraints())
	else:
		print('The problem does not have a solution.')


if __name__ == '__main__':
	# relative import
	from classes import *

	or_process(app_name="speakToMe", size=32, dummy=True)

	# absolute import
else:
	from .classes import *
