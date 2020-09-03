       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    UPDTHST1.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCH.
      *
           05  UPDATE-SUCCESSFUL-SW     PIC X    VALUE 'Y'.
               88  UPDATE-SUCCESSFUL             VALUE 'Y'.
      *
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-UPDATE-HISTORY-TABLES.
      *
           PERFORM 100-CLEAR-WORK-TABLE.
           IF UPDATE-SUCCESSFUL
               PERFORM 200-LOAD-WORK-TABLE.
           IF UPDATE-SUCCESSFUL
               PERFORM 300-MOVE-INVOICES.
           IF UPDATE-SUCCESSFUL
               PERFORM 400-MOVE-LINE-ITEMS.
           IF UPDATE-SUCCESSFUL
               PERFORM 500-MOVE-PAYMENT-ITEMS.
           IF UPDATE-SUCCESSFUL
               DISPLAY 'UPDATE COMPLETED SUCCESSFULLY.'.
           STOP RUN.
      *
       100-CLEAR-WORK-TABLE.
      *
           EXEC SQL
               DELETE FROM MM01.WORKTABLE
           END-EXEC.
           IF SQLCODE < 0
               DISPLAY 'DELETE IN MODULE 100 FAILED.'
               DISPLAY 'SQLCODE = ' SQLCODE
               MOVE 'N' TO UPDATE-SUCCESSFUL-SW.
      *
       200-LOAD-WORK-TABLE.
      *
           EXEC SQL
               INSERT INTO MM01.WORKTABLE
                   SELECT *
                       FROM  MM01.INVOICE A
                       WHERE INVTOTAL =
                           (SELECT SUM(PAYAMT)
                                FROM MM01.PAYMENT
                                WHERE PAYINVNO = A.INVNO)
           END-EXEC.
           IF SQLCODE < 0
               DISPLAY 'INSERT IN MODULE 200 FAILED.'
               DISPLAY 'SQLCODE = ' SQLCODE
               MOVE 'N' TO UPDATE-SUCCESSFUL-SW.
      *
       300-MOVE-INVOICES.
      *
           EXEC SQL
               INSERT INTO MM01.INVHIST
                   SELECT *
                       FROM  MM01.WORKTABLE
           END-EXEC.
           IF SQLCODE < 0
               DISPLAY 'INSERT IN MODULE 300 FAILED.'
               DISPLAY 'SQLCODE = ' SQLCODE
               MOVE 'N' TO UPDATE-SUCCESSFUL-SW
           ELSE
               EXEC SQL
                   DELETE FROM MM01.INVOICE
                       WHERE INVNO IN
                           (SELECT INVNO
                                FROM MM01.WORKTABLE)
               END-EXEC
               IF SQLCODE < 0
                   DISPLAY 'DELETE IN MODULE 300 FAILED.'
                   DISPLAY 'SQLCODE = ' SQLCODE
                   MOVE 'N' TO UPDATE-SUCCESSFUL-SW.
      *
       400-MOVE-LINE-ITEMS.
      *
           EXEC SQL
               INSERT INTO MM01.LIHIST
                   SELECT *
                       FROM  MM01.LINEITEM
                       WHERE LIINVNO IN
                           (SELECT INVNO
                                FROM MM01.WORKTABLE)
           END-EXEC.
           IF SQLCODE < 0
               DISPLAY 'INSERT IN MODULE 400 FAILED.'
               DISPLAY 'SQLCODE = ' SQLCODE
               MOVE 'N' TO UPDATE-SUCCESSFUL-SW
           ELSE
               EXEC SQL
                   DELETE FROM MM01.LINEITEM
                       WHERE LIINVNO IN
                           (SELECT INVNO
                                FROM MM01.WORKTABLE)
               END-EXEC
               IF SQLCODE < 0
                   DISPLAY 'DELETE IN MODULE 400 FAILED.'
                   DISPLAY 'SQLCODE = ' SQLCODE
                   MOVE 'N' TO UPDATE-SUCCESSFUL-SW.
      *
       500-MOVE-PAYMENT-ITEMS.
      *
           EXEC SQL
               INSERT INTO MM01.PAYHIST
                   SELECT *
                       FROM  MM01.PAYMENT
                       WHERE PAYINVNO IN
                           (SELECT INVNO
                                FROM MM01.WORKTABLE)
           END-EXEC.
           IF SQLCODE < 0
               DISPLAY 'INSERT IN MODULE 500 FAILED.'
               DISPLAY 'SQLCODE = ' SQLCODE
               MOVE 'N' TO UPDATE-SUCCESSFUL-SW
           ELSE
               EXEC SQL
                   DELETE FROM MM01.PAYMENT
                       WHERE PAYINVNO IN
                           (SELECT INVNO
                                FROM MM01.WORKTABLE)
               END-EXEC
               IF SQLCODE < 0
                   DISPLAY 'DELETE IN MODULE 500 FAILED.'
                   DISPLAY 'SQLCODE = ' SQLCODE
                   MOVE 'N' TO UPDATE-SUCCESSFUL-SW.
      *
      
