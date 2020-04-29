-- Create table
create table OPERACION.TAB_VENTA
(
  idlote       NUMBER,
  tipsrv       VARCHAR2(50),
  id_contrato  NUMBER,
  numsec       NUMBER,
  nrodocumento VARCHAR2(20),
  customer_id  NUMBER,
  sot          NUMBER,
  estado       VARCHAR2(50),
  feccontrato  DATE,
  co_id        NUMBER,
  slpln_codigo NUMBER,
  campv_codigo VARCHAR2(4),
  tmcode       VARCHAR2(10),
  idservicio   VARCHAR2(4),
  desservicio  VARCHAR2(500),
  cf_precio    NUMBER(9,2),
  flgprincipal NUMBER,
  sncode       NUMBER,
  codprov_iw   VARCHAR2(150),
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
create index IDX_TAB_VENTA_001 on OPERACION.TAB_VENTA (TIPSRV)
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
create index IDX_TAB_VENTA_002 on OPERACION.TAB_VENTA (ID_CONTRATO)
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
create index IDX_TAB_VENTA_003 on OPERACION.TAB_VENTA (NUMSEC)
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
create index IDX_TAB_VENTA_004 on OPERACION.TAB_VENTA (SOT)
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
create index IDX_TAB_VENTA_005 on OPERACION.TAB_VENTA (CUSTOMER_ID)
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
create index IDX_TAB_VENTA_006 on OPERACION.TAB_VENTA (CO_ID)
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
create index IDX_TAB_VENTA_007 on OPERACION.TAB_VENTA (IDSERVICIO)
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
create index IDX_TAB_VENTA_008 on OPERACION.TAB_VENTA (SNCODE)
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

