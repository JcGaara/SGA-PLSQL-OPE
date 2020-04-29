-- Create table
create table OPERACION.LICCAMESTADO
(
  idseq        NUMBER not null,
  estlic       NUMBER not null,
  observacion  VARCHAR2(400),
  idlicitacion NUMBER,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.LICCAMESTADO
  is 'Cambios de estado del Licitaciones';
-- Add comments to the columns 
comment on column OPERACION.LICCAMESTADO.idseq
  is 'Pk de la tabla';
comment on column OPERACION.LICCAMESTADO.estlic
  is 'Codigo del estado de Licitacion';
comment on column OPERACION.LICCAMESTADO.observacion
  is 'Observacion';
comment on column OPERACION.LICCAMESTADO.idlicitacion
  is 'Id Licitacion';
comment on column OPERACION.LICCAMESTADO.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.LICCAMESTADO.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.LICCAMESTADO.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.LICCAMESTADO.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.LICCAMESTADO
  add constraint PK_LICCAMESTADO primary key (IDSEQ)
  using index 
  tablespace OPERACION_IDX;
