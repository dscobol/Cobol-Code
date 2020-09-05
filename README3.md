Status of Programs:

['Beginning COBOL for Programmers' by Michael Coughlan](http://www.apress.com/9781430262534) :

| Program | Description                               | GnuCOBOL |  ZOS  |
| :------ | :---------------------------------------- | :------: | :---: |
|         |                                           |          |       |
| HELLO   | First Program                             |    X     |   X   |
| BDS0702 | Listing7-1 - Read a file                  |    X     |   X   |
| BDS0704 | Listing7-2 - Read a file                  |    X     |   X   |
| BDS0801 | Listing8-1 - Heading Record               |    X     |   X   |
| BDS0802 | Listing8-2 - Footer Record                |    X     |   X   |
| BDS0803 | Listing8-3 - Print Report                 |    X     |   X   |
| BDS0804 | Listing8-4 - Variable Length              |    X     |       |
| BDS0805 | Listing8-5 - Summmary Report              |          |       |
| BDS1001 | Listing10-1 - Control Break - 3 levels    |    X     |   X   |
| BDS1002 | Listing10-2 - Control Break - 2 levels    |    X     |   X   |
| BDS1003 | Listing10-3 - File Update                 |    X     |   X   |
| BDS1004 | Listing10-4 - Full File Update - ver 1    |    X     |   X   |
| BDS1005 | Listing10-5 - Full File Update - full ver |          |       |
| BDS1101 | Listing11-1 - Tabular data report         |          |       |
| BDS1102 | Listing11-2 - Tab data report - sum, avg  |          |       |
| BDS1103 | Listing11-3 - 2-Dimensional Table         |          |       |
| BDS1104 | Listing11-4 - 3 Control Breaks            |          |       |

['DB2 for the COBOL Programmer - Part 1' by Curtis Garvin and Steve Eckols](https://www.murach.com/shop/db2-for-the-cobol-programmer-2c-part-1-detail) :

**Note**: These will only be run using GnuCOBOL and IBM DB2 for Linux, UNIX and Windows.

| Program | Description                                    | GnuCOBOL |
| :------ | :--------------------------------------------- | :------: |
|         |                                                |          |
| CUSTINQ   | A COBOL program that introduces embedded SQL.|    X     |
| SALESINQ | A COBOL program that processes DB2 data with cursors. |    X     |
| UPDTCUST | A COBOL program that maintains a DB2 table using the UPDATE, DELETE, and INSERT SQL statements.|          |
| UPDTROLL | An enhanced COBOL program that uses the COMMIT and ROLLBACK SQL statements.|          |
| INVREG | A COBOL program that uses an inner join to produce a report, or register, that lists all the invoices in an invoice table.|    X     |
| NAMEINQ | An interactive COBOL program that displays customer information for each customer.|          |
| SUMINQ | A COBOL program that uses column functions.|          |
| STRLEN | A COBOL subprogram that determines the length of a character string|          |
| VNCUPDT | A COBOL program that updates a table that has variable-length data and nulls.|          |
| UPDTHST1 | A maintenance COBOL program that moves data from three active tables to three history tables.|          |
| UPDTHST2 | An enhanced COBOL program that uses referential integrity to maintain DB2 tables.|          |
| UPDTHST3 | A COBOL	program that uses enhanced error processing. |          |


[The Open Mainframe Project](https://www.openmainframeproject.org/projects/coboltrainingcourse) :

NOTE: Change in plan.

Most of the CBLXXXX programs are fairly straight forward.

I think my time would be better spent on more "advanced" topics like Tables, VSAM and DB2.

I did convert CBL0001 to my "style" and by creating ODS000C, learned a few things.
  * Converting COMP numbers to normal to be usable by GnuCOBOL.
  * Using MOVE CORRESPONDING - Not something I normally do but it worked well for this.

| Program | Description   | GnuCOBOL |  ZOS  |
| :------ | :------------ | :------: | :---: |
|         |               |          |       |
| HELLO   | First Program |    X     |   X   |
| ODS0001 | CBL0001       |    X     |   X   |
| ODS0106 | CBL0106       |          |   X   |
