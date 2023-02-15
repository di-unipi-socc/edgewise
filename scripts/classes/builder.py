import argparse as ap
import sys
from itertools import product
from os.path import join

import networkx as nx
from colorama import Fore, init
from numpy import random as rnd
from numpy import set_printoptions
from tabulate import tabulate
from utils import INFRS_DIR, normal_distribution

HW_PLATFORMS = ['arm64', 'x86']
SW_CAPS = ['ubuntu', 'mySQL', 'python', 'js', 'gcc']
TYPES = ['cloud', 'isp', 'cabinet', 'accesspoint', 'thing']
PROBS = [0.1, 0.2, 0.3, 0.2, 0.2]
THINGS = ['soil', 'heat', 'water', 'nutrient', 'energy', 'piCamera1', 'piCamera2', 'arViewer',
		  'cam11', 'cam12', 'cam21', 'cam22',
		  'iphoneXS', 'echoDot']

NOT_PLACED_THINGS = len(THINGS)

DUMMY_LAT = 5
DUMMY_BW = 1000


def init_parser() -> ap.ArgumentParser:
	description = "Generate random infrastructure with a given number of nodes."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-d", "--dummy", action="store_true", help="set dummy links (low latency, high bandwidth)")
	p.add_argument("-s", "--seed", type=int, help="seed for random generation ('None' if not set)")
	p.add_argument("n", type=int, help="number of infrastructure nodes")
	p.add_argument("-t", "--things", nargs='*', help="list of IoT devices to be randomly placed")

	return p


def get_random_sw_caps(size=1):
	return list(rnd.choice(SW_CAPS, size=size, replace=False))


def get_random_things(n=1):
	global NOT_PLACED_THINGS
	t = []
	for _ in range(n):
		if THINGS:
			t.append(THINGS.pop(rnd.randint(len(THINGS))))
			NOT_PLACED_THINGS -= 1
		else:
			break
	return t


class Builder(nx.Graph):
	def __init__(self, n, dummy=False):
		super().__init__()
		self._bwTh = 3
		self._hwTh = 1

		self.n = n
		self.file = "infr{}.pl".format(self.n) 	
		self.gnodes = {}  # nodes grouped by TYPES

		self.set_filepath(dummy)
		self.set_nodes(n)
		self.set_links()
		nx.relabel_nodes(self, lambda x: f"n{x}", copy=False)

	def set_filepath(self, dummy):
		path = INFRS_DIR
		if dummy:
			path = join(path, "dummy")

		self.file = join(path, self.file)

	def set_nodes(self, n):
		# i = int(log2(n))
		# R = nx.barabasi_albert_graph(n, 3, seed=seed)
		R = nx.complete_graph(n, nx.DiGraph())
		self.add_nodes_from(R, things=[])

		dist = normal_distribution(size_of_federation=n)

		for node in self.nodes:
			hw_platform = rnd.choice(HW_PLATFORMS)
			self.nodes[node]['hardware'] = (hw_platform, dist[node])

			ntype = rnd.choice(TYPES, p=PROBS)
			method = 'set_as_{}'.format(ntype)
			getattr(self, method)(node)
		self.set_grouped_nodes()

		self.add_edges_from(R.edges)#, bw=rnd.randint(1, 500), lat=5)
		for e in self.edges():
			nx.set_edge_attributes(self, {e: {'lat': rnd.randint(1, 20)}}) 

	def set_grouped_nodes(self):
		for t in TYPES:
			self.gnodes[t] = [x for x, y in nx.get_node_attributes(self, 'ntype').items() if y == t]

	def set_links(self):
		sp = nx.floyd_warshall_numpy(self, weight='lat')
		for i,j in product(range(self.n), repeat=2):
			bw = rnd.randint(20, 250) if i != j else float('inf')
			if self.has_edge(i, j):
				nx.set_edge_attributes(self, {(i, j): {'bw': bw}}) 
			else:
				self.add_edge(i, j, lat=int(sp[i,j]), bw=bw)

	def set_as_cloud(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cloud'
		node['software'] = SW_CAPS
		node['security'] = ["enc", "auth"]

	def set_as_isp(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'isp'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		node['security'] = ["enc"]

	def set_as_cabinet(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cabinet'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		node['security'] = ["enc", "auth"]
		node['things'] = get_random_things(n=rnd.randint(1, 3))

	def set_as_accesspoint(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'accesspoint'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		node['security'] = ["enc", "auth"]
		node['things'] = get_random_things(n=rnd.randint(1, 3))

	def set_as_thing(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'thing'
		node['software'] = get_random_sw_caps(size=rnd.randint(1, 4))
		node['security'] = ["enc", "auth"]
		node['things'] = get_random_things(n=rnd.randint(1, 4))

	def dummy_links(self, lat, bw):
		for n1, n2 in product(self.nodes(), repeat=2):
			if n1 != n2:
				if self.has_edge(n1, n2):
					nx.set_edge_attributes(self, {(n1,n2): {'lat':lat, 'bw':bw}})
				else:
					self.add_edge(n1, n2, lat=lat, bw=bw)

	def get_thresholds(self):
		bwTh = "bwTh({}).".format(self._bwTh)
		hwTh = "hwTh({}).".format(self._hwTh)

		return "{}\n{}\n".format(bwTh, hwTh)

	def get_domain(self):
		return "domain(all, [_])."

	def get_nodes(self):
		nodes_str = ""
		nodes = list(self.nodes(data=True))
		rnd.shuffle(nodes)

		for (nid, nattr) in nodes:
			nodes_str += "node({}, {ntype}, {software}, {hardware}, {security}, {things}).\n".format(nid,**nattr).replace("'", "")
		return nodes_str

	def get_links(self):
		links_str = ""
		links = list(self.edges(data=True))
		rnd.shuffle(links)

		for n1, n2, lattr in links:
			links_str += "link({}, {}, {lat}, {bw}).\n".format(n1, n2, **lattr).replace("'", "")
			if n1 != n2:
				links_str += "link({}, {}, {lat}, {bw}).\n".format(n2, n1, **lattr).replace("'", "")
		return links_str

	def __str__(self):
		infra = ""
		infra += self.get_thresholds() + "\n"
		infra += self.get_nodes() + "\n"
		infra += self.get_links() + "\n"
		infra += self.get_domain() + "\n"
		return infra

	def get_gnodes(self):
		return list([[k, len(v)] for k,v in self.gnodes.items()])

	def upload(self, file=None):
		if file is None:
			file = self.file
		with open(file, "w+") as f:
			f.write(str(self))


def main(n, seed=None, dummy=False):
	infra = Builder(n, dummy=dummy)
	info = [['SEED:', seed if seed else '<not set>'], ['DUMMY:', 'YES' if dummy else 'NO'], ['PATH:', infra.file]]

	if dummy:
		infra.dummy_links(lat=DUMMY_LAT, bw=DUMMY_BW)

	print(Fore.LIGHTCYAN_EX + tabulate(info))

	print(Fore.GREEN + f"NODES: {n}", end="\n")
	print(Fore.LIGHTGREEN_EX + tabulate(infra.get_gnodes()))

	if NOT_PLACED_THINGS:
		raise ValueError(Fore.LIGHTRED_EX + "Not all IoT were placed in the infrastructure, {} left.".format(NOT_PLACED_THINGS))
	else:
		infra.upload()


if __name__ == "__main__":
	set_printoptions(threshold=sys.maxsize)
	init(autoreset=True)

	parser = init_parser()
	args = parser.parse_args()

	
	THINGS = args.things if args.things else THINGS
	rnd.seed(args.seed)
	main(args.n, args.seed, dummy=args.dummy)

