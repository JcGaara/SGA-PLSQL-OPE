create table OPERACION.ETAPAXTIPOPEP
(
  id_seq       NUMBER not null,
  codeta       NUMBER not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.ETAPAXTIPOPEP.id_seq
  is 'ID Seq';
comment on column OPERACION.ETAPAXTIPOPEP.codeta
  is 'Codigo de etapa';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.ETAPAXTIPOPEP
  add constraint PK_ETAPAXTIPOPEP_001 primary key (ID_SEQ, CODETA)
  using index 
  tablespace OPERACION_DAT;
