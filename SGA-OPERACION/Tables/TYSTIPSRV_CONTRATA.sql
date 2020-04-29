CREATE TABLE OPERACION.TYSTIPSRV_CONTRATA
(
  IDTC    NUMBER(6),
  CODCON  NUMBER(6),
  TIPSRV  CHAR(4 BYTE),
  FECUSU  DATE                                  DEFAULT sysdate,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user
);


