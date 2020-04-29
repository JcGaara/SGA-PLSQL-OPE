CREATE TABLE OPERACION.MOTIVO_TIPTRABAJO
(
  CODMOTTIP    NUMBER(4)                        NOT NULL,
  TIPTRA       NUMBER(4),
  TIPTRS       NUMBER(2),
  CODMOTOT     NUMBER(3),
  ESTADO       NUMBER                           DEFAULT 1,
  CODUSU       VARCHAR2(50 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate,
  FGL_VALIDO   NUMBER(2)                        DEFAULT 0,
  OBSERVACION  VARCHAR2(1000 BYTE)
);


