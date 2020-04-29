CREATE TABLE OPERACION.SOLEFXAREA_LOG_EF
(
  CODEF   NUMBER(8)                             NOT NULL,
  USULOG  VARCHAR2(50 BYTE)                     DEFAULT USER                  NOT NULL,
  FECLOG  DATE                                  DEFAULT SYSDATE               NOT NULL,
  ESTADO  VARCHAR2(50 BYTE)                     NOT NULL,
  AREA    NUMBER(4)                             NOT NULL,
  ID      NUMBER(8)
);

COMMENT ON TABLE OPERACION.SOLEFXAREA_LOG_EF IS 'Log de Derivacion del Estudio de Factibilidad';

COMMENT ON COLUMN OPERACION.SOLEFXAREA_LOG_EF.CODEF IS 'Codigo del Estudio de Factibilidad';

COMMENT ON COLUMN OPERACION.SOLEFXAREA_LOG_EF.USULOG IS 'Codigo del Usuario que hace el Estudio de Factibilidad';

COMMENT ON COLUMN OPERACION.SOLEFXAREA_LOG_EF.FECLOG IS 'Fecha de la derivacion del Estudio de Factibilidad';

COMMENT ON COLUMN OPERACION.SOLEFXAREA_LOG_EF.ESTADO IS 'Estados : DERIVADO , RETIRADO';

COMMENT ON COLUMN OPERACION.SOLEFXAREA_LOG_EF.AREA IS 'Codigo del area que hace el Estudio de Factibilidad';


