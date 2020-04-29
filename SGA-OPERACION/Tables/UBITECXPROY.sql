-- Create table

create table OPERACION.UBITECXPROY
(
  tiproy        VARCHAR2(3) not null,
  id_ubitecnica NUMBER not null,
  ipaplicacion  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion  VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu        VARCHAR2(30) default user,
  fecusu        DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.UBITECXPROY
  is 'Maestro de tipos de proyectos';
-- Add comments to the columns 
comment on column OPERACION.UBITECXPROY.tiproy
  is 'Tipo Proyecto SINERGIA';
comment on column OPERACION.UBITECXPROY.id_ubitecnica
  is 'Ubitecnica';
comment on column OPERACION.UBITECXPROY.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.UBITECXPROY.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.UBITECXPROY.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.UBITECXPROY.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.UBITECXPROY
  add constraint PK_UBITECXPROY_001 primary key (TIPROY, ID_UBITECNICA)
  using index 
  tablespace OPERACION_DAT;
