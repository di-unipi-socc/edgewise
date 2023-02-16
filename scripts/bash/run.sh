#!/bin/bash

ROOT_DIR=$(dirname $(dirname $(dirname $(realpath $0))))
PYTHON_SCRIPTS_DIR=$ROOT_DIR/scripts

INFRS=(16 32 64 128 256 512)
APPS=(distSecurity arFarming speakToMe)
BUDGET=(100 250 400)

source $ROOT_DIR/.venv/bin/activate
for j in {0..2}; do
    for i in {0..5}; do
        if [ "$1" = "comp" ]; then
            python3 ${PYTHON_SCRIPTS_DIR}/compare.py -b -o -s ${APPS[$j]} ${INFRS[$i]} ${BUDGET[$j]} binpack
        elif [ "$1" = "exp" ]; then
            python3 ${PYTHON_SCRIPTS_DIR}/experiments.py ${APPS[$j]} ${INFRS[$i]} ${BUDGET[$j]}
        else
            echo "Invalid argument $1."
            exit 1
        fi
    done
done
deactivate