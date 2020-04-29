-- Create table
create table OPERACION.TAB_TH_INSTALACION
(
  idproceso   NUMBER not null,
  id_tarea    NUMBER not null,
  estado      NUMBER default 0,
  codsolot    NUMBER not null,
  fecstart    TIMESTAMP(6),
  fecfinish   TIMESTAMP(6),
  fecusu      DATE default sysdate,
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default user,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  estsol      NUMBER,
  tiptra      VARCHAR2(50),
  tipsrv      VARCHAR2(50),
  customer_id NUMBER,
  cod_id      NUMBER,
  cod_id_old  NUMBER,
  flg_min     NUMBER,
  flg_max     NUMBER,
  data_n1     NUMBER,
  data_n2     NUMBER,
  data_n3     NUMBER,
  data_v1     VARCHAR2(500),
  data_v2     VARCHAR2(1000),
  data_v3     VARCHAR2(4000),
  data_d1     DATE,
  data_d2     DATE,
  data_d3     DATE,
  ntdide      VARCHAR2(15)
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
comment on column OPERACION.TAB_TH_INSTALACION.estado
  is '0= Pendiente 1=Procesado';
comment on column OPERACION.TAB_TH_INSTALACION.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.TAB_TH_INSTALACION.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.TAB_TH_INSTALACION.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.TAB_TH_INSTALACION.pcapp
  is 'PC Aplicacion';
-- Create/Recreate indexes 
create index IDX_TAB_TH_INST_001 on OPERACION.TAB_TH_INSTALACION (CODSOLOT)
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
create index IDX_TAB_TH_INST_002 on OPERACION.TAB_TH_INSTALACION (CUSTOMER_ID)
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
create index IDX_TAB_TH_INST_003 on OPERACION.TAB_TH_INSTALACION (COD_ID)
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
create index IDX_TAB_TH_INST_004 on OPERACION.TAB_TH_INSTALACION (TIPTRA)
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
create index IDX_TAB_TH_INST_005 on OPERACION.TAB_TH_INSTALACION (ESTSOL)
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
create index IDX_TAB_TH_INST_006 on OPERACION.TAB_TH_INSTALACION (FLG_MIN)
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
create index IDX_TAB_TH_INST_007 on OPERACION.TAB_TH_INSTALACION (FLG_MAX)
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
create index IDX_TAB_TH_INST_008 on OPERACION.TAB_TH_INSTALACION (DATA_V1)
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
create index IDX_TAB_TH_INST_009 on OPERACION.TAB_TH_INSTALACION (NTDIDE)
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
create index IDX_TAB_TH_INST_010 on OPERACION.TAB_TH_INSTALACION (DATA_N1)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TAB_TH_INSTALACION
  add constraint PK_TAB_TH_INSTALACION_CODSOLOT primary key (IDPROCESO, ID_TAREA, CODSOLOT)
  using index 
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


