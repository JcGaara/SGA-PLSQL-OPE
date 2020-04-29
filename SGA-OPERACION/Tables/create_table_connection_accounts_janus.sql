create table OPERACION.CONNECTION_ACCOUNTS_JANUS
(
  START_DATE_DT DATE,
  ACCOUNT_ID_N  NUMBER(15),
  PAYER_ID_0_N  NUMBER(15),
  PAYER_ID_3_N  NUMBER(15),
  CUSTOMER_ID   VARCHAR2(20)
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