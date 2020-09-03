      ***********************************************************
      * Program name:    DBCBEX01
      * Original author: David Stagowski
      *
      *    Description: Example 01: DB Record Processing: Load file
      *
      *    This program will load a flat file to a table in the DB.
      *
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
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-20 dastagg       Created to learn.
      * 2020-08-20 dastagg       If you change me, change this.

      ***********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DBCBEX01.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER.   IBM WITH DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT LoadFile
           ASSIGN TO LOADFILE
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS WS-LoadFile-Status.

       DATA DIVISION.
       FILE SECTION.
       FD  LoadFile
           LABEL RECORDS ARE STANDARD
           RECORDING MODE IS F
           BLOCK CONTAINS 0 RECORDS.
           COPY EMPLOYE2 REPLACING ==:tag:== BY ==LoadFile==.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           COPY WSFST REPLACING ==:tag:== BY ==LoadFile==.

       01  WS-File-Counters.
           12 FD-LoadFile-Record-Cnt         PIC S9(4) COMP VALUE ZERO.
           12 DB1-Insert-Cnt                 PIC S9(4) COMP VALUE ZERO.
           12 WS-Display-Counter             PIC ZZZ9.
           12 WS-Display-SQLCode             PIC ZZZZZZZZ9+.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL DECLARE EMPLOYE2 TABLE
           ( EMPNO                          CHAR(6) NOT NULL,
             FIRSTNME                       VARCHAR(12) NOT NULL,
             MIDINIT                        CHAR(1),
             LASTNAME                       VARCHAR(15) NOT NULL,
             WORKDEPT                       CHAR(3),
             PHONENO                        CHAR(4),
             HIREDATE                       DATE,
             JOB                            CHAR(8),
             EDLEVEL                        SMALLINT,
             SEX                            CHAR(1),
             BIRTHDATE                      DATE,
             SALARY                         DECIMAL(9, 2),
             BONUS                          DECIMAL(9, 2),
             COMM                           DECIMAL(9, 2)
           )
           END-EXEC.

      *******************
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
           12 HV-Salary               PIC S9(7)V99 COMP-3.
           12 HV-Bonus                PIC S9(7)V99 COMP-3.
           12 HV-Commission           PIC S9(7)V99 COMP-3.
      *******************

       01 WS-SQL-STATUS                PIC S9(9) COMP-5.
          88 SQL-STATUS-OK             VALUE    0.
          88 SQL-STATUS-NOT-FOUND      VALUE  100.
          88 SQL-STATUS-DUP            VALUE -803.

       01 EOJ-Display-Messages.
           12 EOJ-End-Message PIC X(042) VALUE
              "*** Program DCBCEX01 - End of Run Messages".

       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           SET SQL-STATUS-OK TO TRUE.
           IF SQL-STATUS-OK
              OPEN INPUT LoadFile
              PERFORM 5000-Read-LoadFile
           END-IF.

       2000-Process.
           IF SQL-STATUS-OK
              PERFORM UNTIL WS-LoadFile-EOF
                 PERFORM 2100-Insert-INFile
                 PERFORM 5000-Read-LoadFile
              END-PERFORM
           END-IF.

       2100-Insert-INFile.
           MOVE LoadFile-Emp-Number TO HV-Emp-Number
           MOVE LoadFile-First-Name TO HV-First-Name
           MOVE LoadFile-Middle-Init TO HV-Middle-Init
           MOVE LoadFile-Last-Name TO HV-Last-Name
           MOVE LoadFile-Work-Dept TO HV-Work-Dept
           MOVE LoadFile-Phone-Number TO HV-Phone-Number
           MOVE LoadFile-Hire-Date TO HV-Hire-Date
           MOVE LoadFile-Job-Title TO HV-Job-Title
           MOVE LoadFile-Edu-Level TO HV-Edu-Level
           MOVE LoadFile-Gender TO HV-Gender
           MOVE LoadFile-Birth-Date TO HV-Birth-Date
           COMPUTE HV-Salary = FUNCTION NUMVAL-C(LoadFile-Salary)
           COMPUTE HV-Bonus = FUNCTION NUMVAL-C(LoadFile-Bonus)
           COMPUTE HV-Commission =
              FUNCTION NUMVAL-C(LoadFile-Commission)

           PERFORM 6000-Write-DB1.

       3000-End-Job.
           CLOSE LoadFile.
           EXEC SQL CONNECT RESET END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS.

           DISPLAY EOJ-End-Message.
           DISPLAY "SQLCODE at 3000-End-Job: " SQLCODE.

           MOVE FD-LoadFile-Record-Cnt TO WS-Display-Counter.
           DISPLAY " Load File Records Read: " WS-Display-Counter.
           MOVE DB1-Insert-Cnt  TO WS-Display-Counter.
           DISPLAY "       Records inserted: " WS-Display-Counter.

       5000-Read-LoadFile.
           READ LoadFile
              AT END SET WS-LoadFile-EOF TO TRUE
           END-READ.
           IF WS-LoadFile-Good
              ADD +1 TO FD-LoadFile-Record-Cnt
      D       DISPLAY "LoadFile Record: " LoadFile-Employee-Record
           ELSE
              IF WS-LoadFile-EOF
                 NEXT SENTENCE
              ELSE
                 DISPLAY "** ERROR **: 5000-Read-LoadFile"
                 DISPLAY "Read LoadFile Failed."
                 DISPLAY "File Status: " WS-LoadFile-Status
                 PERFORM 3000-End-Job
                 MOVE 8 TO RETURN-CODE
                 GOBACK
              END-IF
           END-IF.

       6000-Write-DB1.
           DISPLAY "The data: " LoadFile-Employee-Record.
           EXEC SQL
              INSERT INTO EMPLOYE2
              VALUES (
                  :HV-Emp-Number, :HV-First-Name, :HV-Middle-Init,
                  :HV-Last-Name,  :HV-Work-Dept, :HV-Phone-Number,
                  :HV-Hire-Date, :HV-Job-Title, :HV-Edu-Level,
                  :HV-Gender, :HV-Birth-Date,
                  :HV-Salary, :HV-Bonus, :HV-Commission
              )
           END-EXEC.
           MOVE SQLCODE TO WS-SQL-STATUS WS-Display-SQLCode.
           IF SQL-STATUS-OK
              ADD +1 TO DB1-Insert-Cnt
           ELSE
             IF SQL-STATUS-NOT-FOUND
                NEXT SENTENCE
             ELSE
                DISPLAY "*** WARNING ***"
                DISPLAY "There was a problem Inserting the record."
                DISPLAY "SQLCODE = " WS-Display-SQLCode
                PERFORM 3000-End-Job
                MOVE 8 TO RETURN-CODE
                GOBACK
             END-IF
           END-IF.