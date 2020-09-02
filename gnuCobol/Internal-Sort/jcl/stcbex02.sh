#!/bin/bash

PGM=STCBEX02
OUTPUT=stcbex02-out.txt

# Clean Up
rm ../spool/$OUTPUT

SYSLIB="../../../common/cpy"

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
