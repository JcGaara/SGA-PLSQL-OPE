-- Create table
create table OPERACION.LOG_TRS_INTERFACE_IW
(
  idlog        NUMBER not null,
  codcli       VARCHAR2(10),
  idtrs        NUMBER,
  codsolot     NUMBER,
  idinterface  NUMBER,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  error        NUMBER,
  texto        VARCHAR2(1000),
  customer_id  NUMBER,
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.LOG_TRS_INTERFACE_IW
  is 'Tabla de registro de log de errores interface IW';
-- Add comments to the columns 
comment on column OPERACION.LOG_TRS_INTERFACE_IW.idlog
  is 'Identificador unico de la tabla';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.codcli
  is 'Codigo de Cliente';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.idtrs
  is 'Id trs';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.codsolot
  is 'Identificador de SOT';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.idinterface
  is 'id interface';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.error
  is 'Id Error';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.texto
  is 'Texto';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.customer_id
  is 'Customer ID';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.LOG_TRS_INTERFACE_IW.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LOG_TRS_INTERFACE_IW
  add constraint PK_LOGINTERFACE_IW primary key (IDLOG)
  using index 
  tablespace OPERACION_DAT;
