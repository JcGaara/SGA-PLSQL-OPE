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

COMMENT ON TABLE OPERACION.OPE_EST_SOL_ACT_PA_MAE IS 'Maestro de estados de la solicitud de activaci�n de fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.ESTADO IS 'C�digo de estado de la solicitud de activaci�n retroactiva';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.DESCRIPCION IS 'Descripci�n del estado';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.ACTIVO IS 'Estado del registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.USUREG IS 'Usuario que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.FECREG IS 'Fecha que insert� el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.USUMOD IS 'Usuario que modific� el registro';

COMMENT ON COLUMN OPERACION.OPE_EST_SOL_ACT_PA_MAE.FECMOD IS 'Fecha que se modific� el registro';


