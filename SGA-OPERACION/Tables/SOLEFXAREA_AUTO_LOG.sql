CREATE TABLE OPERACION.SOLEFXAREA_AUTO_LOG
(
  USULOG         VARCHAR2(50 BYTE)              DEFAULT USER                  NOT NULL,
  FECLOG         DATE                           DEFAULT SYSDATE               NOT NULL,
  ACCLOG         CHAR(1 BYTE)                   NOT NULL,
  CODEF          NUMBER(8)                      NOT NULL,
  AREA           NUMBER(4)                      NOT NULL,
  NUMSLC         CHAR(10 BYTE),
  ESTSOLEF       NUMBER(2),
  ESRESPONSABLE  NUMBER(1)
);


