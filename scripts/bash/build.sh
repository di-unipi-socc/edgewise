#!/bin/bash
INFRS=(16 32 64 128 256 512)

ROOT_DIR=$(dirname $(dirname $(dirname $(realpath $0))))
INFRS_DIR=$ROOT_DIR/data/infrs
PYTHON=$ROOT_DIR/.venv/bin/python3
PYTHON_SCRIPTS_DIR=$ROOT_DIR/scripts
DATETIME=$1

# remove all old infrastructure files
# rm $INFRS_DIR/*.pl > /dev/null 2>&1
for i in {0..5}; do
    ${PYTHON} ${PYTHON_SCRIPTS_DIR}/classes/builder.py -n ${INFRS[$i]} # -s ${INFRS[$i]}
    mv $INFRS_DIR/infr${INFRS[i]}.pl $INFRS_DIR/infr${INFRS[$i]}_${DATETIME}.pl
done