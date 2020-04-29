CREATE TABLE operacion.sgat_df_condicion_tipo (
    contn_idtipocondicion  NUMBER NOT NULL,
    contv_abrev            VARCHAR2(40) NOT NULL,
    contv_descripcion      VARCHAR2(300) NOT NULL,
    contn_estado           NUMBER DEFAULT 1 NOT NULL,
    contd_fecreg           DATE DEFAULT sysdate,
    contv_usureg           VARCHAR2(50) DEFAULT user,
    contv_pcreg            VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    contv_ipreg            VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    contd_fecmod           DATE,
    contv_usumod           VARCHAR2(50),
    contv_pcmod            VARCHAR2(50),
    contv_ipmod            VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_condicion_tipo IS
    'Tabla donde se almacena los tipos de condiciones que existen';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contn_idtipocondicion IS
    'Identificador del tipo de condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_tipo.contv_ipmod IS
    'Ip desde donde se modificó';
