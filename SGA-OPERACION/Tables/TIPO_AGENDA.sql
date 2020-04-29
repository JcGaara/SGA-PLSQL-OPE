CREATE TABLE OPERACION.TIPO_AGENDA
(
  TIPO_AGENDA  NUMBER(2)                        NOT NULL,
  CLASEAGENDA  NUMBER(2),
  DESCRIPCION  VARCHAR2(50 BYTE),
  ESTADO       NUMBER(1),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate,
  IDFLUJO      NUMBER(3)
);


