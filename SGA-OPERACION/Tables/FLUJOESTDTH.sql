CREATE TABLE OPERACION.FLUJOESTDTH
(
  ESTADOINI  CHAR(2 BYTE)                       NOT NULL,
  ESTADOFIN  CHAR(2 BYTE)                       NOT NULL,
  ACTIVO     NUMBER(1),
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECREG     DATE                               DEFAULT SYSDATE,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECMOD     DATE                               DEFAULT SYSDATE
);


