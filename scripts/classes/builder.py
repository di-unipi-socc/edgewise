import argparse as ap
import sys
from itertools import product
from os import makedirs
from os.path import dirname, exists, join

import networkx as nx
from colorama import Fore, init
from numpy import random as rnd
from numpy import set_printoptions
from tabulate import tabulate
from utils import INFRS_DIR, normal_distribution

HW_PLATFORMS 	= ['arm64', 'x86']
SW_CAPS 		= ['ubuntu', 'mySQL', 'python', 'js', 'gcc']
LOCATIONS 		= ['de', 'es', 'fr', 'it']
PROVIDERS 		= ['aws', 'azure', 'gcp', 'ibm', 'yandex']
THINGS 			= ['soil', 'heat', 'water', 'nutrient', 'energy', 'piCamera1', 'piCamera2', 'arViewer', # arFarming
		  		'cam11', 'cam12', 'cam21', 'cam22', #distSecurity
		  		'iphoneXS', 'echoDot'] # speakToMe

SEC_CAPS_CLOUD 	= ['access_logs', 'authentication', 'host_ids', 'process_isolation', 'permission_model', 'resource_monitoring', 'restore_point', 'user_data_isolation', # virtualisation
                'certificates', 'firewall', 'enc_iot', 'node_isolation', 'network_ids', 'public_key_crypto', # communications
                'backup', 'enc_storage', # data
                'access_control', 'anti_tampering', # physical
                'audit'] # others

SEC_CAPS_EDGE 	= ['access_logs', 'authentication', 'host_ids', 'process_isolation', 'permission_model', 'resource_monitoring', 'user_data_isolation', # virtualisation
                'certificates', 'firewall', 'enc_iot', 'node_isolation', 'network_ids', 'public_key_crypto', # communications
                'backup', 'enc_storage', 'obfuscated_storage', # data,
                'access_control', 'anti_tampering', # physical
                'audit'] # others

SEC_CAPS_IOT 	= ['authentication', 'resource_monitoring', # virtualisation
                'firewall', 'enc_iot', 'node_isolation', 'public_key_crypto', 'wireless_security' # communications
                'enc_storage', 'obfuscated_storage', # data,
                'anti_tampering'] # physical
                # others

TYPES_PROBS 	= [0.15, 0.45, 0.4]
TYPES 			= {'cloud': {'sw': len(SW_CAPS), 'iot': None, 'sec': SEC_CAPS_CLOUD}, 
				   'edge': {'sw': (2, len(SW_CAPS)), 'iot': (1,3), 'sec': SEC_CAPS_EDGE},
				   'thing': {'sw': (1, len(SW_CAPS)-1), 'iot': (1,4), 'sec': SEC_CAPS_IOT}}

NOT_PLACED_THINGS = None
DUMMY_LAT, DUMMY_BW	= 5, 1000
BW_MIN, BW_MAX 	 = 20, 500
LAT_MIN, LAT_MAX = 2, 20


def init_parser() -> ap.ArgumentParser:
	description = "Generate random infrastructure with a given number of nodes."
	p = ap.ArgumentParser(prog=__file__, description=description)

	p.add_argument("-d", "--dummy", action="store_true", help="set dummy links (low latency, high bandwidth)")
	p.add_argument("-s", "--seed", type=int, help="seed for random generation ('None' if not set)")
	p.add_argument("n", type=int, help="number of infrastructure nodes")
	p.add_argument("-t", "--things", nargs='*', help="list of IoT devices to be randomly placed")

	return p


def get_random(l, size=1):
	return list(rnd.choice(l, size=size, replace=False))


