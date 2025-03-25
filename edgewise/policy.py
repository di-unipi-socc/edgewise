from __future__ import annotations

import random as rnd
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from networkx.classes.reportviews import NodeView


def kill_policy(kill_probability: float):

    def node_update_wrapper(nodes: NodeView):
        for n, resources in nodes.data():
            # if resources["IoT"] != []:
            #     continue
            if rnd.random() < kill_probability:
                resources["availability"] = 0
                # print(f"Killed node {n}")
            else:
                resources["availability"] = 0.99
                # print(f"Revived node {n}")

    return node_update_wrapper


__all__ = ["kill_policy"]
