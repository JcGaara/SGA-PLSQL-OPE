CREATE TABLE OPERACION.PENALIDADES
(
  IDPENALIDAD    NUMBER(8)                      NOT NULL,
  DESCPENALIDAD  VARCHAR2(1000 BYTE)            NOT NULL,
  ACTIVO         NUMBER                         DEFAULT 0,
  COSTO          NUMBER(10,2)                   DEFAULT 0                     NOT NULL,
  MONEDA_ID      NUMBER(10)                     NOT NULL,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT USER,
  FECUSU         DATE                           DEFAULT SYSDATE
);