def get_random_things(size=1):
	global NOT_PLACED_THINGS
	t = []
	for _ in range(size):
		if THINGS:
			t.append(THINGS.pop(rnd.randint(len(THINGS))))
			NOT_PLACED_THINGS -= 1
		else: break
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
		path = join(path, "dummy") if dummy else path
		self.file = join(path, self.file)

	def set_nodes(self, n):
		R = nx.complete_graph(n, nx.DiGraph())
		self.add_nodes_from(R, things=[])

		dist = normal_distribution(size_of_federation=n)

		for node in self.nodes:
			ntype = rnd.choice(list(TYPES.keys()), p=TYPES_PROBS)
			self.set_node(node, ntype, hw=int(dist[node]), sw_size=TYPES[ntype]['sw'], iot_size=TYPES[ntype]['iot'], sec_caps=TYPES[ntype]['sec'])

		self.add_edges_from(R.edges)
		for e in self.edges():
			nx.set_edge_attributes(self, {e: {'lat': rnd.randint(LAT_MIN, LAT_MAX)}}) 

		self.set_grouped_nodes()

	def set_grouped_nodes(self):
		self.gnodes = {t: [x for x, y in nx.get_node_attributes(self, 'nodeType').items() if y == t] for t in TYPES}

	def set_links(self):
		sp = nx.floyd_warshall_numpy(self, weight='lat')
		for i,j in product(range(self.n), repeat=2):
			bw = rnd.randint(BW_MIN, BW_MAX) if i != j else float('inf')
			if self.has_edge(i, j):
				nx.set_edge_attributes(self, {(i, j): {'bw': bw}}) 
			else:
				self.add_edge(i, j, lat=int(sp[i,j]), bw=bw)

	def set_node(self, nid, ntype, hw, sw_size=None, iot_size=None, sec_caps=None):
		node = self.nodes[nid]
		sw_min, sw_max = sw_size if isinstance(sw_size, tuple) else (0,0)
		iot_min, iot_max = iot_size if isinstance(iot_size, tuple) else (0,0)

		node['nodeType'] = ntype
		node['hardware'] = (rnd.choice(HW_PLATFORMS), hw)
		node['location'] = rnd.choice(LOCATIONS)
		node['provider'] = rnd.choice(PROVIDERS)
		node['software'] = SW_CAPS if sw_size == len(SW_CAPS) else get_random(SW_CAPS, size=rnd.randint(sw_min, sw_max)) if sw_size else []
		#node['security'] = SEC_CAPS if sec_size == LEN_SEC else get_random(SEC_CAPS, size=rnd.randint(sec_min, sec_max)) if sec_size else []
		node['security'] = sec_caps if sec_caps else []
		node['things'] = get_random_things(size=rnd.randint(iot_min, iot_max)) if iot_size else []

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

	def get_nodes(self):
		nodes = list(self.nodes(data=True))
		rnd.shuffle(nodes)

		nodes_str = "".join(["node({}, {software}, {hardware}, {security}, {things}).\n".format(nid,**nattr).replace("'", "") for (nid,nattr) in nodes])
		return nodes_str

	def get_links(self):
		links_str = ""
		links = list(self.edges(data=True))
		rnd.shuffle(links)

		for n1, n2, lattr in links:
			links_str += "link({}, {}, {lat}, {bw}).\n".format(n1, n2, **lattr).replace("'", "")
			links_str += "link({}, {}, {lat}, {bw}).\n".format(n2, n1, **lattr).replace("'", "") if n1 != n2 else ""
		return links_str
	
	def get_property(self, prop_name):
		return "".join(["{}({}, {}).\n".format(prop_name, nid, prop) for nid, prop in self.nodes(data=prop_name)])

	""" def get_security(self):
		s = {k: [nid for nid, sec in self.nodes(data='security') if k in sec] for k in SEC_CAPS}
		return "".join(["{}({}).\n".format(k, n) for k,v in s.items() for n in v]) """

	def __str__(self):
		infra = ""
		infra += self.get_thresholds() + "\n"
		infra += self.get_nodes() + "\n"
		infra += self.get_links() + "\n"
		infra += self.get_property('nodeType') + "\n"
		infra += self.get_property('location') + "\n"
		infra += self.get_property('provider')
		return infra

	def get_gnodes(self):
		return list([[k, len(v)] for k,v in self.gnodes.items()])

	def upload(self, file=None):
		file = self.file if not file else file
		makedirs(dirname(file)) if not exists(dirname(file)) else None		
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
	NOT_PLACED_THINGS = len(THINGS)
	rnd.seed(args.seed)
	main(args.n, args.seed, dummy=args.dummy)