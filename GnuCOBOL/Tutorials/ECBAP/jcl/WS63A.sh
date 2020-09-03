#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=ws63a
REPORT=fav-report.rpt

# clean up
rm ../bin/$PGM
rm ../spool/$REPORT

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
