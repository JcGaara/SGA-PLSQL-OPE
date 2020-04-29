CREATE TABLE OPERACION.PREUBI_POS
(
  CODSOLOT  NUMBER(8)                           NOT NULL,
  PUNTO     NUMBER(10)                          NOT NULL,
  ORDEN     NUMBER(3)                           NOT NULL,
  TIPO      NUMBER(2),
  FECPOS    DATE,
  MOTIVO    VARCHAR2(100 BYTE),
  FECTEN    DATE,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user,
  FECUSU    DATE                                DEFAULT sysdate
);


