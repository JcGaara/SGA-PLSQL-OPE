CREATE TABLE operacion.sgat_df_condicion_cab (
    concn_idcondicion      NUMBER NOT NULL,
    concn_idtipocondicion  NUMBER NOT NULL,
    concv_abrev            VARCHAR2(40) NOT NULL,
    concv_descripcion      VARCHAR2(300) NOT NULL,
    concn_estado           NUMBER DEFAULT 1 NOT NULL,
    concd_fecreg           DATE DEFAULT sysdate,
    concv_usureg           VARCHAR2(50) DEFAULT user,
    concv_pcreg            VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    concv_ipreg            VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    concd_fecmod           DATE,
    concv_usumod           VARCHAR2(50),
    concv_pcmod            VARCHAR2(50),
    concv_ipmod            VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_condicion_cab IS
    'Tabla de condiciones del flujo';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concn_idcondicion IS
    'Identificador de condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concn_idtipocondicion IS
    'Identificador del tipo de condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_cab.concv_ipmod IS
    'Ip desde donde se modificó';
