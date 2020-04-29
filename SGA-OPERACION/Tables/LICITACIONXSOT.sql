-- Create table
create table OPERACION.LICITACIONXSOT
(
  idseq        NUMBER not null,
  codsolot     NUMBER not null,
  idlicitacion NUMBER,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.LICITACIONXSOT
  is 'SOT x Licitacion';
-- Add comments to the columns 
comment on column OPERACION.LICITACIONXSOT.idseq
  is 'Pk de la tabla';
comment on column OPERACION.LICITACIONXSOT.codsolot
  is 'SOT';
comment on column OPERACION.LICITACIONXSOT.idlicitacion
  is 'Id Licitacion';
comment on column OPERACION.LICITACIONXSOT.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LICITACIONXSOT.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.LICITACIONXSOT.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.LICITACIONXSOT.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate indexes 
create index OPERACION.PK_00011 on OPERACION.LICITACIONXSOT (CODSOLOT)
  tablespace OPERACION_DAT;
create index OPERACION.PK_00012 on OPERACION.LICITACIONXSOT (IDLICITACION)
  tablespace OPERACION_DAT;
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LICITACIONXSOT
  add constraint PK_LICITACIONXSOT primary key (IDSEQ)
  using index 
  tablespace OPERACION_IDX;

