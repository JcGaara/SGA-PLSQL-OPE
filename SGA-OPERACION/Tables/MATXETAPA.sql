CREATE TABLE OPERACION.MATXETAPA
(
  CODETA  NUMBER(5)                             NOT NULL,
  CODMAT  CHAR(15 BYTE)                         NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.MATXETAPA IS 'Listado de materiales por etapa';

COMMENT ON COLUMN OPERACION.MATXETAPA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.MATXETAPA.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.MATXETAPA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MATXETAPA.FECUSU IS 'Fecha de registro';


