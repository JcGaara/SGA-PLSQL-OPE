CREATE TABLE operacion.sgat_df_transaccion_cab (
    trscn_idtrs          NUMBER
        CONSTRAINT nnc_trsc_trsc_id NOT NULL,
    trscn_idprocesoejec  NUMBER
        CONSTRAINT nnc_trsc_trscn_idprocesoejec NOT NULL,
    trscn_idflujo        NUMBER
        CONSTRAINT nnc_trsc_trscn_idflujo NOT NULL,
    trscn_customer_id    NUMBER,
    trscn_cod_id         NUMBER,
    trscn_tiptra         NUMBER,
    trscc_numslc         CHAR(10),
    trscn_codsolot       NUMBER,
    trscc_paramenvio     CLOB,
    trscc_paramrpta      CLOB,
    trscn_estado         NUMBER DEFAULT 1
        CONSTRAINT nnc_trsc_trscn_estado NOT NULL,
    trscn_codrpta        NUMBER,
    trscv_msjrpta        VARCHAR2(500),
    trscd_fecreg         DATE DEFAULT sysdate,
    trscv_usureg         VARCHAR2(50) DEFAULT user,
    trscv_pcreg          VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    trscv_ipreg          VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    trscd_fecmod         DATE,
    trscv_usumod         VARCHAR2(50),
    trscv_pcmod          VARCHAR2(50),
    trscv_ipmod          VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_transaccion_cab IS
    'Tabla donde se registran las peticiones de los flujos';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_idtrs IS
    'Identificador de la transacción';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_idprocesoejec IS
    'Identificador del proceso que ejecuta el flujo';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_idflujo IS
    'Identificador del flujo';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_customer_id IS
    'ID del cliente de BSCS';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_cod_id IS
    'Código de contrado de BSCS';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_tiptra IS
    'Código del tipo de trabajo';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscc_numslc IS
    'Número de proyecto';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_codsolot IS
    'Código de solicitud de orden de trabajo';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscc_paramenvio IS
    'Parámetros recibidos';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscc_paramrpta IS
    'Parámetros respondidos';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_estado IS
    'Estado de la transacción (1: Por ejecutar - 2: Ejecutado)';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscn_codrpta IS
    'Código de respuesta de la transacción';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_msjrpta IS
    'Mensaje de respuesta de la transacción';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_transaccion_cab.trscv_ipmod IS
    'Ip desde donde se modificó';
