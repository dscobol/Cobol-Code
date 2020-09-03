       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.       VNCUPDT.
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
           RECORD CONTAINS 375 CHARACTERS.
      *
       01  CUSTOMER-TRANSACTION-RECORD.
      *
           05  CTR-TRANSACTION-CODE     PIC X.
           05  CTR-TRANSACTION-DATA.
               10  CTR-CUSTNO           PIC X(6).
               10  CTR-FNAME            PIC X(20).
               10  CTR-LNAME            PIC X(30).
               10  CTR-CITY             PIC X(20).
               10  CTR-STATE            PIC XX.
               10  CTR-ZIPCODE          PIC X(10).
               10  CTR-HOMEPH           PIC X(16).
               10  CTR-WORKPH           PIC X(16).
               10  CTR-NOTES            PIC X(254).
      *
       FD  BADTRAN
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 375 CHARACTERS.
      *
       01  BAD-TRANSACTION-RECORD.
      *
           05  BTR-TRANSACTION-CODE     PIC X.
           05  BTR-TRANSACTION-DATA     PIC X(374).
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCHES.
      *
           05  END-OF-TRANSACTIONS-SW   PIC X    VALUE 'N'.
               88  END-OF-TRANSACTIONS           VALUE 'Y'.
           05  VALID-TRANSACTION-SW     PIC X    VALUE 'Y'.
               88  VALID-TRANSACTION             VALUE 'Y'.
      *
       01  INDICATORS.
      *
           05  IND-HOMEPH               PIC S9(4) COMP.
           05  IND-WORKPH               PIC S9(4) COMP.
           05  IND-NOTES                PIC S9(4) COMP.
      *
           EXEC SQL
               INCLUDE VARCUST
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
               MOVE CTR-CUSTNO  TO CUSTNO
               MOVE CTR-FNAME   TO FNAME-TEXT
               MOVE CTR-LNAME   TO LNAME-TEXT
               MOVE CTR-CITY    TO CITY-TEXT
               MOVE CTR-STATE   TO STATE
               MOVE CTR-ZIPCODE TO ZIPCODE
               MOVE CTR-HOMEPH  TO HOMEPH
               MOVE CTR-WORKPH  TO WORKPH
               MOVE CTR-NOTES   TO NOTES-TEXT
               EVALUATE CTR-TRANSACTION-CODE
                   WHEN 'A'   PERFORM 120-INSERT-CUSTOMER-ROW
                   WHEN 'R'   PERFORM 140-UPDATE-CUSTOMER-ROW
                   WHEN 'D'   PERFORM 150-DELETE-CUSTOMER-ROW
                   WHEN OTHER MOVE 'N' TO VALID-TRANSACTION-SW
               END-EVALUATE
               IF NOT VALID-TRANSACTION
                   PERFORM 160-WRITE-BAD-TRANSACTION.
      *
       110-READ-TRANSACTION-RECORD.
      *
           READ CUSTTRAN
               AT END
                   MOVE 'Y' TO END-OF-TRANSACTIONS-SW.
      *
       120-INSERT-CUSTOMER-ROW.
      *
           PERFORM 130-SET-NULLS-AND-LENGTHS.
           EXEC SQL
               INSERT INTO MM01.VARCUST
                     (  CUSTNO,               FNAME,
                        LNAME,                CITY,
                        STATE,                ZIPCODE,
                        HOMEPH,               WORKPH,
                        NOTES)
               VALUES (:CUSTNO,              :FNAME,
                       :LNAME,               :CITY,
                       :STATE,               :ZIPCODE,
                       :HOMEPH:IND-HOMEPH,   :WORKPH:IND-WORKPH,
                       :NOTES:IND-NOTES)
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       130-SET-NULLS-AND-LENGTHS.
      *
           MOVE LENGTH OF FNAME-TEXT TO FNAME-LEN.
           CALL 'STRLEN' USING FNAME-LEN
                               FNAME-TEXT.
      *
           MOVE LENGTH OF LNAME-TEXT TO LNAME-LEN.
           CALL 'STRLEN' USING LNAME-LEN
                               LNAME-TEXT.
      *
           MOVE LENGTH OF CITY-TEXT TO CITY-LEN.
           CALL 'STRLEN' USING CITY-LEN
                               CITY-TEXT.
      *
           IF HOMEPH = SPACE
               MOVE -1 TO IND-HOMEPH
           ELSE
               MOVE 0  TO IND-HOMEPH.
      *
           IF WORKPH = SPACE
               MOVE -1 TO IND-WORKPH
           ELSE
               MOVE 0  TO IND-WORKPH.
      *
           IF NOTES-TEXT = SPACE
               MOVE -1 TO IND-NOTES
           ELSE
               MOVE 0  TO IND-NOTES
               MOVE LENGTH OF NOTES-TEXT TO NOTES-LEN
               CALL 'STRLEN' USING NOTES-LEN
                                   NOTES-TEXT.
      *
       140-UPDATE-CUSTOMER-ROW.
      *
           PERFORM 130-SET-NULLS-AND-LENGTHS.
           EXEC SQL
               UPDATE MM01.VARCUST
                  SET CUSTNO  = :CUSTNO,
                      FNAME   = :FNAME,
                      LNAME   = :LNAME,
                      CITY    = :CITY,
                      STATE   = :STATE,
                      ZIPCODE = :ZIPCODE,
                      HOMEPH  = :HOMEPH:IND-HOMEPH,
                      WORKPH  = :WORKPH:IND-WORKPH,
                      NOTES   = :NOTES:IND-NOTES
               WHERE  CUSTNO  = :CUSTNO
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       150-DELETE-CUSTOMER-ROW.
      *
           EXEC SQL
               DELETE FROM MM01.VARCUST
                   WHERE CUSTNO = :CUSTNO
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-TRANSACTION-SW.
      *
       160-WRITE-BAD-TRANSACTION.
      *
           WRITE BAD-TRANSACTION-RECORD
               FROM CUSTOMER-TRANSACTION-RECORD.
      *
