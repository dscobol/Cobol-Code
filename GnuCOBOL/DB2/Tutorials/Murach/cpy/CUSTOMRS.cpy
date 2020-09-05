      ***********************************************************
      * Copybook name: CUSTOMRS
      * Original author: David Stagowski
      *
      * Description: A copybook for the CUSTOMRS VSAM file.
      *    This is a version created to be used for the Murach
      *    DB2 for COBOL Programmers book.
      *
      *    This will be used to load a text file into an indexed file
      *    which will then be used to update the CUSTOMERS table.
      *
      * Typical Use: Within the Working-Storage Section:
      *
      *    COPY CUSTOMRS replacing ==:tag:== with ==XX==. 
      *        where "XX" would be whatever you need it to be.
      *
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-09-05 dastagg       Created to Learn
      *
      **********************************************************
           12 :tag:-Cust-Trans-Code     PIC X(001).
           12 :tag:-Customer-Record.    
              15 :tag:-Cust-Number         PIC X(006).    
              15 :tag:-Cust-First-Name     PIC X(020).         
              15 :tag:-Cust-Last-Name      PIC X(030).
              15 :tag:-Cust-Address        PIC X(030).   
              15 :tag:-Cust-City           PIC X(020).
              15 :tag:-Cust-State          PIC X(002).
              15 :tag:-Cust-ZipCode        PIC X(010).
