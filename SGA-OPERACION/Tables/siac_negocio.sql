-- Create table
create table OPERACION.SIAC_NEGOCIO
(
  idnegocio   NUMBER(3) not null,
  descripcion VARCHAR2(100),
  flg_activo  NUMBER(1) default 0,
  usureg      VARCHAR2(30) default USER,
  fecreg      DATE default SYSDATE,
  usumod      VARCHAR2(30) default USER,
  fecmod      DATE default SYSDATE
);
-- Add comments to the columns 
comment on column OPERACION.SIAC_NEGOCIO.idnegocio
  is 'Identificador del Negocio';
comment on column OPERACION.SIAC_NEGOCIO.descripcion
  is 'Descripcion del Negocio';
comment on column OPERACION.SIAC_NEGOCIO.flg_activo
  is 'Estado del Negocio';
comment on column OPERACION.SIAC_NEGOCIO.usureg
  is 'Usuario de Registro';
comment on column OPERACION.SIAC_NEGOCIO.fecreg
  is 'Fecha del Registro';
comment on column OPERACION.SIAC_NEGOCIO.usumod
  is 'Usuario de Modificacion';
comment on column OPERACION.SIAC_NEGOCIO.fecmod
  is 'Fecha de Modificacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SIAC_NEGOCIO
  add constraint PK_SIAC_NEGOCIO primary key (IDNEGOCIO);
