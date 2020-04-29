-- Create/Recreate indexes 
create index OPERACION.IDX_OPE_LTE_ARCHIVO_DET on OPERACION.OPE_LTE_ARCHIVO_DET (IDLOTE, ARCHIVO, BOUQUET, SERIE)
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