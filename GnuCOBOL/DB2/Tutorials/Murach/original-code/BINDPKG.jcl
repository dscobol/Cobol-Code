//MM01P   JOB  (99999),CURTIS.GARVIN,CLASS=C,MSGCLASS=X,
//             REGION=4M,NOTIFY=&SYSUID
//*-------------------------------------------------------------------*
//*   BIND DB2 PACKAGE                                                *
//*-------------------------------------------------------------------*
//BIND    EXEC PGM=IKJEFT01,DYNAMNBR=20,COND=(4,LT)
//DBRMLIB   DD DSN=MM01.DB2.DBRMLIB,DISP=SHR
//SYSTSPRT  DD SYSOUT=*
//SYSPRINT  DD SYSOUT=*
//SYSUDUMP  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//REPORT    DD SYSOUT=*
//SYSIN     DD *
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
