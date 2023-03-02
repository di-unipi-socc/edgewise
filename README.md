# EdgeWise

[daplacer](https://github.com/di-unipi-socc/daplacer) 2.0.
It compares a Prolog reasoner with [Google OR-Tools](https://github.com/google/or-tools), on the placement of (micro)service-based applications on a cloud infrastructure.


## Repository Folders' structure <img src="https://img.icons8.com/small/344/folder-tree.png" alt="folder tree" width="20" height="20">

``` bash
.
├── README.md
├── data
├── output
├── pl-utils
├── scripts
└── versions
```

## How to use &nbsp;<img src="https://cdn-icons-png.flaticon.com/512/3208/3208615.png" alt="checklist" width="20" height="20"/> 

Download or clone this repo. Make sure you have the following prerequisites:

- [`swipl`](https://www.swi-prolog.org/download/stable) >= 8.4.2 (both the executable and the dynamic library)
- [`swipl MQI for Python`](https://www.swi-prolog.org/pldoc/man?section=mqi-python-installation)
- [`python`](https://www.python.org/downloads/) >= 3.8
- [`requirements`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/requirements.txt) for the python virtual environment (_or-tools_, _colorama_, etc.)

Each script in the `scripts` folder has its own _help_ and _usage_, which can be accessed by typing the following command:
``` bash
python3 <script>.py -h
```

