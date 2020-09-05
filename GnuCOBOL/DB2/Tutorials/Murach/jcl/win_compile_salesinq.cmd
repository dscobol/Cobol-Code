@echo off
setlocal

::set LLM=GETDBID
:: set Program name
set PGM=SALESINQ

:: set copybook locations
rem To me, this looks ugly but I wanted to avoid hardcoding the
rem location of the cpy directory on my PC. It works.
set "CURRDIR=%cd%"
cd ..\cpy
set "MYCOPY=%cd%"
cd %CURRDIR%

set SQLCOPY=C:\IBM\SQLLIB\include\cobol_mf

:: set env. variables
call "C:\GC31-rc1-BDB-M64\bin\cobenv.cmd"
set COBCPY=%SQLCOPY%;%MYCOPY%
set LOADLIB=c:\IBM\SQLLIB\lib

:: del ..\bin\%LLM%.dll    2>NUL
:: delete old files (ignoring errors)
del ..\cbl\%PGM%.bnd    2>NUL
del ..\tcbl\%PGM%.cbl   2>NUL
del ..\bin\%PGM%.exe    2>NUL

:: db2cmd -i -w -c db2 [command line parameters]
:: -i : don't open a new console, share the existing console and stdin, stdout handles
:: -c : run the specified command (db2 etc.) and terminate
:: -w : wait until the spawned command process ends

db2cmd -i -w -c db2 -tvf ..\sql\%PGM%.sql

echo Press any key to continue...
pause

:: compile
:: cobc -o ..\bin\%LLM%.dll ..\tcbl\%LLM%.cbl
cobc -x -std=mf -o ..\bin\%PGM% ..\tcbl\%PGM%.cbl -L %LOADLIB% -l db2api

endlocal
