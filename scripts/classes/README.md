## List of files <img src="https://img.icons8.com/small/344/folder-tree.png" alt="folder tree" width="20" height="20">

 - [`application.py`](application.py): contains the `Application` class, storing all components (services, function, IoT devices) and their requirements.
 - [`infrastructure.py`](infrastructure.py): contains the `Infrastructure` class, storing all infrastructure nodes and their capabilities.
 - ['components.py'](components.py): contains some `Component` classes (i.e. `ServiceInstance`, `FunctionInstance`...), used by the `Application` class.
 - [`builder.py`](builder.py): contains the `Builder` class, used to build a random infrastructure, saved as Prolog knowledge base, in [`data/infrs`](data/infrs) folder.
 - [`utils.py`](utils.py): contains some utility functions used by the other classes/scripts.
 - [`README.md`](README.md): this file.