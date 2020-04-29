CREATE TABLE operacion.sgat_df_flujo_det (
    fludn_idseq           NUMBER NOT NULL,
    fludn_idflujo         NUMBER NOT NULL,
    fludn_orden           NUMBER NOT NULL,
    fludn_idproceso       NUMBER NOT NULL,
    fludv_preproceso      VARCHAR2(300),
    fludv_postproceso     VARCHAR2(300),
    fludc_flgmandatorio   CHAR(2) DEFAULT 'SI' NOT NULL,
    fludn_ordencondicion  NUMBER,
    fludn_idcondicion     NUMBER,
    fludc_flgregtrs       CHAR(2) DEFAULT 'NO' NOT NULL,
    fludn_reintentos      NUMBER DEFAULT 1 NOT NULL,
    fludn_idprocesoerror  VARCHAR2(100),
    fludn_estado          NUMBER DEFAULT 1 NOT NULL,
    fludd_fecreg          DATE DEFAULT sysdate,
    fludv_usureg          VARCHAR2(50) DEFAULT user,
    fludv_pcreg           VARCHAR2(50) DEFAULT sys_context('USERENV', 'TERMINAL'),
    fludv_ipreg           VARCHAR2(20) DEFAULT sys_context('USERENV', 'IP_ADDRESS'),
    fludd_fecmod          DATE,
    fludv_usumod          VARCHAR2(50),
    fludv_pcmod           VARCHAR2(50),
    fludv_ipmod           VARCHAR2(20)
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

COMMENT ON TABLE operacion.sgat_df_flujo_det IS
    'Tabla donde se definen los flujos';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_idseq IS
    'Identificador de detalle del flujo';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_idflujo IS
    'Identificador del flujo';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_orden IS
    'Orden';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_idproceso IS
    'Identificador del proceso';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_preproceso IS
    'Identificador de los procesos precedentes';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_postproceso IS
    'Identificador de los procesos posteriores';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludc_flgmandatorio IS
    'Flag que indica si la ejecución correcta del servicio es mandatorio u opcional (SI - NO)';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_ordencondicion IS
    'Orden de ejecución de la condición';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_idcondicion IS
    'Identificador de condición';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludc_flgregtrs IS
    'Flag que indica si la ejecución del proceso debe registrarse en el LOG antes de la ejecución del siguiente (SI - NO)';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_reintentos IS
    'Cantidad de reintentos que se puede ejecutar el proceso';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_idprocesoerror IS
    'Proceso a ejecutarse en caso ocurra un error y sobrepase la cantidad de reintentos';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludn_estado IS
    'Estado (1: Activo - 0: Inactivo)';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludd_fecreg IS
    'Fecha de registro';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_usureg IS
    'Usuario que registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_pcreg IS
    'PC desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_ipreg IS
    'Ip desde donde se registró';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludd_fecmod IS
    'Fecha de modificación';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_usumod IS
    'Usuario que modificó';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_pcmod IS
    'PC desde donde se modificó';

COMMENT ON COLUMN operacion.sgat_df_flujo_det.fludv_ipmod IS
    'Ip desde donde se modificó';
