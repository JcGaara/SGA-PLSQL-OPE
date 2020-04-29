CREATE TABLE OPERACION.SOT_LIQUIDACION
(
  IDLIQ          NUMBER                         NOT NULL,
  CODCON         NUMBER,
  FECRECEPCION   DATE,
  NUMERO         VARCHAR2(100 BYTE),
  FECUSU         DATE                           DEFAULT SYSDATE,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT USER,
  ESTADO         NUMBER,
  OBSERVACIONES  VARCHAR2(4000 BYTE),
  PENALIDAD      NUMBER(10,2)                   DEFAULT 0,
  AREA           VARCHAR2(60 BYTE),
  SERVICIO       VARCHAR2(30 BYTE),
  FEC_ENV_OBS    DATE,
  FEC_LEV_OBS    DATE,
  FEC_ENV_LIQ    DATE,
  FEC_ENV_SO     DATE,
  ANALISTA       VARCHAR2(6 BYTE)
);

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.IDLIQ IS 'Id Liquidacion';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.CODCON IS 'Codigo de Contrata';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FECRECEPCION IS 'Fecha de recepcion de Liquidacion';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.NUMERO IS 'Numero de Liquidacion';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FECUSU IS 'Fecha de Registro';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.CODUSU IS 'Usuario que Registro';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.ESTADO IS 'Estado de Liquidacion';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.OBSERVACIONES IS 'Observaciones de Liquidacion';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.PENALIDAD IS 'Penalidad asignada';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FEC_LEV_OBS IS 'FECHA DE LEVANTAMIENTO DE OBSERVACIONES';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.AREA IS '�rea de trabajo';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.SERVICIO IS 'Servicio';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FEC_ENV_OBS IS 'FECHA DE ENVIO DE OBSERVACIONES';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FEC_ENV_LIQ IS 'FECHA DE ENVIO DE LIQUIDACI�N A CONTRATA';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.FEC_ENV_SO IS 'FECHA DE ENVIO DE FECHA DE ENVIO A S.O.';

COMMENT ON COLUMN OPERACION.SOT_LIQUIDACION.ANALISTA IS 'ANALISTA A CARGO';

