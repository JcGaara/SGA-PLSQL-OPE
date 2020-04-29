CREATE TABLE OPERACION.EFPTOMET
(
  CODEF        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  ORDEN        NUMBER(10)                       NOT NULL,
  TIPMETEF     NUMBER(2),
  CODUBI       CHAR(10 BYTE),
  CANTIDAD     NUMBER(10,2),
  OBSERVACION  VARCHAR2(200 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOMET IS 'Metrado de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOMET.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOMET.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOMET.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOMET.TIPMETEF IS 'Tipo de metrado del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOMET.CODUBI IS 'Codigo del distrito';

COMMENT ON COLUMN OPERACION.EFPTOMET.CANTIDAD IS 'Cantidad de metrado';

COMMENT ON COLUMN OPERACION.EFPTOMET.OBSERVACION IS 'Observación';

COMMENT ON COLUMN OPERACION.EFPTOMET.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOMET.FECUSU IS 'Fecha de registro';


