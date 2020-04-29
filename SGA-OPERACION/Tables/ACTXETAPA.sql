CREATE TABLE OPERACION.ACTXETAPA
(
  CODETA  NUMBER(5)                             NOT NULL,
  CODACT  NUMBER(5)                             NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.ACTXETAPA IS 'Listado de actividades por etapa';

COMMENT ON COLUMN OPERACION.ACTXETAPA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.ACTXETAPA.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.ACTXETAPA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ACTXETAPA.FECUSU IS 'Fecha de registro';


