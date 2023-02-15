import os
from os.path import abspath, dirname, exists, isfile, join

import numpy
from scipy.stats import truncnorm

# path to the main directories
ROOT_DIR = dirname(dirname(dirname(abspath(__file__))))
DATA_DIR = join(ROOT_DIR, 'data')
VERSIONS_DIR = join(ROOT_DIR, 'versions')
PL_UTILS_DIR = join(ROOT_DIR, 'pl-utils')
OUTPUT_DIR = join(ROOT_DIR, 'output')

INFRS_DIR = join(DATA_DIR, 'infrs')
APPS_DIR = join(DATA_DIR, 'apps')
MODELS_DIR = join(DATA_DIR, 'models')

PLOTS_DIR = join(OUTPUT_DIR, 'plots')
CSV_DIR = join(OUTPUT_DIR, 'csv')

COMPARISON_FILE = join(CSV_DIR, 'comparison.csv')


def check_files(app=None, infr=None, versions=None, dummy_infr=False):
	result = []
	if app:
		result.append(check_app(app))
	if infr:
		result.append(check_infr(infr, dummy_infr))
	
	result.append(check_versions(versions) if versions else [])

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


def df_to_file(df, file_path):

	# create the directory if it doesn't exist
	dir = dirname(file_path)
	os.makedirs(dir) if not exists(dir) else None		
	df.to_csv(file_path, mode='a', header=(not isfile(file_path)))


def normal_distribution(min_value=32, max_value=1024, center=512, size_of_federation=128, stepping=32, deviation=None):

    def get_truncated_normal(mean=0, sd=1, low=0, upp=10):
        return truncnorm((low - mean) / sd, (upp - mean) / sd, loc=mean, scale=sd)
    
    if min_value > max_value:
        raise ValueError('min_value should be smaller than max_value')
    
    if not max_value/stepping:
        raise ValueError('max_value should be a multiple of stepping')

    if not min_value/stepping:
        raise ValueError('min_value should be a multiple of stepping')

    if not min_value < center < max_value:
        raise ValueError('center should be between min_value and max_value')

    if size_of_federation < 1:
        raise ValueError('size_of_federation should be greater than 0')

    max_step = int(max_value/stepping)
    if min_value == 0: 
        min_step = int(min_value/stepping)
    else:
        min_step = max(1, int(min_value/stepping)) # to avoid min_value = 0 when stepping is greater than min_value
    mean_step = int(center/stepping)

    if deviation is None:
        m = max(max_step-mean_step, mean_step-min_step)
        deviation = m/3

    x = get_truncated_normal(mean=mean_step, sd=deviation, low=min_step, upp=max_step)

    result = numpy.rint(x.rvs(size_of_federation)) * stepping
    return result
