CREATE TABLE operacion.sgat_df_proceso_tipo (
    protn_idtipoproceso  NUMBER NOT NULL,
    protv_abrev          VARCHAR2(40) NOT NULL,
    protv_descripcion    VARCHAR2(300) NOT NULL,
    protn_estado         NUMBER DEFAULT 1 NOT NULL,
    protd_fecreg         DATE DEFAULT sysdate,
    protv_usureg         VARCHAR2(50) DEFAULT user,
    protv_pcreg          VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    protv_ipreg          VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    protd_fecmod         DATE,
    protv_usumod         VARCHAR2(50),
    protv_pcmod          VARCHAR2(50),
    protv_ipmod          VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_proceso_tipo IS
    'Tabla donde se definen los tipos de procesos';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protn_idtipoproceso IS
    'Identificador del tipo de proceso';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_tipo.protv_ipmod IS
    'Ip desde donde se modificó';
