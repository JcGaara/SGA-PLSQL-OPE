-- Create table
create table AUDITORIA.APP_LOG_AUDIT
(
  logn_id          NUMBER(10) not null,
  logv_evento      VARCHAR2(30),
  logv_codusu      VARCHAR2(30),
  logv_nomusu      VARCHAR2(100),
  logv_origenip    VARCHAR2(100),
  logv_origenhost  VARCHAR2(100),
  logv_sousu       VARCHAR2(100),
  logd_fecusu      DATE,
  logv_destinoip   VARCHAR2(100),
  logv_destinohost VARCHAR2(100),
  logv_modulo      VARCHAR2(100),
  logv_url         VARCHAR2(900),
  logc_variable    VARCHAR2(900),
  logv_msgrpta     VARCHAR2(900)
)
tablespace USERS
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
-- Add comments to the columns 
comment on column AUDITORIA.APP_LOG_AUDIT.logn_id
  is 'Identificador del log';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_evento
  is 'Categoría o grupo del Evento';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_codusu
  is 'Usuario de creacion';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_nomusu
  is 'Nombre de creacion';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_origenip
  is 'IP origen';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_origenhost
  is 'Hostname origen';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_sousu
  is 'Usuario de sistema operativo';
comment on column AUDITORIA.APP_LOG_AUDIT.logd_fecusu
  is 'Fecha de creacion';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_destinoip
  is 'IP destino';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_destinohost
  is 'Hostname destino';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_modulo
  is 'Modulo SGA';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_url
  is 'Direccion URL';
comment on column AUDITORIA.APP_LOG_AUDIT.logc_variable
  is 'Variable';
comment on column AUDITORIA.APP_LOG_AUDIT.logv_msgrpta
  is 'Mensaje de Respuesta ';
-- Create/Recreate primary, unique and foreign key constraints 
alter table AUDITORIA.APP_LOG_AUDIT
  add constraint PK_APP_LOG_AUDIT primary key (LOGN_ID)
  using index 
  tablespace USERS
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