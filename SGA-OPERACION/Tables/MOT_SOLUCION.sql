CREATE TABLE OPERACION.MOT_SOLUCION
(
  CODMOT_SOLUCION  NUMBER(3)                    NOT NULL,
  DESCRIPCION      VARCHAR2(200 BYTE)           NOT NULL,
  USUREG           VARCHAR2(30 BYTE)            DEFAULT user                  NOT NULL,
  FECREG           DATE                         DEFAULT sysdate               NOT NULL,
  USUMOD           VARCHAR2(30 BYTE)            DEFAULT user                  NOT NULL,
  FECMOD           DATE                         DEFAULT sysdate               NOT NULL,
  ESTADO           NUMBER(1)                    DEFAULT 0                     NOT NULL
);

COMMENT ON TABLE OPERACION.MOT_SOLUCION IS 'Motivo de la Orden de Trabajo';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.CODMOT_SOLUCION IS 'Codigo de motivo de la orden de trabajo';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.DESCRIPCION IS 'Descripcion del motivo de la ot';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.FECREG IS 'Fecha de registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.FECMOD IS 'Fecha que se modificó el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCION.ESTADO IS 'Estado del Motivo';


