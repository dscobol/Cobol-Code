#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=TABLE1

# clean up
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
