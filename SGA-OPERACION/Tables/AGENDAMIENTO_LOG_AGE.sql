CREATE TABLE OPERACION.AGENDAMIENTO_LOG_AGE
(
  IDAGENDA        NUMBER,
  IDSEQ           NUMBER,
  FECREAGENDA     DATE                          DEFAULT sysdate               NOT NULL,
  USUREAGENDA     VARCHAR2(30 BYTE)             DEFAULT user                  NOT NULL,
  CODCONREAGENDA  NUMBER
);

COMMENT ON TABLE OPERACION.AGENDAMIENTO_LOG_AGE IS 'Tabla de Log de Asignacion de Contrata';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO_LOG_AGE.IDSEQ IS 'Secuencial';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO_LOG_AGE.IDAGENDA IS 'ID agenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO_LOG_AGE.FECREAGENDA IS 'Fecha de Reagenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO_LOG_AGE.USUREAGENDA IS 'Usuario de Reagenda';

COMMENT ON COLUMN OPERACION.AGENDAMIENTO_LOG_AGE.CODCONREAGENDA IS 'Contrata asignada';


