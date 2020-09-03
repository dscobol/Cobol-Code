#!/bin/bash
# static parms
SYSLIB="../cpy"

# Program parms
PGM=STCBEX01
OUTPUT=stcbex01-out.txt

# clean up
rm ../bin/$PGM
rm ../spool/$OUTPUT

cobc -x -o ../bin/$PGM ../cbl/$PGM.cbl -I $SYSLIB 

if [ "$?" -eq 0 ]; then
    ../bin/$PGM
else
    echo "Complier Return code not ZERO."
fi
