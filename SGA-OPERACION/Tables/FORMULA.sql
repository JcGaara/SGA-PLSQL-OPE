CREATE TABLE OPERACION.FORMULA
(
  CODFOR       NUMBER(5)                        NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE)               NOT NULL
);

COMMENT ON TABLE OPERACION.FORMULA IS 'Listado de formulas';

COMMENT ON COLUMN OPERACION.FORMULA.CODFOR IS 'Codigo de formula (Pk)';

COMMENT ON COLUMN OPERACION.FORMULA.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.FORMULA.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.FORMULA.DESCRIPCION IS 'Descripcion de la formula';


