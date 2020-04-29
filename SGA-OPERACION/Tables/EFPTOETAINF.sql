CREATE TABLE OPERACION.EFPTOETAINF
(
  CODEF        NUMBER(8)                        NOT NULL,
  PUNTO        NUMBER(10)                       NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  ORDEN        NUMBER(5)                        NOT NULL,
  TIPINFEF     NUMBER(5)                        NOT NULL,
  FECINI       DATE,
  FECFIN       DATE,
  OBSERVACION  VARCHAR2(100 BYTE),
  FECUSU       DATE                             DEFAULT SYSDATE               NOT NULL,
  CODUSU       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL
);

COMMENT ON TABLE OPERACION.EFPTOETAINF IS 'Informe de las etapas de cada detalle del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.CODEF IS 'Codigo del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.PUNTO IS 'Punto del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.CODETA IS 'Codigo de la etapa';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.TIPINFEF IS 'Tipo de informe del estudio de factibilidad';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.FECINI IS 'Fecha de inicio';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.FECFIN IS 'Fecha de fin';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.OBSERVACION IS 'Observacion';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.EFPTOETAINF.CODUSU IS 'Codigo de Usuario registro';


