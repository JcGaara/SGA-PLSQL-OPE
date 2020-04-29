-- Create table
create table OPERACION.CONNECTION_ACCOUNTS_JANUS
(
  start_date_dt DATE,
  account_id_n  NUMBER(15),
  payer_id_0_n  NUMBER(15),
  payer_id_3_n  NUMBER(15),
  fecusu        DATE default sysdate,
  customer_id   VARCHAR2(50)
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
create index OPERACION.IDX_PAYER_ID_0_N_001 on OPERACION.CONNECTION_ACCOUNTS_JANUS (PAYER_ID_0_N)
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
create index OPERACION.IDX_PAYER_ID_3_N_001 on OPERACION.CONNECTION_ACCOUNTS_JANUS (PAYER_ID_3_N)
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
create index OPERACION.IDX_START_DATE_DT_001 on OPERACION.CONNECTION_ACCOUNTS_JANUS (START_DATE_DT)
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

 

