CREATE TABLE OPERACION.EFPTOEQUCMP_STD
(
  IDPAQ        NUMBER(10)                       NOT NULL,
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
  CODETA       NUMBER,
  FLGESTADO    NUMBER                           DEFAULT 1
);

COMMENT ON TABLE OPERACION.EFPTOEQUCMP_STD IS 'Compontes del equipos de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.IDPAQ IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.ORDENCMP IS 'Orden del componente de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.OBSERVACION IS 'OBSERVACION';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.CANTIDAD IS 'Cantidad del componente de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.COSTO IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.TIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.COSTEAR IS 'Valida si se costeo el equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOEQUCMP_STD.FLGESTADO IS 'Estado del equipo';


