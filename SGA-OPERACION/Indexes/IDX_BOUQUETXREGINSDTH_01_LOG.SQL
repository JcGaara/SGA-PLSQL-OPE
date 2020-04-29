-- Create/Recreate indexes 
create index OPERACION.IDX_BOUQUETXREGINSDTH_01_LOG on OPERACION.BOUQUETXREGINSDTH_LOG (NUMREGISTRO)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 88M
    next 1M
    minextents 1
    maxextents unlimited
  );
  