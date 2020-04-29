-- Create table
create table OPERACION.CLIENTEXCONTRATA
(
  codcon NUMBER(6) not null,
  codcli varchar2(10) not null,
  tiptra NUMBER not null,
  codusu VARCHAR2(30) default USER,
  fecusu DATE default SYSDATE
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.CLIENTEXCONTRATA
  is 'Asignar Cliente por contrata';
-- Add comments to the columns 
comment on column OPERACION.CLIENTEXCONTRATA.codcon
  is 'Codigo de Contrata';
comment on column OPERACION.CLIENTEXCONTRATA.codcli
  is 'Codigo de Cliente';
comment on column OPERACION.CLIENTEXCONTRATA.tiptra
  is 'Tipo de trabajo';
comment on column OPERACION.CLIENTEXCONTRATA.codusu
  is 'Usuario';
comment on column OPERACION.CLIENTEXCONTRATA.fecusu
  is 'Fecha';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CLIENTEXCONTRATA
  add constraint PK_CLIENTEXCONTRATA1 primary key (CODCON, CODCLI, TIPTRA)
  using index 
  tablespace OPERACION_DAT;
