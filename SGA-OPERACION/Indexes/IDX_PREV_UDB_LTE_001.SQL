-- 
-- create indice tabla PREV_UDB_LTE 
--

create index OPERACION.IDX_PREV_UDB_LTE_001 on OPERACION.PREV_UDB_LTE (NUM_MODIF)
  tablespace operacion_dat
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

