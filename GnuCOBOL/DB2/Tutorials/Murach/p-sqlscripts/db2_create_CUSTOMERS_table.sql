connect to MURACH user <userid> using <password>;

DROP TABLESPACE TSCUST;

CREATE TABLESPACE TSCUST
      MANAGED BY AUTOMATIC STORAGE
      USING STOGROUP IBMSTOGROUP;

CREATE TABLE CUSTOMERS (
       CUSTNO            CHAR(6) NOT NULL,
       FNAME             CHAR(20) NOT NULL,
       LNAME             CHAR(30) NOT NULL,
       ADDR              CHAR(30) NOT NULL,
       CITY              CHAR(20) NOT NULL,
       STATE             CHAR(2) NOT NULL,
       ZIPCODE           CHAR(10) NOT NULL,
     CONSTRAINT CUSTNO_PK PRIMARY KEY 
     (CUSTNO)		
	)
	IN TSCUST;

connect reset;
