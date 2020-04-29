  create index OPERACION.IDX_INSTANCIA on OPERACION.SIAC_INSTANCIA (INSTANCIA)
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