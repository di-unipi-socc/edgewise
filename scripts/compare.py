import os
import argparse as ap
from os.path import dirname, abspath, exists, join, basename

# ../../newDAP/
ROOT_DIR = dirname(dirname(abspath(__file__)))
QUERY = "time(best(App, Placement, Cost, Budget))"


def init_parser() -> ap.ArgumentParser:
	usage = "<%(prog)s> n"
	description = "Compare several placement strategies"
	p = ap.ArgumentParser(usage=usage, description=description)

	p.add_argument("versions", nargs='+', help="List of the versions to compare.")
	p.add_argument("n", type=int, help="Infrastructure size.")

	return p


def main(versions, n=32):
	infr = join(ROOT_DIR, "data", "infr", "infr{}.pl".format(n))
	if not exists(infr):
		raise Exception("No infrastructure file found at {}".format(infr))

	files = []
	for v in versions:
		f = join(ROOT_DIR, "versions", "{}.pl".format(v))
		if not exists(f):
			raise Exception("No version file found at {}".format(f))
		files.append(f)
	print("CONSIDERED VERSIONS: {}".format([basename(f) for f in files]))


if __name__ == "__main__":
	parser = init_parser()
	args = parser.parse_args()
	main(args.versions, args.n)
