CREATE TABLE OPERACION.SOLOTPTOETAPER_DET
(
  CODPERMISO  NUMBER(10)                        NOT NULL,
  TIPFEC      NUMBER(2)                         NOT NULL,
  FECINI      DATE,
  FECFIN      DATE,
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user,
  FECUSU      DATE                              DEFAULT sysdate
);


