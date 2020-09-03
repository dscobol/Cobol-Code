       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    INVREG.
      *
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
      *
       FILE-CONTROL.
      *
           SELECT PRTOUT ASSIGN TO UT-S-PRTOUT.
      *
       DATA DIVISION.
      *
       FILE SECTION.
      *
       FD  PRTOUT
           LABEL RECORDS ARE STANDARD
           BLOCK CONTAINS 0 RECORDS
           RECORD CONTAINS 132 CHARACTERS.
      *
       01  PRTOUT-RECORD               PIC X(132).
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCHES.
           05  VALID-CURSOR-SW         PIC X   VALUE 'Y'.
               88  VALID-CURSOR                VALUE 'Y'.
               88  NOT-VALID-CURSOR            VALUE 'N'.
           05  END-OF-INVOICES-SW      PIC X   VALUE 'N'.
               88  END-OF-INVOICES             VALUE 'Y'.
      *
       01  DATE-FIELDS.
           05  PRESENT-DATE            PIC 9(6).
           05  PRESENT-DATE-X          REDEFINES PRESENT-DATE.
               10  PRESENT-YEAR        PIC 99.
               10  PRESENT-MONTH       PIC 99.
               10  PRESENT-DAY         PIC 99.
      *
       01  INVOICE-TOTAL-FIELDS        COMP-3.
           05  INVOICES-COUNT          PIC S9(9)       VALUE ZERO.
           05  INVOICES-SUBTOTAL       PIC S9(9)V99    VALUE ZERO.
           05  INVOICES-TAX            PIC S9(7)V99    VALUE ZERO.
           05  INVOICES-SHIPPING       PIC S9(7)V99    VALUE ZERO.
           05  INVOICES-TOTAL          PIC S9(9)V99    VALUE ZERO.
      *
       01  PRINT-FIELDS                COMP-3.
           05  PAGE-COUNT              PIC S9(3)       VALUE ZERO.
           05  LINE-COUNT              PIC S9(3)       VALUE +999.
           05  LINES-ON-PAGE           PIC S9(3)       VALUE +50.
           05  SPACE-CONTROL           PIC S9(3)       VALUE +1.
      *
       01  HEADING-LINE-1.
           05  FILLER      PIC X(19)   VALUE 'INVOICE REGISTER - '.
           05  HL1-MONTH   PIC X(2).
           05  FILLER      PIC X       VALUE '/'.
           05  HL1-DAY     PIC X(2).
           05  FILLER      PIC X       VALUE '/'.
           05  HL1-YEAR    PIC X(2).
           05  FILLER      PIC X(63)   VALUE SPACES.
           05  FILLER      PIC X(6)    VALUE 'PAGE: '.
           05  HL1-PAGE    PIC X(5)    VALUE SPACES.
           05  FILLER      PIC X(31)   VALUE SPACES.
      *
       01  HEADING-LINE-2.
           05  FILLER      PIC X(20)   VALUE 'INVOICE     SUBTOTAL'.
           05  FILLER      PIC X(20)   VALUE '         TAX    SHIP'.
           05  FILLER      PIC X(20)   VALUE 'PING         TOTAL  '.
           05  FILLER      PIC X(20)   VALUE 'CUSTOMER            '.
           05  FILLER      PIC X(20)   VALUE '                    '.
           05  FILLER      PIC X(20)   VALUE '                    '.
           05  FILLER      PIC X(12)   VALUE '            '.
      *
       01  REPORT-LINE.
           05  RL-INVNO    PIC X(6).
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-SUBTOTAL PIC Z(8)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-TAX      PIC Z(6)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-SHIPPING PIC Z(6)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-TOTAL    PIC Z(8)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-CUSTNO   PIC X(6).
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-FNAME    PIC X(20).
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  RL-LNAME    PIC X(30).
           05  FILLER      PIC X(12)   VALUE SPACES.
      *
       01  TOTAL-LINE.
           05  FILLER      PIC X(8)    VALUE 'TOTAL: '.
           05  TL-SUBTOTAL PIC Z(8)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  TL-TAX      PIC Z(6)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  TL-SHIPPING PIC Z(6)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  TL-TOTAL    PIC Z(8)9.99.
           05  FILLER      PIC X(2)    VALUE SPACES.
           05  TL-COUNT    PIC Z(8)9.
           05  FILLER      PIC X(16)   VALUE ' INVOICES ISSUED'.
           05  FILLER      PIC X(47)   VALUE SPACES.
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
                   SELECT A.INVNO,    A.INVSUBT,  A.INVTAX,  A.INVSHIP,
                          A.INVTOTAL, B.CUSTNO,   B.FNAME,   B.LNAME
                       FROM MM01.INVOICE A
                           INNER JOIN MM01.CUSTOMER B
                       ON A.INVCUST = B.CUSTNO
                   ORDER BY INVNO
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-PREPARE-INVOICE-REGISTER.
      *
           OPEN OUTPUT PRTOUT.
           ACCEPT PRESENT-DATE FROM DATE.
           MOVE PRESENT-MONTH TO HL1-MONTH.
           MOVE PRESENT-DAY   TO HL1-DAY.
           MOVE PRESENT-YEAR  TO HL1-YEAR.
           PERFORM 100-OPEN-INVOICE-CURSOR.
           IF VALID-CURSOR
               PERFORM 200-PRINT-INVOICE-LINE
                   UNTIL END-OF-INVOICES
                      OR NOT-VALID-CURSOR
               PERFORM 300-CLOSE-INVOICE-CURSOR.
           PERFORM 400-PRINT-TOTAL-LINES.
           CLOSE PRTOUT.
           STOP RUN.
      *
       100-OPEN-INVOICE-CURSOR.
      *
           EXEC SQL
               OPEN INVCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-CURSOR-SW.
      *
       200-PRINT-INVOICE-LINE.
      *
           PERFORM 210-FETCH-INVOICE-ROW.
           IF NOT END-OF-INVOICES
               IF VALID-CURSOR
                   ADD 1           TO INVOICES-COUNT
                   ADD INVSUBT     TO INVOICES-SUBTOTAL
                   ADD INVTAX      TO INVOICES-TAX
                   ADD INVSHIP     TO INVOICES-SHIPPING
                   ADD INVTOTAL    TO INVOICES-TOTAL
                   MOVE INVNO      TO RL-INVNO
                   MOVE INVSUBT    TO RL-SUBTOTAL
                   MOVE INVTAX     TO RL-TAX
                   MOVE INVSHIP    TO RL-SHIPPING
                   MOVE INVTOTAL   TO RL-TOTAL
                   MOVE CUSTNO     TO RL-CUSTNO
                   MOVE FNAME      TO RL-FNAME
                   MOVE LNAME      TO RL-LNAME
                   PERFORM 220-PRINT-REPORT-LINE.
      *
       210-FETCH-INVOICE-ROW.
      *
           EXEC SQL
               FETCH INVCURS
                   INTO :INVNO,    :INVSUBT,   :INVTAX,    :INVSHIP,
                        :INVTOTAL, :CUSTNO,    :FNAME,     :LNAME
           END-EXEC.
           IF SQLCODE = 100
               MOVE 'Y' TO END-OF-INVOICES-SW
           ELSE
               IF SQLCODE NOT = 0
                   MOVE 'N' TO VALID-CURSOR-SW.
      *
       220-PRINT-REPORT-LINE.
      *
           IF LINE-COUNT > LINES-ON-PAGE
               PERFORM 230-PRINT-REPORT-HEADING
               MOVE 1 TO LINE-COUNT.
           MOVE REPORT-LINE TO PRTOUT-RECORD.
           PERFORM 250-WRITE-REPORT-LINE.
           ADD 1 TO LINE-COUNT.
           MOVE 1 TO SPACE-CONTROL.
      *
       230-PRINT-REPORT-HEADING.
      *
           ADD 1 TO PAGE-COUNT.
           MOVE PAGE-COUNT TO HL1-PAGE.
           MOVE HEADING-LINE-1 TO PRTOUT-RECORD.
           PERFORM 240-WRITE-PAGE-TOP-LINE.
           MOVE 2 TO SPACE-CONTROL.
           MOVE HEADING-LINE-2 TO PRTOUT-RECORD.
           PERFORM 250-WRITE-REPORT-LINE.
      *
       240-WRITE-PAGE-TOP-LINE.
      *
           WRITE PRTOUT-RECORD
               AFTER ADVANCING PAGE.
      *
       250-WRITE-REPORT-LINE.
      *
           WRITE PRTOUT-RECORD
               AFTER SPACE-CONTROL LINES.
      *
       300-CLOSE-INVOICE-CURSOR.
      *
           EXEC SQL
               CLOSE INVCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'N' TO VALID-CURSOR-SW.
      *
       400-PRINT-TOTAL-LINES.
      *
           IF VALID-CURSOR
               MOVE INVOICES-SUBTOTAL  TO TL-SUBTOTAL
               MOVE INVOICES-TAX       TO TL-TAX
               MOVE INVOICES-SHIPPING  TO TL-SHIPPING
               MOVE INVOICES-TOTAL     TO TL-TOTAL
               MOVE INVOICES-COUNT     TO TL-COUNT
               MOVE TOTAL-LINE         TO PRTOUT-RECORD
           ELSE
               MOVE '****  DB2 ERROR  -- INCOMPLETE REPORT  ****'
                                       TO PRTOUT-RECORD.
           MOVE 2 TO SPACE-CONTROL.
           PERFORM 250-WRITE-REPORT-LINE.
      *
