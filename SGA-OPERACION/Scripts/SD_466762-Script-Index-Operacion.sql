CREATE INDEX OPERACION.IDX_INSSRV_IDPAQ ON OPERACION.INSSRV (IDPAQ)
  tablespace OPERACION_DAT
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
