CREATE TABLE OPERACION.MIGRACION_CDMA_NUMEROS
(
  NUMERO      VARCHAR2(40 BYTE),
  AREA        VARCHAR2(40 BYTE),
  ESTADO      VARCHAR2(40 BYTE),
  TIPO        VARCHAR2(40 BYTE),
  ESTADO_REG  NUMBER(1)                         DEFAULT 0,
  MENSAJE     VARCHAR2(4000 BYTE)
);


