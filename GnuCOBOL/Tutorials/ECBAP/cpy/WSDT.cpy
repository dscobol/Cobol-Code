      ***********************************************************
      * Copybook name: WSDT
      * Original author: David Stagowski
      *
      * Description: A copybook to capture the current date and time.
      *
      * Typical Use:
      * Within the Working-Storage Section:
      * Create 01:
      *01  CURRENT-DATE-AND-TIME.
      *    COPY WSDT REPLACING ==:tag:== BY ==CDT==.
      *
      * Then within the Procedure Division:
      *    MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME.
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-11 dastagg       Created to Learn
      *
      **********************************************************
           12 :tag:-Full-Date           PIC 9(8).
           12 :tag:-Date-Sep REDEFINES :tag:-Full-Date.
              15 :tag:-Year             PIC 9(4).
              15 :tag:-Month            PIC 9(2).
              15 :tag:-Day              PIC 9(2).
           12 :tag:-Full-Time           PIC 9(8).
           12 :tag:-Time-Sep REDEFINES :tag:-Full-Time.
              15 :tag:-Hour                PIC 9(2).
              15 :tag:-Minutes             PIC 9(2).
              15 :tag:-Seconds             PIC 9(2).
              15 :tag:-Hundredths-Of-Secs  PIC 9(2).
           12 :tag:-GMT-Diff-Hours      PIC S9(2)
                                      SIGN LEADING SEPARATE.
           12 :tag:-GMT-Diff-Minutes    PIC 9(2).
