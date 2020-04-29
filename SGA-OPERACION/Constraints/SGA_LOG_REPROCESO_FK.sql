-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGA_LOG_REPROCESO
  add constraint PK_SGA_LOG_REPROCESO primary key (SLREN_ID_REPROCESO, SLREN_SECUENCIA)
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