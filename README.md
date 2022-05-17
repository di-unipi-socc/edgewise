# newDAPlacer

[daplacer](https://github.com/di-unipi-socc/daplacer) 2.0.
It compares a Prolog reasoner with [Google OR-Tools](https://github.com/google/or-tools), on the placement of service-based applications on a cloud infrastructure.


## Repository Folders' structure <img src="https://img.icons8.com/small/344/folder-tree.png" alt="folder tree" width="20" height="20">

``` bash
newDAP
├── data
│   ├── apps
│   └── infrs
│       └── dummy
├── scripts
│   ├── googleOR
│   │   ├── classes
│   │   └── orsolver.py
│   ├── builder.py
│   └── compare.py
└── versions
```

- [`data`](https://github.com/jacopo-massa/newDAP/tree/main/data): contains the input data (as Prolog knowledge base):
    - [`apps`](https://github.com/jacopo-massa/newDAP/tree/main/data/apps): contains the applications
    - [`infrs`](https://github.com/jacopo-massa/newDAP/tree/main/data/infrs): contains the infrastructures
        - [`dummy`](https://github.com/jacopo-massa/newDAP/tree/main/data/infrs/dummy): contains the dummy infrastructures (links with low latency and high bandwidth, used for faster testing)
- [`scripts`](https://github.com/jacopo-massa/newDAP/tree/main/scripts): contains some useful scripts
    - [`googleOR`](https://github.com/jacopo-massa/newDAP/tree/main/scripts/googleOR):
        - [`classes`](https://github.com/jacopo-massa/newDAP/tree/main/scripts/googleOR/classes): contains the classes to model application and infrastructure
        - [`orsolver.py`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/googleOR/orsolver.py): the main script, which contains the main logic with
        the solver within its constraints, and the visualization of the results.
    - [`builder.py`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/builder.py): the script to build randomly generated infrastructure of a given size
    - [`compare.py`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/compare.py): the script to compare the results of different versions (and optionally the _or-tools_ one)
- [`versions`](https://github.com/jacopo-massa/newDAP/tree/main/versions): contains several version of the Prolog reasoner
implementing different heuristics.

## How To &nbsp;<img src="https://cdn-icons-png.flaticon.com/512/3208/3208615.png" alt="checklist" width="20" height="20"/> 

Download or clone this repo. Make sure you have the following prerequisites:

- [`swipl`](https://www.swi-prolog.org/download/stable) (both the executable and the dynamic library)
- [`python`](https://www.python.org/downloads/) >= 3.6
- [`requirements`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/requirements.txt) for the python virtual environment (_or-tools_, _colorama_, etc.)

Each script in the `scripts` folder has its own _help_ and _usage_, which can be accessed by typing the following command:
``` bash
python3 <script>.py -h
```

