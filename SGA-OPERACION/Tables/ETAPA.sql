CREATE TABLE OPERACION.ETAPA
(
  CODETA                   NUMBER(5)            NOT NULL,
  CODDPT                   CHAR(6 BYTE),
  DESCRIPCION              VARCHAR2(100 BYTE)   NOT NULL,
  ABREVI                   VARCHAR2(20 BYTE)    NOT NULL,
  PORCOSMOCLI              NUMBER(8,2)          DEFAULT 0                     NOT NULL,
  PORCOSMATCLI             NUMBER(8,2)          DEFAULT 0                     NOT NULL,
  ORDEN                    NUMBER(3)            DEFAULT 0                     NOT NULL,
  FECUSU                   DATE                 DEFAULT SYSDATE               NOT NULL,
  CODUSU                   VARCHAR2(30 BYTE)    DEFAULT user                  NOT NULL,
  FLG_ASIGNAR              NUMBER(2)            DEFAULT 1                     NOT NULL,
  ESTADO                   NUMBER(1)            DEFAULT 1                     NOT NULL,
  TIPO                     VARCHAR2(1 BYTE),
  FLG_MANO_OBRA            NUMBER,
  AREA_ETA                 VARCHAR2(1 BYTE),
  FLG_VENTA                VARCHAR2(1 BYTE),
  FLG_SERVICIO_COTIZACION  VARCHAR2(1 BYTE),
  CODSRVSAPOLD             NUMBER,
  CODSAP_MIG               VARCHAR2(18 BYTE),
  CODSRVSAP                VARCHAR2(18 BYTE)
);

COMMENT ON TABLE OPERACION.ETAPA IS 'Listado de etapas';

COMMENT ON COLUMN OPERACION.ETAPA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.ETAPA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.ETAPA.DESCRIPCION IS 'Descripcion de la etapa';

COMMENT ON COLUMN OPERACION.ETAPA.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.ETAPA.PORCOSMOCLI IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.ETAPA.PORCOSMATCLI IS 'No se utiliza';

COMMENT ON COLUMN OPERACION.ETAPA.ORDEN IS 'ORDEN';

COMMENT ON COLUMN OPERACION.ETAPA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ETAPA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ETAPA.FLG_SERVICIO_COTIZACION IS 'Flag servicio de mano de obra por cotizacion';


