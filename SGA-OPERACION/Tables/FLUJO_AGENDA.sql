CREATE TABLE OPERACION.FLUJO_AGENDA
(
  IDFLUJO      NUMBER(3)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  ACTIVO       NUMBER(1)                        DEFAULT 0,
  FECUSU       DATE                             DEFAULT sysdate,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user
);


