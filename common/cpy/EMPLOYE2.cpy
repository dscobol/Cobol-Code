      ***********************************************************
      * Copybook name: EMPLOYE2
      * Original author: David Stagowski
      *
      * Description: A copybook for the EMPLOYE2 file.
      *    This is for the flat file to load the EMPLOYEE2 Table.
      *
      * Typical Use: Within the Working-Storage Section:
      *
      *    COPY EMPLOYEE replacing ==:tag:== with ==XX==. 
      *        where "XX" would be whatever you need it to be.
      *
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-11 dastagg       Created to Learn
      *
      **********************************************************
       01  :tag:-Employee-Record.  
           12 :tag:-Emp-Number           PIC X(06).
           12 FILLER                     PIC X(01).
           12 :tag:-First-Name           PIC X(09).
           12 FILLER                     PIC X(01).
           12 :tag:-Middle-Init          PIC X(01).
           12 FILLER                     PIC X(01).
           12 :tag:-Last-Name            PIC X(10).
           12 FILLER                     PIC X(01).
           12 :tag:-Work-Dept            PIC X(03).
           12 FILLER                     PIC X(01).
           12 :tag:-Phone-Number         PIC X(04).
           12 FILLER                     PIC X(01).
           12 :tag:-Hire-Date            PIC X(10).
           12 FILLER                     PIC X(01).
           12 :tag:-Job-Title            PIC X(08).
           12 FILLER                     PIC X(01).
           12 :tag:-Edu-Level            PIC 9(02).
           12 FILLER                     PIC X(01).
           12 :tag:-Gender               PIC X(01).
           12 FILLER                     PIC X(01).
           12 :tag:-Birth-Date           PIC x(10).
           12 FILLER                     PIC X(01).
           12 :tag:-Salary               PIC X(08).
           12 FILLER                     PIC X(01).
           12 :tag:-Bonus                PIC X(06).
           12 FILLER                     PIC X(02).
           12 :tag:-Commission           PIC X(07).
