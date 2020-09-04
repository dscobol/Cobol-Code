## Notes for creating the database, tables and applications.

Because there are tables used in this book that
have the same names as the Sample DB, I decided 
to create a new Database and call it murach.

Currently, I am running: IBM Db2 for Linux, UNIX and Windows v11.1
on a Windows 10 PC.

Create a new Database.
- Opened the **DB2 Command Window - Administrator** terminal window from the Windows Start Menu.
- Typed "db2" at the prompt.
- This got me "into the system".
- At the db2> prompt, typed "CREATE DATABASE murach" and hit Enter.

Waited a bit of time and it came back with "successfully created database"

Opened PyCharm. (This only works with the Pro version)
- Created new database connection for DB2 LUW:
    - Type4
    - localhost, 50000
    - MURACH as the database.

And was connected to the Murach DB.

Ran the "create table" sql for CUSTOMERS.

In PyCharm, had to go to the Schemas tab of the datasource Properties, check the checkbox next to  "DASTAGG" to select it as a viewable Schema, then I was able to see the table.
