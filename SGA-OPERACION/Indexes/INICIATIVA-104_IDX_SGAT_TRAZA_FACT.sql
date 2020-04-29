-- Create/Recreate indexes 
create index OPERACION.IDX_TRAZA_DET_FACT_IDTRAZADT on OPERACION.SGAT_TRAZA_DET_FACT (TDFAN_IDTRAZADT, TRFAN_IDTRAZA)
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
  
create index OPERACION.IDX_TRAZA_DET_FACT_ESTADO on OPERACION.SGAT_TRAZA_DET_FACT (TDFAV_ESTADO)
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
/
  