#!/bin/bash

ROOT_DIR=$(dirname $(dirname $(dirname $(realpath $0))))
PYTHON=$ROOT_DIR/.venv/bin/python3
PYTHON_SCRIPTS_DIR=$ROOT_DIR/scripts

INFRS=(16 32 64 128 256 512)
APPS=(distSecurity arFarming speakToMe)

for j in {0..2}; do
    for i in {0..5}; do
        if [ "$1" = "comp" ]; then
            ${PYTHON} ${PYTHON_SCRIPTS_DIR}/compare.py -s -b -on -o ${APPS[$j]} ${INFRS[$i]} binpack binpack_num
        elif [ "$1" = "exp" ]; then
            ${PYTHON} ${PYTHON_SCRIPTS_DIR}/experiments.py ${APPS[$j]} ${INFRS[$i]}
        else
            echo "Invalid argument $1."
            exit 1
        fi
    done
done