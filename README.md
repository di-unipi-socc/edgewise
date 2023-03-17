<div align='center'>
<picture>
    <img width=250 alt="edgewise-logo" src="assets/logo.png"/>
</picture>
</div>

## Repository Folders' structure <img src="https://img.icons8.com/small/344/folder-tree.png" alt="folder tree" width="20" height="20">

``` bash
.
├── data
├── pl-utils
├── scripts
├── versions
├── Makefile
└── README.md
```

The above tree shows the structure of the repository (_see the README.md file in each folder for more information_):
 - [`data`](data) folder contains the input files for the tool execution.
 - [`pl-utils`](pl-utils) folder contains some Prolog files implementing a part of the reasoner logic (i.e. pre-processing, resource allocation...).
 - [`scripts`](scripts) folder contains the python scripts implementing the MILP approach and oter ones used to run the experiments. 
 - [`versions`](versions) folder contains different versions of the declarative approach. 
 - [`Makefile`](Makefile) contains some shortcut commands to generate input data and run the experiments.

## How to use &nbsp;<img src="https://cdn-icons-png.flaticon.com/512/3208/3208615.png" alt="checklist" width="20" height="20"/> 

Download or clone this repo. Make sure you have the following prerequisites:

- [`swipl`](https://www.swi-prolog.org/download/stable) >= 8.4.2 (both the executable and the dynamic library)
- [`swipl MQI for Python`](https://www.swi-prolog.org/pldoc/man?section=mqi-python-installation)
- [`python`](https://www.python.org/downloads/) >= 3.8
- [`requirements.txt`](https://github.com/jacopo-massa/newDAP/blob/main/scripts/requirements.txt) for the python virtual environment (_or-tools_, _colorama_, etc.)

see the [`scripts` folder README.md](scripts/README.md) for more information on how to execute the scripts.

