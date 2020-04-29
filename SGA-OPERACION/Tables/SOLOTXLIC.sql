-- Create table
create table OPERACION.SOLOTXLIC
(
  idlicitacion NUMBER not null,
  codsolot     NUMBER not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.SOLOTXLIC
  is 'Agrupador de Licitaciones por SOT';
-- Add comments to the columns 
comment on column OPERACION.SOLOTXLIC.idlicitacion
  is 'Id licitacion';
comment on column OPERACION.SOLOTXLIC.codsolot
  is 'SOT';
comment on column OPERACION.SOLOTXLIC.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.SOLOTXLIC.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.SOLOTXLIC.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.SOLOTXLIC.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.SOLOTXLIC
  add constraint PK_SOLOTXLIC001 primary key (IDLICITACION, CODSOLOT)
  using index 
  tablespace OPERACION_IDX;
