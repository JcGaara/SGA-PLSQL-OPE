-- Create/Recreate indexes 
create index OPERACION.IDX_EF_PARTIDA_CAB_01 on OPERACION.SGAT_EF_PARTIDA_CAB (EFPCN_ESTADO)
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
create index OPERACION.IDX_EF_PARTIDA_CAB_02 on OPERACION.SGAT_EF_PARTIDA_CAB (EFPCV_RFS_GIS)
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
