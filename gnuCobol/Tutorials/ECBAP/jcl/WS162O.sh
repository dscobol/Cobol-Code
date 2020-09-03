#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=ws162o
REPORT=hrptfileo.rpt
OUTFILE=houtfileo.dat.txt
ERRFILE=herrfileo.dat.txt

# clean up
rm ../bin/$PGM
rm ../spool/$REPORT
rm ../data/$OUTFILE
rm ../data/$ERRFILE

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
