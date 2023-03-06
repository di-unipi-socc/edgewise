## List of scripts <img src="https://img.icons8.com/small/344/folder-tree.png" alt="folder tree" width="20" height="20">

- [`classes/`](classes/): contains the python classes used by the scripts. See the [README.md](classes/README.md) file for more information.
- [`milp.py`](milp.py): MILP approach implementation.
- [`budgeting.py`](budgeting.py): MILP approach implementation with budgeting over the maximum number of used infrastructure nodes.
- [`edgewise.py`](edgewise.py): Edgewise implementation. MILP approach with Prolog pre-processing.
- [`compare.py`](compare.py): can compare all the implemented approaches (MILP, declarative, EdgeWise), over a given application and infrastructure, saving results in [`data/output/csv`](data/output/csv) folder.
- [`plot.py`](plot.py): plots the results of the experiments, stored in [`data/output/csv`](data/output/csv) folder, saving plots in [`data/output/plots`](data/output/plots) folder.
- [`README.md`](README.md): this file.

## How to use &nbsp;<img src="https://cdn-icons-png.flaticon.com/512/3208/3208615.png" alt="checklist" width="20" height="20"/>

Each script has its own _help_ and _usage_ that can be accessed by typing the following command:
``` bash
python3 <script>.py -h
```