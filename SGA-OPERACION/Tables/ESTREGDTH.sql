CREATE TABLE OPERACION.ESTREGDTH
(
  CODESTDTH   CHAR(2 BYTE)                      NOT NULL,
  DSCESTDTH   VARCHAR2(50 BYTE),
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT USER,
  FECREG      DATE                              DEFAULT SYSDATE,
  TIPOESTADO  NUMBER(1),
  ACTIVO      NUMBER(1)                         DEFAULT 1,
  USUMOD      VARCHAR2(30 BYTE)                 DEFAULT USER,
  FECMOD      DATE                              DEFAULT SYSDATE
);


