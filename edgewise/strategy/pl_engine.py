import time
from typing import (
    Any,
    Dict,
    Optional,
)

from swiplserver import PrologThread

from edgewise.utils import (
    DEPLOYED_QUERY,
    PL_QUERY,
    PL_STRATEGY_DIR,
    prolog_to_dict,
    timed_async_query,
    timed_query,
)


def pl_process(
    prolog: PrologThread,
    app_name: str,
    preprocess: bool = False,
    cr: bool = False,
    timeout: Optional[int] = None,
) -> Optional[Dict[str, Any]]:

    if preprocess:
        timed_query(prolog, f"consult('{PL_STRATEGY_DIR / 'binpack.pl'}')")
        if not cr:
            timed_query(prolog, query="retract(deployed(_,_))")
    else:
        timed_query(prolog, f"consult('{PL_STRATEGY_DIR / 'binpack_num.pl'}')")

    start_time = time.time()
    r = timed_async_query(
        prolog,
        query=PL_QUERY.format(app=app_name),
        timeout=timeout,
    )
    end_time = time.time() - start_time

    mapping = prolog_to_dict(r["Placement"]) if r else {}
    cost = r["Cost"] if r else float("inf")
    exec_time = timeout if r is None else end_time if r == False else r["Time"]

    if mapping:
        str_pl = (
            "[" + ", ".join(["({}, {})".format(s, n) for s, n in mapping.items()]) + "]"
        )
        print(f"Assert PL mapping: {str_pl}")
        timed_query(
            prolog,
            query=f"assert({DEPLOYED_QUERY.format(app=app_name, placement=str_pl)})",
        )
    else:
        timed_query(prolog, query="retractall(deployed(_,_))")

    return mapping, cost, exec_time
