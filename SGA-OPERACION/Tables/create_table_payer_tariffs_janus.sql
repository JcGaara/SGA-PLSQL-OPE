create table OPERACION.PAYER_TARIFFS_JANUS
(
  START_DATE_DT DATE,
  TARIFF_ID_N   NUMBER(10),
  PAYER_ID_N    NUMBER(15),
  DESCRIPTION_V VARCHAR2(50),
  TARIFF_TYPE_V VARCHAR2(50)
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