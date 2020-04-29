-- Create/Recreate indexes 
create index OPERACION.IX_DET_TRAS_EXT_CUSTOMER_ID on OPERACION.SHFCT_DET_TRAS_EXT (SHFCI_CUSTOMER_ID)
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
