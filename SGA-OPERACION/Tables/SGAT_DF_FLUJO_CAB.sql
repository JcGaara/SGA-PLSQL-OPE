CREATE TABLE operacion.sgat_df_flujo_cab (
    flucn_idflujo      NUMBER NOT NULL,
    flucn_tiptrabajo   NUMBER,
    flucv_transaccion  VARCHAR2(300),
    flucv_tecnologia   VARCHAR2(300),
    flucv_abrev        VARCHAR2(40) NOT NULL,
    flucv_descripcion  VARCHAR2(300) NOT NULL,
    flucn_estado       NUMBER DEFAULT 1 NOT NULL,
    flucn_tipo         NUMBER NOT NULL,
    flucv_sepcampo     VARCHAR2(40) DEFAULT '|' NOT NULL,
    flucv_sepregistro  VARCHAR2(40) DEFAULT '#' NOT NULL,
    flucd_fecreg       DATE DEFAULT sysdate,
    flucv_usureg       VARCHAR2(50) DEFAULT user,
    flucv_pcreg        VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    flucv_ipreg        VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    flucd_fecmod       DATE,
    flucv_usumod       VARCHAR2(50),
    flucv_pcmod        VARCHAR2(50),
    flucv_ipmod        VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_flujo_cab IS
    'Tabla cabecera de la configuración de los flujos';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucn_idflujo IS
    'Identificador del flujo';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucn_tiptrabajo IS
    'Tipo de trabajo';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_transaccion IS
    'Transacción';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_tecnologia IS
    'Tecnología';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_abrev IS
    'Abreviación';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_descripcion IS
    'Descripción';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucn_tipo IS
    'Tipo (1: Flujo para WS - 2: Flujo para SP)';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_sepcampo IS
    'Separador de campo para registrar las transacciones y evaluar las condiciones del flujo';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_sepregistro IS
    'Separador de registros para registrar las transacciones  del flujo';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_flujo_cab.flucv_ipmod IS
    'Ip desde donde se modificó';
