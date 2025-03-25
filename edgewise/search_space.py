from ray import tune

search_space = {
    "timeout": 1200,
    "max_ticks": 30,
    "application_id": tune.grid_search(
        [
            "speakToMe",
            "arFarming",
            "distSecurity",
        ]
    ),
    "kill_prob": 0.1,
    "seed": tune.grid_search(
        [
            3997,
            151195,
            300425,
        ]
    ),
    "topology": tune.grid_search(
        [
            "ER",
            "BA",
            "IAG",
        ]
    ),
    "declarative": tune.grid_search([False, True]),
    "preprocess": True,  # True,  # tune.grid_search([False, True]),
    "cr": tune.grid_search([False, True]),
    # "cr:" tune.grid_search([False, True]) if config["preprocess"] else False
    "nodes": tune.grid_search([2**i for i in range(6, 12)]),
}
