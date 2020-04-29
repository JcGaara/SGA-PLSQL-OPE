-- create index 
create index OPERACION.IDX_TMPCD_V01 on operacion.tmp_capacidad(ID_AGENDA)
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
  