#!/bin/bash

# The program to run
PGM=BDS0702

# Location of copylibs
SYSLIB="../../../../common/cpy"

# clean up
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
