CREATE INDEX operacion.ix_trsdn_idtrs_idproceso_002 ON
    operacion.sgat_df_transaccion_det (
        trsdn_idtrs
    ASC,
        trsdn_idproceso
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