CREATE TABLE OPERACION.OPE_EST_SOL_ACT_PA_MAE
(
  ESTADO       NUMBER(3)                        NOT NULL,
  DESCRIPCION  VARCHAR2(100 BYTE),
  ACTIVO       NUMBER(1)                        DEFAULT 1,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user,
  FECREG       DATE                             DEFAULT sysdate,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user,
  FECMOD       DATE                             DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.OPE_EST_SOL_ACT_PA_MAE IS 'Maestro de estados de la solicitud de activación de fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.ESTADO IS 'Código de estado de la solicitud de activación retroactiva';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.DESCRIPCION IS 'Descripción del estado';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.ACTIVO IS 'Estado del registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.FECMOD IS 'Fecha que se modificó el registro';


