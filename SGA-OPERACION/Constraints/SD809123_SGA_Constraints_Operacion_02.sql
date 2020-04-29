-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_LTE_LOTE_SLTD_AUX
  add constraint PK_OPE_LTE_LOTE_SLTD_AUX primary key (IDLOTE)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 2M
    next 1M
    minextents 1
    maxextents unlimited
  );