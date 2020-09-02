#!/bin/bash

# The program to run
PGM=BDS1001
REPORT=bds1001-1.rpt

# Location of copylibs
SYSLIB="../../../../common/cpy"

# clean up
rm ../spool/$REPORT
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
