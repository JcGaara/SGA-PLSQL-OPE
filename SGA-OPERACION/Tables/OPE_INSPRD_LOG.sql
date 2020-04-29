CREATE TABLE OPERACION.OPE_INSPRD_LOG
(
  IDLOG    NUMBER(10)                           NOT NULL,
  PID      NUMBER(10)                           NOT NULL,
  DESCLOG  VARCHAR2(3000 BYTE),
  USUREG   VARCHAR2(30 BYTE)                    DEFAULT user                  NOT NULL,
  FECREG   DATE                                 DEFAULT SYSDATE               NOT NULL,
  USUMOD   VARCHAR2(30 BYTE)                    DEFAULT user,
  FECMOD   DATE                                 DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_INSPRD_LOG IS 'Tabla en la que se registra los updates generados a los campos de la tabla INSPRD';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.IDLOG IS 'id del registro';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.USUREG IS 'Usuario que ingresó el registro';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.FECREG IS 'Fecha de Registro';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.USUMOD IS 'Ultimo usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.FECMOD IS 'Ultima Fecha en que se modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_INSPRD_LOG.DESCLOG IS 'descripcion del cambio realizado en la tabla INSPRD';


