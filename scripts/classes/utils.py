from os.path import abspath, dirname, join, exists

# path to the main directories
ROOT_DIR = dirname(dirname(dirname(abspath(__file__))))
DATA_DIR = join(ROOT_DIR, 'data')
VERSIONS_DIR = join(ROOT_DIR, 'versions')
UTILS_DIR = join(ROOT_DIR, 'utils')
OUTPUT_DIR = join(ROOT_DIR, 'output')

INFRS_DIR = join(DATA_DIR, 'infrs')
APPS_DIR = join(DATA_DIR, 'apps')
MODELS_DIR = join(DATA_DIR, 'models')

PLOTS_DIR = join(OUTPUT_DIR, 'plots')


def check_files(app=None, infr=None, dummy_infr=False, versions=None):
	result = []
	if app:
		result.append(check_app(app))
	if infr:
		result.append(check_infr(infr, dummy_infr))
	if versions:
		result.append(check_versions(versions))

	return result


def check_app(app):
	# newDAP/data/apps/<app>.pl
	app = join(APPS_DIR, "{}.pl".format(app))
	if not exists(app):
		raise FileNotFoundError("Application file not found at {}".format(app))

	return app


def check_infr(name, dummy):
	# newDAP/data/infrs/<dummy>/infr<name>.pl
	infr = INFRS_DIR
	if dummy:
		infr = join(infr, "dummy")
	infr = join(infr, "infr{}.pl".format(name))

	if not exists(infr):
		raise FileNotFoundError("No infrastructure file found at {}".format(infr))

	return infr


def check_versions(versions):
	files = []
	for v in versions:
		# newDAP/versions/<v>.pl
		f = join(VERSIONS_DIR, "{}.pl".format(v))
		if not exists(f):
			raise FileNotFoundError("No version file found at {}".format(f))
		files.append(f)
	files = sorted(files)

	return files
