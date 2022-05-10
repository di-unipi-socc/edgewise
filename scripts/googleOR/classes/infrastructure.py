import networkx as nx
import parse as p
from scripts.utils import check_infr

BW_TH = "bwTh({})."
HW_TH = "hwTh({})."

NODE = "node({id}, {type}, {swcaps}, {hwcaps}, {seccaps}, {iotcaps})."
LINK = "link({source}, {target}, {lat}, {bw})."


class Infrastructure(nx.DiGraph):
	def __init__(self, size, dummy=False):
		super().__init__()
		self._hwTh = None
		self._bwTh = None

		self.parse(size, dummy)

	def parse(self, size, dummy):
		infr_file = check_infr(size, dummy)

		with open(infr_file, "r") as f:
			lines = f.read().splitlines()

			bw_th = next(i for i in lines if i.startswith("bwTh("))
			hw_th = next(i for i in lines if i.startswith("hwTh("))
			nodes = [i for i in lines if i.startswith("node(")]
			links = [i for i in lines if i.startswith("link(")]

			self.set_thresholds(bw_th, hw_th)
			self.add_nodes(nodes)
			self.add_links(links)

	def parse_node(self, data):
		out = p.parse(NODE, data)
		if not out:
			raise ParseException("Node parse error: {}".format(data))

		out = out.named
		self.add_node(out.pop("id"), **out)

	def parse_link(self, data):
		out = p.parse(LINK, data)
		if not out:
			raise ParseException("Link parse error: {}".format(data))

		out = out.named
		self.add_edge(out.pop("source"), out.pop("target"), **out)

	def add_nodes(self, nodes):
		for n in nodes:
			self.parse_node(n)

	def add_links(self, links):
		for e in links:
			self.parse_link(e)

	def set_thresholds(self, bw_th, hw_th):
		out_bw = int(p.parse(BW_TH, bw_th).fixed[0])
		out_hw = int(p.parse(HW_TH, hw_th).fixed[0])

		self._bwTh = out_bw
		self._hwTh = out_hw

	def get_thresholds(self):
		bwTh = "bwTh({}).".format(self._bwTh)
		hwTh = "hwTh({}).".format(self._hwTh)

		return "{}\n{}\n".format(bwTh, hwTh)

	def get_nodes(self):
		nodes_str = ""
		nodes = list(self.nodes(data=True))

		for (nid, nattr) in nodes:
			nodes_str += "node({}, {type}, {swcaps}, {hwcaps}, {seccaps}, {iotcaps}).\n".format(nid, **nattr).replace("'", "")
		return nodes_str

	def get_links(self):
		links_str = ""
		links = list(self.edges(data=True))

		for n1, n2, lattr in links:
			links_str += "link({}, {}, {lat}, {bw}).\n".format(n1, n2, **lattr).replace("'", "")
		return links_str

	def __str__(self):
		return "{}\n{}\n{}".format(self.get_thresholds(), self.get_nodes(), self.get_links())


class ParseException(Exception):
	def __init__(self, message):
		self.message = message
