-- Create/Recreate indexes 
create index OPERACION.IX_ORDEN_REP_ID_SOLOT_001 on OPERACION.SGA_ORDEN_REPROCESO_ADC (SORAN_ID_SOLOT)
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
