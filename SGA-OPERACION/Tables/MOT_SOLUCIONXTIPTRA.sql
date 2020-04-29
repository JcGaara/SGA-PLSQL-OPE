CREATE TABLE OPERACION.MOT_SOLUCIONXTIPTRA
(
  TIPTRA           NUMBER(4)                    NOT NULL,
  CODMOT_SOLUCION  NUMBER(3)                    NOT NULL,
  USUREG           VARCHAR2(30 BYTE)            DEFAULT user                  NOT NULL,
  FECREG           DATE                         DEFAULT sysdate               NOT NULL,
  USUMOD           VARCHAR2(30 BYTE)            DEFAULT user,
  FECMOD           DATE                         DEFAULT sysdate
);

COMMENT ON TABLE OPERACION.MOT_SOLUCIONXTIPTRA IS 'Motivo de solución por tipo de trabajo';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.TIPTRA IS 'Tipo de Trabajo';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.CODMOT_SOLUCION IS 'Motivo de solución';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.USUREG IS 'Usuario   que   insertó   el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.FECREG IS 'Fecha que inserto el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.USUMOD IS 'Usuario   que modificó   el registro';

COMMENT ON COLUMN OPERACION.MOT_SOLUCIONXTIPTRA.FECMOD IS 'Fecha   que se   modificó el registro';


