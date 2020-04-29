  
  create index OPERACION.IDX_AGENDACHGEST_FECREG on OPERACION.AGENDAMIENTOCHGEST (FECREG)
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
