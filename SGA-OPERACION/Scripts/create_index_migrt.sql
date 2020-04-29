create index OPERACION.ID_IDCODCLICAB on OPERACION.MIGRT_CAB_TEMP_SOT (DATAC_CODCLI)
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
  
  create index OPERACION.ID_CODSRV on OPERACION.MIGRT_DET_TEMP_SOT (DATAC_CODSRV)
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
  
  -- Create/Recreate indexes 
create index OPERACION.ID_IDCODCLI on OPERACION.MIGRT_DATAPRINC (DATAC_CODCLI)
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
create index OPERACION.ID_IDTIPSRV on OPERACION.MIGRT_DATAPRINC (DATAC_TIPSRV)
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
  
  commit;
