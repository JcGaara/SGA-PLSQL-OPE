CREATE TABLE OPERACION.OPE_TVSAT_ARCHIVO_CAB
(
  IDLOTE   NUMBER(10)                           NOT NULL,
  ARCHIVO  VARCHAR2(50 BYTE)                    NOT NULL,
  BOUQUET  VARCHAR2(10 BYTE)                    NOT NULL,
  ESTADO   NUMBER(2),
  USUREG   VARCHAR2(30 BYTE)                    DEFAULT USER                  NOT NULL,
  FECREG   DATE                                 DEFAULT SYSDATE               NOT NULL,
  USUMOD   VARCHAR2(30 BYTE)                    DEFAULT USER                  NOT NULL,
  FECMOD   DATE                                 DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_ARCHIVO_CAB IS 'Tabla de cabecera de archivos. Cada archivo corresponde a un bouquete distinto contenido dentro del grupo de solicitudes incluidas en el lote que se esta procesando. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de solicitudes al conax.';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.IDLOTE IS 'Identificador del lote del archivo';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.ARCHIVO IS 'nombre del archivo';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.BOUQUET IS 'numero del bouquete';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.ESTADO IS 'estado del archivo. 1: GENERADO, 2:ENVIADO_CONAX, 3: DEVUELTO CONAX, 4: ERROR';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.USUREG IS 'Usuario que creo el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.FECREG IS 'Fecha de creacion del registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.USUMOD IS 'Usuario de modifico el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_ARCHIVO_CAB.FECMOD IS 'Fecha modificacion del registro';


