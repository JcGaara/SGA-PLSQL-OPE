create table OPERACION.T_DATA_IMS
(
  linea VARCHAR2(20),
  mac   VARCHAR2(40)
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
