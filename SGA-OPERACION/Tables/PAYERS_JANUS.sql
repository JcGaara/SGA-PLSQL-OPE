-- Create table
create table OPERACION.PAYERS_JANUS
(
  payer_id_n          NUMBER(15),
  external_payer_id_v VARCHAR2(20),
  numero              VARCHAR2(20),
  payer_status_n      NUMBER(3),
  bill_cycle_n        VARCHAR2(10),
  payer_id_3_n        NUMBER(15),
  customer_id         VARCHAR2(50),
  fecusu              DATE default sysdate,
  idproceso           NUMBER,
  id_tarea            NUMBER,
  estado              NUMBER
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
create index OPERACION.IDX_CUSTOMER_ID on OPERACION.PAYERS_JANUS (CUSTOMER_ID)
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
create index OPERACION.IDX_NUMERO_001 on OPERACION.PAYERS_JANUS (NUMERO)
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
create index OPERACION.IDX_PAYER_ID_N_002 on OPERACION.PAYERS_JANUS (PAYER_ID_N)
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
create index OPERACION.IDX_PAYER_ID_N_003 on OPERACION.PAYERS_JANUS (PAYER_ID_3_N)
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

 
