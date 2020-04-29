CREATE TABLE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX
(
  IDLOTE       NUMBER(10)                       NOT NULL,
  NUMSOL       NUMBER(5),
  NUMARCHIVOS  NUMBER(3),
  ESTADO       NUMBER(1)                        NOT NULL,
  USUREG       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECREG       DATE                             DEFAULT SYSDATE               NOT NULL,
  USUMOD       VARCHAR2(30 BYTE)                DEFAULT USER                  NOT NULL,
  FECMOD       DATE                             DEFAULT SYSDATE               NOT NULL
);

COMMENT ON TABLE OPERACION.OPE_TVSAT_LOTE_SLTD_AUX IS 'Tabla de agrupacion de solicitudes suspension / activacion para la generacion de archivos a enviar el conax. Esta tabla debe se llenada por un proceso automatico a partir de la informacion de las tablas de solicitudes al conax.';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.IDLOTE IS 'Identificador del lote';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.NUMSOL IS 'Numero de solicitudes incluidas en el lote';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.NUMARCHIVOS IS 'Numero de archivos al conax incluidos en el lote';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.ESTADO IS 'Estado del lote: 1:PEND_EJECUCION, 2:GEN_ARCHIVOS, 3: ARCHIVOS_COMPLETADOS, 4: ENV_CONAX,5: REC_CONAX, 6: VERIFICADO';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.USUREG IS 'Usuario que genero el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.FECREG IS 'Usuario que modifico el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.USUMOD IS 'Usuario que modifico el registro';

COMMENT ON COLUMN OPERACION.OPE_TVSAT_LOTE_SLTD_AUX.FECMOD IS 'Fecha de modificacion del registro';


