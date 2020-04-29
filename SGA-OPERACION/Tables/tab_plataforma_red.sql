-- Create table
create table OPERACION.TAB_PLATAFORMA_RED
(
  idlote      NUMBER,
  orireg      VARCHAR2(50),
  tipsrv      VARCHAR2(10),
  interface   VARCHAR2(100),
  numserie    VARCHAR2(100),
  macaddress  VARCHAR2(100),
  unitaddress VARCHAR2(100),
  codprov     VARCHAR2(100),
  status      VARCHAR2(100),
  central     VARCHAR2(400),
  data_n1     NUMBER,
  data_n2     NUMBER,
  data_n3     NUMBER,
  data_n4     NUMBER,
  data_n5     NUMBER,
  data_v1     VARCHAR2(500),
  data_v2     VARCHAR2(500),
  data_v3     VARCHAR2(1000),
  data_v4     VARCHAR2(4000),
  data_v5     VARCHAR2(4000),
  data_d1     DATE,
  data_d2     DATE,
  data_d3     DATE,
  fecusu      DATE default SYSDATE not null
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
create index IDX_TAB_PLATAFORMA_RED_001 on OPERACION.TAB_PLATAFORMA_RED (IDLOTE)
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
create index IDX_TAB_PLATAFORMA_RED_002 on OPERACION.TAB_PLATAFORMA_RED (MACADDRESS)
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
create index IDX_TAB_PLATAFORMA_RED_003 on OPERACION.TAB_PLATAFORMA_RED (NUMSERIE)
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
create index IDX_TAB_PLATAFORMA_RED_004 on OPERACION.TAB_PLATAFORMA_RED (UNITADDRESS)
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
create index IDX_TAB_PLATAFORMA_RED_005 on OPERACION.TAB_PLATAFORMA_RED (TIPSRV)
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
create index IDX_TAB_PLATAFORMA_RED_006 on OPERACION.TAB_PLATAFORMA_RED (DATA_D1)
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
create index IDX_TAB_PLATAFORMA_RED_007 on OPERACION.TAB_PLATAFORMA_RED (DATA_D2)
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
create index IDX_TAB_PLATAFORMA_RED_008 on OPERACION.TAB_PLATAFORMA_RED (ORIREG)
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
create index IDX_TAB_PLATAFORMA_RED_009 on OPERACION.TAB_PLATAFORMA_RED (INTERFACE)
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
create index IDX_TAB_PLATAFORMA_RED_010 on OPERACION.TAB_PLATAFORMA_RED (DATA_V1)
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
create index IDX_TAB_PLATAFORMA_RED_011 on OPERACION.TAB_PLATAFORMA_RED (DATA_N1)
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
create index IDX_TAB_PLATAFORMA_RED_012 on OPERACION.TAB_PLATAFORMA_RED (DATA_V2)
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
create index IDX_TAB_PLATAFORMA_RED_013 on OPERACION.TAB_PLATAFORMA_RED (ORIREG, NUMSERIE)
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

