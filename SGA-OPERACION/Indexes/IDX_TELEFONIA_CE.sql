  create index OPERACION.IDX_TELEFONIA_CE on OPERACION.TELEFONIA_CE (IDWF,ID_TELEFONIA_CE,IDTAREAWF)
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