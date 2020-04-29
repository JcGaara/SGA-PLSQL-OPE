-- Create table
create table OPERACION.OPE_DET_XML
(
  idcab       NUMBER,
  idseq       NUMBER not null,
  campo       VARCHAR2(200),
  nombrecampo VARCHAR2(200),
  ipapp       VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp  VARCHAR2(30) default USER,
  fecusu      DATE default SYSDATE,
  pcapp       VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  tipo        NUMBER default 1
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.OPE_DET_XML.idcab
  is 'ID Cabecera';
comment on column OPERACION.OPE_DET_XML.idseq
  is 'ID detalle';
comment on column OPERACION.OPE_DET_XML.campo
  is 'Campo';
comment on column OPERACION.OPE_DET_XML.nombrecampo
  is 'Nombre Campo';
comment on column OPERACION.OPE_DET_XML.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.OPE_DET_XML.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.OPE_DET_XML.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.OPE_DET_XML.pcapp
  is 'PC Aplicacion';
comment on column OPERACION.OPE_DET_XML.tipo
  is '1: Constante 2: Execute';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_DET_XML
  add constraint PK_OPE_DET_XML primary key (IDSEQ)
  using index 
  tablespace OPERACION_DAT;
