-- Create table
create table OPERACION.TAB_FACTURACION
(
  idlote       NUMBER,
  ori_reg      VARCHAR2(50),
  customer_id  NUMBER,
  co_id        NUMBER,
  ch_status    VARCHAR2(100),
  ch_pending   VARCHAR2(100),
  ch_validfrom DATE,
  tmcode       NUMBER,
  ciclo        NUMBER,
  tiposrv      VARCHAR2(30),
  flgprinc     NUMBER,
  sncode       NUMBER,
  servicio     VARCHAR2(30),
  numero       VARCHAR2(30),
  cargo_fijo   FLOAT,
  date_billed  DATE,
  estsrv       VARCHAR2(5),
  codplanj     VARCHAR2(30),
  data_n1      NUMBER,
  data_n2      NUMBER,
  data_n3      NUMBER,
  data_n4      NUMBER,
  data_n5      NUMBER,
  data_v1      VARCHAR2(500),
  data_v2      VARCHAR2(500),
  data_v3      VARCHAR2(1000),
  data_v4      VARCHAR2(4000),
  data_v5      VARCHAR2(4000),
  data_d1      DATE,
  data_d2      DATE,
  data_d3      DATE,
  fecusu       DATE default SYSDATE not null
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
-- Create/Recreate indexes 
create index IDX_TAB_FAC_001 on OPERACION.TAB_FACTURACION (ORI_REG)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_002 on OPERACION.TAB_FACTURACION (CUSTOMER_ID)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_003 on OPERACION.TAB_FACTURACION (CO_ID)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_004 on OPERACION.TAB_FACTURACION (SNCODE)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_005 on OPERACION.TAB_FACTURACION (NUMERO)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_006 on OPERACION.TAB_FACTURACION (CH_STATUS)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_007 on OPERACION.TAB_FACTURACION (TIPOSRV)
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TAB_FAC_008 on OPERACION.TAB_FACTURACION (CO_ID, TIPOSRV, FLGPRINC)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

