create table OPERACION.MIGRT_BLACKLIST_PLANES
( datac_codsrv CHAR(4) not null)
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
alter table OPERACION.MIGRT_BLACKLIST_PLANES
  add constraint PK_MIGRT_CODSRV primary key (DATAC_CODSRV)
  using index 
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
