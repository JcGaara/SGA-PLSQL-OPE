-- Create/Recreate indexes 
create unique index OPERACION.IDX_ID_LOGRQT_CSR on OPERACION.LOGRQT_CSR_LTE (ID)
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