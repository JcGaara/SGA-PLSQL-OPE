CREATE TABLE OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG
(
  ORDEN_LOG       NUMBER                        NOT NULL,
  CODSOLOT        NUMBER(8)                     NOT NULL,
  PUNTO           NUMBER(10)                    NOT NULL,
  ORDEN           NUMBER(4)                     NOT NULL,
  FECREAGENDA     DATE,
  USUREAGENDA     VARCHAR2(30 BYTE),
  CODCONREAGENDA  NUMBER
);

COMMENT ON TABLE OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG IS 'Tabla de log para el reagendamiento del Listado de etapa del detalle de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.ORDEN_LOG IS 'PK';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.PUNTO IS 'Punto de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.FECREAGENDA IS 'Fecha de reagendamiento';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.USUREAGENDA IS 'Usuario de reagendamiento';

COMMENT ON COLUMN OPERACION.SOLOTPTOETA_AGENDAMIENTO_LOG.CODCONREAGENDA IS 'C�digo de contrata reagendada';


