-- Create table
create table OPERACION.SIAC_NEGOCIO_REGLA
(
  idregla     NUMBER(6) not null,
  idnegocio   NUMBER(3) not null,
  orden       NUMBER(3),
  descripcion VARCHAR2(100),
  sentencia   VARCHAR2(200),
  tipo        VARCHAR2(3),
  flg_activo  NUMBER(1) default 0,
  usureg      VARCHAR2(30) default USER,
  fecreg      DATE default SYSDATE
);
-- Add comments to the table 
comment on table OPERACION.SIAC_NEGOCIO_REGLA
  is 'TABLA DE REGLAS POR TIPO DE NEGOCIO';
-- Add comments to the columns 
comment on column OPERACION.SIAC_NEGOCIO_REGLA.idregla
  is 'IDENTIFICADOR UNICO DE LA REGLA';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.idnegocio
  is 'IDENTIFICADOR DEL NEGOCIO';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.orden
  is 'ORDEN DE EJECUCION DE LAS REGLAS';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.descripcion
  is 'DESCRIPCION DE LA REGLA';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.tipo
  is 'PRE:ANTERIOR A LA VENTA, POS:POSTERIOR A LA VENTA';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.flg_activo
  is '0:INACTIVO, 1:ACTIVO';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.usureg
  is 'USUARIO QUE INSERTO EL REGISTRO';
comment on column OPERACION.SIAC_NEGOCIO_REGLA.fecreg
  is 'FECHA QUE INSERTO EL REGISTRO';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SIAC_NEGOCIO_REGLA
  add constraint PK_SIAC_NEGOCIO_REGLA primary key (IDREGLA);
