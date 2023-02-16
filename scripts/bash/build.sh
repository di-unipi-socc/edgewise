#!/bin/bash
INFRS=(16 32 64 128 256 512)

ROOT_DIR=$(dirname $(dirname $(dirname $(realpath $0))))
PYTHON=$ROOT_DIR/.venv/bin/python3
PYTHON_SCRIPTS_DIR=$ROOT_DIR/scripts

for i in {0..5}; do
    ${PYTHON} ${PYTHON_SCRIPTS_DIR}/classes/builder.py ${INFRS[$i]} -s ${INFRS[$i]}
done