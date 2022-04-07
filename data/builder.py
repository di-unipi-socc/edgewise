import networkx as nx
from numpy import random as rnd
import argparse as ap

HW_PLATFORMS = ['arm64', 'x86']
TYPES = ['cloud', 'isp', 'cabinet', 'accesspoint', 'thing']
PROBS = [0.1, 0.2, 0.3, 0.2, 0.2]
THINGS = ['iphoneXS', 'echoDot']


class Infra(nx.DiGraph):
	def __init__(self, n):
		super().__init__()
		self.gnodes = {} # nodes grouped by TYPES
		self._file = "infr/infr{}.pl".format(n)
		self._bwTh = 5
		self._hwTh = 2

		self.set_nodes(n)

	def set_nodes(self, n):
		self.add_nodes_from([f"n{i}" for i in range(0, n)], things=[])
		for node in self.nodes:
			ntype = rnd.choice(TYPES, p=PROBS)
			method = 'set_as_{}'.format(ntype)
			getattr(self, method)(node)
		self.set_grouped_nodes()

	def set_grouped_nodes(self):
		for t in TYPES:
			self.gnodes[t] = [x for x, y in nx.get_node_attributes(self, 'ntype').items() if y == t]

	def add_links(self, type1, type2, lat=1, bw=500):
		for n1 in self.gnodes[type1]:
			for n2 in self.gnodes[type2]:
				if n1 != n2:
					self.add_edge(n1, n2, lat=lat, bw=bw)

	def set_as_cloud(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cloud'
		node['software'] = ["ubuntu", "mySQL", "gcc", "python"]
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 1024)
		node['security'] = ["enc", "auth"]

	def set_as_isp(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'isp'
		node['software'] = ["ubuntu", "mySQL"]
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 512)
		node['security'] = ["enc"]

	def set_as_cabinet(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'cabinet'
		node['software'] = ["ubuntu", "mySQL"]
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 256)
		node['security'] = ["enc"]

	def set_as_accesspoint(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'accesspoint'
		node['software'] = ["ubuntu", "gcc", "python"]
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 128)
		node['security'] = ["enc", "auth"]
		# randomly assign 1 IoT device
		if THINGS:
			node['things'] = [THINGS.pop(rnd.randint(len(THINGS)))]

	def set_as_thing(self, nid):
		node = self.nodes[nid]
		node['ntype'] = 'thing'
		node['software'] = ["android", "gcc", "python"]
		hw_platform = rnd.choice(HW_PLATFORMS)
		node['hardware'] = (hw_platform, 64)
		node['security'] = ["enc", "auth"]
		# randomly assign 1 IoT device
		if THINGS:
			node['things'] = [THINGS.pop(rnd.randint(len(THINGS)))]

	def dummy_links(self, lat, bw):
		for n1 in self.nodes:
			for n2 in self.nodes:
				if n1 != n2:
					self.add_edge(n1, n2, lat=lat, bw=bw)

	def get_thresholds(self):
		bwTh = "bwTh({}).".format(self._bwTh)
		hwTh = "hwTh({}).".format(self._hwTh)

		return "{}\n{}\n".format(bwTh, hwTh)

	def get_domain(self):
		return "domain(all, [_])."

	def get_nodes(self):
		nodes = ""
		for (nid, nattr) in self.nodes(data=True):
			nodes += "node({}, {ntype}, {software}, {hardware}, {security}, {things}).\n".format(nid, **nattr).replace("'", "")
		return nodes

	def get_links(self):
		links = ""
		for n1, n2, lattr in self.edges(data=True):
			links += "link({},{},{lat},{bw}).\n".format(n1, n2, **lattr).replace("'", "")
		return links

	def __str__(self):
		infra = ""
		infra += self.get_thresholds() + "\n"
		infra += self.get_nodes() + "\n"
		infra += self.get_links() + "\n"
		infra += self.get_domain() + "\n"
		infra += "\n"
		return infra

	def upload(self, file=None):
		if file is None:
			file = self._file
		with open(file, "w+") as f:
			f.write(str(self))


def generate_from_basename(g, n, basename=""):
	nodes = [basename + str(i) for i in range(0, n)]
	g.add_nodes_from(nodes)
	return nodes


def main(nodesnumber):
	infra = Infra(nodesnumber)
	infra.add_links('cloud', 'cloud', 20, 1000)
	infra.add_links('cloud', 'isp', 110, 1000)
	infra.add_links('cloud', 'cabinet', 135, 100)
	infra.add_links('cloud', 'accesspoint', 148, 20)
	infra.add_links('cloud', 'thing', 150, 18)

	infra.add_links('isp', 'cloud', 110, 1000)
	infra.add_links('isp', 'isp', 20, 1000)
	infra.add_links('isp', 'cabinet', 25, 500)
	infra.add_links('isp', 'accesspoint', 38, 50)
	infra.add_links('isp', 'thing', 20, 1000)

	infra.add_links('cabinet', 'cloud', 135, 100)
	infra.add_links('cabinet', 'isp', 25, 50)
	infra.add_links('cabinet', 'cabinet', 20, 100)
	infra.add_links('cabinet', 'accesspoint', 13, 50)
	infra.add_links('cabinet', 'thing', 15, 35)

	infra.add_links('accesspoint', 'cloud', 148, 50)
	infra.add_links('accesspoint', 'isp', 38, 80)
	infra.add_links('accesspoint', 'cabinet', 13, 80)
	infra.add_links('accesspoint', 'accesspoint', 10, 10)
	infra.add_links('accesspoint', 'thing', 2, 20)

	infra.add_links('thing', 'cloud', 150, 50)
	infra.add_links('thing', 'isp', 40, 50)
	infra.add_links('thing', 'cabinet', 15, 50)
	infra.add_links('thing', 'accesspoint', 2, 20)
	infra.add_links('thing', 'thing', 15, 50)
	
	#infra.dummy_links(lat=5, bw=700)
	infra.upload()
	
	print(infra.gnodes)


def init_parser() -> ap.ArgumentParser:
	usage = "<%(prog)s> n"
	description = "Generate random infrastructure made of a given number of nodes."
	parser = ap.ArgumentParser(usage=usage, description=description)

	parser.add_argument("n", type=int, help="Number of infrastructure nodes to generate.")

	return parser


if __name__ == "__main__":
	parser = init_parser()
	args = parser.parse_args()
	main(args.n)