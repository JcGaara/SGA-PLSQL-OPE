CREATE TABLE OPERACION.OPE_DETLOG_TRANSFER
(
  IDLOG     NUMBER                              NOT NULL,
  MENSAJE   VARCHAR2(2000 BYTE),
  ORAERROR  VARCHAR2(2000 BYTE),
  USUREG    VARCHAR2(30 BYTE)                   DEFAULT user,
  FECREG    DATE                                DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.OPE_DETLOG_TRANSFER IS 'Tabla que contiene los errores en la transferencia a INT';

COMMENT ON COLUMN OPERACION.OPE_DETLOG_TRANSFER.MENSAJE IS 'Mensaje del error';

COMMENT ON COLUMN OPERACION.OPE_DETLOG_TRANSFER.IDLOG IS 'Id log';

COMMENT ON COLUMN OPERACION.OPE_DETLOG_TRANSFER.ORAERROR IS 'sqlerrm';

COMMENT ON COLUMN OPERACION.OPE_DETLOG_TRANSFER.USUREG IS 'Usuario de registro';

COMMENT ON COLUMN OPERACION.OPE_DETLOG_TRANSFER.FECREG IS 'Fecha de registro';

