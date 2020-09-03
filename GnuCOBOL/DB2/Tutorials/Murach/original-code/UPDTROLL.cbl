       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    UPDTROLL.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
      *
           SELECT CUSTTRAN ASSIGN TO UT-S-CUSTTRAN.
           SELECT BADTRAN  ASSIGN TO UT-S-BADTRAN.
      *
       DATA DIVISION.
      *
       FILE SECTION.
      *
       FD  CUSTTRAN
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 119 CHARACTERS.
      *
       01  CUSTOMER-TRANSACTION-RECORD.
      *
           05  CTR-TRANSACTION-CODE        PIC X.
           05  CTR-TRANSACTION-DATA.
               10  CTR-CUSTOMER-NUMBER     PIC X(6).
               10  CTR-CUSTOMER-DETAILS    PIC X(112).
      *
       FD  BADTRAN
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 119 CHARACTERS.
      *
       01  BAD-TRANSACTION-RECORD.
      *
           05  BTR-TRANSACTION-CODE        PIC X.
           05  BTR-TRANSACTION-DATA        PIC X(118).
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCHES.
      *
           05  END-OF-TRANSACTIONS-SW   PIC X    VALUE 'N'.
               88  END-OF-TRANSACTIONS           VALUE 'Y'.
           05  VALID-TRANSACTION-SW     PIC X    VALUE 'Y'.
               88  VALID-TRANSACTION             VALUE 'Y'.
           05  ROLLBACK-REQUIRED-SW     PIC X    VALUE 'N'.
               88  ROLLBACK-REQUIRED             VALUE 'Y'.
      *
       01  COUNT-FIELDS                 COMP.
      *
           05  VALID-TRANS-COUNT        PIC S9(9)    VALUE 0.
           05  INVALID-TRANS-COUNT      PIC S9(9)    VALUE 0.
           05  UNIT-OF-WORK-COUNT       PIC S9(9)    VALUE 0.
      *
           EXEC SQL
               INCLUDE CUSTOMER
           END-EXEC.
      *
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-POST-CUST-TRANSACTIONS.
      *
           OPEN INPUT  CUSTTRAN
                OUTPUT BADTRAN.
           PERFORM 100-POST-CUST-TRANSACTION
               UNTIL END-OF-TRANSACTIONS.
           IF ROLLBACK-REQUIRED
               DISPLAY '****** UPDATE NOT SUCCESSFUL ******'
               DISPLAY '        SQLCODE ' SQLCODE
               PERFORM 200-ROLLBACK-UNIT-OF-WORK
               DISPLAY '******  ROLLBACK PERFORMED   ******'
               SUBTRACT UNIT-OF-WORK-COUNT FROM VALID-TRANS-COUNT
           ELSE
               DISPLAY '******   UPDATE SUCCESSFUL   ******'.
           CLOSE CUSTTRAN
                 BADTRAN.
           DISPLAY VALID-TRANS-COUNT
                   ' VALID TRANSACTION RECORDS PROCESSED.'.
           DISPLAY INVALID-TRANS-COUNT
                   ' INVALID TRANSACTION RECORDS PROCESSED.'.
           STOP RUN.
      *
       100-POST-CUST-TRANSACTION.
      *
           MOVE 'Y' TO VALID-TRANSACTION-SW.
           PERFORM 110-READ-TRANSACTION-RECORD.
           IF NOT END-OF-TRANSACTIONS
               MOVE CTR-TRANSACTION-DATA TO CUSTOMER-ROW
               EVALUATE CTR-TRANSACTION-CODE
                   WHEN 'A'   PERFORM 120-INSERT-CUSTOMER-ROW
                   WHEN 'R'   PERFORM 130-UPDATE-CUSTOMER-ROW
                   WHEN 'D'   PERFORM 140-DELETE-CUSTOMER-ROW
                   WHEN OTHER MOVE 'N' TO VALID-TRANSACTION-SW
               END-EVALUATE
               IF NOT VALID-TRANSACTION
                   ADD 1 TO INVALID-TRANS-COUNT
                   PERFORM 150-WRITE-BAD-TRANS-RECORD
               ELSE
                   ADD 1 TO VALID-TRANS-COUNT
                   ADD 1 TO UNIT-OF-WORK-COUNT
                   IF UNIT-OF-WORK-COUNT = 10
                       PERFORM 160-COMMIT-UNIT-OF-WORK
                       MOVE 0 TO UNIT-OF-WORK-COUNT.
      *
       110-READ-TRANSACTION-RECORD.
      *
           READ CUSTTRAN
               AT END
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW.
      *
       120-INSERT-CUSTOMER-ROW.
      *
           EXEC SQL
               INSERT INTO MM01.CUSTOMER
                     ( CUSTNO,   FNAME,     LNAME,    ADDR,
                       CITY,     STATE,     ZIPCODE)
              VALUES (:CUSTNO,  :FNAME,    :LNAME,   :ADDR,
                      :CITY,    :STATE,    :ZIPCODE)
           END-EXEC.
           IF SQLCODE = -803
               MOVE 'N' TO VALID-TRANSACTION-SW
           ELSE
               IF SQLCODE < 0
                   MOVE 'N' TO VALID-TRANSACTION-SW
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW
                   MOVE 'Y' TO ROLLBACK-REQUIRED-SW.
      *
       130-UPDATE-CUSTOMER-ROW.
      *
           EXEC SQL
               UPDATE MM01.CUSTOMER
                  SET FNAME   = :FNAME,
                      LNAME   = :LNAME,
                      ADDR    = :ADDR,
                      CITY    = :CITY,
                      STATE   = :STATE,
                      ZIPCODE = :ZIPCODE
               WHERE  CUSTNO  = :CUSTNO
           END-EXEC.
           IF SQLCODE = +100
               MOVE 'N' TO VALID-TRANSACTION-SW
           ELSE
               IF SQLCODE < 0
                   MOVE 'N' TO VALID-TRANSACTION-SW
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW
                   MOVE 'Y' TO ROLLBACK-REQUIRED-SW.
      *
       140-DELETE-CUSTOMER-ROW.
      *
           EXEC SQL
               DELETE FROM MM01.CUSTOMER
                   WHERE CUSTNO = :CUSTNO
           END-EXEC.
           IF SQLCODE = +100
               MOVE 'N' TO VALID-TRANSACTION-SW
           ELSE
               IF SQLCODE < 0
                   MOVE 'N' TO VALID-TRANSACTION-SW
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW
                   MOVE 'Y' TO ROLLBACK-REQUIRED-SW.
      *
       150-WRITE-BAD-TRANS-RECORD.
      *
           WRITE BAD-TRANSACTION-RECORD
               FROM CUSTOMER-TRANSACTION-RECORD.
      *
       160-COMMIT-UNIT-OF-WORK.
      *
           EXEC SQL
               COMMIT
           END-EXEC.
      *
       200-ROLLBACK-UNIT-OF-WORK.
      *
           EXEC SQL
               ROLLBACK
           END-EXEC.
      *
      