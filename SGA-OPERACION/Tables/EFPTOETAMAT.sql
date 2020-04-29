CREATE TABLE OPERACION.EFPTOETAMAT
(
  CODEF     NUMBER(8)                           NOT NULL,
  PUNTO     NUMBER(10)                          NOT NULL,
  CODETA    NUMBER(5)                           NOT NULL,
  CODMAT    CHAR(15 BYTE)                       NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  COSTO     NUMBER(10,2)                        DEFAULT 0                     NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOETAMAT IS 'Materiales de las etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.COSTO IS 'Costo del material';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETAMAT.CODUSU IS 'Codigo de Usuario registro';


