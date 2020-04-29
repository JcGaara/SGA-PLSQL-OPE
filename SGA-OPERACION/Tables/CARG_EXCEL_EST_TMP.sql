-- Create table
create global temporary table OPERACION.CARG_EXCEL_EST_TMP
(
  PUNTO           VARCHAR2(100),
  CODETA          VARCHAR2(100),
  ORDEN           VARCHAR2(30),
  CODTIPEQU       VARCHAR2(100),
  TIPPRP          VARCHAR2(100),
  OBSERVCION      VARCHAR2(200),
  COSTEAR         VARCHAR2(100),
  CANTIDAD        VARCHAR2(30),
  CODEQUCOM       VARCHAR2(200),
  COD_SAP         VARCHAR2(100),
  PROPIETARIO     VARCHAR2(30),
  NRO_FILAS       NUMBER,
  CODEF           NUMBER,
  COD_RUBRO       NUMBER,
  ID_PROY_CONTROL NUMBER
)
on commit preserve rows;