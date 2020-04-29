CREATE TABLE OPERACION.EQUIPOSERIE
(
  COD_SAP              CHAR(18 BYTE),
  NUMSERIE             VARCHAR2(30 BYTE),
  CODSOLOT             NUMBER(8),
  PUNTO                NUMBER(10),
  ORDEN                NUMBER(4),
  USUARIO              VARCHAR2(30 BYTE),
  FECHA_ACTUALIZACION  DATE,
  ESTADO               CHAR(1 BYTE)             DEFAULT '0'                   NOT NULL,
  ALMACEN              CHAR(4 BYTE)
);


