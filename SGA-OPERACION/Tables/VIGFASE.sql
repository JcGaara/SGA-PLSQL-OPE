CREATE TABLE OPERACION.VIGFASE
(
  FASE         NUMBER(2)                        NOT NULL,
  DESCRIPCION  VARCHAR2(50 BYTE),
  ESTADO       NUMBER(1),
  ABREV        CHAR(5 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate
);


