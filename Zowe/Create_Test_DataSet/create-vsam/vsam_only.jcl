//Z81187V   JOB 1,NOTIFY=&SYSUID,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=144M
//* This JCL will delete and create the file, no data.
//* Reminder: Within the SYSIN def: 
//*           only &SYSUID, 
//*  no other symbolics. Dont use &HLQ
//S1   EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *,SYMBOLS=CNVTSYS
  DELETE &SYSUID..TEST.VCUST
  SET MAXCC=0
  DEFINE CLUSTER ( NAME ( &SYSUID..TEST.VCUST ) -
            VOLUME(VPWRKB) TRACKS(15) RECORDSIZE(157,157) -
            INDEXED KEYS(4 0) -
            REUSE SHAREOPTIONS(2) SPANNED SPEED -
            CONTROLINTERVALSIZE(4096) )
//* End of job
