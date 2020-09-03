       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    SUMINQ.
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
       01  SWITCH.
           05  END-OF-CUSTOMERS-SW        PIC X  VALUE 'N'.
               88  END-OF-CUSTOMERS              VALUE 'Y'.
      *
       01  WORK-FIELDS.
           05  INVOICE-COUNT              PIC S9(9)     COMP.
           05  INVOICE-SUM                PIC S9(7)V99  COMP-3.
           05  INVOICE-AVG                PIC S9(7)V99  COMP-3.
           05  EDITED-INVOICE-COUNT       PIC Z(8)9.
           05  EDITED-INVOICE-SUM         PIC Z(6)9.99.
           05  EDITED-INVOICE-AVG         PIC Z(6)9.99.
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
                   SELECT  INVCUST AS INVCUST,  COUNT(*) AS INVCOUNT,
                           AVG(INVTOTAL),       SUM(INVTOTAL)
                       FROM MM01.INVOICE
                           GROUP BY INVCUST
                           ORDER BY INVCOUNT DESC, INVCUST
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-DISPL-CUST-SUMMRY-ROWS.
      *
           PERFORM 100-OPEN-INVOICE-CURSOR.
           IF NOT END-OF-CUSTOMERS
               DISPLAY 'CUSTOMER          COUNT      TOTAL    AVERAGE'
               PERFORM 200-DISPL-CUST-SUMMRY-ROW
                   UNTIL END-OF-CUSTOMERS
               PERFORM 300-CLOSE-INVOICE-CURSOR.
           STOP RUN.
      *
       100-OPEN-INVOICE-CURSOR.
      *
           EXEC SQL
               OPEN INVCURS
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'Y' TO END-OF-CUSTOMERS-SW.
      *
       200-DISPL-CUST-SUMMRY-ROW.
      *
           PERFORM 210-FETCH-CUSTOMER-ROW.
           IF NOT END-OF-CUSTOMERS
               MOVE INVOICE-COUNT TO EDITED-INVOICE-COUNT
               MOVE INVOICE-AVG   TO EDITED-INVOICE-AVG
               MOVE INVOICE-SUM   TO EDITED-INVOICE-SUM
               DISPLAY INVCUST '        '
                   EDITED-INVOICE-COUNT ' '
                   EDITED-INVOICE-SUM   ' '
                   EDITED-INVOICE-AVG.
      *
       210-FETCH-CUSTOMER-ROW.
      *
           EXEC SQL
               FETCH  INVCURS
               INTO  :INVCUST,     :INVOICE-COUNT,
                     :INVOICE-AVG, :INVOICE-SUM
           END-EXEC.
           IF SQLCODE NOT = 0
               MOVE 'Y' TO END-OF-CUSTOMERS-SW.
      *
       300-CLOSE-INVOICE-CURSOR.
      *
           EXEC SQL
               CLOSE INVCURS
           END-EXEC.
      *
