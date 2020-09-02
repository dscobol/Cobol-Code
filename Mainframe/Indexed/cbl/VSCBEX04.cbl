      ***********************************************************
      * Program name:    VSCBEX04
      * Original author: dastagg
      *
      *    Description: Example 04: Indexed File Processing: Update
      *
      *    This program will load 5 Keys from a table to read and
      *       update each record in the indexed file opened. 
      *       ACCESS MODE IS RANDOM
      *       OPEN I-O
      *
      *    The same program will run on both gnuCobol and ZOS COBOL.
      *    The only change is the ASSIGN TO statement.
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-20 dastagg       Created to learn.
      * 2020-08-20 dastagg       If you change me, change this.

      ***********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VSCBEX04.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INFile
           ASSIGN TO INFILE
           ORGANIZATION IS INDEXED
           RECORD KEY IS INFile-Cust-ID
           ACCESS MODE IS RANDOM
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
           12 FD-INFile-Re-Write-Cnt       PIC S9(4) COMP VALUE ZERO.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program VSCBEX04 - End of Run Messages".

       01  WS-Key-HOLD.
           12 FILLER PIC 9(9) VALUE 001000100.
           12 FILLER PIC 9(9) VALUE 042000100.
           12 FILLER PIC 9(9) VALUE 087800100.
           12 FILLER PIC 9(9) VALUE 021000100.
           12 FILLER PIC 9(9) VALUE 099800100.

       01  WS-Key-Table-Storage.
           12 WS-Key-Element-Cnt               PIC 9 VALUE 5.
           12 WS-Key-SUB                       PIC 9 VALUE 0.
           12 WS-Key-Table-Setup.
              15 WS-Key-Table OCCURS 5 TIMES.
                18 WS-Key-Value                PIC 9(04).
                18 WS-Price                    PIC 9(3)V99.

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           MOVE WS-Key-HOLD  TO WS-Key-Table-Setup.
           OPEN I-O INFile.
      D    DISPLAY "INFile Open Status: " WS-INFile-Status.

       2000-Process.
           PERFORM VARYING WS-Key-SUB FROM 1 BY 1
              UNTIL WS-Key-SUB > WS-Key-Element-Cnt
              MOVE WS-Key-Value(WS-Key-SUB) TO
                 INFile-Cust-ID
              PERFORM 5000-Read-INFile
              PERFORM 2100-Update-INFile
           END-PERFORM.

       2100-Update-INFile.
           MOVE WS-Price(WS-Key-SUB) TO
              INFile-Cust-Price.

           PERFORM 6000-Re-Write-INFile.

       3000-End-Job.
           DISPLAY EOJ-End-Message.
           DISPLAY "      Records Read: " FD-INFile-Record-Cnt
           DISPLAY "Records Re-Written: " FD-INFile-Re-Write-Cnt

           CLOSE INFile.
      D    DISPLAY "INFile Close Status: " WS-INFile-Status.

       5000-Read-INFile.
           READ INFile
              RECORD KEY IS INFile-Cust-ID
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

       6000-Re-Write-INFile.
           REWRITE INFile-Customer-Record.
           IF WS-INFile-Good
              ADD +1 TO FD-INFile-Re-Write-Cnt
      D       DISPLAY "INFile on Re-Write: " INFile-Customer-Record
           ELSE
              DISPLAY "** ERROR **: 6000-Re-Write-INFile"
              DISPLAY "Re-Write INFile Failed."
              DISPLAY "File Status: " WS-INFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK 
           END-IF.
