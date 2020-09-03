//MM01R   JOB  (99999),'CURTIS GARVIN',CLASS=C,MSGCLASS=X,
//             REGION=4M,NOTIFY=&SYSUID
//*-------------------------------------------------------------------*
//* BATCH JOB TO RUN A DB2 PROGRAM.
//*-------------------------------------------------------------------*
//JOBLIB  DD  DISP=SHR,DSN=DSN410.SDSNEXIT
//        DD  DISP=SHR,DSN=DSN410.SDSNLOAD
//*-------------------------------------------------------------------*
//DEL1    EXEC PGM=IEFBR14
//DD1       DD DSN=MM01.PRTOUT.FILE,DISP=(MOD,DELETE,DELETE),
//             UNIT=SYSDA,SPACE=(TRK,(0))
//*-------------------------------------------------------------------*
//RUN     EXEC PGM=IKJEFT1B,DYNAMNBR=20
//STEPLIB   DD DSN=MM01.DB2.LOADLIB,DISP=SHR
//PRTOUT    DD DSN=MM01.PRTOUT.FILE,DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,VOL=SER=LIB788,SPACE=(TRK,(1,1)),
//             DCB=(RECFM=FBA,LRECL=133,BLKSIZE=133)
//SYSTSPRT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSTSIN   DD *
DSN SYSTEM(DSN)
 RUN  PROGRAM(INVREG) PLAN(MM01PLAN) LIB('MM01.DB2.LOADLIB')
 END
/*
