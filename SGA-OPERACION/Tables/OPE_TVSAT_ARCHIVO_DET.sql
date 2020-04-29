CREATE TABLE OPERACION.OPE_TVSAT_ARCHIVO_DET
(
  IDLOTE        NUMBER(10)                      NOT NULL,
  ARCHIVO       VARCHAR2(50 BYTE)               NOT NULL,
  BOUQUET       VARCHAR2(10 BYTE)               NOT NULL,
  SERIE         VARCHAR2(30 BYTE)               NOT NULL,
  ESTADO        VARCHAR2(10 BYTE),
  MENSAJE       VARCHAR2(2000 BYTE),
  FLG_REVISION  NUMBER(1)                       DEFAULT 0,
  USUREG        VARCHAR2(30 BYTE)               DEFAULT USER                  NOT NULL,
  FECREG        DATE                            DEFAULT SYSDATE               NOT NULL,
  USUMOD        VARCHAR2(30 BYTE)               DEFAULT USER                  NOT NULL,
  FECMOD        DATE                            DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_ARCHIVO_DET IS 'Tabla donde se registra la seria de las tarjetas que seran incluidas dentro de cada uno de los archivos a enviar al conax. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de solicitudes al conax.';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.IDLOTE IS 'Identificador del lote';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.ARCHIVO IS 'nombre del archivo';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.BOUQUET IS 'numero del bouquet';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.SERIE IS 'Numero de seria de la tarjeta del deco';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.ESTADO IS 'OK,ERROR';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.MENSAJE IS 'Mensaje descriptivo del error encontrado';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.FLG_REVISION IS '0: No requiere revisión, 1: Requiere revisión';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.USUREG IS 'Usuario que creo el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.FECREG IS 'Fecha creacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.USUMOD IS 'Usuario modificacion del regsitro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_DET.FECMOD IS 'Fecha modificacion del registro';


