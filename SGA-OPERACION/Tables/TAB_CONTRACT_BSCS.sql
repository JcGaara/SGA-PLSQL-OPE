
-- Create table
create table OPERACION.TAB_CONTRACT_BSCS
(
  customer_id NUMBER,
  codsolot    NUMBER,
  co_id       NUMBER,
  co_id_old   NUMBER,
  codcli      VARCHAR2(20),
  numero      VARCHAR2(20),
  estsol      NUMBER,
  ciclo       VARCHAR2(10),
  codplan     NUMBER,
  dn_num      VARCHAR2(20),
  codinssrv   NUMBER,
  ch_status   VARCHAR2(20),
  ch_pending  VARCHAR2(20),
  estinssrv   NUMBER,
  fecultest   DATE,
  flg_unico   NUMBER,
  descripcion VARCHAR2(4000),
  observacion VARCHAR2(4000),
  transaccion VARCHAR2(4000),
  num01       NUMBER,
  num02       NUMBER,
  num03       NUMBER,
  num04       NUMBER,
  num05       NUMBER,
  num06       NUMBER,
  num07       NUMBER,
  num08       NUMBER,
  num09       NUMBER,
  num10       NUMBER,
  var01       VARCHAR2(500),
  var02       VARCHAR2(500),
  var03       VARCHAR2(1000),
  var04       VARCHAR2(1000),
  var05       VARCHAR2(2000),
  var06       VARCHAR2(2000),
  var07       VARCHAR2(2000),
  var08       VARCHAR2(4000),
  var09       VARCHAR2(4000),
  var10       VARCHAR2(4000),
  var11       VARCHAR2(4000),
  var12       VARCHAR2(4000),
  codusu      VARCHAR2(25) default USER,
  fecusu      DATE default SYSDATE
)
tablespace OPERACION_IDX
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_01 on OPERACION.TAB_CONTRACT_BSCS (CODSOLOT)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_02 on OPERACION.TAB_CONTRACT_BSCS (CO_ID)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_03 on OPERACION.TAB_CONTRACT_BSCS (CUSTOMER_ID)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_04 on OPERACION.TAB_CONTRACT_BSCS (CO_ID_OLD)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_06 on OPERACION.TAB_CONTRACT_BSCS (ESTSOL)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_07 on OPERACION.TAB_CONTRACT_BSCS (CODCLI)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_08 on OPERACION.TAB_CONTRACT_BSCS (CODPLAN)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_09 on OPERACION.TAB_CONTRACT_BSCS (CH_STATUS)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_10 on OPERACION.TAB_CONTRACT_BSCS (CH_PENDING)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_11 on OPERACION.TAB_CONTRACT_BSCS (ESTINSSRV)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_12 on OPERACION.TAB_CONTRACT_BSCS (FECULTEST)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_13 on OPERACION.TAB_CONTRACT_BSCS (DESCRIPCION)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index OPERACION.IDX_TAB_CONTRACT_BSCS_14 on OPERACION.TAB_CONTRACT_BSCS (OBSERVACION)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index OPERACION.IDX_TAB_CONTRACT_BSCS_15 on OPERACION.TAB_CONTRACT_BSCS (NUM01)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_16 on OPERACION.TAB_CONTRACT_BSCS (NUM02)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_17 on OPERACION.TAB_CONTRACT_BSCS (NUM05)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_18 on OPERACION.TAB_CONTRACT_BSCS (NUM06)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_19 on OPERACION.TAB_CONTRACT_BSCS (NUM07)
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
create index OPERACION.IDX_TAB_CONTRACT_BSCS_20 on OPERACION.TAB_CONTRACT_BSCS (VAR09)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index OPERACION.IDX_TAB_CONTRACT_BSCS_21 on OPERACION.TAB_CONTRACT_BSCS (VAR10)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index OPERACION.IDX_TAB_CONTRACT_BSCS_22 on OPERACION.TAB_CONTRACT_BSCS (VAR11)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index OPERACION.IDX_TAB_CONTRACT_BSCS_23 on OPERACION.TAB_CONTRACT_BSCS (VAR12)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 167
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );