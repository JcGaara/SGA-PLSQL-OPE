CREATE TABLE OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE
(
  ESTADOINI  NUMBER(3)                          NOT NULL,
  ESTADOFIN  NUMBER(3)                          NOT NULL,
  ACTIVO     NUMBER(1)                          DEFAULT 1,
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECREG     DATE                               DEFAULT sysdate,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT user,
  FECMOD     DATE                               DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE IS 'Flujo de estado de solicitud de activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.ESTADOINI IS 'Estado inicial de activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.ESTADOFIN IS 'Estado final de activaciones retroactivas';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.ACTIVO IS 'Estado del registro. 0: Inactivo, 1: Activo';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_FLUJO_EST_SOL_ACT_PA_MAE.FECMOD IS 'Fecha que se modificó el registro';


