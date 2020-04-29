CREATE TABLE OPERACION.TIPTRAXAREA
(
  TIPTRA  NUMBER(4)                             NOT NULL,
  CODDPT  CHAR(6 BYTE),
  FECUSU  DATE                                  DEFAULT SYSDATE               NOT NULL,
  CODUSU  VARCHAR2(30 BYTE)                     DEFAULT user                  NOT NULL,
  AREA    NUMBER(4)                             NOT NULL,
  TIPO    NUMBER(1)                             DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.TIPTRAXAREA IS 'Areas asociado a tipo trabajo';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.TIPTRAXAREA.TIPO IS 'Tipo';


