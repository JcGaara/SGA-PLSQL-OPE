-- Create table
create table OPERACION.OPE_RESTCONTRATA
(
  AREA          NUMBER not null,
  USUARIO_ASIG  VARCHAR2(30) not null,       
  CODUSU        VARCHAR2(30) default user,
  FECUSU        DATE default sysdate,
  ESTADO        CHAR(1)
)
tablespace OPERACION_DAT;
-- Add comments to the table
comment on table OPERACION.OPE_RESTCONTRATA
  is 'Tabla de Usuarios que pueden asignar contrata';
-- Add comments to the columns 
comment on column OPERACION.OPE_RESTCONTRATA.AREA
  is 'Area';
comment on column OPERACION.OPE_RESTCONTRATA.USUARIO_ASIG
  is 'Usuario asignado';
comment on column OPERACION.OPE_RESTCONTRATA.CODUSU
  is 'Usuario que crea el registro';
comment on column OPERACION.OPE_RESTCONTRATA.FECUSU
  is 'Fecha de registro';
comment on column OPERACION.OPE_RESTCONTRATA.ESTADO
  is 'Estado del registro';
-- Create/Recreate indexes 
create index OPERACION.IDK_OPE_RESTCONTRATA on OPERACION.OPE_RESTCONTRATA (AREA,USUARIO_ASIG)
  tablespace OPERACION_DAT;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_RESTCONTRATA
  add constraint PK_OPE_RESTCONTRATA primary key (AREA,USUARIO_ASIG)
  using index 
  tablespace OPERACION_DAT;
