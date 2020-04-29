-- Create table
create table OPERACION.SGAT_LOG_WS_FTTH
(
  sgatn_idtransaccion NUMBER not null,
  sgatv_numserie      VARCHAR2(50),
  sgatv_metodo        VARCHAR2(30),
  sgatc_xmlenvio      CLOB default EMPTY_CLOB(),
  sgatc_xmlrespuesta  CLOB default EMPTY_CLOB(),
  sgatn_iderror       NUMBER,
  sgatv_mensajeerror  VARCHAR2(2000),
  sgatv_ip            VARCHAR2(30),
  sgatd_feccrea       DATE default SYSDATE,
  sgatv_usucrea       VARCHAR2(30) default USER
)
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
-- Create/Recreate indexes 
create index OPERACION.PK_SGATV_NUMSERIE on OPERACION.SGAT_LOG_WS_FTTH (SGATV_NUMSERIE)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_LOG_WS_FTTH
  add constraint PK_SGATN_IDTRANSACCION primary key (SGATN_IDTRANSACCION)
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

-- Grant/Revoke object privileges
grant select, insert, update, delete on OPERACION.SGAT_LOG_WS_FTTH to R_PROD;
grant select, insert, update, delete on OPERACION.SGAT_LOG_WS_FTTH to WEBSERVICE;
/