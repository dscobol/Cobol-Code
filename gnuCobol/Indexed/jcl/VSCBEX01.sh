#!/bin/bash

PGM=VSCBEX01
SYSLIB="../../../common/cpy"

rm ../data/customer.idat

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
