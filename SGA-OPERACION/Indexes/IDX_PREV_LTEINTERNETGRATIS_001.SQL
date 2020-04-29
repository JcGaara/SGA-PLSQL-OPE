-- 
-- create indice tabla PREV_LTEINTERNETGRATIS 
--

create index OPERACION.IDX_PREV_LTEINTERNETGRATIS_001 on OPERACION.PREV_LTEINTERNETGRATIS (DN_NUM)
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

