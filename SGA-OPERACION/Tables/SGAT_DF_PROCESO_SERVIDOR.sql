CREATE TABLE operacion.sgat_df_proceso_servidor (
    prosn_idservproceso  NUMBER NOT NULL,
    prosv_torre          VARCHAR2(200) NOT NULL,
    prosv_cluster        VARCHAR2(200) NOT NULL,
    prosv_abrev          VARCHAR2(40) NOT NULL,
    prosv_descripcion    VARCHAR2(300) NOT NULL,
    prosn_numnodo        NUMBER NOT NULL,
    prosv_ip             VARCHAR2(40) NOT NULL,
    prosn_puerto         NUMBER NOT NULL,
    prosv_protocolo      VARCHAR2(40) NOT NULL,
    prosn_estado         NUMBER DEFAULT 1 NOT NULL,
    prosd_fecreg         DATE DEFAULT sysdate,
    prosv_usureg         VARCHAR2(50) DEFAULT user,
    prosv_pcreg          VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    prosv_ipreg          VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    prosd_fecmod         DATE,
    prosv_usumod         VARCHAR2(50),
    prosv_pcmod          VARCHAR2(50),
    prosv_ipmod          VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_proceso_servidor IS
    'Tabla donde se definen los servidores donde se alojan los procesos (WS)';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosn_idservproceso IS
    'Identificador del servidor';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_torre IS
    'Torre donde se encuentra desplegado el servicio';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_cluster IS
    'Cluster de la torre';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosn_numnodo IS
    'Número de Nodo';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_ip IS
    'IP';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosn_puerto IS
    'Puerto';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_protocolo IS
    'Protocolo (HTTP - HTTPS)';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_proceso_servidor.prosv_ipmod IS
    'Ip desde donde se modificó';
