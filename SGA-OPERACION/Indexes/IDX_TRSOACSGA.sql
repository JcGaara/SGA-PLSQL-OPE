-- Create/Recreate indexes 
create index OPERACION.IDX_TRSOACSG_CODSOT on OPERACION.TRSOACSGA (CODSOLOT)
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