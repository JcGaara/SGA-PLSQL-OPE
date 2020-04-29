CREATE TABLE OPERACION.SOLEFXAREA_LOG
(
  ID_LOG       NUMBER(8)                        NOT NULL,
  CODEF        NUMBER(8)                        NOT NULL,
  AREA         NUMBER(4)                        NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  NUMDIAPLA    NUMBER(3),
  OBSERVACION  VARCHAR2(4000 BYTE),
  FECUSU       DATE                             DEFAULT sysdate               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECAPR       DATE,
  NUMDIAVAL    NUMBER(3)
);


