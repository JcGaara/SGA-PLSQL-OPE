-- 
-- create indice tabla PREV_PCRF
--

create index OPERACION.IDX_PREV_PCRF_001 on OPERACION.PREV_PCRF (LINEA)
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

