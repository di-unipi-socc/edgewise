import time

from .classes import Application, Infrastructure
import numpy as np
from ortools.linear_solver import pywraplp


def or_process(app_name, size, dummy, result):
	start = time.process_time()

	app = Application(app_name)
	infr = Infrastructure(size, dummy=dummy)

	# Create the solver.
	solver = pywraplp.Solver.CreateSolver('SCIP')

	x = {}
	instances = app.services + app.functions

	num_instances = len(instances)
	num_nodes = len(infr.nodes())

	for n in range(num_nodes):
		for i in range(num_instances):
			x[n, i] = solver.IntVar(0, 1, "")  # f"on({n},{i})"

	# random costs (for testing)
	costs = np.random.randint(1, 100, size=(num_nodes, num_instances))

	# Each instance is assigned to exactly one node.
	for j in range(num_instances):
		solver.Add(solver.Sum([x[i, j] for i in range(num_nodes)]) == 1)

	objective_terms = [(costs[i][j] * x[i, j]) for i in range(num_nodes) for j in range(num_instances)]
	solver.Minimize(solver.Sum(objective_terms))

	# Solve
	status = solver.Solve()

	cost = -1
	placement = {}

	# Print solution.
	if status == pywraplp.Solver.OPTIMAL or status == pywraplp.Solver.FEASIBLE:
		# print(f'Total cost = {solver.Objective().Value()}\n')
		cost = solver.Objective().Value()
		for i in range(num_nodes):
			for j in range(num_instances):
				# Test if x[i,j] is 1 (with tolerance for floating point arithmetic).
				if x[i, j].solution_value() > 0.5:
					# print(f'on({instances[j].id}, {list(infr.nodes)[i]}) (cost: {costs[i][j]})')
					placement[instances[j].id] = list(infr.nodes)[i]
	else:
		raise ValueError(f'Solver status: {status}. No solution found.')

	n_distinct = len(set(placement.values()))

	end = time.process_time()
	tot_time = end - start
	result['OR tools'] = {'App': app_name, 'Cost': cost, 'Placement': placement, 'NDistinct': n_distinct, 'Infs': '---', 'Time': tot_time}


if __name__ == '__main__':
	or_process(app_name="speakToMe", size=32)
