create index OPERACION.FECUSU_100 on OPERACION.NUMERO_NOALINEADO (TO_CHAR(FECUSU,'dd/MM/yyyy'))
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
