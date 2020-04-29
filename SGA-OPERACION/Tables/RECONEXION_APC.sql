CREATE TABLE OPERACION.RECONEXION_APC
(
  CODSOLOT       NUMBER(8)                      NOT NULL,
  CODCLI         CHAR(8 BYTE),
  FECREC         DATE,
  FECUSU         DATE                           DEFAULT sysdate,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user,
  FLG_PROCESADO  NUMBER(1)                      DEFAULT 0,
  FEC_PROCESO    DATE,
  CODSOLOTRX     NUMBER(8)
);

COMMENT ON TABLE OPERACION.RECONEXION_APC IS 'Tabla temporal para la reconexión automática';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.CODSOLOT IS 'Codigo de la solicitud de orden de trabajo';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.CODCLI IS 'Codigo del cliente';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.FECREC IS 'Fecha de reconexión a pedido del cliente';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.FLG_PROCESADO IS '0: No procesado 1:procesado';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.FEC_PROCESO IS 'Fecha que se hizo la SOT de reconexión';

COMMENT ON COLUMN OPERACION.RECONEXION_APC.CODSOLOTRX IS 'Codigo de la solicitud de orden de trabajo de la reconexión';


