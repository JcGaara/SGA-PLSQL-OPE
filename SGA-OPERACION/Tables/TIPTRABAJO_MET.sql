CREATE TABLE OPERACION.TIPTRABAJO_MET
(
  TIPTRA  NUMBER(4)                             NOT NULL,
  CODSRV  CHAR(4 BYTE)                          NOT NULL,
  ESTADO  NUMBER(2)                             DEFAULT 1,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL
);


