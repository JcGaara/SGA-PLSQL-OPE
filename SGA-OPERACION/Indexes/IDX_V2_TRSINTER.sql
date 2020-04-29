/*creacion de index*/
create index OPERACION.IDX_V2_TRSINTER on OPERACION.TRS_INTERFACE_IW (PIDSGA)
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