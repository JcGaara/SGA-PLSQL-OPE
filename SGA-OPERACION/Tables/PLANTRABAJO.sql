CREATE TABLE OPERACION.PLANTRABAJO
(
  PLAN         VARCHAR2(10 BYTE)                NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  ABREVI       VARCHAR2(20 BYTE),
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  ESTADO       NUMBER(1)                        DEFAULT 1,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.PLANTRABAJO IS 'No es usada';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.PLAN IS 'Plan de trabajo';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.DESCRIPCION IS 'Descripcion del plan de trabajo';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.ABREVI IS 'Abreviatura';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.ESTADO IS 'Estado del plan de trabajo';

COMMENT ON COLUMN OPERACION.PLANTRABAJO.FECUSU IS 'Fecha de registro';

