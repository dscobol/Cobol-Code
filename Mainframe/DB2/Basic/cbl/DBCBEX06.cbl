      **********************************************************
      * Program name:    DBCBEX06
      * Original author: David Stagowski
      *
      *    Description: Example 6: DB2 Processing: Read All with View
      *
      *    This program will read all the records using a View supplied          
      *    by the DB and display them.

      *    There are some differences between the gnuCobol and
      *       ZOS DB2 programs.
      *
      *    The biggest difference is the 9800-Connect-to-DB1 paragraph.
      *
      *    On ZOS, the JCL makes the connection so there is no need for
      *       passing the username and password for the database.
      *
      *    That is required with gnuCobol.
      *    These gnuCobol programs use GETDBID, a very simple called
      *    module that has the username and password embedded in it.
      *    When called, it passes them up to the calling program which
      *    then uses them to make the connection to the server.
      *
      * Maintenance Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-29 dastagg       Created to learn.
      * 20XX-XX-XX               If you change me, change this.
      *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DBCBEX06.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

       01  HV-Employee-Row.
           12 HV-Emp-Number           PIC X(06).
           12 HV-First-Name           PIC X(12).
           12 HV-Middle-Init          PIC X(01).
           12 HV-Last-Name            PIC X(15).
           12 HV-Work-Dept            PIC X(03).

           EXEC SQL DECLARE DB1-C1 CURSOR FOR
                    SELECT EMPNO,
                           FIRSTNME,
                           MIDINIT,
                           LASTNAME,
                           WORKDEPT
                    FROM VEMP
           END-EXEC.

       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -803.

       01  WS-Counters.
           12 WS-Employee-Record-Cnt   PIC 9(4) COMP.
           12 WS-Display-Counter       PIC ZZZ9.
           12 WS-Temp-SQL-Status       PIC ZZZZZZZZ9+.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program DCBCEX06 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           PERFORM 9800-Connect-to-DB1.
           IF SQL-STATUS-OK
              PERFORM 5000-Read-DB1
           END-IF.

       2000-Process.
           PERFORM 2100-Process-Data
              UNTIL NOT SQL-STATUS-OK.

       2100-Process-Data.
           IF SQL-STATUS-OK
              PERFORM 2110-Display-Detail-Data
              PERFORM 5000-Read-DB1
           END-IF.

       2110-Display-Detail-Data.
           DISPLAY "Employee: ",
              HV-Emp-Number,
              HV-First-Name,
              HV-Middle-Init,
              HV-Last-Name,
              HV-Work-Dept.

       3000-End-Job.
           EXEC SQL CLOSE DB1-C1 END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.

           EXEC SQL CONNECT RESET END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.

           DISPLAY EOJ-End-Message.
           MOVE WS-Employee-Record-Cnt TO WS-Display-Counter.
           DISPLAY "Number of Records Read: " WS-Display-Counter.

       5000-Read-DB1.
           EXEC SQL FETCH DB1-C1
              INTO
                 :HV-Emp-Number,
                 :HV-First-Name,
                 :HV-Middle-Init,
                 :HV-Last-Name,
                 :HV-Work-Dept
           END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.
           IF SQL-STATUS-OK
              ADD +1 TO WS-Employee-Record-Cnt
           ELSE
             IF SQL-STATUS-NOT-FOUND
                NEXT SENTENCE
             ELSE
                 DISPLAY "*** WARNING ***"
                 DISPLAY "There was a problem Fetching the cursor."
                 DISPLAY "SQLCODE = " SQLCODE
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK
              END-IF
           END-IF.

       9800-Connect-to-DB1.
           PERFORM 9810-Setup-DB1-Connection.
           IF SQL-STATUS-OK
              CONTINUE
           ELSE
              DISPLAY "*** The DB connection is not valid!***"
              DISPLAY "Exiting the program.!"
              GOBACK
           END-IF.

       9810-Setup-DB1-Connection.
           PERFORM 9812-Create-Connection-To-DB1.

       9812-Create-Connection-To-DB1.
           IF SQL-STATUS-OK
              PERFORM 9816-Create-Cursor-DB1
              IF SQL-STATUS-OK
                 PERFORM 9818-Open-Cursor-DB1
              END-IF
           END-IF.

       9816-Create-Cursor-DB1.
      *    Parms for DB1-C1
      *D     DISPLAY "Nothing to do here.".
      *    As an example:
      *     MOVE "DESIGNER" TO HV-Job-Title.

       9818-Open-Cursor-DB1.
           EXEC SQL OPEN DB1-C1 END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.
