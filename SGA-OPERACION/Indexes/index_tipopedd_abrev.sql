create index OPERACION.IX_TIPOPEDD_002 on OPERACION.TIPOPEDD (ABREV)
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
