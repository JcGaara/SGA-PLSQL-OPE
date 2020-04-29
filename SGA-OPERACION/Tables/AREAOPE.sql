CREATE TABLE OPERACION.AREAOPE
(
  AREA           NUMBER(4)                      NOT NULL,
  DESCRIPCION    VARCHAR2(100 BYTE),
  FLGDERPRV      NUMBER(1)                      DEFAULT 0                     NOT NULL,
  ESTADO         NUMBER(1)                      DEFAULT 1                     NOT NULL,
  CODDPT         CHAR(6 BYTE),
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FECUSU         DATE                           DEFAULT SYSDATE               NOT NULL,
  FLGCC          NUMBER(1)                      DEFAULT 0,
  DESCABR        VARCHAR2(30 BYTE),
  CADCAMPOS      VARCHAR2(35 BYTE),
  CADCAMPOS1     VARCHAR2(55 BYTE),
  AREA_OF_REQ    VARCHAR2(100 BYTE),
  AREA_OF_OPERA  CHAR(3 BYTE),
  CECO_SAP       VARCHAR2(10 BYTE),
  EMPRESA        NUMBER,
  CONTRATA       NUMBER                         DEFAULT 0
);

COMMENT ON TABLE OPERACION.AREAOPE IS 'Listado de areas de operaciones';

COMMENT ON COLUMN OPERACION.AREAOPE.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.AREAOPE.DESCRIPCION IS 'Descripcion del area';

COMMENT ON COLUMN OPERACION.AREAOPE.FLGDERPRV IS 'Indica si la area puede ser derivado';

COMMENT ON COLUMN OPERACION.AREAOPE.ESTADO IS 'Estado del area (1=activo, 0=inactivo)';

COMMENT ON COLUMN OPERACION.AREAOPE.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.AREAOPE.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.AREAOPE.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.AREAOPE.FLGCC IS 'Indica si la area del control de cambio';

COMMENT ON COLUMN OPERACION.AREAOPE.DESCABR IS 'Descripcion abreviada';

COMMENT ON COLUMN OPERACION.AREAOPE.CADCAMPOS IS 'Observacion 1';

COMMENT ON COLUMN OPERACION.AREAOPE.CADCAMPOS1 IS 'Observacion 2';

COMMENT ON COLUMN OPERACION.AREAOPE.CONTRATA IS 'Indica si el Grupo de Trabajo es Contrata';


