      ***********************************************************
      * Program name:    STCBEX01
      * Original author: David Stagowski
      *
      * Description: Program to sort files.
      *    This version will just sort with USING and GIVING.
      *
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------  ------------  --------------------------------
      * 2020-08-16 dastagg       Created to learn.
      *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  STCBEX01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INFile
           ASSIGN TO "../data/customer.dat.txt"
           ORGANIZATION IS LINE SEQUENTIAL.

           SELECT SORTFile
           ASSIGN TO SORTWK.

           SELECT OUTFile
           ASSIGN TO "../spool/stcbex01-out.txt"
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INFile
           LABEL RECORDS ARE STANDARD
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.
           COPY CUSTOMER REPLACING ==:tag:== BY ==INFile==.

       SD  SORTFile.
           COPY CUSTOMER REPLACING ==:tag:== BY ==SORTFile==.

       FD OUTFile
           LABEL RECORDS ARE STANDARD
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.
           COPY CUSTOMER REPLACING ==:tag:== BY ==OUTFile==.

       WORKING-STORAGE SECTION.
       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program STCBEX01 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
      *    Because it is just USING and GIVING, file opening and 
      *    closing is not needed. The OS handles that.
      D     DISPLAY "1000-Begin-Job: ".
      D     DISPLAY "Normally, I would have something to do here".

       2000-Process.
           SORT SORTFile
              ON ASCENDING KEY
                 SORTFile-Cust-Last-Name
                USING INFile
                GIVING OUTFile.
           IF SORT-RETURN > 0
              DISPLAY '*** WARNING ***'
              DISPLAY '  SORT FAILED  '
           END-IF.

       3000-End-Job.
      D     DISPLAY "3000-End-Job: ".
           DISPLAY EOJ-End-Message.
