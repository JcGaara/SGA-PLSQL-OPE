create index sales.idx_tystabsrv_01 ON sales.tystabsrv (codsrv,idproducto)
  tablespace SALES_IDX
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