CREATE INDEX operacion.ix_trsdn_idtrs_001 ON
    operacion.sgat_df_transaccion_det (
        trsdn_idtrs
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