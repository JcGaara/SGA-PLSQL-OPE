CREATE TABLE OPERACION.MOTINSSRV
(
  CODMOTINSSRV   NUMBER(3)                      NOT NULL,
  DESCRIPCION    VARCHAR2(200 BYTE)             NOT NULL,
  FECUSU         DATE                           DEFAULT SYSDATE               NOT NULL,
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT user                  NOT NULL,
  FLG_GENERA_NC  NUMBER(1)                      DEFAULT 0,
  FLG_ANULA_DEV  NUMBER(1)                      DEFAULT 0,
  FLG_PENALIDAD  NUMBER(1)                      DEFAULT 0
);

COMMENT ON TABLE OPERACION.MOTINSSRV IS 'Motivo de cambio de la instancia de servicio';

COMMENT ON COLUMN OPERACION.MOTINSSRV.CODMOTINSSRV IS 'Codigo del motivo de la instancia de servicio';

COMMENT ON COLUMN OPERACION.MOTINSSRV.DESCRIPCION IS 'Descripcion del motivo de la instancia de servicio';

COMMENT ON COLUMN OPERACION.MOTINSSRV.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.MOTINSSRV.CODUSU IS 'Codigo de Usuario registro';

COMMENT ON COLUMN OPERACION.MOTINSSRV.FLG_GENERA_NC IS 'Genera una nota de crédito por baja';

COMMENT ON COLUMN OPERACION.MOTINSSRV.FLG_ANULA_DEV IS 'Anula la generación de abono por baja';

COMMENT ON COLUMN OPERACION.MOTINSSRV.FLG_PENALIDAD IS 'Exige la definición por parte del usuario si aplica o no penalidad';


