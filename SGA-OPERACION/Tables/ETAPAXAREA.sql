CREATE TABLE OPERACION.ETAPAXAREA
(
  CODDPT    CHAR(6 BYTE),
  CODETA    NUMBER(5)                           NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT USER,
  FECUSU    DATE                                DEFAULT SYSDATE,
  ESNORMAL  NUMBER(1)                           DEFAULT 1                     NOT NULL,
  AREA      NUMBER(4)                           NOT NULL
);

COMMENT ON TABLE OPERACION.ETAPAXAREA IS 'Listado de etapas por area';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.CODDPT IS 'Codigo del departamento (reemplazado por el codigo del area)';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.ESNORMAL IS 'Indica si la etapa es valida';

COMMENT ON COLUMN OPERACION.ETAPAXAREA.AREA IS 'Codigo de area';


