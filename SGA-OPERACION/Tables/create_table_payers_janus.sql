create table OPERACION.PAYERS_JANUS
(
  PAYER_ID_N          NUMBER(15),
  EXTERNAL_PAYER_ID_V VARCHAR2(20),
  NUMERO              VARCHAR2(20),
  PAYER_STATUS_N      NUMBER(3),
  BILL_CYCLE_N        VARCHAR2(50)
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
