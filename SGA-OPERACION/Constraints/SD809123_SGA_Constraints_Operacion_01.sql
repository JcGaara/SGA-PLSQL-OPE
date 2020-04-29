
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_LTE_ARCHIVO_CAB
  add constraint PK_OPE_LTE_ARCHIVO_CAB primary key (IDLOTE, ARCHIVO, BOUQUET)
  using index 
  tablespace OPERACION_DAT
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 51M
    next 1M
    minextents 1
    maxextents unlimited
  );