-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_TRAZA_DET_FACT
  add constraint PK_TRAZA_DET_FACT primary key (TDFAN_IDTRAZADT)
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
  /
  