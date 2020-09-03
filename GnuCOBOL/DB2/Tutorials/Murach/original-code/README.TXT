
DB2 for the COBOL programmer Part 1

============================================================
Thank you for purchasing DB2 for the COBOL Programmer
Part 1. This README file contains information about the
downloadable files that can be used with this book.

To read this file on screen, use the Page Down and Page Up
keys. To print the file, open it in any Windows word
processing program and choose the Print command from the
File menu.

============================================================
List of the downloaded text files:
============================================================

PROGRAMS   JCL 	      SQL        PROC       CLIST
--------   ---	      ---        ----       -----	
CUSTINQ	   BINDPKG    CUSTOMER   DSNHCOB2   P010CLST
INVREG	   BINDPLN    PLANTBL
NAMEINQ	   COMPILE
P010	   INVREG_J
SALESINQ
STRLEN
SUMINQ
UPDTCUST
UPDTHST1
UPDTHST2
UPDTHST3
UPDTROLL
VNCUPDT

============================================================
Chapter 1 - Introduction to DB2 and embedded SQL
============================================================

Text file	Description
---------	-----------
CUSTINQ		A COBOL program that introduces embedded
		SQL. Table used: CUSTOMER.

============================================================
Chapter 2 - How to retrieve DB2 data from a single table
============================================================

Text file	Description
---------	-----------
SALESINQ	A COBOL program that processes DB2 data	with
		cursors. Tables used: CUSTOMER and INVOICE.

============================================================
Chapter 3 - How to modify DB2 tables
============================================================

Text file	Description
---------	-----------
UPDTCUST	A COBOL program that maintains a DB2 table
		using the UPDATE, DELETE, and INSERT SQL
		statements. Table used: CUSTOMER.

UPDTROLL	An enhanced COBOL program that uses the
		COMMIT and ROLLBACK SQL statements. Table
		used: CUSTOMER.

============================================================
Chapter 4 - How to use unions and joins
============================================================

Text file	Description
---------	-----------
INVREG		A COBOL program that uses an inner join to
		produce a report, or register, that lists
		all the invoices in an invoice table.
		Tables used: CUSTOMER and INVOICE.

============================================================
Chapter 5 - How to use advanced selection conditions
============================================================

Text file	Description
---------	-----------
NAMEINQ		An interactive COBOL program that displays
		customer information for each customer.
		Table used: CUSTOMER.

============================================================
Chapter 6 - How to use column functions
============================================================

Text file	Description
---------	-----------
SUMINQ		A COBOL program that uses column functions.
		Table used: INVOICE.

============================================================
Chapter 7 - How to use the data manipulation features
============================================================

Text file	Description
---------	-----------
none

============================================================
Chapter 8 - How to use variable-length data and nulls
============================================================

Text file	Description
---------	-----------
STRLEN		A COBOL subprogram that determines the
		length of a character string.

VNCUPDT		A COBOL program that updates a table that
		has variable-length data and nulls. Table
		used: VARCUST.

============================================================
Chapter 9 - How to use subqueries
============================================================

Text file	Description
---------	-----------
UPDTHST1	A maintenance COBOL program that moves data
		from three active tables to three history
		tables. Tables used: INVOICE, LINEITEM,
		PAYMENT, INVHIST, LIHIST, PAYHIST, and
		WORKTABLE.

UPDTHST2	An enhanced COBOL program that uses
		referential integrity to maintain DB2
		tables. Tables used: INVOICE, LINEITEM, 
		PAYMENT, INVHIST, LIHIST, PAYHIST, and
		WORKTABLE.  

============================================================
Chapter 10 - How to use the features for error processing
============================================================

Text file	Description
---------	-----------
UPDTHST3	A COBOL	program that uses enhanced error
		processing. Tables used: INVOICE, LINEITEM,
		PAYMENT, INVHIST, LIHIST, PAYHIST, and
		WORKTABLE.

============================================================
Chapter 11 - How to maximize locking efficiency
============================================================

Text file	Description
---------	----------- 
none

============================================================
Chapter 12 - How to use DB2I to prepare and run programs
============================================================

Text file	Description
---------	-----------
P010		A COBOL program that displays an employee's
		payroll	information. Table used: PAYROLL

============================================================
Chapter 13 - How to develop programs outside of DB2I
============================================================
Text file	Description
---------	-----------
BINDPLN		JCL used to bind a plan.

BINDPKG		JCL used to bind a package.

DSNHCOB2	A PROC used to compile and link-edit a DB2
		COBOL program.

COMPILE		JCL used to invoke the DSNHCOB2 PROC and
		bind a package.

P010CLST	A CLIST	to execute the P010 program.

INVREG_J	JCL used to run the INVREG program.

============================================================
Chapter 14 - How to use SPUFI
============================================================

Text file	Description
---------	-----------
CUSTOMER	An SQL statement that can be used in SPUFI
		to create the MM01.CUSTOMER table.

PLANTBL		An SQL statement that can be used in SPUFI
		to create the MM01.PLAN_TABLE.

============================================================
Chapter 15 - How to use QMF to update tables
============================================================

Text file	Description
---------	-----------
none