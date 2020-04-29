-- Create table
create table OPERACION.SIAC_INSTANCIA
(
  idinstancia    NUMBER(10) not null,
  idprocess      NUMBER(10),
  tipo_postventa VARCHAR2(50),
  tipo_instancia VARCHAR2(50),
  instancia      VARCHAR2(20),
  usureg         VARCHAR2(30) default USER,
  fecreg         DATE default SYSDATE
);
-- Add comments to the columns 
comment on column OPERACION.SIAC_INSTANCIA.idinstancia
  is 'Identificador de Instancia';
comment on column OPERACION.SIAC_INSTANCIA.idprocess
  is 'Identificador del Proceso';
comment on column OPERACION.SIAC_INSTANCIA.tipo_postventa
  is 'Tipo de PostVenta';
comment on column OPERACION.SIAC_INSTANCIA.tipo_instancia
  is 'Tipo de Instancia';
comment on column OPERACION.SIAC_INSTANCIA.instancia
  is 'Valor de la Instancia';
comment on column OPERACION.SIAC_INSTANCIA.usureg
  is 'Usuario de Registro';
comment on column OPERACION.SIAC_INSTANCIA.fecreg
  is 'Fecha de Registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SIAC_INSTANCIA
  add constraint PK_IDINSTANCIA primary key (IDINSTANCIA);
