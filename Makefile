ROOT_DIR			= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OUTPUT_DIR			= $(ROOT_DIR)/output
SCRIPTS_DIR			= $(ROOT_DIR)/scripts
BASH_SCRIPTS_DIR 	= $(SCRIPTS_DIR)/bash

PYTHON		= $(shell which python3)
BASH 		= $(shell which bash)
TARGETS		= build comp plot

.ONESHELL:
.PHONY: all clean-plot clean-csv cleanall build comp exp plot

all: $(TARGETS)

clean-plot:
	rm -rf $(OUTPUT_DIR)/plots/*

clean-csv:
	rm -rf $(OUTPUT_DIR)/csv/*

cleanall: clean-plot clean-csv

build: 
	$(BASH) $(BASH_SCRIPTS_DIR)/build.sh

comp: 
	$(BASH) $(BASH_SCRIPTS_DIR)/run.sh comp

exp: 
	$(BASH) $(BASH_SCRIPTS_DIR)/run.sh exp

plot: 
	$(PYTHON) $(SCRIPTS_DIR)/plot.py