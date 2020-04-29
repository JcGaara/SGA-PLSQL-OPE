CREATE TABLE operacion.sgat_df_proceso_det (
    prodn_idseq                 NUMBER NOT NULL,
    prodn_idflujo               NUMBER NOT NULL,
    prodn_idprocesopre          NUMBER NOT NULL,
    prodv_campopre              VARCHAR2(300),
    prodn_idprocesopost         NUMBER NOT NULL,
    prodv_campopost             VARCHAR2(300),
    prodc_flgtransformacion     CHAR(2) DEFAULT 'NO',
    prodc_scripttransformacion  CLOB,
    prodn_estado                NUMBER DEFAULT 1 NOT NULL,
    prodd_fecreg                DATE DEFAULT sysdate,
    prodv_usureg                VARCHAR2(50) DEFAULT user,
    prodv_pcreg                 VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    prodv_ipreg                 VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    prodd_fecmod                DATE,
    prodv_usumod                VARCHAR2(50),
    prodv_pcmod                 VARCHAR2(50),
    prodv_ipmod                 VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_proceso_det IS
    'Tabla donde se almacena la interrelación entre parámetros de los procesos para un flujo';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodn_idseq IS
    'Identificador del detalle del proceso';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodn_idflujo IS
    'Identificador del flujo';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodn_idprocesopre IS
    'Identificador del proceso previo';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_campopre IS
    'Campo del proceso previo';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodn_idprocesopost IS
    'Identificador del proceso posterior';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_campopost IS
    'Campo del proceso posterior';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodc_flgtransformacion IS
    'Flag que indica si se debe realizar una transformación al valor del CAMPOPRE (SI - NO)';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodc_scripttransformacion IS
    'Script de transformación del valor del CAMPOPRE para llenarse en el CAMPOPOST';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_det.prodv_ipmod IS
    'Ip desde donde se modificó';
