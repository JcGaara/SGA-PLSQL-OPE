CREATE TABLE OPERACION.EFPTOETAACT
(
  CODEF        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CODACT       NUMBER(5)                        NOT NULL,
  COSTO        NUMBER(10,2)                     DEFAULT 0                     NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  OBSERVACION  VARCHAR2(200 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  MONEDA       CHAR(1 BYTE)                     DEFAULT 'D'                   NOT NULL,
  MONEDA_ID    NUMBER(10),
  CODPREC      NUMBER(8)
);

COMMENT ON TABLE OPERACION.EFPTOETAACT IS 'Actividades de las etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.PUNTO IS 'Punto del cada estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.CANTIDAD IS 'Cantidad de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.MONEDA IS 'Codigo de moneda (No se utiliza)';

COMMENT ON COLUMN OPERACION.EFPTOETAACT.MONEDA_ID IS 'Codigo de moneda';


