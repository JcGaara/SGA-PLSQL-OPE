CREATE TABLE OPERACION.TIPESTAGENDA
(
  TIPESTAGE    NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(30 BYTE),
  FECUSU       DATE                             DEFAULT sysdate,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user
);


