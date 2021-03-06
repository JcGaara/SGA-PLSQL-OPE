CREATE TABLE OPERACION.SOLOTPTO_IDXINC
(
  CODSOLOT    NUMBER(8)                         NOT NULL,
  PUNTO       NUMBER(10)                        NOT NULL,
  ORDEN       NUMBER(10)                        NOT NULL,
  INCIDENCIA  VARCHAR2(4000 BYTE),
  CODUSU      VARCHAR2(30 BYTE)                 DEFAULT user,
  FECUSU      DATE                              DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.SOLOTPTO_IDXINC IS 'Listado de incidencias de cada instalacion';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.PUNTO IS 'Punto de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.INCIDENCIA IS 'Numero de incidencia';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTPTO_IDXINC.FECUSU IS 'Fecha de registro';


