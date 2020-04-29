CREATE TABLE OPERACION.OPE_FORMULA_ACTIVIDAD_DET
(
  CODFOR    NUMBER(5)                           NOT NULL,
  CODACT    NUMBER(5)                           NOT NULL,
  IDPAQ     NUMBER(10)                          NOT NULL,
  CANTIDAD  NUMBER(8,2)                         DEFAULT 0                     NOT NULL,
  CODETA    NUMBER(5)                           NOT NULL,
  CAN_MAX   NUMBER,
  USUREG    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECREG    DATE                                DEFAULT SYSDATE               NOT NULL,
  USUMOD    VARCHAR2(30 BYTE)                   DEFAULT user                  NOT NULL,
  FECMOD    DATE                                DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_FORMULA_ACTIVIDAD_DET IS 'Tabla de actividades etapa paquete por formula';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.CODACT IS 'Codigo de actividad';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.CANTIDAD IS 'Cantidad de actividades';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.CODETA IS 'Etapa';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.FECREG IS 'Fecha que se insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_ACTIVIDAD_DET.FECMOD IS 'Fecha que se modificó el registro';


