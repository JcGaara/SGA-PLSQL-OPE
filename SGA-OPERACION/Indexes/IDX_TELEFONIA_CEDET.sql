 create index OPERACION.IDX_TELEFONIA_CEDET on OPERACION.TELEFONIA_CE_DET (ID_TELEFONIA_CE)
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