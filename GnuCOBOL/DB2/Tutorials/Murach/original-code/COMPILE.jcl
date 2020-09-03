//MM01C   JOB  (99999),CURTIS.GARVIN,CLASS=C,MSGCLASS=X,
//             REGION=4M,NOTIFY=&SYSUID
//*-------------------------------------------------------------------*
//* BATCH COBOL2, DB2 AND LINK. PLAN BIND.
//*-------------------------------------------------------------------*
//JOBLIB  DD  DSN=DSN410.SDSNEXIT,DISP=SHR
//        DD  DSN=DSN410.SDSNLOAD,DISP=SHR
//*-------------------------------------------------------------------*
// EXEC DSNHCOB2,MEM=TEMPNAME,USER='MM01',
//   PARM.PC='HOST(COB2),APOST,APOSTSQL,SOURCE,XREF',
//   PARM.COB=('OBJECT,APOST,MAP,XREF,NONUM,OFF,FLAG(I,E),TRUNC(BIN)', X
//             'LIB,RES,DYNAM'),
//   PARM.LKED='LIST,XREF,LET,AMODE=24'
//*-------------------------------------------------------------------*
//PC.DBRMLIB DD DSN=MM01.DB2.DBRMLIB(P010),DISP=SHR
//PC.SYSLIB  DD DSN=MM01.DB2.DCLGENS,DISP=SHR
//PC.SYSIN   DD DSN=MM01.DB2.SOURCE(P010),DISP=SHR
//*-------------------------------------------------------------------*
//COB.SYSLIB DD DSN=MM01.DB2.COPYLIB,DISP=SHR
//*-------------------------------------------------------------------*
//LKED.SYSLMOD DD DSN=MM01.DB2.LOADLIB(P010),DISP=SHR
//*-------------------------------------------------------------------*
//BIND    EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//DBRMLIB   DD DSN=MM01.DB2.DBRMLIB,DISP=SHR
//SYSTSPRT  DD SYSOUT=*
//SYSPRINT  DD SYSOUT=*
//SYSUDUMP  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//REPORT    DD SYSOUT=*
//SYSTSIN   DD *
 DSN SYSTEM(DSN)
 RUN  PROGRAM(DSNTEP2) PLAN(DSNTEP41) LIB('DSN410.RUNLIB.LOAD')
 END
 DSN SYSTEM(DSN)
 BIND PACKAGE   (PYRLCOL)   -
   MEMBER       (P010)      -
   ISOLATION    (CS)        -
   VALIDATE     (BIND)      -
   RELEASE      (COMMIT)    -
   EXPLAIN      (YES)       -
   CURRENTDATA  (NO)        -
   DEGREE       (ANY)       -
   DYNAMICRULES (BIND)      -
   SQLERROR     (NOPACKAGE) -
   ACTION       (REPLACE)   -
   FLAG         (I)         -
   QUALIFIER    (MM01)      -
   OWNER        (MM01)
 END
//
