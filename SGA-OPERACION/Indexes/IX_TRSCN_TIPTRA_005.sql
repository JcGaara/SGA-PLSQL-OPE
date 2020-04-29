CREATE INDEX operacion.ix_trscn_tiptra_005 ON
    operacion.sgat_df_transaccion_cab (
        trscn_tiptra
    ASC )
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