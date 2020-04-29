-- Create table
create table OPERACION.PAYER_TARIFFS_JANUS
(
  start_date_dt DATE,
  tariff_id_n   NUMBER(10),
  payer_id_n    NUMBER(15),
  description_v VARCHAR2(1000),
  tariff_type_v VARCHAR2(500),
  fecusu        DATE default sysdate,
  bill_cycle_n  VARCHAR2(10)
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
create index OPERACION.IDX_PAYER_ID_N on OPERACION.PAYER_TARIFFS_JANUS (PAYER_ID_N)
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
create index OPERACION.IDX_START_DATE_DT_003 on OPERACION.PAYER_TARIFFS_JANUS (START_DATE_DT)
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
create index OPERACION.IDX_TARIFF_TYPE_V_003 on OPERACION.PAYER_TARIFFS_JANUS (TARIFF_TYPE_V)
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
create index OPERACION.IDX01_PAYER_TARIFFS_JANUS on OPERACION.PAYER_TARIFFS_JANUS (PAYER_ID_N, TARIFF_TYPE_V)
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

 

