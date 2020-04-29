CREATE TABLE OPERACION.PQT_EQU_SEQUENCE
(
  IDPAQ        NUMBER(10)                       NOT NULL,
  CODSEQUENCE  NUMBER(4)                        NOT NULL,
  TIPCAMB      NUMBER(4),
  PUNTO        NUMBER(10),
  CODETA       NUMBER,
  OBSERVACION  VARCHAR2(200 BYTE),
  TIPEQU       NUMBER(6),
  TIPEQUCOM    NUMBER(6),
  COSTO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);


