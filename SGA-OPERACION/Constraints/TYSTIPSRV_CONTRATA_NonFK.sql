ALTER TABLE OPERACION.TYSTIPSRV_CONTRATA ADD (
  CONSTRAINT PK_TYSTIPSRV_CONTRATA
 PRIMARY KEY
 (IDTC),
  CONSTRAINT U_TYSTIPSRV_CONTRATA
 UNIQUE (CODCON, TIPSRV));
