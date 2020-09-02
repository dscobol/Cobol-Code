      ***********************************************************
      * Program name:    VSCBEX01
      * Original author: David Stagowki
      *
      *    Description: Example 01: Indexed File Processing: Load File
      *
      *    This program will create and load an Indexed file
      *     with data from a flat file.
      *       ACCESS MODE IS SEQUENTIAL
      *       OPEN OUTPUT
      *
      *    The same program will run on both gnuCobol and ZOS COBOL.
      *    The only changes are:
      *    Flat File:  the ASSIGN TO and ORGANIZATION statement.
      *    Indexed File: the ASSIGN TO statement.
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-20 dastagg       Created to learn.
      * 2020-08-20 dastagg       If you change me, change this.

      ***********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VSCBEX01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT UPFile
           ASSIGN TO UPFILE
           ORGANIZATION IS SEQUENTIAL           
           FILE STATUS IS WS-UPFile-Status.

           SELECT INFile
           ASSIGN TO INFILE      
           ORGANIZATION IS INDEXED
           RECORD KEY IS INFile-Cust-ID
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-INFile-Status.

       DATA DIVISION.
       FILE SECTION.
       FD  UPFile
           LABEL RECORDS ARE STANDARD
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.
           COPY CUSTOMER REPLACING ==:tag:== BY ==UPFile==.

       FD  INFile.
           COPY CUSTOMER REPLACING ==:tag:== BY ==INFile==.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           COPY WSFST REPLACING ==:tag:== BY ==UPFile==.
           COPY WSFST REPLACING ==:tag:== BY ==INFile==.

       01  WS-File-Counters.
           12 FD-UPFile-Record-Cnt         PIC S9(4) COMP VALUE ZERO.
           12 FD-INFile-Insert-Cnt         PIC S9(4) COMP VALUE ZERO.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program VSCBEX01 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           OPEN  INPUT UPFile.
           OPEN OUTPUT INFile.
           PERFORM 5000-Read-UPFile.

       2000-Process.
           IF WS-UPFile-Good
              PERFORM UNTIL WS-UPFile-EOF
                 PERFORM 2100-Insert-INFile
                 PERFORM 5000-Read-UPFile
              END-PERFORM
           END-IF.

       2100-Insert-INFile.
           MOVE UPFile-Customer-Record TO
              INFile-Customer-Record.
           PERFORM 6000-Write-INFile.

       3000-End-Job.
           DISPLAY EOJ-End-Message.
           DISPLAY "      Records Read: " FD-UPFile-Record-Cnt
           DISPLAY "  Records Inserted: " FD-INFile-Insert-Cnt

           CLOSE UPFile
                 INFile.
      D    DISPLAY "INFile Close Status: " WS-INFile-Status.

       5000-Read-UPFile.
           READ UPFile
              AT END SET WS-UPFile-EOF TO TRUE
           END-READ.
           IF WS-UPFile-Good
              ADD +1 TO FD-UPFile-Record-Cnt
      D       DISPLAY "UPFile Record: " UPFile-Customer-Record
           ELSE
              IF WS-UPFile-EOF
                 NEXT SENTENCE
              ELSE
                 DISPLAY "** ERROR **: 5000-Read-UPFile"
                 DISPLAY "Read UPFile Failed."
                 DISPLAY "File Status: " WS-UPFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK 
              END-IF
           END-IF.

       6000-Write-INFile.
           WRITE INFile-Customer-Record.
           IF WS-INFile-Good
              ADD +1 TO FD-INFile-Insert-Cnt
      D       DISPLAY "INFile on Write: " INFile-Customer-Record
           ELSE
              DISPLAY "** ERROR **: 6000-Write-INFile"
              DISPLAY "Write INFile Failed."
              DISPLAY "File Status: " WS-INFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK 
           END-IF.
