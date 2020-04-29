CREATE TABLE OPERACION.EFPTOEQUCMP
(
  CODEF        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  ORDENCMP     NUMBER(4)                        NOT NULL,
  OBSERVACION  VARCHAR2(200 BYTE),
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  CODTIPEQU    CHAR(15 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  COSTO        NUMBER(10,2)                     DEFAULT 0,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  COSTEAR      NUMBER(1)                        DEFAULT 1                     NOT NULL,
  CODETA       NUMBER
);

COMMENT ON TABLE OPERACION.EFPTOEQUCMP IS 'Compontes del equipos de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.ORDENCMP IS 'Orden del componente de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.OBSERVACION IS 'OBSERVACION';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.CANTIDAD IS 'Cantidad del componente de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.COSTO IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP.COSTEAR IS 'Valida si se costeo el equipo';


