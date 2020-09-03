#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=ws162e
REPORT=hrptfile.rpt
OUTFILE=houtfile.dat.txt
ERRFILE=herrfile.dat.txt

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
