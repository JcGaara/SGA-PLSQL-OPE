-- Create table
create table OPERACION.LOG_ERROR_PROVISION
(
  idlog          NUMBER not null,
  idoac			 NUMBER,
  customer_id    NUMBER,
  codsolot       NUMBER,
  co_id			 NUMBER,
  proceso        VARCHAR2(50), --RECONEXION - SUSPENSION - BAJA
  error          NUMBER,
  texto          VARCHAR2(2000),
  codusu         VARCHAR2(30) default user,
  fecusu         DATE default sysdate,
  ipaplicacion   VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion   VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;

-- Add comments to the table 
comment on table OPERACION.LOG_ERROR_PROVISION  is 'Tabla Log Errores transacciones Provision.';
-- Add comments to the columns 
comment on column OPERACION.LOG_ERROR_PROVISION.proceso  is 'Proceso ejecutado.';
comment on column OPERACION.LOG_ERROR_PROVISION.error  is 'Codigo de Error.';
comment on column OPERACION.LOG_ERROR_PROVISION.texto  is 'Descripcion del Error.';

-- Create/Recreate indexes 
create index OPERACION.IDX_LOGPROVCUSTOMERID on OPERACION.LOG_ERROR_PROVISION(customer_id)
tablespace OPERACION_IDX;

  
 create index OPERACION.IDX_LOGPROVCODSOLOT on OPERACION.LOG_ERROR_PROVISION(codsolot)
tablespace OPERACION_IDX;

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LOG_ERROR_PROVISION  add constraint PK_LOGERRORPROVISION primary key (idlog);

