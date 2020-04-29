-- Create table
create table OPERACION.TAB_TH_FACTURACION
(
  idproceso   NUMBER not null,
  id_tarea    NUMBER not null,
  estado      NUMBER default 0,
  co_id       NUMBER not null,
  tmcode      NUMBER,
  fecstart    TIMESTAMP(6),
  fecfinish   TIMESTAMP(6),
  fecusu      DATE default sysdate,
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default user,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  customer_id NUMBER,
  ch_status   VARCHAR2(30),
  ch_pending  VARCHAR2(30),
  ciclo       VARCHAR2(30),
  flg_alta    NUMBER,
  flg_unico   NUMBER,
  data_n1     NUMBER,
  data_n2     NUMBER,
  data_n3     NUMBER,
  data_v1     VARCHAR2(500),
  data_v2     VARCHAR2(1000),
  data_v3     VARCHAR2(4000),
  data_d1     DATE,
  data_d2     DATE,
  data_d3     DATE,
  passportno  VARCHAR2(15)
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
-- Add comments to the columns 
comment on column OPERACION.TAB_TH_FACTURACION.estado
  is '0= Pendiente 1=Procesado';
comment on column OPERACION.TAB_TH_FACTURACION.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.TAB_TH_FACTURACION.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.TAB_TH_FACTURACION.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.TAB_TH_FACTURACION.pcapp
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index IDX_TAB_TH_FACT_001 on OPERACION.TAB_TH_FACTURACION (CO_ID, FLG_UNICO)
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
create index IDX_TAB_TH_FACT_002 on OPERACION.TAB_TH_FACTURACION (CUSTOMER_ID, FLG_UNICO)
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
create index IDX_TAB_TH_FACT_003 on OPERACION.TAB_TH_FACTURACION (CO_ID)
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
create index IDX_TAB_TH_FACT_004 on OPERACION.TAB_TH_FACTURACION (CUSTOMER_ID)
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
create index IDX_TAB_TH_FACT_005 on OPERACION.TAB_TH_FACTURACION (CH_STATUS)
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
create index IDX_TAB_TH_FACT_006 on OPERACION.TAB_TH_FACTURACION (FLG_UNICO)
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
create index IDX_TAB_TH_FACT_007 on OPERACION.TAB_TH_FACTURACION (PASSPORTNO)
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
create index IDX_TAB_TH_FACT_008 on OPERACION.TAB_TH_FACTURACION (DATA_V1)
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
create index IDX_TAB_TH_FACT_009 on OPERACION.TAB_TH_FACTURACION (DATA_V1, FLG_UNICO)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TAB_TH_FACTURACION
  add constraint PK_TAB_TH_FACT_CO_ID primary key (IDPROCESO, ID_TAREA, CO_ID)
  using index 
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

