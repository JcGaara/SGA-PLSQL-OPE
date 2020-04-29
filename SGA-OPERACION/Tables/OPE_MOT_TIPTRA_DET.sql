CREATE TABLE OPERACION.OPE_MOT_TIPTRA_DET
(
  ID               NUMBER(8)                    NOT NULL,
  TIPTRA           NUMBER(6)                    NOT NULL,
  CODMOT_SOLUCION  NUMBER(3)                    NOT NULL,
  TIPO             VARCHAR2(6 BYTE)             NOT NULL,
  USUREG           VARCHAR2(30 BYTE)            DEFAULT USER,
  FECREG           DATE                         DEFAULT SYSDATE,
  USUMOD           VARCHAR2(30 BYTE)            DEFAULT USER,
  FECMOD           DATE                         DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_MOT_TIPTRA_DET IS 'Detalle motivo tipo de trabajo';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.ID IS 'Identificador de instancia de motivo de tipo de trabajo';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.TIPTRA IS 'identificador de Tipo de trabajo';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.CODMOT_SOLUCION IS 'identificador de Motivo de solución';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.TIPO IS 'Identificador del tipo';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_MOT_TIPTRA_DET.FECMOD IS 'Fecha que modificó el registro';


