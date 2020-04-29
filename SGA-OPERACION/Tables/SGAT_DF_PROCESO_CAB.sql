CREATE TABLE operacion.sgat_df_proceso_cab (
    procn_idproceso      NUMBER NOT NULL,
    procn_idtipoproceso  NUMBER NOT NULL,
    procv_abrev          VARCHAR2(40) NOT NULL,
    procv_descripcion    VARCHAR2(300) NOT NULL,
    procn_estado         NUMBER DEFAULT 1 NOT NULL,
    procn_idservproceso  NUMBER,
    procv_ruta           VARCHAR2(500),
    procc_cabecera       CLOB,
    procc_cuerpo         CLOB,
    procv_metodo         VARCHAR2(100),
    procn_timeout        NUMBER DEFAULT 5000,
    procd_fecreg         DATE DEFAULT sysdate,
    procv_usureg         VARCHAR2(50) DEFAULT user,
    procv_pcreg          VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    procv_ipreg          VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    procd_fecmod         DATE,
    procv_usumod         VARCHAR2(50),
    procv_pcmod          VARCHAR2(50),
    procv_ipmod          VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_proceso_cab IS
    'Tabla catálogo de los procesos';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procn_idproceso IS
    'Identificador del proceso';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procn_idtipoproceso IS
    'Identificador del tipo de proceso';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procn_idservproceso IS
    'Identificador del servidor';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_ruta IS
    'Ruta (URL de WS - ruta de SP)';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procc_cabecera IS
    'Cabecera del WS';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procc_cuerpo IS
    'Cuerpo del WS';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_metodo IS
    'Metodo del WS';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procn_timeout IS
    'Timeout del WS';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_cab.procv_ipmod IS
    'Ip desde donde se modificó';
