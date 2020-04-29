CREATE TABLE OPERACION.EFPTOETADAT
(
  CODEF     NUMBER(8)                           NOT NULL,
  PUNTO     NUMBER(10)                          NOT NULL,
  CODETA    NUMBER(5)                           NOT NULL,
  TIPDATEF  NUMBER(4)                           NOT NULL,
  DATO      VARCHAR2(100 BYTE)                  DEFAULT '0'                   NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOETADAT IS 'Datos adicionales de las etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.TIPDATEF IS 'Tipo de dato del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.DATO IS 'Datos por etapa segun el tipo de dato del ef';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETADAT.CODUSU IS 'Codigo de Usuario registro';


