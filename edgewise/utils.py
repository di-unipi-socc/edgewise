from __future__ import annotations

from pathlib import Path
from typing import Optional

import numpy as np
from scipy.stats import truncnorm
from swiplserver import (
    PrologQueryTimeoutError,
    PrologResultNotAvailableError,
    PrologThread,
    prolog_args,
)

ROOT_DIR = Path(__file__).parent
INFRS_DIR = ROOT_DIR / "infrastructures"
PL_UTILS_DIR = ROOT_DIR / "pl-utils"
PL_STRATEGY_DIR = ROOT_DIR / "strategy" / "prolog"
PREPROCESS_FILE = PL_UTILS_DIR / "preprocessing.pl"
REQUIREMENTS_FILE = PL_UTILS_DIR / "requirements.pl"
COSTS_FILE = PL_UTILS_DIR / "costs.pl"

PREPROCESS_QUERY = "preprocess({app_name}, Compatibles)"
PL_QUERY = "stats({app}, Placement, Cost, Bins, Infs, Time)"
COST_QUERY = "cost({ntype}, {compid}, Cost)"
DEPLOYED_QUERY = "deployed({app}, {placement})"


def prolog_to_dict(p):
    return dict(list(map((lambda x: prolog_args(x)), p)))


def parse_compatibles(r):
    compatibles = {}
    for t in r:
        name, comps = prolog_args(t)
        compatibles[name] = {}
        for c in comps:
            n, cost = prolog_args(c)
            compatibles[name][n] = round(float(cost), 4)
    return compatibles


def timed_async_query(
    prolog: PrologThread,
    query: str,
    timeout: Optional[int] = None,
    find_all: Optional[bool] = False,
):
    try:
        prolog.query_async(query, find_all=find_all)
        r = prolog.query_async_result(wait_timeout_seconds=timeout)
        if not find_all:
            prolog.cancel_query_async()
        r = r[0] if isinstance(r, list) else r
    except PrologResultNotAvailableError:
        print(f"Timeout: {query} took longer than {timeout} seconds.")
        prolog.cancel_query_async()
        r = None

    return r


def timed_query(
    prolog: PrologThread,
    query: str,
    timeout: Optional[int] = None,
):
    try:
        r = prolog.query(query, query_timeout_seconds=timeout)
    except PrologQueryTimeoutError:
        print(f"Timeout: {query} took longer than {timeout} seconds.")
        r = None

    return r


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

    result = np.rint(x.rvs(size_of_federation)) * stepping
    return result
