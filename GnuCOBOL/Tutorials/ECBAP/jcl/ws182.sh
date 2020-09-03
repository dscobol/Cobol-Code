#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=ws182
RPTFILE=pres-cb1-report.rpt

# clean up
rm ../bin/$PGM
rm ../spool/$RPTFILE

cobc -x ../cbl/$PGM.cbl -I $SYSLIB -o ../bin/$PGM

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
