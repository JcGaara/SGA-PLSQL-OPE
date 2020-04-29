CREATE TABLE OPERACION.XX_CARGA_INVENTARIO
(
  SITE               VARCHAR2(300 BYTE),
  AMBIENTE           VARCHAR2(300 BYTE),
  EQUIPO             VARCHAR2(300 BYTE),
  TARJETA            VARCHAR2(200 BYTE),
  NUMSLC_CRE         VARCHAR2(10 BYTE),
  SLOT               VARCHAR2(10 BYTE),
  PUERTO             VARCHAR2(30 BYTE),
  ESTADO_PUERTO      VARCHAR2(30 BYTE),
  BW                 NUMBER,
  BWOPERACIONES      NUMBER,
  IDE                NUMBER,
  CID                NUMBER,
  PRODUCTO           VARCHAR2(200 BYTE),
  NOMCLI             VARCHAR2(1000 BYTE),
  FAMILIA_SERVICIO   VARCHAR2(300 BYTE),
  SERVICIO           VARCHAR2(300 BYTE),
  ESTADO_SERVICIO    VARCHAR2(100 BYTE),
  SEDE               VARCHAR2(1000 BYTE),
  DIRECCION          VARCHAR2(2000 BYTE),
  DATOS_CID          VARCHAR2(2000 BYTE),
  DATOS_IDE          VARCHAR2(2000 BYTE),
  FECASIG            VARCHAR2(30 BYTE),
  FECINST            VARCHAR2(30 BYTE),
  PROVEEDOR_ENLACE   VARCHAR2(200 BYTE),
  MEDIO_TRANSMISION  VARCHAR2(100 BYTE),
  PLATAFORMA         VARCHAR2(1 BYTE),
  IDPLATAFORMA       NUMBER
);


