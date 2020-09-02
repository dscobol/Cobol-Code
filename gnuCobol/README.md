## A short guide to what you are looking at.

I have a certain structure on my computer.

For batch programs:
```
├───data
├───Indexed
│   ├───bin
│   ├───cbl
│   ├───data
│   ├───jcl
│   ├───spool
│   └───tcbl
├───Internal-Sort
│   ├───bin
│   ├───cbl
│   ├───jcl
│   ├───spool
│   └───tcbl

For DB2:

Basic
│   ├───bin
│   ├───cbl
│   ├───docs
│   ├───jcl
│   ├───spool
│   ├───sql
│   ├───SQLScripts
│   └───tcbl


```
In all structures:

- bin: the executables
- cbl: the COBOL source code
- jcl: the scripts used to compile and run
- spool: the printed output
- tcbl: temporary COBOL output

For the DB2 directories, there is also a sql,
docs and SQLScripts. AND for DB2 programs, there is a cmd file in jcl to compile and a different one in bin to run it.

There are "sample" examples of the sql file, the run cmd file and the called module GETDBID in the docs directory.

### Why don't I see them?
Only the following directories are pushed to GitHub:
common/cpy, data, cbl, jcl and docs.

The others are not because they are either binary, temporary or they contain usernames and passwords.

For the Indexed programs, there is a special data directory just for the indexed datafiles, this is also not pushed. It's binary.