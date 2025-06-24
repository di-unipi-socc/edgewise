from pathlib import Path
from time import time

import ray
from eclypse.simulation import (
    Simulation,
    SimulationConfig,
)
from eclypse.utils import DEFAULT_SIM_PATH
from ray import (
    train,
    tune,
)
from swiplserver import PrologMQI

from edgewise.applications import get_application
from edgewise.assets import (
    get_edge_assets,
    get_node_assets,
    get_path_aggregators,
)
from edgewise.infrastructures import get_infrastructure
from edgewise.metrics import get_metrics
from edgewise.policy import kill_policy
from edgewise.search_space import search_space
from edgewise.strategy import get_strategy


def edgewise_grid(config):
    stg = train.get_context().get_storage()
    path = (
        Path(stg.storage_fs_path)
        / stg.experiment_dir_name
        / str(stg.trial_dir_name)
        / "output"
    )

    sim_config = SimulationConfig(
        seed=config["seed"],
        max_ticks=config["max_ticks"],
        include_default_callbacks=False,
        callbacks=get_metrics(),
        path=path,
        # path=DEFAULT_SIM_PATH / "trial",
        log_level="ERROR",
        # log_to_file=True,
    )

    app = get_application(
        application_id=config["application_id"],
        node_assets=get_node_assets(),
        edge_assets=get_edge_assets(),
        seed=config["seed"],
    )

    node_update_policy = kill_policy(config["kill_prob"])

    infr = get_infrastructure(
        n=config["nodes"],
        seed=config["seed"],
        topology=config["topology"],
        node_assets=get_node_assets(config["preprocess"], is_app=False),
        edge_assets=get_edge_assets(),
        path_assets_aggregators=get_path_aggregators(),
        node_update_policy=node_update_policy,
    )

    with PrologMQI(mqi_traces=None) as mqi:
        with mqi.create_thread() as prolog:
            sim = Simulation(infrastructure=infr, simulation_config=sim_config)

            sim.register(app, get_strategy(prolog=prolog, **config))

            sim.start()
            sim.wait()


if __name__ == "__main__":
    config_example = {
        "application_id": "distSecurity",
        "cr": True,
        "declarative": True,
        "kill_prob": 0.1,
        "max_ticks": 30,
        "nodes": 128,
        "preprocess": True,
        "seed": 300425,
        "timeout": 100,
        "topology": "BA",
    }

    # edgewise_grid(config_example)

    ray.init(address="auto")

    start_time = time()
    run_config = train.RunConfig(storage_path=(DEFAULT_SIM_PATH).resolve())
    tuner = tune.Tuner(
        tune.with_resources(edgewise_grid, {"cpu": 2}),
        param_space=search_space,
        run_config=run_config,
    )

    # tuner = tune.Tuner.restore(
    #     "/home/massa/eclypse-sim/edgewise_grid_2025-02-20_15-07-31",
    #     trainable=tune.with_resources(edgewise_grid, {"cpu": 2}),
    #     param_space=search_space,
    #     restart_errored=True,
    # )

    tuner.fit()
    print("Elapsed time: ", time() - start_time)
