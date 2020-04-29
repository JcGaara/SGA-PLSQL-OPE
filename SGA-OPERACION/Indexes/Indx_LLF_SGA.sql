create index TELEFONIA.IDX_LILIFI on TELEFONIA.NUMTEL (ESTNUMTEL)
  tablespace APP_AUX_DAT
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