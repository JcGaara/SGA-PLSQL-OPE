-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGA_ORDEN_REPROCESO_ADC
  add constraint PK_SGA_ORDEN_REPROCESO_ADC primary key (SORAN_ID_REPROCESO, SORAN_SECUENCIA)
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