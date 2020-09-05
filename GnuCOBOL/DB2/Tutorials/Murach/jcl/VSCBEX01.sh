#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=VSCBEX01

# clean up
rm ../bin/$PGM
rm ../idata/customrs.idat

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
