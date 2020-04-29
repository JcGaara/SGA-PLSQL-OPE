-- Create table
create table OPERACION.CANDIDATO_ROLLOUT
(
  idseq        NUMBER not null,
  codsolot     NUMBER,
  descripcion  VARCHAR2(200),
  conforme     NUMBER  ,
  fecfin       DATE,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  codusu       VARCHAR2(30) default USER,
  fecusu       DATE default SYSDATE,
  pcaplicacion VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.CANDIDATO_ROLLOUT.idseq
  is 'Secuencial';
comment on column OPERACION.CANDIDATO_ROLLOUT.codsolot
  is 'SOT';
comment on column OPERACION.CANDIDATO_ROLLOUT.descripcion
  is 'Descripcion';
comment on column OPERACION.CANDIDATO_ROLLOUT.conforme
  is '1 : Conforme 0: No Conforme';
comment on column OPERACION.CANDIDATO_ROLLOUT.fecfin
  is 'Fecha de Conformidad';
comment on column OPERACION.CANDIDATO_ROLLOUT.ipaplicacion
  is 'IP Aplicacion';
comment on column OPERACION.CANDIDATO_ROLLOUT.codusu
  is 'Usuario APP';
comment on column OPERACION.CANDIDATO_ROLLOUT.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.CANDIDATO_ROLLOUT.pcaplicacion
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.CANDIDATO_ROLLOUT
  add constraint PK_CANDIDA_ROLLOUT primary key (IDSEQ);
