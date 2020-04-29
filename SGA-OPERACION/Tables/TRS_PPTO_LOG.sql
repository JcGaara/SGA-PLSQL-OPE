-- Create table
create table OPERACION.TRS_PPTO_LOG
(
  idseq          NUMBER not null,
  agrupador_ppto VARCHAR2(200),
  idppto         VARCHAR2(200),
  reserva        VARCHAR2(200),
  proveedor      VARCHAR2(200),
  pep            VARCHAR2(200),
  codsolot       VARCHAR2(200),
  documento      VARCHAR2(200),
  ppto           VARCHAR2(200),
  ipaplicacion   VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion   VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu         VARCHAR2(30) default user,
  fecusu         DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.TRS_PPTO_LOG.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.TRS_PPTO_LOG.pcaplicacion
  is 'PC Aplicacion';
comment on column OPERACION.TRS_PPTO_LOG.codusu
  is 'Usuario de creacion del registro';
comment on column OPERACION.TRS_PPTO_LOG.fecusu
  is 'Fecha de creacion del resgitro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRS_PPTO_LOG
  add constraint PK_TRS_PPTO_LOG primary key (IDSEQ)
  using index 
  tablespace OPERACION_IDX;

