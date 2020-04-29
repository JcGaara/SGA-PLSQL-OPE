create table OPERACION.MIGRT_BLACKLIST_CLIENTES
( datac_codcli CHAR(8) not null )
tablespace OPERACION_DAT
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
