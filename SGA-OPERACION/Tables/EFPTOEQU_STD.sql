CREATE TABLE OPERACION.EFPTOEQU_STD
(
  IDPAQ        NUMBER(10)                       NOT NULL,
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
  CODETA       NUMBER,
  FLGESTADO    NUMBER                           DEFAULT 1                     NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOEQU_STD IS 'Equipos estandares de cada detalle del paquete';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.IDPAQ IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.ORDEN IS 'Orden del equipo en el punto ';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.CODTIPEQU IS 'Codigo del tipo de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.TIPPRP IS 'Tipo de propiedad';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.COSTEAR IS 'Indica si el equipo se costea';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.CANTIDAD IS 'Cantidad de equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.COSTO IS 'Costo del equipo';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.CODEQUCOM IS 'Codigo del equipo comercial';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOEQU_STD.TIPEQU IS 'Codigo de tipo de equipo';


