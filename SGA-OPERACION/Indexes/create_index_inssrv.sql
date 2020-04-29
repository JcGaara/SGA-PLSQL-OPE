create index operacion.IDX_inssrv_15 ON operacion.inssrv (codinssrv,tipinssrv)
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
