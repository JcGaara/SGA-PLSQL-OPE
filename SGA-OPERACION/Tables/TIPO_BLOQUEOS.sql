CREATE TABLE OPERACION.TIPO_BLOQUEOS
(
  IDTIPOBLOQUEO  CHAR(2 BYTE)                   NOT NULL,
  DESCRIPCION    VARCHAR2(100 BYTE),
  ESTADO         NUMBER(1)                      DEFAULT 0                     NOT NULL
);


