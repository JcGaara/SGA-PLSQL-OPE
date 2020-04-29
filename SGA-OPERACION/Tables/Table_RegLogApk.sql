--operacion.maestro_Series_equ_det
-- Create table 
create table OPERACION.REG_LOG_APK
(
  idseq        		number not null,
  tipo          	VARCHAR2(100),
  cod_resp      	VARCHAR2(100),
  msg_resp      	VARCHAR2(500),
  param_envio      	CLOB,
  estado_log      	NUMBER,
  
  usureg          	VARCHAR2(30) default USER,
  fecreg          	DATE default SYSDATE,
  ipreg          	VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcreg           	VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  
  usumod          	VARCHAR2(30),
  ipmod            	VARCHAR2(30),
  pcmod           	VARCHAR2(100),
  fecmod          	DATE
)
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
-- Add comments to the table 
comment on table OPERACION.REG_LOG_APK
  is 'Código de errores de respuesta de Incógnito';
-- Add comments to the columns 
comment on column OPERACION.REG_LOG_APK.idseq
  is 'Id secuencial';
comment on column OPERACION.REG_LOG_APK.tipo
  is 'Nombre del SP';
comment on column OPERACION.REG_LOG_APK.cod_resp
  is 'Código de error';
comment on column OPERACION.REG_LOG_APK.msg_resp
  is 'Descripción del error';
comment on column OPERACION.REG_LOG_APK.param_envio
  is 'Parámetros de envio al SP';
  
comment on column OPERACION.REG_LOG_APK.usureg
  is 'Usuario que registra';
comment on column OPERACION.REG_LOG_APK.fecreg
  is 'Fecha de registro';
comment on column OPERACION.REG_LOG_APK.ipreg
  is 'Ip usuario que registra';
comment on column OPERACION.REG_LOG_APK.pcreg
  is 'Pc de usuario que registra';
  
comment on column OPERACION.REG_LOG_APK.usumod
  is 'Usuario que modifica';
comment on column OPERACION.REG_LOG_APK.fecmod
  is 'Fecha de modificación';
comment on column OPERACION.REG_LOG_APK.ipmod
  is 'Ip usuario que modifica';
comment on column OPERACION.REG_LOG_APK.pcmod
  is 'Pc de usuario que modifica';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.REG_LOG_APK
  add constraint PK_REG_LOG_APK primary key (idseq)
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
  




