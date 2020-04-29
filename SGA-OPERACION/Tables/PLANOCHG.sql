CREATE TABLE OPERACION.PLANOCHG
(
  IDSEQ           NUMBER(10)                    NOT NULL,
  IDPLANO         NUMBER(8)                     NOT NULL,
  DIGITALIZACION  NUMBER(4)                     NOT NULL,
  FECUSU          DATE                          DEFAULT sysdate               NOT NULL,
  CODUSU          VARCHAR2(30 BYTE)             DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.PLANOCHG IS 'Log de cambios en los estados de la Digitalización del Plano.';

COMMENT ON COLUMN OPERACION.PLANOCHG.CODUSU IS 'Usuario que inserto el registro.';

COMMENT ON COLUMN OPERACION.PLANOCHG.IDSEQ IS 'PK de la tabla.';

COMMENT ON COLUMN OPERACION.PLANOCHG.IDPLANO IS 'ID del Plano.';

COMMENT ON COLUMN OPERACION.PLANOCHG.DIGITALIZACION IS 'Cambio de la Digitalización.';

COMMENT ON COLUMN OPERACION.PLANOCHG.FECUSU IS 'Fecha de inserción del registro.';


