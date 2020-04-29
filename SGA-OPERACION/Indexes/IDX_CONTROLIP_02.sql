create index OPERACION.IDX_CONTROLIP_02 on OPERACION.CONTROLIP (COD_SOLOT)
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
