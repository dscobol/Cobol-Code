       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. NAMEINQ.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
      *
       DATA DIVISION.
      *
       FILE SECTION.
      *
       WORKING-STORAGE SECTION.
      *
       01 SWITCHES.
           05 END-OF-INQUIRIES-SW     PIC X    VALUE 'N'.
               88 END-OF-INQUIRIES             VALUE 'Y'.
           05 END-OF-CUSTOMERS-SW     PIC X    VALUE 'N'.
               88 END-OF-CUSTOMERS             VALUE 'Y'.
           05 VALID-CURSOR-SW         PIC X    VALUE 'Y'.
               88 VALID-CURSOR                 VALUE 'Y'.
      *
       01 COUNT-FIELDS.
           05 CUSTOMER-COUNT          PIC S9(7)  COMP-3.
           05 EDITED-CUSTOMER-COUNT   PIC Z(6)9.
      *
       01 SEARCH-STRINGS.
           05 NAME-STRING             PIC X(5).
           05 STATE-STRING            PIC XX.
      *
           EXEC SQL
               INCLUDE CUSTOMER
           END-EXEC.
      *
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *
           EXEC SQL
               DECLARE CUSTCURS CURSOR FOR
                   SELECT CUSTNO, LNAME, FNAME, STATE
                       FROM MM01.CUSTOMER
                           WHERE LNAME LIKE :NAME-STRING
                             AND STATE LIKE :STATE-STRING
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-PROCESS-CUST-INQUIRIES.
           PERFORM 100-PROCESS-CUST-INQUIRY
               UNTIL END-OF-INQUIRIES.
           STOP RUN.
      *
       100-PROCESS-CUST-INQUIRY.
           PERFORM 110-ACCEPT-SEARCH-VALUES.
           IF NOT END-OF-INQUIRIES
               MOVE 'Y' TO VALID-CURSOR-SW
               MOVE ZERO TO CUSTOMER-COUNT
               PERFORM 120-OPEN-CUSTOMER-CURSOR
               IF VALID-CURSOR
                   MOVE 'N' TO END-OF-CUSTOMERS-SW
                   PERFORM 130-DISPLAY-CUSTOMER-INFO
                       UNTIL END-OF-CUSTOMERS
                   PERFORM 150-CLOSE-CUSTOMER-CURSOR
                   MOVE CUSTOMER-COUNT TO EDITED-CUSTOMER-COUNT
                   DISPLAY EDITED-CUSTOMER-COUNT ' CUSTOMER(S) FOUND.'.
      *
       110-ACCEPT-SEARCH-VALUES.
           MOVE SPACE TO NAME-STRING.
           MOVE SPACE TO STATE-STRING.
           DISPLAY '------------------------------------------------'.
           DISPLAY '(ENTER 99 FOR NAME OR STATE TO QUIT.)'.
           DISPLAY 'ENTER FIRST ONE TO FOUR CHARACTERS OF LAST NAME:'.
           ACCEPT NAME-STRING.
           IF NAME-STRING = '99'
               MOVE 'Y' TO END-OF-INQUIRIES-SW
           ELSE
               STRING NAME-STRING '%%%%%' DELIMITED BY ' '
                   INTO NAME-STRING
               DISPLAY 'ENTER STATE CODE: '
               ACCEPT STATE-STRING
               IF STATE-STRING = '99'
                   MOVE 'Y' TO END-OF-INQUIRIES-SW
               ELSE
                   STRING STATE-STRING '%%' DELIMITED BY ' '
                       INTO STATE-STRING.
      *
       120-OPEN-CUSTOMER-CURSOR.
           EXEC SQL
               OPEN CUSTCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-CURSOR-SW.
      *
       130-DISPLAY-CUSTOMER-INFO.
           PERFORM 140-FETCH-CUSTOMER-ROW.
           IF NOT END-OF-CUSTOMERS
               IF VALID-CURSOR
                   DISPLAY 'CUST: ' CUSTNO '--' FNAME ' '
                           LNAME ' ' STATE.
      *
       140-FETCH-CUSTOMER-ROW.
           EXEC SQL
               FETCH CUSTCURS
                   INTO :CUSTNO, :LNAME, :FNAME, :STATE
           END-EXEC.
           IF SQLCODE = 0
               ADD 1 TO CUSTOMER-COUNT
           ELSE
               MOVE 'Y' TO END-OF-CUSTOMERS-SW
               IF SQLCODE NOT = 100
                   MOVE 'N' TO VALID-CURSOR-SW.
      *
       150-CLOSE-CUSTOMER-CURSOR.
           EXEC SQL
               CLOSE CUSTCURS
           END-EXEC.
