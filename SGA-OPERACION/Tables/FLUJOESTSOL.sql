CREATE TABLE OPERACION.FLUJOESTSOL
(
  IDSEQ       NUMBER(6)                         NOT NULL,
  TIPO        NUMBER(2)                         NOT NULL,
  ESTADO_ANT  NUMBER(2),
  ESTADO_NUE  NUMBER(2)
);

COMMENT ON TABLE OPERACION.FLUJOESTSOL IS 'Flujos de los estado de la solicitud de ot';

COMMENT ON COLUMN OPERACION.FLUJOESTSOL.IDSEQ IS 'Id de la tabla';

COMMENT ON COLUMN OPERACION.FLUJOESTSOL.TIPO IS 'Tipo de flujo';

COMMENT ON COLUMN OPERACION.FLUJOESTSOL.ESTADO_ANT IS 'Estado antiguo de la solicitud';

COMMENT ON COLUMN OPERACION.FLUJOESTSOL.ESTADO_NUE IS 'Estado nuevo de la solicitud';


