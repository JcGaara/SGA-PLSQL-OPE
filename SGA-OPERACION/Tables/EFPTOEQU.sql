CREATE TABLE OPERACION.EFPTOEQU
(
  CODEF        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(4)                        NOT NULL,
  CODTIPEQU    CHAR(15 BYTE),
  TIPPRP       NUMBER(2)                        NOT NULL,
  OBSERVACION  VARCHAR2(200 BYTE),
  COSTEAR      NUMBER(1)                        DEFAULT 1                     NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 1                     NOT NULL,
  COSTO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  CODEQUCOM    CHAR(4 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  TIPEQU       NUMBER(6)                        NOT NULL,
  CODETA       NUMBER
);

COMMENT ON TABLE OPERACION.EFPTOEQU IS 'Equipos de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQU.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQU.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQU.ORDEN IS 'Orden del equipo en el punto ';

COMMENT ON COLUMN OPERACION.EFPTOEQU.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU.TIPPRP IS 'Tipo de propiedad';

COMMENT ON COLUMN OPERACION.EFPTOEQU.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.EFPTOEQU.COSTEAR IS 'Indica si el equipo se costea';

COMMENT ON COLUMN OPERACION.EFPTOEQU.CANTIDAD IS 'Cantidad de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU.COSTO IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU.CODEQUCOM IS 'Codigo del equipo comercial';

COMMENT ON COLUMN OPERACION.EFPTOEQU.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOEQU.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOEQU.TIPEQU IS 'Codigo de tipo de equipo';


