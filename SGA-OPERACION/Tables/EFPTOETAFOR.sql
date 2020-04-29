CREATE TABLE OPERACION.EFPTOETAFOR
(
  CODEF     NUMBER(8)                           NOT NULL,
  PUNTO     NUMBER(10)                          NOT NULL,
  CODETA    NUMBER(5)                           NOT NULL,
  CODFOR    NUMBER(5)                           NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOETAFOR IS 'Formulas de las etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.PUNTO IS 'Punto de la orden de estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.CANTIDAD IS 'Cantidad de equipo en la formula';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETAFOR.CODUSU IS 'Codigo de Usuario registro';


