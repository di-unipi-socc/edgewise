#!/bin/bash

ROOT_DIR=$(dirname $(dirname $(dirname $(realpath $0))))
PYTHON=$ROOT_DIR/.venv/bin/python3
PYTHON_SCRIPTS_DIR=$ROOT_DIR/scripts
DATETIME=$2
CSV_FILE=compare_$DATETIME.csv

INFRS=(16 32 64 128 256 512)
# APPS=(distSecurity arFarming speakToMe)

for i in {0..5}; do
    if [ "$1" = "comp" ]; then
        ${PYTHON} ${PYTHON_SCRIPTS_DIR}/compare.py -b -on -o -s -f ${CSV_FILE} speakToMe ${INFRS[$i]}_${DATETIME} binpack_num
    elif [ "$1" = "exp" ]; then
        ${PYTHON} ${PYTHON_SCRIPTS_DIR}/experiments.py speakToMe ${INFRS[$i]}_${DATETIME}
    else
        echo "Invalid argument $1."
        exit 1
    fi
done