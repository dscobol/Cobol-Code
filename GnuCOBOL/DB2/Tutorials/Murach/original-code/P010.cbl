       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    P010.
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
           05  EMPLOYEE-FOUND-SW       PIC X.
               88  EMPLOYEE-FOUND              VALUE 'Y'.
      *
       01  EDIT-FIELDS.
      *
           05  EDIT-SALARY             PIC Z,ZZZ,ZZ9.99.
           05  EDIT-BONUS              PIC       ZZ9.99.
      *
           EXEC SQL
               INCLUDE PAYROLL
           END-EXEC.
      *
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
      *
       PROCEDURE DIVISION.
      *
       000-DISPLAY-EMPLOYEE-ROWS.
      *
           PERFORM 100-DISPLAY-EMPLOYEE-ROW
               UNTIL END-OF-INQUIRIES.
           STOP RUN.
      *
       100-DISPLAY-EMPLOYEE-ROW.
      *
           PERFORM 110-ACCEPT-EMPLOYEE-NUMBER.
           IF NOT END-OF-INQUIRIES
               MOVE 'Y' TO EMPLOYEE-FOUND-SW
               PERFORM 120-GET-EMPLOYEE-ROW
               IF EMPLOYEE-FOUND
                   PERFORM 130-DISPLAY-EMPLOYEE-LINES
               ELSE
                   PERFORM 140-DISPLAY-ERROR-LINES.
      *
       110-ACCEPT-EMPLOYEE-NUMBER.
      *
           DISPLAY '------------------------------------------------'.
           DISPLAY 'KEY IN THE NEXT EMPLOYEE NUMBER AND PRESS ENTER,'.
           DISPLAY 'OR KEY IN 999999 AND PRESS ENTER TO QUIT.'.
           ACCEPT PYRL-EMPNO.
           IF PYRL-EMPNO = '999999'
               MOVE 'Y' TO END-OF-INQUIRIES-SW.
      *
       120-GET-EMPLOYEE-ROW.
      *
           EXEC SQL
               SELECT EMPNO,     FNAME,       LNAME,
                      ADDR,      CITY,        STATE,
                      ZIPCODE,   SALARY,      BONUS
               INTO  :PYRL-EMPNO,    :PYRL-FNAME,      :PYRL-LNAME,
                     :PYRL-ADDR,     :PYRL-CITY,       :PYRL-STATE,
                     :PYRL-ZIPCODE,  :PYRL-SALARY,     :PYRL-BONUS
               FROM   MM01.PAYROLL
                   WHERE  EMPNO = :PYRL-EMPNO
           END-EXEC.
      *
           IF SQLCODE NOT = 0
               MOVE 'N' TO EMPLOYEE-FOUND-SW.
      *
       130-DISPLAY-EMPLOYEE-LINES.
      *
           MOVE PYRL-SALARY  TO  EDIT-SALARY.
           MOVE PYRL-BONUS   TO  EDIT-BONUS.
           DISPLAY '------------------------------------------------'.
           DISPLAY '   EMPLOYEE ' PYRL-EMPNO.
           DISPLAY '   NAME     ' PYRL-FNAME ' ' PYRL-LNAME.
           DISPLAY '   ADDRESS  ' PYRL-ADDR.
           DISPLAY '            ' PYRL-CITY ' ' PYRL-STATE ' '
                                  PYRL-ZIPCODE.
           DISPLAY '   SALARY   ' EDIT-SALARY.
           DISPLAY '   BONUS          ' EDIT-BONUS.
      *
       140-DISPLAY-ERROR-LINES.
      *
           DISPLAY '------------------------------------------------'.
           DISPLAY '   EMPLOYEE NUMBER ' PYRL-EMPNO ' NOT FOUND.'.
      *
