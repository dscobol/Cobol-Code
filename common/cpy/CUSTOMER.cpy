      ***********************************************************
      * Copybook name: CUSTOMER
      * Original author: David Stagowski
      *
      * Description: A copybook for the CUSTOMER file.
      *
      * Typical Use: Within the Working-Storage Section:
      *
      *    COPY customer replacing ==:tag:== with ==XX==. 
      *        where "XX" would be whatever you need it to be.
      *
      *
      * Maintenence Log
      * Date       Author        Maintenance Requirement
      * ---------- ------------  --------------------------------
      * 2020-08-11 dastagg       Created to Learn
      *
      **********************************************************
       01  :tag:-Customer-Record.  
           12 :tag:-Cust-ID             PIC 9(004).    
           12 :tag:-Cust-First-Name     PIC X(012).         
           12 :tag:-Cust-Last-Name      PIC X(021).
           12 :tag:-Cust-Address        PIC X(029).   
           12 :tag:-Cust-City           PIC X(025).
           12 :tag:-Cust-State          PIC X(020).
           12 :tag:-Cust-Postal-Code    PIC X(005).
           12 :tag:-Cust-CCard          PIC X(025).
           12 :tag:-Cust-Product        PIC X(011).
           12 :tag:-Cust-Price          PIC 9(3)V99.
