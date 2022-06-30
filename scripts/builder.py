import argparse as ap
from os.path import join
from itertools import product

import networkx as nx
from numpy import log2, set_printoptions
from numpy import random as rnd

from colorama import Fore, init
from tabulate import tabulate

from googleOR.classes.utils import INFRS_DIR

HW_PLATFORMS = ['arm64', 'x86']
SW_CAPS = ['ubuntu', 'mySQL', 'python', 'js', 'gcc']
TYPES = ['cloud', 'isp', 'cabinet', 'accesspoint', 'thing']
PROBS = [0.1, 0.2, 0.3, 0.2, 0.2]
THINGS = ['soil', 'heat', 'water', 'nutrient', 'energy', 'piCamera1', 'piCamera2', 'arViewer',
		  'cam11', 'cam12', 'cam21', 'cam22',
		  'iphoneXS', 'echoDot']

NOT_PLACED_THINGS = len(THINGS)

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


class Infra(nx.Graph):
	def __init__(self, n, seed, dummy=False):
		super().__init__()
		self._bwTh = 3
		self._hwTh = 1

		self.n = n
		self.file = "infr{}.pl".format(self.n) 	
		self.gnodes = {}  # nodes grouped by TYPES

		self.set_filepath(dummy)
		self.set_nodes(n, seed)
		self.set_links()
		nx.relabel_nodes(self, lambda x: f"n{x}", copy=False)

	def set_filepath(self, dummy):
		path = INFRS_DIR
		if dummy:
			path = join(path, "dummy")

		self.file = join(path, self.file)

	def set_nodes(self, n, seed):
		i = int(log2(n))
		R = nx.barabasi_albert_graph(n, 3, seed=seed)
		# R = nx.complete_graph(n, nx.DiGraph())
		# R = nx.relabel_nodes(R, lambda x: f"n{x}")
		self.add_nodes_from(R, things=[])
		for node in self.nodes:
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

	""" def add_links(self, type1, type2, lat=1, bw=500):
		for n1 in self.gnodes[type1]:
			for n2 in self.gnodes[type2]:
				if n1 != n2 and self.has_edge(n1, n2):
					nx.set_edge_attributes(self, {(n1,n2): {'lat':lat, 'bw':bw}}) """

	def set_links(self):
		sp = nx.floyd_warshall_numpy(self, weight='lat')
		for i,j in product(range(self.n), repeat=2):
			bw = rnd.randint(20, 250) if i!= j else float('inf')
			if self.has_edge(i, j):
				nx.set_edge_attributes(self, {(i, j): {'bw': bw}}) 
			else:
				self.add_edge(i, j, lat=int(sp[i,j]), bw=bw)

	def set_as_cloud(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cloud'
		node['software'] = SW_CAPS
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 1024)
		node['security'] = ["enc", "auth"]

	def set_as_isp(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'isp'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, rnd.choice([256, 512]))
		node['security'] = ["enc"]

	def set_as_cabinet(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cabinet'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, rnd.choice([128, 256]))
		node['security'] = ["enc", "auth"]
		# randomly assign IoT device(s)
		node['things'] = get_random_things(n=rnd.randint(1, 3))

	def set_as_accesspoint(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'accesspoint'
		node['software'] = get_random_sw_caps(size=rnd.randint(2, 5))
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 64)
		node['security'] = ["enc", "auth"]
		# randomly assign IoT device(s)
		node['things'] = get_random_things(n=rnd.randint(1, 3))

	def set_as_thing(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'thing'
		node['software'] = get_random_sw_caps(size=rnd.randint(1, 4))
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 32)
		node['security'] = ["enc", "auth"]
		# randomly assign IoT device(s)
		node['things'] = get_random_things(n=rnd.randint(1, 4))

	def dummy_links(self, lat, bw):
		for n1, n2 in product(self.nodes(), repeat=2):
			if n1 != n2: #self.has_edge(n1, n2):
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
		infra += "\n"
		return infra

	def get_gnodes(self):
		return list([[k, len(v)] for k,v in self.gnodes.items()])

	def upload(self, file=None):
		if file is None:
			file = self.file
		with open(file, "w+") as f:
			f.write(str(self))


def main(n, seed=None, dummy=False):
	infra = Infra(n, seed=seed, dummy=dummy)
	#assert(NOT_PLACED_THINGS == 0)
	info = [['SEED:', seed], ['DUMMY:', 'YES' if dummy else 'NO']]

	if dummy:
		infra.dummy_links(lat=5, bw=700)
	else:
		pass
		""" infra.add_links('cloud', 'cloud', 20, 1000)
		infra.add_links('cloud', 'isp', 50, 1000)
		infra.add_links('cloud', 'cabinet', 50, 100)
		infra.add_links('cloud', 'accesspoint', 60, 20)
		infra.add_links('cloud', 'thing', 65, 30)

		infra.add_links('isp', 'cloud', 50, 1000)
		infra.add_links('isp', 'isp', 20, 1000)
		infra.add_links('isp', 'cabinet', 25, 500)
		infra.add_links('isp', 'accesspoint', 30, 50)
		infra.add_links('isp', 'thing', 20, 1000)

		infra.add_links('cabinet', 'cloud', 60, 100)
		infra.add_links('cabinet', 'isp', 25, 50)
		infra.add_links('cabinet', 'cabinet', 20, 100)
		infra.add_links('cabinet', 'accesspoint', 13, 50)
		infra.add_links('cabinet', 'thing', 15, 35)

		infra.add_links('accesspoint', 'cloud', 65, 50)
		infra.add_links('accesspoint', 'isp', 30, 80)
		infra.add_links('accesspoint', 'cabinet', 10, 80)
		infra.add_links('accesspoint', 'accesspoint', 10, 10)
		infra.add_links('accesspoint', 'thing', 2, 20)

		infra.add_links('thing', 'cloud', 65, 30)
		infra.add_links('thing', 'isp', 40, 50)
		infra.add_links('thing', 'cabinet', 15, 50)
		infra.add_links('thing', 'accesspoint', 2, 20)
		infra.add_links('thing', 'thing', 15, 50) """

	info.append(['PATH:', infra.file])
	print(Fore.LIGHTCYAN_EX + tabulate(info))

	print(Fore.GREEN + f"NODES: {n}", end="\n")
	print(Fore.LIGHTGREEN_EX + tabulate(infra.get_gnodes()))

	infra.upload()

def init_parser() -> ap.ArgumentParser:
	description = "Generate random infrastructure with a given number of nodes."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-d", "--dummy", action="store_true", help="set dummy links (low latency, high bandwidth)")
	p.add_argument("-s", "--seed", type=int, help="seed for random generation ('None' if not set)")
	p.add_argument("n", type=int, help="number of infrastructure nodes")
	p.add_argument("-t", "--things", nargs='*', help="list of IoT devices to be randomly placed")

	return p


if __name__ == "__main__":
	import sys
	set_printoptions(threshold=sys.maxsize)
	init(autoreset=True)
	parser = init_parser()
	args = parser.parse_args()

	if args.things:
		THINGS = args.things
	rnd.seed(args.seed)
	main(args.n, args.seed, dummy=args.dummy)

