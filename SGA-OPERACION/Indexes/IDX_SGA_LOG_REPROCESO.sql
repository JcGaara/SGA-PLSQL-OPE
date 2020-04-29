-- Create/Recreate indexes 
create index OPERACION.IX_ORDEN_REP_ID_AGENDA_003 on OPERACION.SGA_LOG_REPROCESO (SLREN_ID_AGENDA)
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
create index OPERACION.IX_ORDEN_REP_ID_SOLOT_002 on OPERACION.SGA_LOG_REPROCESO (SLREN_ID_SOLOT)
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