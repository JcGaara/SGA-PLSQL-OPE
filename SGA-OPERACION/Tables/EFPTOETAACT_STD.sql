CREATE TABLE OPERACION.EFPTOETAACT_STD
(
  IDPAQ        NUMBER(10)                       NOT NULL,
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

COMMENT ON TABLE OPERACION.EFPTOETAACT_STD IS 'Actividades estandares de las etapas de cada detalle del paquete';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.PUNTO IS 'Punto del cada estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.CODACT IS 'Codigo de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.COSTO IS 'Costo de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.CANTIDAD IS 'Cantidad de la actividad';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.MONEDA IS 'Codigo de moneda (No se utiliza)';

COMMENT ON COLUMN OPERACION.EFPTOETAACT_STD.MONEDA_ID IS 'Codigo de moneda';


