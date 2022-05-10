from classes import Application, Infrastructure
import numpy as np
from ortools.linear_solver import pywraplp


def main(app_name="", size=0, dummy=False):
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

	# Print solution.
	if status == pywraplp.Solver.OPTIMAL or status == pywraplp.Solver.FEASIBLE:
		print(f'Total cost = {solver.Objective().Value()}\n')
		for i in range(num_nodes):
			for j in range(num_instances):
				# Test if x[i,j] is 1 (with tolerance for floating point arithmetic).
				if x[i, j].solution_value() > 0.5:
					print(f'on({instances[j].id}, {list(infr.nodes)[i]}) (cost: {costs[i][j]})')
	else:
		print('No solution found.')


if __name__ == '__main__':

	main(app_name="speakToMe", size=32)
