CREATE TABLE OPERACION.SOLOT_ANULA
(
  CODSOLOT        NUMBER(8)                     NOT NULL,
  CODSOLOT_ANULA  NUMBER(8),
  CODMOT          NUMBER(6),
  CODUSU          VARCHAR2(30 BYTE)             DEFAULT user                  NOT NULL,
  FECUSU          DATE                          DEFAULT sysdate               NOT NULL
);


