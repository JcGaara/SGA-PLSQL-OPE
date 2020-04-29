create index OPERACION.IDX01_payers_janus on OPERACION.payers_janus(payer_id_n)
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
