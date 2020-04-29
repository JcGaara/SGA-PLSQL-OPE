create index OPERACION.IDX01_payer_tariffs_janus on OPERACION.payer_tariffs_janus (payer_id_n, tariff_type_v)
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
