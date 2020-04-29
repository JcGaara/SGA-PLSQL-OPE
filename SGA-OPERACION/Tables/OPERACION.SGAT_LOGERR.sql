-- Create table
create table OPERACION.SGAT_LOGERR
(
  logerrn_idlog        NUMBER not null,
  logerrc_numregistro  CHAR(15),
  logerrc_codsolot     CHAR(15),
  logerrv_proceso      VARCHAR2(50),
  logerrv_error        VARCHAR2(10),
  logerrv_texto        VARCHAR2(4000),
  logerrv_codusu       VARCHAR2(30) default user,
  logerrd_fecusu       DATE default sysdate,
  logerrv_ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  logerrv_pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.SGAT_LOGERR
  is 'Tabla Log Errores transacciones CONTEGO';
-- Add comments to the columns 
comment on column OPERACION.SGAT_LOGERR.logerrn_idlog
  is 'Identificador de log';
comment on column OPERACION.SGAT_LOGERR.logerrc_numregistro
  is 'Identificador del numero de registro';
comment on column OPERACION.SGAT_LOGERR.logerrv_proceso
  is 'Nombre del proceso con error';
comment on column OPERACION.SGAT_LOGERR.logerrv_error
  is 'Identificador del error';
comment on column OPERACION.SGAT_LOGERR.logerrv_texto
  is 'Mensaje de eror';
comment on column OPERACION.SGAT_LOGERR.logerrv_codusu
  is 'Usuario';
comment on column OPERACION.SGAT_LOGERR.logerrd_fecusu
  is 'Fecha';
comment on column OPERACION.SGAT_LOGERR.logerrv_ipaplicacion
  is 'Numero de IP';
comment on column OPERACION.SGAT_LOGERR.logerrv_pcaplicacion
  is 'Nombre de PC';
comment on column OPERACION.SGAT_LOGERR.logerrc_codsolot
  is 'Identificador del numero de sot';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SGAT_LOGERR
  add constraint PK_SGAT_LOGERR primary key (LOGERRN_IDLOG)
  using index 
  tablespace OPERACION_IDX;
