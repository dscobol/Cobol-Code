      ***********************************************************
      * Program name:    BDS0704
      * Original author: Michael Coughlan
      *    from the book: "BEGINNING COBOL FOR Programers"
      * Re-written by: David Stagowski 
      *
      * Description: Program to read a file.
      *    This version will read a file and display some info.
      * Chapter 7: Listing7-4
      * I have added a basic structure and ERROR checking.
      *
      *
      * Maintenance Log
      * Date       Author        Maintenance Requirement
      * ---------  ------------  --------------------------------
      * 2020-08-16 dastagg       Created to learn.
      *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID.  BDS0704.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT GadgetStockFile
           ASSIGN TO "../data/c07-gadgets.dat.txt"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-Gadget-Status.

       DATA DIVISION.
       FILE SECTION.
       FD GadgetStockFile.
       01  StockRec.
           02 GadgetID         PIC 9(6).
           02 GadgetName       PIC X(30).
           02 QtyInStock       PIC 9(4).
           02 Price            PIC 9(4)V99.

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           COPY WSFST REPLACING ==:tag:== BY ==Gadget==.

       01  PrnStockValue.
           02 PrnGadgetName      PIC X(30).
           02 FILLER             PIC XX VALUE SPACES.
           02 PrnValue           PIC $$$,$$9.99.

       01  PrnFinalStockTotal.
           02 FILLER              PIC X(16) VALUE SPACES.
           02 FILLER              PIC X(16) VALUE "Stock Total:".
           02 PrnFinalTotal       PIC $$$,$$9.99.

       01 FinalStockTotal        PIC 9(6)V99.
       01 StockValue             PIC 9(6)V99.


       PROCEDURE DIVISION.
       0000-Mainline.
           PERFORM 1000-Begin-Job.
           PERFORM 2000-Process.
           PERFORM 3000-End-Job.
           GOBACK.

       1000-Begin-Job.
           OPEN INPUT GadgetStockFile.
           READ GadgetStockFile
              AT END SET WS-Gadget-EOF TO TRUE
           END-READ.

       2000-Process.
           PERFORM 5010-DisplayGadgetValues UNTIL WS-Gadget-EOF
           MOVE FinalStockTotal TO PrnFinalTotal.
           DISPLAY PrnFinalStockTotal.

       3000-End-Job.
           CLOSE GadgetStockFile.


       5010-DisplayGadgetValues.
           COMPUTE StockValue = Price * QtyInStock
           ADD StockValue  TO FinalStockTotal
           MOVE GadgetName TO PrnGadgetName
           MOVE StockValue TO PrnValue
           DISPLAY PrnStockValue
           READ GadgetStockFile
                AT END SET WS-Gadget-EOF TO TRUE
           END-READ.
