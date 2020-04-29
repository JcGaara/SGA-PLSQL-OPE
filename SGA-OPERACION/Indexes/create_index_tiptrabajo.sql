create index operacion.IDX_TIPTRABAJO_02 ON operacion.tiptrabajo (tiptra, tiptrs)
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
