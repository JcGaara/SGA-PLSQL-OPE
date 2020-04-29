CREATE TABLE operacion.sgat_df_condicion_det (
    condn_idseq        NUMBER NOT NULL,
    condn_idcondicion  NUMBER NOT NULL,
    condn_orden        NUMBER NOT NULL,
    condv_parametro    VARCHAR2(300) NOT NULL,
    condn_idexplog     NUMBER,
    condv_valor        VARCHAR2(300) NOT NULL,
    condn_idexppost    NUMBER,
    condn_cantidad     NUMBER DEFAULT 1 NOT NULL,
    condc_script       CLOB,
    condn_estado       NUMBER DEFAULT 1 NOT NULL,
    condd_fecreg       DATE DEFAULT sysdate,
    condv_usureg       VARCHAR2(50) DEFAULT user,
    condv_pcreg        VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    condv_ipreg        VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    condd_fecmod       DATE,
    condv_usumod       VARCHAR2(50),
    condv_pcmod        VARCHAR2(50),
    condv_ipmod        VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_condicion_det IS
    'Tabla donde se encuentra el detalle de cada condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_idseq IS
    'Identificador del detalle de la condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_idcondicion IS
    'Identificador de condición';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_orden IS
    'Orden';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_parametro IS
    'Parámetro que será evaluado';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_idexplog IS
    'Identificador de la expresión lógica';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_valor IS
    'Valor con el cual el parámetro será evaluado';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_idexppost IS
    'Identificador de la expresión lógica posterior, usada para condiciones múltiples';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_cantidad IS
    'Cantidad de parámetros para la validación por SCRIPT';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condc_script IS
    'Script que realiza validación';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_condicion_det.condv_ipmod IS
    'Ip desde donde se modificó';
