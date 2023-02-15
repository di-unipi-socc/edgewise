from itertools import product

import networkx as nx
import parse as p

BW_TH = "bwTh({t:g})."
HW_TH = "hwTh({t:g})."

NODE = "node({id}, {type}, [{swcaps:to_list}], ({arch}, {hwcaps:g}), [{seccaps:to_list}], {iotcaps:to_list2})."
LINK = "link({source}, {target}, {lat:g}, {bw:g})."


def to_list_maybe_empty(s):  # due to a bug of 'parse' module
	s = s[1:-1]
	return [x.strip() for x in s.split(',')] if s else []


def to_list(s):
	return [x.strip() for x in s.split(',')] if s else []


class Infrastructure(nx.DiGraph):
	def __init__(self, file_path):
		
		super().__init__()
		self.hwTh = None
		self.bwTh = None
		self._file = file_path
		self._size = None

		with open(self._file, "r") as f:
			lines = f.read().splitlines()

			bw_th = next(i for i in lines if i.startswith("bwTh("))
			hw_th = next(i for i in lines if i.startswith("hwTh("))
			nodes = [i for i in lines if i.startswith("node(")]
			links = [i for i in lines if i.startswith("link(")]

			self.set_thresholds(bw_th, hw_th)
			self.add_nodes(nodes)
			self.add_links(links)	
			self._size = len(self.nodes())	

	def parse_node(self, data):
		out = p.parse(NODE, data, dict(to_list=to_list, to_list2=to_list_maybe_empty))
		if not out:
			raise ParseException("Node parse error: {}".format(data))

		out = out.named
		self.add_node(out.pop("id"), **out)

	def parse_link(self, data):
		out = p.parse(LINK, data)
		if not out:
			raise ParseException("Link parse error: {}".format(data))

		out = out.named
		src = out.pop("source")
		trg = out.pop("target")
		nx.set_edge_attributes(self, {(src, trg): out})

	def add_nodes(self, nodes):
		for n in nodes:
			self.parse_node(n)

	def add_links(self, links):
		# initialize links with lat = 'inf' and bw = 0
		all_links = list(product(self.nodes(), repeat=2))
		self.add_edges_from(all_links, lat=float('inf'), bw=0)

		# dummy links to a node itself
		self.set_self_links()

		# add links info from infrastructure file
		for e in links:
			self.parse_link(e)

	def set_self_links(self):
		for n in self.nodes():
			nx.set_edge_attributes(self, {(n, n): {'lat': 0, 'bw': float('inf')}})

	def set_thresholds(self, bw_th, hw_th):
		out_bw = p.parse(BW_TH, bw_th).named['t']
		out_hw = p.parse(HW_TH, hw_th).named['t']

		self.bwTh = out_bw
		self.hwTh = out_hw

	def update_allocated_resources(self, alloc_hw, alloc_bw):
		for n, hw in alloc_hw.items():
			self.nodes[n]['hwcaps'] -= float(hw)

		for (n1, n2), bw in alloc_bw.items():
			self.edges[n1, n2]['bw'] -= float(bw)

	def get_thresholds(self):
		bwTh = "bwTh({}).".format(self.bwTh)
		hwTh = "hwTh({}).".format(self.hwTh)

		return "{}\n{}\n".format(bwTh, hwTh)

	def get_nodes(self):
		nodes_str = ""
		nodes = list(self.nodes(data=True))

		for (nid, nattr) in nodes:
			nodes_str += "node({}, {type}, {swcaps}, ({arch}, {hwcaps}), {seccaps}, {iotcaps}).\n".format(nid, **nattr).replace(
				"'", "")
		return nodes_str

	def get_links(self):
		links_str = ""
		links = list(self.edges(data=True))

		for n1, n2, lattr in links:
			if n1 != n2: 
				links_str += "link({}, {}, {lat}, {bw}).\n".format(n1, n2, **lattr).replace("'", "")
		return links_str
	
	def get_domain(self):
		return "domain(all, [_])."
	
	def get_size(self):
		return self._size
	
	def get_file(self):
		return self._file
	
	def __str__(self):
		infra = ""
		infra += self.get_thresholds() + "\n"
		infra += self.get_nodes() + "\n"
		infra += self.get_links() + "\n"
		infra += self.get_domain() + "\n"
		return infra

	def upload(self, file=None):
		if not file:
			file = self._file
		with open(file, 'w') as f:
			f.write(str(self))

class ParseException(Exception):
	def __init__(self, message):
		self.message = message
