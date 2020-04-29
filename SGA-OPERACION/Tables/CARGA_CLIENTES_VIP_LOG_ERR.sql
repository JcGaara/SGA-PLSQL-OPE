-- Create table
create table OPERACION.CARGA_CLIENTES_VIP_LOG_ERR
(
  idcarga     NUMBER not null,
  secuencia   NUMBER not null,
  fecha_carga DATE,
  cliente     CHAR(8),
  des_error   VARCHAR2(600),
  usureg      VARCHAR2(50) default USER,
  fecreg      DATE default SYSDATE
)
tablespace OPERACION_DAT;

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CARGA_CLIENTES_VIP_LOG_ERR
  add constraint PK_CARGA_CLIENTES_VIP_LOG_ERR primary key (IDCARGA, SECUENCIA)
  using index 
  tablespace OPERACION_DAT;

comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.idcarga   is 'Secuencia de carga';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.secuencia is 'Secuencia de carga por fecha';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.fecha_carga is 'Fecha de carga';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.cliente is 'Codigo del Cliente';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.des_error is 'Descripcion del errro';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.usureg  is 'Usuario de creacion';
comment on column OPERACION.CARGA_CLIENTES_VIP_LOG_ERR.fecreg  is 'Fecha de registro';
