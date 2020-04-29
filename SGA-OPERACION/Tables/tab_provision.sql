-- Create table
create table OPERACION.TAB_PROVISION
(
  idlote             NUMBER,
  ori_reg            VARCHAR2(50),
  codcli             VARCHAR2(20),
  idproducto         NUMBER,
  idventa            NUMBER,
  hub                VARCHAR2(50),
  nodo               VARCHAR2(50),
  macaddress         VARCHAR2(100),
  disabled           NUMBER,
  servicepackagename VARCHAR2(50),
  idispcrm           VARCHAR2(50),
  activationcode     VARCHAR2(50),
  serialnumber       VARCHAR2(100),
  fechaalta          DATE,
  fechaactivacion    DATE,
  cantpcs            NUMBER,
  mensaje            VARCHAR2(50),
  fec_susp           DATE,
  idcablemodem       NUMBER not null,
  estado             NUMBER default 0,
  data_n1            NUMBER,
  data_n2            NUMBER,
  data_n3            NUMBER,
  data_n4            NUMBER,
  data_n5            NUMBER,
  data_v1            VARCHAR2(500),
  data_v2            VARCHAR2(500),
  data_v3            VARCHAR2(1000),
  data_v4            VARCHAR2(4000),
  data_v5            VARCHAR2(4000),
  data_d3            DATE,
  data_d4            DATE,
  data_d5            DATE,
  fecusu             DATE default SYSDATE not null
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
create index IDX_TAB_PROV_001 on OPERACION.TAB_PROVISION (NODO)
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
create index IDX_TAB_PROV_002 on OPERACION.TAB_PROVISION (MACADDRESS)
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
create index IDX_TAB_PROV_003 on OPERACION.TAB_PROVISION (SERVICEPACKAGENAME)
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
create index IDX_TAB_PROV_004 on OPERACION.TAB_PROVISION (IDISPCRM)
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
create index IDX_TAB_PROV_005 on OPERACION.TAB_PROVISION (SERIALNUMBER)
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
create index IDX_TAB_PROV_006 on OPERACION.TAB_PROVISION (CODCLI)
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
create index IDX_TAB_PROV_007 on OPERACION.TAB_PROVISION (DATA_N1)
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
create index IDX_TAB_PROV_008 on OPERACION.TAB_PROVISION (DATA_N2)
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
create index IDX_TAB_PROV_009 on OPERACION.TAB_PROVISION (DATA_V2)
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
create index IDX_TAB_PROV_012 on OPERACION.TAB_PROVISION (ORI_REG)
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
create index IDX_TAB_PROV_013 on OPERACION.TAB_PROVISION (DATA_V1)
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
alter table OPERACION.TAB_PROVISION
  add constraint PK_REGCM001 primary key (IDCABLEMODEM)
  disable;
alter table OPERACION.TAB_PROVISION
  add constraint PK_REGCM002 unique (CODCLI, IDPRODUCTO, IDVENTA)
  disable;

