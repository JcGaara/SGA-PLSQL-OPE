CREATE TABLE OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET
(
  IDSEC      NUMBER(18)                         NOT NULL,
  CODSOLOT   NUMBER(8)                          NOT NULL,
  LOTETRS    NUMBER(18)                         NOT NULL,
  CODTRS     NUMBER(10)                         NOT NULL,
  FEC_RETRO  DATE,
  USUREG     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECREG     DATE                               DEFAULT SYSDATE,
  USUMOD     VARCHAR2(30 BYTE)                  DEFAULT USER,
  FECMOD     DATE                               DEFAULT SYSDATE
);

COMMENT ON TABLE OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET IS 'Registra las transacciones que estan en estado pendiente de aprobación';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.IDSEC IS 'Número identificador de los registros del lote de transacciones pendientes';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.CODSOLOT IS 'Número identificador de las solicitudes de activación que tienen fechas retroactivas';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.LOTETRS IS 'N° de lote de transacciones pendientes de aprobación';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.CODTRS IS 'N° de transacción pendiente';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.FEC_RETRO IS 'Fecha de activación retroactiva';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.USUREG IS 'Usuario que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.FECREG IS 'Fecha que insertó el registro';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.USUMOD IS 'Usuario que modificó el registro';

COMMENT ON COLUMN OPERACION.OPE_TRSSOLOT_FECHA_RETRO_DET.FECMOD IS 'Fecha que se modificó el registro';


