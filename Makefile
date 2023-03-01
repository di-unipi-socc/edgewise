#!make
include .env

ROOT_DIR 			= $(shell pwd)
OUTPUT_DIR			= $(ROOT_DIR)/output
SCRIPTS_DIR			= $(ROOT_DIR)/scripts
BASH_SCRIPTS_DIR 	= $(SCRIPTS_DIR)/bash

URL = "https://api.telegram.org/bot$(BOT_ID)/sendMessage"

PYTHON		= $(ROOT_DIR)/.venv/bin/python3
BASH 		= $(shell which bash)
TARGETS		= clean-plot build comp plot notify

.ONESHELL:
.PHONY: all clean-plot clean-csv cleanall build comp exp plot

all: $(TARGETS)

clean-plot:
	rm -rf $(OUTPUT_DIR)/plots/*

clean-csv:
	rm -rf $(OUTPUT_DIR)/csv/*

clean: clean-plot clean-csv

build: 
	$(BASH) $(BASH_SCRIPTS_DIR)/build.sh

comp: 
	$(BASH) $(BASH_SCRIPTS_DIR)/run.sh comp

exp: 
	$(BASH) $(BASH_SCRIPTS_DIR)/run.sh exp

plot:
	$(PYTHON) $(SCRIPTS_DIR)/plot.py

notify:
	curl -s -X POST $(URL) -d chat_id=$(CHAT_ID) -d text="Experiment finished"