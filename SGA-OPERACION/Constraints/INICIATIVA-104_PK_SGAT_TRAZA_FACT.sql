alter table OPERACION.SGAT_TRAZA_FACT
  add constraint PK_SGAT_TRAZA_FACT primary key (TRFAN_IDTRAZA)
  using index 
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
  /
  