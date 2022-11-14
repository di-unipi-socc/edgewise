#!/bin/bash

INFRS=(16 32 64 128 256 512)
APP=$1
BUDGET=$2

if [ $# -ne 2 ]; then
    echo "Usage: $0 <app> <budget>"
    exit 1
fi

# iterate over infrs
for i in {0..5}; do
    python3 compare.py -o -b $APP ${INFRS[$i]} $BUDGET binpack
done

echo " +++ DONE +++"