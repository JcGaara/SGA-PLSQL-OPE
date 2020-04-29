CREATE TABLE OPERACION.OPE_FORMULA_MATERIAL_DET
(
  CODFOR       NUMBER(5)                        NOT NULL,
  CODMAT       CHAR(15 BYTE)                    NOT NULL,
  IDPAQ        NUMBER(10)                       NOT NULL,
  CANTIDAD     NUMBER(8,2)                      DEFAULT 0                     NOT NULL,
  CODETA       NUMBER(5)                        NOT NULL,
  CAN_MAX      NUMBER,
  RECUPERABLE  NUMBER                           DEFAULT 0,
  TIPO         NUMBER                           DEFAULT 1,
  TIPSRV       CHAR(4 BYTE),
  USUREG       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECREG       DATE                             DEFAULT SYSDATE               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT user                  NOT NULL,
  FECMOD       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_FORMULA_MATERIAL_DET IS 'Tabla de Materiales etapa paquete por formula';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.CODFOR IS 'Codigo de formula';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.CODMAT IS 'Codigo de material';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.CANTIDAD IS 'Cantidad de material';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.CODETA IS 'Etapa';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.RECUPERABLE IS 'Indica si el Equipo o Material sera recuperable';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.TIPO IS '1:Material 2;Equipo';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.TIPSRV IS 'Tipo de servicio para relacionar con el punto de servicio de sopotpto';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.FECREG IS 'Fecha que se insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_FORMULA_MATERIAL_DET.FECMOD IS 'Fecha que se modificó el registro';


