CREATE TABLE OPERACION.OPE_SRV_RECARGA_DET
(
  NUMREGISTRO    CHAR(10 BYTE)                  NOT NULL,
  CODINSSRV      NUMBER(10)                     NOT NULL,
  TIPSRV         CHAR(4 BYTE),
  CODSRV         CHAR(4 BYTE),
  CODUSU         VARCHAR2(30 BYTE)              DEFAULT USER                  NOT NULL,
  FECUSU         DATE                           DEFAULT SYSDATE               NOT NULL,
  FECACT         DATE,
  FECBAJA        DATE,
  PID            NUMBER(10),
  ESTADO         CHAR(2 BYTE),
  ULTTAREAWF     NUMBER(8),
  FLG_VERIF_TEC  NUMBER(1),
  MENSAJE        VARCHAR2(1000 BYTE)
);

COMMENT ON TABLE OPERACION.OPE_SRV_RECARGA_DET IS 'Contiene las instancias de servicio asociadas al codigo de recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.NUMREGISTRO IS 'Codigo de la recarga';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.CODINSSRV IS 'Codigo de la instancia de servicio';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.CODSRV IS 'Codigo del servicio';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.TIPSRV IS 'Codigo del tipo de servicio';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.CODUSU IS 'Usuario de registro';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.FECUSU IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.FECACT IS 'Fecha de baja en plataforma.';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.PID IS 'PID principal del servicio';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.ESTADO IS 'Estado del registro, tabla estregdth';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.ULTTAREAWF IS 'Ultima tarea de transaccion con plataforma';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.FLG_VERIF_TEC IS 'Flag de verificacion tecnica';

COMMENT ON COLUMN OPERACION.OPE_SRV_RECARGA_DET.MENSAJE IS 'Mensaje de error al activar o desactivar';


