      **********************************************************
      * Program name:    DBCBEX02
      * Original author: David Stagowski
      *
      *    Description: Example 02: DB2 Processing: Read All
      *
      *    This program will read and display all the
      *       records from a DB2 Table.
      *    There are some differences between the GnuCOBOL and
      *       ZOS DB2 programs.
      *
      *    The biggest difference is the 9800-Connect-to-DB1 paragraph.
      *
      *    On ZOS, the JCL makes the connection so there is no need for
      *       passing the username and password for the database.
      *
      *    That is required with GnuCOBOL.
      *    These GnuCOBOL programs use GETDBID, a very simple called
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
       PROGRAM-ID. DBCBEX02.

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
           12 HV-Phone-Number         PIC X(04).
           12 HV-Hire-Date            PIC X(10).
           12 HV-Job-Title            PIC X(08).
           12 HV-Edu-Level            PIC S9(04) COMP-5.
           12 HV-Gender               PIC X(01).
           12 HV-Birth-Date           PIC x(10).
           12 HV-Salary               PIC S9(9)V99 COMP-3.
           12 HV-Bonus                PIC S9(9)V99 COMP-3.
           12 HV-Commission           PIC S9(9)V99 COMP-3.

           EXEC SQL DECLARE DB1_C1 CURSOR FOR
                    SELECT EMPNO,
                           FIRSTNME,
                           MIDINIT,
                           LASTNAME,
                           WORKDEPT,
                           PHONENO,
                           HIREDATE,
                           JOB,
                           EDLEVEL,
                           SEX,
                           BIRTHDATE,
                           SALARY,
                           BONUS,
                           COMM
                    FROM EMPLOYEE
           END-EXEC.

       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -803.

       01  WS-Counters.
           12 WS-Employee-Record-Cnt   PIC 9(4) COMP.
           12 WS-Display-Counter       PIC ZZZ9.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program DCBCEX02 - End of Run Messages".

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
              DISPLAY "Data: " HV-Emp-Number, HV-First-Name,
                 HV-Last-Name, HV-Job-Title
              PERFORM 5000-Read-DB1
           END-IF.

       3000-End-Job.
           EXEC SQL CLOSE DB1_C1 END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.

           EXEC SQL CONNECT RESET END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.

           DISPLAY EOJ-End-Message.
           DISPLAY "SQLCODE at 3000-End-Job: " SQLCODE.

           MOVE WS-Employee-Record-Cnt TO WS-Display-Counter.
           DISPLAY "Number of Rows Read: " WS-Display-Counter.

       5000-Read-DB1.
           EXEC SQL FETCH DB1_C1
              INTO
                 :HV-Emp-Number,
                 :HV-First-Name,
                 :HV-Middle-Init,
                 :HV-Last-Name,
                 :HV-Work-Dept,
                 :HV-Phone-Number,
                 :HV-Hire-Date,
                 :HV-Job-Title,
                 :HV-Edu-Level,
                 :HV-Gender,
                 :HV-Birth-Date,
                 :HV-Salary,
                 :HV-Bonus,
                 :HV-Commission
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
      *    Parms for DB1_C1
      *    None, get all the records
      *     MOVE "DESIGNER" TO HV-Job-Title.

       9818-Open-Cursor-DB1.
           EXEC SQL OPEN DB1_C1 END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.
