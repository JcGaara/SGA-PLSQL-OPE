CREATE TABLE OPERACION.PENXETAPA
(
  CODETA       NUMBER(5)                        NOT NULL,
  IDPENALIDAD  NUMBER(5)                        NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.PENXETAPA IS 'Listado de etapas por penalidad';

COMMENT ON COLUMN OPERACION.PENXETAPA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.PENXETAPA.IDPENALIDAD IS 'Codigo de la penalidad';

COMMENT ON COLUMN OPERACION.PENXETAPA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PENXETAPA.FECUSU IS 'Fecha de registro';


