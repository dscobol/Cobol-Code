#!/bin/bash

# The program to run
PGM=BDS1003
#REPORT=bds1002.rpt
NEWFILE=c10-3newmast.dat.txt

# Location of copylibs
SYSLIB="../cpy"

# clean up
rm ../data/$NEWFILE
#rm ../spool/$REPORT
rm ../bin/$PGM

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
