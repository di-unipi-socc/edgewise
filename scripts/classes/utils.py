import time
from glob import iglob
from os import listdir, makedirs
from os.path import abspath, dirname, exists, getctime, isfile, join

import numpy
from pandas import concat, read_csv
from scipy.stats import truncnorm

TIME_FORMAT = "%Y%m%d-%H%M%S"
PLOT_FORMAT = "pdf"

# Paths to the main directories
ROOT_DIR = dirname(dirname(dirname(abspath(__file__))))
DATA_DIR = join(ROOT_DIR, "data")
PL_UTILS_DIR = join(ROOT_DIR, "pl-utils")
VERSIONS_DIR = join(ROOT_DIR, "versions")

APPS_DIR = join(DATA_DIR, "apps")
INFRS_DIR = join(DATA_DIR, "infrs")
GMLS_DIR = join(DATA_DIR, "gml")
MODELS_DIR = join(DATA_DIR, "models")
OUTPUT_DIR = join(DATA_DIR, "output")

CSV_DIR = join(OUTPUT_DIR, "csv")
PLOTS_DIR = join(OUTPUT_DIR, "plots")

PLOTS_SUBDIR = join(PLOTS_DIR, time.strftime(TIME_FORMAT))
PLOT_PATH = join(PLOTS_SUBDIR, "{name}." + PLOT_FORMAT)

COMPARE_FILE = "compare_{}.csv"
COMPARE_PATTERN = join(CSV_DIR, COMPARE_FILE.format("*"))
COMPARE_PATH = join(CSV_DIR, COMPARE_FILE.format("now"))

BUDGETS_FILE = "budgets_{}.csv"
BUDGETS_PATTERN = join(CSV_DIR, BUDGETS_FILE.format("*"))
BUDGETS_PATH = join(CSV_DIR, BUDGETS_FILE.format("now"))

GML_FILE = "{name}.gml"
GML_PATH = join(GMLS_DIR, GML_FILE)
GML_CHOICES = [f[:-4] for f in listdir(GMLS_DIR) if f.endswith(".gml")]

RESULTS_FILE = "results_{}.csv"
RESULTS_PATTERN = join(OUTPUT_DIR, RESULTS_FILE.format("*"))
RESULTS_PATH = join(OUTPUT_DIR, RESULTS_FILE.format(time.strftime(TIME_FORMAT)))

# Prolog queries
MAIN_QUERY = "once(stats(App, Placement, Cost, Bins, Infs, Time))"
ALLOC_QUERY = "allocatedResources({placement}, AllocHW, AllocBW)"
PREPROCESS_QUERY = "preprocess({app_name}, Compatibles)"
COST_QUERY = "cost({ntype}, {compid}, Cost)"

PL = "declarative"
PL_NUM = f"{PL} (num)"
MILP = "MILP"
EDGEWISE = "EdgeWise"

# Timeout for Prolog and OR-Tools processes: default 1h
TIMEOUT = 3600  # seconds


def check_files(app=None, infr=None, versions=None, dummy_infr=False):
    result = []
    result.append(check_app(app)) if app else None
    result.append(check_infr(infr, dummy_infr)) if infr else None
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
    infr = join(INFRS_DIR, "dummy" if dummy else "")
    infr = join(infr, "infr{}.pl".format(name))

    if not exists(infr):
        raise FileNotFoundError("Infrastructure file not found at {}".format(infr))

    return infr


def check_versions(versions):
    files = []
    for v in versions:
        # newDAP/versions/<v>.pl
        f = join(VERSIONS_DIR, "{}.pl".format(v))
        if not exists(f):
            raise FileNotFoundError("Version file not found at {}".format(f))
        files.append(f)

    return sorted(files)


def df_to_file(df, file_path):

    # create the directory if it doesn't exist
    dir = dirname(file_path)
    makedirs(dir) if not exists(dir) else None
    df.to_csv(file_path, mode="a", header=(not isfile(file_path)))


def get_latest_file(pattern):
    # get the latest file in the directory respecting the pattern
    return max(iglob(pattern), key=getctime)


def merge_results():
    files = iglob(COMPARE_PATTERN)
    df = concat(map(read_csv, files), ignore_index=True)
    return df


def normal_distribution(
    min_value=32,
    max_value=1024,
    center=512,
    size_of_federation=128,
    stepping=32,
    deviation=None,
):

    def get_truncated_normal(mean=0, sd=1, low=0, upp=10):
        return truncnorm((low - mean) / sd, (upp - mean) / sd, loc=mean, scale=sd)

    if min_value > max_value:
        raise ValueError("min_value should be smaller than max_value")

    if not max_value / stepping:
        raise ValueError("max_value should be a multiple of stepping")

    if not min_value / stepping:
        raise ValueError("min_value should be a multiple of stepping")

    if not min_value < center < max_value:
        raise ValueError("center should be between min_value and max_value")

    if size_of_federation < 1:
        raise ValueError("size_of_federation should be greater than 0")

    max_step = int(max_value / stepping)
    # to avoid min_value = 0 when stepping is greater than min_value
    min_step = (
        int(min_value / stepping)
        if min_value == 0
        else max(1, int(min_value / stepping))
    )
    mean_step = int(center / stepping)

    if deviation is None:
        m = max(max_step - mean_step, mean_step - min_step)
        deviation = m / 3

    x = get_truncated_normal(mean=mean_step, sd=deviation, low=min_step, upp=max_step)

    result = numpy.rint(x.rvs(size_of_federation)) * stepping
    return result
