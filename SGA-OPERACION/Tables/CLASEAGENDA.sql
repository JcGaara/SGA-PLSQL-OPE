CREATE TABLE OPERACION.CLASEAGENDA
(
  CLASEAGENDA  NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(50 BYTE),
  ESTADO       NUMBER(1)                        DEFAULT 1,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate
);


