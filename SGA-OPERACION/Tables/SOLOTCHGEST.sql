CREATE TABLE OPERACION.SOLOTCHGEST
(
  IDSEQ        NUMBER(10)                       NOT NULL,
  CODSOLOT     NUMBER(8)                        NOT NULL,
  TIPO         NUMBER(1)                        NOT NULL,
  ESTADO       NUMBER(4)                        NOT NULL,
  FECHA        DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  OBSERVACION  VARCHAR2(4000 BYTE)
);

COMMENT ON TABLE OPERACION.SOLOTCHGEST IS 'Cambios de estado de la solicitud de ot';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.IDSEQ IS 'Pk de la tabla';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.TIPO IS 'Tipo de cambio de estado';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.ESTADO IS 'Codigo del estado de la solicitud';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.FECHA IS 'Fecha del cambio de estado';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.SOLOTCHGEST.OBSERVACION IS 'Observacion';


