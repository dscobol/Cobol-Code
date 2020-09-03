       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    UPDTCUST.
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
           05  END-OF-TRANSACTIONS-SW      PIC X    VALUE 'N'.
               88  END-OF-TRANSACTIONS              VALUE 'Y'.
           05  VALID-TRANSACTION-SW        PIC X    VALUE 'Y'.
               88  VALID-TRANSACTION                VALUE 'Y'.
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
           CLOSE CUSTTRAN
                 BADTRAN.
           STOP RUN.
      *
       100-POST-CUST-TRANSACTION.
      *
           MOVE 'Y' TO VALID-TRANSACTION-SW.
           PERFORM 110-READ-TRANSACTION-RECORD.
           IF NOT END-OF-TRANSACTIONS
               EVALUATE CTR-TRANSACTION-CODE
                   WHEN 'A'   PERFORM 120-INSERT-CUSTOMER-ROW
                   WHEN 'R'   PERFORM 130-UPDATE-CUSTOMER-ROW
                   WHEN 'D'   PERFORM 140-DELETE-CUSTOMER-ROW
                   WHEN OTHER MOVE 'N' TO VALID-TRANSACTION-SW
               END-EVALUATE
               IF NOT VALID-TRANSACTION
                   PERFORM 150-WRITE-BAD-TRANS-RECORD.
      *
       110-READ-TRANSACTION-RECORD.
      *
           READ CUSTTRAN
               AT END
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW.
      *
       120-INSERT-CUSTOMER-ROW.
      *
           MOVE CTR-TRANSACTION-DATA TO CUSTOMER-ROW
           EXEC SQL
               INSERT INTO MM01.CUSTOMER
                      ( CUSTNO,   FNAME,     LNAME,    ADDR,
                        CITY,     STATE,     ZIPCODE)
               VALUES (:CUSTNO,  :FNAME,    :LNAME,   :ADDR,
                       :CITY,    :STATE,    :ZIPCODE)
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       130-UPDATE-CUSTOMER-ROW.
      *
           MOVE CTR-TRANSACTION-DATA TO CUSTOMER-ROW
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
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       140-DELETE-CUSTOMER-ROW.
      *
           MOVE CTR-CUSTOMER-NUMBER TO CUSTNO.
           EXEC SQL
               DELETE FROM MM01.CUSTOMER
                   WHERE CUSTNO = :CUSTNO
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       150-WRITE-BAD-TRANS-RECORD.
      *
           WRITE BAD-TRANSACTION-RECORD
               FROM CUSTOMER-TRANSACTION-RECORD.
      *
