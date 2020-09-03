#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=ws172a
RPTFILE=student-grade-report.rpt
ERRFILE=student-ERRFILE.dat.txt

# clean up
rm ../bin/$PGM
rm ../spool/$RPTFILE
rm ../data/$ERRFILE

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
