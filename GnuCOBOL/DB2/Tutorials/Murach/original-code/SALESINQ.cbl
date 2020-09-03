       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.   SALESINQ.
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
       01  SWITCHES.
      *
           05  END-OF-INQUIRIES-SW     PIC X   VALUE 'N'.
               88  END-OF-INQUIRIES            VALUE 'Y'.
           05  CUSTOMER-FOUND-SW       PIC X   VALUE 'Y'.
               88  CUSTOMER-FOUND              VALUE 'Y'.
           05  VALID-CURSOR-SW         PIC X   VALUE 'Y'.
               88  VALID-CURSOR                VALUE 'Y'.
           05  END-OF-INVOICES-SW      PIC X   VALUE 'N'.
               88  END-OF-INVOICES             VALUE 'Y'.
      *
       01  INVOICE-TOTAL-FIELDS    COMP-3.
      *
           05  INVOICES-COUNT      PIC S9(5)    VALUE ZERO.
           05  INVOICES-TOTAL      PIC S9(7)V99 VALUE ZERO.
      *
       01  EDITED-TOTAL-FIELDS.
      *
           05  EDITED-COUNT        PIC Z(4)9.
           05  EDITED-TOTAL        PIC Z(6)9.99.
      *
           EXEC SQL
               INCLUDE CUSTOMER
           END-EXEC.
      *
           EXEC SQL
               INCLUDE INVOICE
           END-EXEC.
      *
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *
           EXEC SQL
              DECLARE INVCURS CURSOR FOR
                   SELECT   INVNO, INVDATE, INVTOTAL
                       FROM MM01.INVOICE
                       WHERE INVCUST = :CUSTNO
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-PROCESS-SALES-INQUIRIES.
      *
           PERFORM 100-PROCESS-SALES-INQUIRY
               UNTIL END-OF-INQUIRIES.
           STOP RUN.
      *
       100-PROCESS-SALES-INQUIRY.
      *
           MOVE 'Y' TO CUSTOMER-FOUND-SW.
           PERFORM 110-ACCEPT-CUSTOMER-NUMBER.
           IF NOT END-OF-INQUIRIES
               PERFORM 120-GET-CUSTOMER-ROW
               PERFORM 130-DISPLAY-CUSTOMER-INFO
               IF CUSTOMER-FOUND
                   PERFORM 140-GET-INVOICES-INFORMATION
                   PERFORM 200-DISPLAY-SALES-TOTALS.
      *
       110-ACCEPT-CUSTOMER-NUMBER.
      *
           DISPLAY '------------------------------------------------'.
           DISPLAY 'KEY IN THE NEXT CUSTOMER NUMBER AND PRESS ENTER,'.
           DISPLAY 'OR KEY IN 999999 AND PRESS ENTER TO QUIT.'.
           ACCEPT CUSTNO.
           IF CUSTNO = '999999'
               MOVE 'Y' TO END-OF-INQUIRIES-SW.
      *
       120-GET-CUSTOMER-ROW.
      *
           EXEC SQL
               SELECT    FNAME,  LNAME
                   INTO :FNAME, :LNAME
                   FROM MM01.CUSTOMER
                       WHERE CUSTNO = :CUSTNO
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO CUSTOMER-FOUND-SW.
      *
       130-DISPLAY-CUSTOMER-INFO.
      *
           DISPLAY '------------------------------------------------'.
           IF CUSTOMER-FOUND
               DISPLAY '  CUSTOMER ' CUSTNO ' -- ' FNAME ' ' LNAME
               DISPLAY ' '
           ELSE
               DISPLAY '  CUSTOMER NUMBER ' CUSTNO ' NOT FOUND.'.
      *
       140-GET-INVOICES-INFORMATION.
      *
           MOVE 'Y' TO VALID-CURSOR-SW.
           PERFORM 150-OPEN-INVOICE-CURSOR.
           IF VALID-CURSOR
               MOVE 'N' TO END-OF-INVOICES-SW
               MOVE ZERO TO INVOICES-COUNT
               MOVE ZERO TO INVOICES-TOTAL
               PERFORM 160-GET-INVOICE-INFORMATION
                   UNTIL END-OF-INVOICES
               PERFORM 190-CLOSE-INVOICE-CURSOR.
      *
       150-OPEN-INVOICE-CURSOR.
      *
           EXEC SQL
               OPEN INVCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-CURSOR-SW.
      *
       160-GET-INVOICE-INFORMATION.
      *
           PERFORM 170-FETCH-INVOICE-ROW.
           IF NOT END-OF-INVOICES
               ADD 1        TO INVOICES-COUNT
               ADD INVTOTAL TO INVOICES-TOTAL
               PERFORM 180-DISPLAY-INVOICE-INFO.
      *
       170-FETCH-INVOICE-ROW.
      *
           EXEC SQL
               FETCH INVCURS
                   INTO :INVNO, :INVDATE, :INVTOTAL
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'Y' TO END-OF-INVOICES-SW
               IF SQLCODE NOT = 100
                   MOVE 'N' TO VALID-CURSOR-SW.
      *
       180-DISPLAY-INVOICE-INFO.
      *
           MOVE INVTOTAL TO EDITED-TOTAL.
           DISPLAY '  INVOICE ' INVNO ' ' INVDATE ' ' EDITED-TOTAL.
      *
       190-CLOSE-INVOICE-CURSOR.
      *
           EXEC SQL
               CLOSE INVCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-CURSOR-SW.
      *
       200-DISPLAY-SALES-TOTALS.
      *
           IF VALID-CURSOR
               MOVE INVOICES-TOTAL              TO EDITED-TOTAL
               MOVE INVOICES-COUNT              TO EDITED-COUNT
               IF INVOICES-TOTAL > 0
                   DISPLAY '                            ------------'
               END-IF
               DISPLAY '  TOTAL BILLED              '     EDITED-TOTAL
               DISPLAY '  INVOICES ISSUED                ' EDITED-COUNT
               DISPLAY ' '
           ELSE
               DISPLAY ' '
               DISPLAY '     *** INVOICE RETRIEVAL ERROR   ***'
               DISPLAY ' '.
      *
      