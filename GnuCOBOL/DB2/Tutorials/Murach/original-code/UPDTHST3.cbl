       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    UPDTHST3.
      *
      *USER ABEND CODES:  2200  DSNTIAR SUBPROGRAM ERROR
      *                   2270  INSERT STATEMENT ERROR
      *                   2280  DELETE STATEMENT ERROR
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  SQL-ERROR-ROUTINE-FIELDS.
      *
           05  PROGRAM-ERROR-MESSAGE.
               10  FILLER            PIC X(11)   VALUE 'SQLCODE IS '.
               10  PEM-SQLCODE       PIC -999.
               10  FILLER            PIC X(5)    VALUE SPACES.
               10  PEM-TABLE         PIC X(18)   VALUE SPACES.
               10  FILLER            PIC X(2)    VALUE SPACES.
               10  PEM-PARAGRAPH     PIC X(30)   VALUE SPACES.
      *
           05  DSNTIAR-ERROR-MESSAGE.
               10  DEM-LENGTH        PIC S9(4)   COMP    VALUE +800.
               10  DEM-MESSAGE       PIC X(80)   OCCURS 10 TIMES
                                                 INDEXED BY DEM-INDEX.
      *
           05  DSNTIAR-LINE-LENGTH   PIC S9(9)   COMP    VALUE +80.
      *
           05  ROLLBACK-ERROR-MESSAGE.
               10  FILLER            PIC X(20)
                                     VALUE 'ROLLBACK SQLCODE IS '.
               10  REM-SQLCODE       PIC -999.
      
           05  ABND-CODE             PIC S9(4)   COMP    VALUE +00.
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
           PERFORM 200-LOAD-WORK-TABLE.
           PERFORM 300-INSERT-INVOICES.
           PERFORM 400-INSERT-LINE-ITEMS.
           PERFORM 500-INSERT-PAYMENT-ITEMS.
           PERFORM 600-DELETE-ALL-ITEMS.
           DISPLAY 'UPDATE COMPLETED SUCCESSFULLY.'.
           STOP RUN.
      *
       100-CLEAR-WORK-TABLE.
      *
           EXEC SQL
               DELETE FROM MM01.WORKTABLE
           END-EXEC.
           IF SQLCODE < 0
               MOVE SQLCODE                  TO PEM-SQLCODE
               MOVE 'MM01.WORKTABLE'         TO PEM-TABLE
               MOVE '100-CLEAR-WORK-TABLE'   TO PEM-PARAGRAPH
               MOVE +2280 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS DELETED FROM WORKTABLE.'.
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
               MOVE SQLCODE                  TO PEM-SQLCODE
               MOVE 'MM01.WORKTABLE'         TO PEM-TABLE
               MOVE '200-LOAD-WORK-TABLE'    TO PEM-PARAGRAPH
               MOVE +2270 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS INSERTED INTO WORKTABLE.'.
      *
       300-INSERT-INVOICES.
      *
           EXEC SQL
               INSERT INTO MM01.INVHIST
                   SELECT *
                       FROM  MM01.WORKTABLE
           END-EXEC.
           IF SQLCODE < 0
               MOVE SQLCODE                  TO PEM-SQLCODE
               MOVE 'MM01.INVHIST'           TO PEM-TABLE
               MOVE '300-INSERT-INVOICES'    TO PEM-PARAGRAPH
               MOVE +2270 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS INSERTED INTO INVHIST.'.
      *
       400-INSERT-LINE-ITEMS.
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
               MOVE SQLCODE                  TO PEM-SQLCODE
               MOVE 'MM01.LIHIST'            TO PEM-TABLE
               MOVE '400-INSERT-LINE-ITEMS'  TO PEM-PARAGRAPH
               MOVE +2270 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS INSERTED INTO LIHIST.'.
      *
       500-INSERT-PAYMENT-ITEMS.
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
               MOVE SQLCODE                    TO PEM-SQLCODE
               MOVE 'MM01.PAYHIST'             TO PEM-TABLE
               MOVE '500-INSERT-PAYMENT-ITEMS' TO PEM-PARAGRAPH
               MOVE +2270 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS INSERTED INTO PAYHIST.'.
      *
       600-DELETE-ALL-ITEMS.
      *
           EXEC SQL
               DELETE FROM MM01.INVOICE
                   WHERE INVNO IN
                       (SELECT INVNO
                            FROM MM01.WORKTABLE)
           END-EXEC.
           IF SQLCODE < 0
               MOVE SQLCODE                    TO PEM-SQLCODE
               MOVE 'MM01.INVOICE'             TO PEM-TABLE
               MOVE '600-DELETE-ALL-ITEMS'     TO PEM-PARAGRAPH
               MOVE +2280 TO ABND-CODE
               PERFORM 990-SQL-ERROR-ROUTINE
           ELSE
               DISPLAY SQLERRD(3) ' ROWS DELETED FROM INVOICE.'.
      *
       990-SQL-ERROR-ROUTINE.
      *
           DISPLAY PROGRAM-ERROR-MESSAGE.
           CALL 'DSNTIAR' USING SQLCA
                                DSNTIAR-ERROR-MESSAGE
                                DSNTIAR-LINE-LENGTH.
           IF RETURN-CODE IS EQUAL TO ZERO
               PERFORM
                   VARYING DEM-INDEX FROM 1 BY 1
                   UNTIL DEM-INDEX > 10
                       DISPLAY DEM-MESSAGE(DEM-INDEX)
               END-PERFORM
           ELSE
               DISPLAY 'DSNTIAR ERROR - RETURN CODE = ' RETURN-CODE.
           DISPLAY 'SQLERRMC   ' SQLERRMC.
           DISPLAY 'SQLERRD1   ' SQLERRD(1).
           DISPLAY 'SQLERRD2   ' SQLERRD(2).
           DISPLAY 'SQLERRD3   ' SQLERRD(3).
           DISPLAY 'SQLERRD4   ' SQLERRD(4).
           DISPLAY 'SQLERRD5   ' SQLERRD(5).
           DISPLAY 'SQLERRD6   ' SQLERRD(6).
           DISPLAY 'SQLWARN0   ' SQLWARN0.
           DISPLAY 'SQLWARN1   ' SQLWARN1.
           DISPLAY 'SQLWARN2   ' SQLWARN2.
           DISPLAY 'SQLWARN3   ' SQLWARN3.
           DISPLAY 'SQLWARN4   ' SQLWARN4.
           DISPLAY 'SQLWARN5   ' SQLWARN5.
           DISPLAY 'SQLWARN6   ' SQLWARN6.
           DISPLAY 'SQLWARN7   ' SQLWARN7.
           DISPLAY 'SQLWARN8   ' SQLWARN8.
           DISPLAY 'SQLWARN9   ' SQLWARN9.
           DISPLAY 'SQLWARNA   ' SQLWARNA.
           EXEC SQL
               ROLLBACK
           END-EXEC.
           IF SQLCODE NOT EQUAL ZERO
               DISPLAY 'INVALID ROLLBACK'
               MOVE SQLCODE TO REM-SQLCODE
               DISPLAY ROLLBACK-ERROR-MESSAGE.
           CALL 'ILBOABN0' USING ABND-CODE.
      
