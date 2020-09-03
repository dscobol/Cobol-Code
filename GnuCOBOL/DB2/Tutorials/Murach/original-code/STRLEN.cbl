       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    STRLEN.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCH.
      *
           05  LENGTH-DETERMINED-SW     PIC X  VALUE 'N'.
               88  LENGTH-DETERMINED           VALUE 'Y'.
      *
       LINKAGE SECTION.
      *
       01  TEXT-LENGTH                  PIC S9(4) COMP.
      *
       01  WORK-TABLE.
      *
           05  WT-CHARACTER             OCCURS 1 TO 254 TIMES
                                        DEPENDING ON TEXT-LENGTH
                                        PIC X.
      *
       PROCEDURE DIVISION USING TEXT-LENGTH
                                WORK-TABLE.
      *
       000-DETERMINE-STRING-LENGTH.
      *
           MOVE 'N' TO LENGTH-DETERMINED-SW.
           PERFORM 100-EXAMINE-LAST-CHARACTER
               UNTIL LENGTH-DETERMINED.
      *
       000-EXIT.
      *
           EXIT PROGRAM.
      *
       100-EXAMINE-LAST-CHARACTER.
      *
           IF WT-CHARACTER(TEXT-LENGTH) = SPACE
               SUBTRACT 1 FROM TEXT-LENGTH
           ELSE
               MOVE 'Y' TO LENGTH-DETERMINED-SW.
           IF TEXT-LENGTH = 0
               MOVE 'Y' TO LENGTH-DETERMINED-SW.
      *
