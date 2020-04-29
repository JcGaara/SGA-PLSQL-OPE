create index OPERACION.IDX_SOLOTPTO_009 on OPERACION.SOLOTPTO (PID_OLD)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 368M
    next 1M
    minextents 1
    maxextents unlimited
  );