CREATE TABLE OPERACION.PLANFLUJO
(
  PLAN      VARCHAR2(10 BYTE)                   NOT NULL,
  ORDEN     NUMBER(4)                           NOT NULL,
  AREA      NUMBER(4),
  TIPTRA    NUMBER(4),
  CODMOTOT  NUMBER(3),
  APRTRS    NUMBER(1)                           DEFAULT 0                     NOT NULL,
  CODUSU    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECUSU    DATE                                DEFAULT SYSDATE               NOT NULL,
  FLAGEJE   NUMBER(1)                           DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.PLANFLUJO IS 'No es usada';

COMMENT ON COLUMN OPERACION.PLANFLUJO.PLAN IS 'Plan del flujo';

COMMENT ON COLUMN OPERACION.PLANFLUJO.ORDEN IS 'Orden de la tabla';

COMMENT ON COLUMN OPERACION.PLANFLUJO.AREA IS 'Codigo de area';

COMMENT ON COLUMN OPERACION.PLANFLUJO.TIPTRA IS 'Codigo del tipo de trabajo';

COMMENT ON COLUMN OPERACION.PLANFLUJO.CODMOTOT IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.PLANFLUJO.APRTRS IS 'Indica si es reponsable de la aprobacion de la transaccion';

COMMENT ON COLUMN OPERACION.PLANFLUJO.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.PLANFLUJO.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.PLANFLUJO.FLAGEJE IS 'Identifica si la ot es responsable de la ejecución';


