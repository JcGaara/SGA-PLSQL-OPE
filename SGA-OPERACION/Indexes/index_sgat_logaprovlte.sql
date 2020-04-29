-- Create/Recreate indexes 
create index OPERACION.IDX_LOGAPROVLTE_ID_SOLOT_001 on OPERACION.SGAT_LOGAPROVLTE (LOGAN_CODSOLOT)
  tablespace OPERACION_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 8K
    minextents 1
    maxextents unlimited
  );