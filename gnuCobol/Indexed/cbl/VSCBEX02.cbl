      ***********************************************************
      * Program name:    VSCBEX02
      * Original author: David Stagowski
      *
      *    Description: Example 02: Indexed File Processing: Read All
      *
      *    This program will read and display all the
      *       records from an indexed file opened:
      *       ACCESS MODE IS SEQUENTIAL
      *       OPEN INPUT
      *
      *    The same program will run on both gnuCobol and ZOS COBOL.
      *    The only change is the ASSIGN TO statement.
      *
      * Maintenance Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-20 dastagg       Created to learn.
      * 20XX-XX-XX               If you change me, change this.
      *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VSCBEX02.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INFile
           ASSIGN TO "../data/customer.idat"       
           ORGANIZATION IS INDEXED
           RECORD KEY IS INFile-Cust-ID
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-INFile-Status.

       DATA DIVISION.
       FILE SECTION.
       FD  INFile.
           COPY CUSTOMER REPLACING ==:tag:== BY ==INFile==.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           COPY WSFST REPLACING ==:tag:== BY ==INFile==.

       01  WS-File-Counters.
           12 FD-INFile-Record-Cnt         PIC S9(4) COMP VALUE ZERO.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program VSCBEX02 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process UNTIL WS-INFile-EOF.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           OPEN INPUT INFile.
      D    DISPLAY "INFile Status: " WS-INFile-Status.
           PERFORM 5000-Read-INFile.

       2000-Process.
           IF WS-INFile-Good
              DISPLAY INFile-Customer-Record
           END-IF.
           PERFORM 5000-Read-INFile.

       3000-End-Job.
           DISPLAY EOJ-End-Message.
           DISPLAY "   Records Read: " FD-INFile-Record-Cnt
           CLOSE INFile.

       5000-Read-INFile.
           READ INFile
              AT END SET WS-INFile-EOF TO TRUE
           END-READ.
           IF WS-INFile-Good
              ADD +1 TO FD-INFile-Record-Cnt
      D       DISPLAY "INFile Record: " INFile-Customer-Record
           ELSE
              IF WS-INFile-EOF
                 NEXT SENTENCE
              ELSE
                 DISPLAY "** ERROR **: 5000-Read-INFile"
                 DISPLAY "Read INFile Failed."
                 DISPLAY "File Status: " WS-INFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK 
              END-IF
           END-IF.
