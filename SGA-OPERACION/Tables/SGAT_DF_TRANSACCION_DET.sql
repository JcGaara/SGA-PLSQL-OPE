CREATE TABLE operacion.sgat_df_transaccion_det (
    trsdn_idseq       NUMBER
        CONSTRAINT nnc_trsd_trsdn_idseq NOT NULL,
    trsdn_idtrs       NUMBER
        CONSTRAINT nnc_trsd_trsdn_idtrs NOT NULL,
    trsdn_orden       NUMBER
        CONSTRAINT nnc_trsd_trsdn_orden NOT NULL,
    trsdn_idproceso   NUMBER
        CONSTRAINT nnc_trsd_trsdn_idproceso NOT NULL,
    trsdc_paramenvio  CLOB,
    trsdc_paramrpta   CLOB,
    trsdn_estado      NUMBER DEFAULT 1
        CONSTRAINT nnc_trsd_trsdn_estado NOT NULL,
    trsdn_numintento  NUMBER DEFAULT 0
        CONSTRAINT nnc_trsd_trsdn_numintento NOT NULL,
    trsdn_codrpta     NUMBER,
    trsdv_msjrpta     VARCHAR2(500),
    trsdd_fecreg      DATE DEFAULT sysdate,
    trsdv_usureg      VARCHAR2(50) DEFAULT user,
    trsdv_pcreg       VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    trsdv_ipreg       VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    trsdd_fecmod      DATE,
    trsdv_usumod      VARCHAR2(50),
    trsdv_pcmod       VARCHAR2(50),
    trsdv_ipmod       VARCHAR2(20)
)
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

COMMENT ON TABLE operacion.sgat_df_transaccion_det IS
    'Tabla donde se registran los estados y respuestas de los procesos';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_idseq IS
    'Identificador del detalle de la transacción';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_idtrs IS
    'Identificador de la transacción';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_orden IS
    'Orden';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_idproceso IS
    'Identificador del proceso';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdc_paramenvio IS
    'Parámetros recibidos por el proceso';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdc_paramrpta IS
    'Parámetros respondidos por el proceso';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_estado IS
    'Estado (1: Por ejecutar - 2: Ejecutado - 0: No ejecutado)';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_numintento IS
    'Número de intento de ejecución';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdn_codrpta IS
    'Código de respuesta del proceso';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_msjrpta IS
    'Mensaje de respuesta del proceso';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_transaccion_det.trsdv_ipmod IS
    'Ip desde donde se modificó';
