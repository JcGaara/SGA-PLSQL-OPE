 create index OPERACION.IDX_TELEFONIA_CE_error on OPERACION.TELEFONIA_CE (ID_ERROR)
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
  