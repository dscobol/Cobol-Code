#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=FAHR2CEL

# clean up
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I ../cpy 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
