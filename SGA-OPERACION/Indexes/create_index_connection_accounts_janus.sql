create index OPERACION.IDX01_connec_accounts_janus on OPERACION.connection_accounts_janus(payer_id_0_n)
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