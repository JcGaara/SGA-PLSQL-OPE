-- Create table
create table OPERACION.LOG_CONFIG_EQUCOM_CP
(
  CODEQUCOM_NEW	 varchar2(4),		
  CODEQUCOM_OLD	 varchar2(4),		
  FLAG_APLICA	 char(1),		
  ACCION         char(1),
  USUMOD         VARCHAR2(30) default user,
  FECMOD         DATE default sysdate,
  ipaplicacion   VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion   VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL')  
)
tablespace OPERACION_DAT  ;
-- Add comments to the table 
comment on table OPERACION.LOG_CONFIG_EQUCOM_CP
  is 'Tabla de registro de log de Configuracion de Visita';
-- Add comments to the columns 
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.CODEQUCOM_NEW
  is 'CODIGO DE EQUIPO NUEVO';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.CODEQUCOM_OLD
  is 'CODIGO DE EQUIPO ACTUAL';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.FLAG_APLICA
  is 'FLAG DE APLICA O NO VISITA';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.ACCION
  is 'INSERT/UPDATE EN LA TABLA';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.USUMOD
  is 'USUARIO QUE REALIZA EL CAMBIO';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.FECMOD
  is 'FECHA EN QUE SE REALIZO  EL CAMBIO';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LOG_CONFIG_EQUCOM_CP.pcaplicacion
  is 'PC Aplicacion';
  /

