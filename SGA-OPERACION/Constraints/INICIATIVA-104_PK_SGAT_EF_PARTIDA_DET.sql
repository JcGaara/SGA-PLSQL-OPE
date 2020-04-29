-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_EF_PARTIDA_DET
  add constraint PK_SGAT_EF_PARTIDA_DET primary key (EFPDN_ID, EFPDN_IDDET)
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
