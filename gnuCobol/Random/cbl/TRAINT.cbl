      ***********************************************************
      * Program name:    DUMMYPGM
      * Re-written by: David Stagowski 
      *
      * Description: This is a program that will demonstrate the 
      *    difference between GnuCOBOL and IBM Enterprise COBOL.
      * 
      *    If you run this using GnuCOBOL, the result is:
      *    "NUM-C IS 188"
      *
      *    If you run this on the Mainframe, the result is:
      *    "NUM-C IS 100"
      *
      *    This is because in Enterprise COBOL, the receiving field,
      *     NUM-C, determines the truncation or "integer division".
      *
      * Maintenance Log
      * Date       Author        Maintenance Requirement
      * ---------  ------------  --------------------------------
      * 2020-08-16 dastagg       Created to learn.
      *
      **********************************************************
       ID DIVISION.
       PROGRAM-ID. DUMMYPGM.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NUM-A PIC 9(3) VALUE 399.
       01 NUM-B PIC 9(3) VALUE 211.
       01 NUM-C PIC 9(3).
      *
       PROCEDURE DIVISION.
       MAIN.
           COMPUTE NUM-C = ((NUM-A / 100) - (NUM-B / 100)) * 100
           DISPLAY 'NUM-C IS ' NUM-C
           STOP RUN.
