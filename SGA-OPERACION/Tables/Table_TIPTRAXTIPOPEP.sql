-- Create table
create table OPERACION.TIPTRAXTIPOPEP
(
  id_seq       NUMBER not null,
  tiptra       NUMBER not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the columns 
comment on column OPERACION.TIPTRAXTIPOPEP.id_seq
  is 'ID Seq';
comment on column OPERACION.TIPTRAXTIPOPEP.tiptra
  is 'Codigo de etapa';
