-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.INVENTARIO_ENVIO_ETA_ERR
  add constraint PK_INVENTARIO_ENVIO_ETA_ERR primary key (ID_RECURSO_EXT, FECHA_INVENTARIO)
  using index 
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