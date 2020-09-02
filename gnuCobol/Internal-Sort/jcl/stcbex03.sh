#!/bin/bash

PGM=STCBEX03
OUTPUT=stcbex03-out.txt

# Clean Up
rm ../spool/$OUTPUT

SYSLIB="../../../common/cpy"

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
