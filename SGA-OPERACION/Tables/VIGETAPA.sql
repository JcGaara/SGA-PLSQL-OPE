CREATE TABLE OPERACION.VIGETAPA
(
  IDETAPA      NUMBER(4)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  TABLA        VARCHAR2(100 BYTE),
  ACTIVO       NUMBER(2),
  DURACION     NUMBER(4),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user,
  FECUSU       DATE                             DEFAULT sysdate
);


