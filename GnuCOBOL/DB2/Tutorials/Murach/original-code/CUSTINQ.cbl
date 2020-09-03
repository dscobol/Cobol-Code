       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    CUSTINQ.
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
           05  CUSTOMER-FOUND-SW       PIC X.
               88  CUSTOMER-FOUND              VALUE 'Y'.
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
       000-DISPLAY-CUSTOMER-ROWS.
      *
           PERFORM 100-DISPLAY-CUSTOMER-ROW
               UNTIL END-OF-INQUIRIES.
           STOP RUN.
      *
       100-DISPLAY-CUSTOMER-ROW.
      *
           PERFORM 110-ACCEPT-CUSTOMER-NUMBER.
           IF NOT END-OF-INQUIRIES
               MOVE 'Y' TO CUSTOMER-FOUND-SW
               PERFORM 120-GET-CUSTOMER-ROW
               IF CUSTOMER-FOUND
                   PERFORM 130-DISPLAY-CUSTOMER-LINES
               ELSE
                   PERFORM 140-DISPLAY-ERROR-LINES.
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
               SELECT CUSTNO,    FNAME,       LNAME,
                      ADDR,      CITY,        STATE,
                      ZIPCODE
               INTO  :CUSTNO,       :FNAME,          :LNAME,
                     :ADDR,         :CITY,           :STATE,
                     :ZIPCODE
               FROM   MM01.CUSTOMER
                   WHERE  CUSTNO = :CUSTNO
           END-EXEC.
      *
           IF SQLCODE NOT = 0
               MOVE 'N' TO CUSTOMER-FOUND-SW.
      *
       130-DISPLAY-CUSTOMER-LINES.
      *
           DISPLAY '------------------------------------------------'.
           DISPLAY '   CUSTOMER ' CUSTNO.
           DISPLAY '   NAME     ' FNAME ' ' LNAME.
           DISPLAY '   ADDRESS  ' ADDR.
           DISPLAY '            ' CITY ' ' STATE ' '
                                  ZIPCODE.
      *
       140-DISPLAY-ERROR-LINES.
      *
           DISPLAY '------------------------------------------------'.
           DISPLAY '   CUSTOMER NUMBER ' CUSTNO ' NOT FOUND.'.
      *
