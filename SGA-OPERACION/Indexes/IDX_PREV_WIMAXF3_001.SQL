-- 
-- create indice tabla PREV_WIMAXF3 
--

create index OPERACION.IDX_PREV_WIMAXF3_001 on OPERACION.PREV_WIMAXF3 (CUSTOMER_ID)
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
