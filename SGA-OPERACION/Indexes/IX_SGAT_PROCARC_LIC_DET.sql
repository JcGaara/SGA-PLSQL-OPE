-- Create/Recreate indexes 
create index OPERACION.IX_SGAT_PROCARC_LIC_DET on OPERACION.SGAT_PROCARC_LIC_DET (PRARI_ID_LIC_DET)
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