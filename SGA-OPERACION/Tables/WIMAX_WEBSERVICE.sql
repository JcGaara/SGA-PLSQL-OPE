-- Create table
create table OPERACION.WIMAX_WEBSERVICE
(
  COD_WEBS     NUMBER(5) not null,
  URL_WEBS     VARCHAR2(600) not null,
  ACTION_WEBS  VARCHAR2(600) not null,
  EST_WEBS     CHAR(1),
  FEC_WEBS     DATE default SYSDATE not null,
  PROYECTO     VARCHAR2(100) not null,
  SOAP_REQ_XML VARCHAR2(2000),
  CAB_INI      CLOB,
  CAB_FIN      CLOB,
  CODUSU       VARCHAR2(30) default USER not null
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.WIMAX_WEBSERVICE
  add constraint WIMAX_WEBSERVICE_PK primary key (COD_WEBS)
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