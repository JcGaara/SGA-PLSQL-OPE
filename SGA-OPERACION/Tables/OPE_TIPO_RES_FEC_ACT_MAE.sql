CREATE TABLE OPERACION.OPE_TIPO_RES_FEC_ACT_MAE
(
  IDTIPO       NUMBER(5)                        NOT NULL,
  DESCRIPCION  VARCHAR2(200 BYTE),
  ESTADO       NUMBER(4)                        DEFAULT 1,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECREG       DATE                             DEFAULT SYSDATE,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT USER,
  FECMOD       DATE                             DEFAULT SYSDATE,
  IDTIPORES    NUMBER
);

COMMENT ON TABLE OPERACION.OPE_TIPO_RES_FEC_ACT_MAE IS 'Registra los tipos de restricciones de fechas de activacion';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.IDTIPO IS 'Identificador de los tipos de restricciones de activacion';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.DESCRIPCION IS 'Descripción del tipo de restricciones de activacion';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.ESTADO IS 'Estado del tipo de restricción de activacion';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.FECMOD IS 'Fecha que se modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_TIPO_RES_FEC_ACT_MAE.IDTIPORES IS 'Tipo de restricción. 1: Retroactiva, 2: Administrativa';


