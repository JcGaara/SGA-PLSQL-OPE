-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_PROCARC_LIC_DET
  add constraint PK_SGA_PROCARC_LIC_DET primary key (PRARI_SECUENCIA)
  using index 
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
  
  alter table OPERACION.SGAT_PROCARC_LIC_DET
  add constraint FK_PROLICDET_PROARCH foreign key (PRARI_ID_LIC_DET)
  references OPERACION.SGAT_PROCESO_LIC_DET (LICDI_SECUENCIA);