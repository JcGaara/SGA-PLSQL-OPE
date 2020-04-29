-- Create table
create table OPERACION.TAB_INSTALACION
(
  idlote      NUMBER,
  ori_reg     VARCHAR2(50),
  codcli      CHAR(8),
  numslc      CHAR(10),
  codsolot    NUMBER(8),
  tiptra      NUMBER(4),
  estsol      NUMBER(2),
  tipsrvs     CHAR(4),
  fecreg      DATE,
  customer_id NUMBER,
  co_id       NUMBER,
  co_id_old   NUMBER,
  numsec      NUMBER(20),
  codsrv_pvu  VARCHAR2(4),
  tiposrv     VARCHAR2(100),
  codsrv      CHAR(4),
  servicio    VARCHAR2(200),
  estinsprd   NUMBER(2),
  codinssrv   NUMBER(10),
  pid         NUMBER(10),
  montocr     NUMBER(18,4),
  tipsrv      CHAR(4),
  flgprinc    NUMBER(1),
  numero      VARCHAR2(20),
  fecini      DATE,
  fecfin      DATE,
  codprov_iw  VARCHAR2(150),
  codprov_j   VARCHAR2(100),
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
  fecusu      DATE default SYSDATE not null,
  ciclo       VARCHAR2(10)
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
create index IDX_TAB_INST_001 on OPERACION.TAB_INSTALACION (CODSOLOT)
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
create index IDX_TAB_INST_002 on OPERACION.TAB_INSTALACION (CO_ID)
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
create index IDX_TAB_INST_003 on OPERACION.TAB_INSTALACION (NUMSEC)
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
create index IDX_TAB_INST_004 on OPERACION.TAB_INSTALACION (CO_ID_OLD)
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
create index IDX_TAB_INST_005 on OPERACION.TAB_INSTALACION (CUSTOMER_ID)
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
create index IDX_TAB_INST_006 on OPERACION.TAB_INSTALACION (TIPSRVS)
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
create index IDX_TAB_INST_007 on OPERACION.TAB_INSTALACION (CODCLI)
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
create index IDX_TAB_INST_008 on OPERACION.TAB_INSTALACION (CODSRV_PVU)
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
create index IDX_TAB_INST_009 on OPERACION.TAB_INSTALACION (CODINSSRV)
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
create index IDX_TAB_INST_010 on OPERACION.TAB_INSTALACION (NUMERO)
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
create index IDX_TAB_INST_011 on OPERACION.TAB_INSTALACION (ORI_REG)
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
create index IDX_TAB_INST_012 on OPERACION.TAB_INSTALACION (ESTINSPRD)
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
create index IDX_TAB_INST_013 on OPERACION.TAB_INSTALACION (TIPOSRV)
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
create index IDX_TAB_INST_014 on OPERACION.TAB_INSTALACION (CODSRV)
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
create index IDX_TAB_INST_015 on OPERACION.TAB_INSTALACION (FLGPRINC)
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
create index IDX_TAB_INST_016 on OPERACION.TAB_INSTALACION (NUMSLC)
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

