CREATE TABLE OPERACION.SOLOTPTOETA_POS
(
  CODSOLOT  NUMBER(8)                           NOT NULL,
  PUNTO     NUMBER(10)                          NOT NULL,
  ORDEN     NUMBER(4)                           NOT NULL,
  ORDENCMP  NUMBER(4),
  TIPO      NUMBER(2),
  FECPOS    DATE,
  MOTIVO    VARCHAR2(100 BYTE),
  FECTEN    DATE,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user,
  FECUSU    DATE                                DEFAULT sysdate
);


