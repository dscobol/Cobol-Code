## A short guide to what you are looking at.

I have a certain structure on my computer.

For batch programs:
```
├───Indexed
│   ├───bin
│   ├───cbl
│   ├───cpy
│   ├───data
│   ├───idata
│   ├───jcl
│   ├───spool
│   └───tcbl
├───Internal-Sort
│   ├───bin
│   ├───cbl
│   ├───cpy
│   ├───data
│   ├───jcl
│   ├───spool
│   └───tcbl

For DB2:

Basic
│   ├───bin
│   ├───cbl
│   ├───cpy
│   ├───data
│   ├───docs
│   ├───jcl
│   ├───p-sqlscripts
│   ├───spool
│   ├───sql
│   ├───SQLScripts
│   └───tcbl


```
In all structures:

- bin: the executables
- cbl: the COBOL source code
- cpy: the copybooks
- data: the data for the programs
- jcl: the scripts used to compile and run
- spool: the printed output
- tcbl: temporary COBOL output
  
For the Indexed directory:
- idata: not public: indexed datafiles 

For the DB2 directories:
- docs: examples of the files needed to run the programs but are not public
- p-sqlscripts: public: versions of SQL DDL code
- sql: not public: the sql code to prep and bind the COBOL programs
- SQLScripts: not public: versions of the SQL DDL code.

AND for DB2 programs, there is a cmd file in jcl to compile and a different one in bin to run it.

### Why don't I see them?
Only the following directories are pushed to GitHub:

cbl, cpy, data, docs, jcl, and p-sqlscripts.

The others are not public because they are either binary, temporary or they contain usernames and passwords. For examples of some of these, look in the docs directory.
