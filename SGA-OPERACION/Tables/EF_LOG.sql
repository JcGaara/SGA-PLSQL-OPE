CREATE TABLE OPERACION.EF_LOG
(
  CODEF      NUMBER(8)                          NOT NULL,
  CODCLI     CHAR(8 BYTE),
  COSMO      NUMBER(10,2),
  COSMAT     NUMBER(10,2),
  COSEQU     NUMBER(10,2),
  COSMO_S    NUMBER(10,2),
  COSMAT_S   NUMBER(10,2),
  NUMDIAPLA  NUMBER(3),
  CODPREC    NUMBER(8),
  USUREG     VARCHAR2(50 BYTE)                  DEFAULT USER                  NOT NULL,
  FECREG     DATE                               DEFAULT SYSDATE               NOT NULL
);


