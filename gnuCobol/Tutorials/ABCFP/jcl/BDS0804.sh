#!/bin/bash

# The program to run
PGM=BDS0804
#REPORT=Members.rpt

# Location of copylibs
SYSLIB="../cpy"

# clean up
#rm ../spool/$REPORT
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
