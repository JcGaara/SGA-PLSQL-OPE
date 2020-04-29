-- Create table
create table OPERACION.TIPROY_SINERGIA_PEPXTIPTRA
(
  id_seq       NUMBER not null,
  tiptra       NUMBER not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.TIPROY_SINERGIA_PEPXTIPTRA
  is 'Secuencial PEP x tipo de trabajo';
-- Add comments to the columns 
comment on column OPERACION.TIPROY_SINERGIA_PEPXTIPTRA.id_seq
  is 'ID secuencial PEP';
comment on column OPERACION.TIPROY_SINERGIA_PEPXTIPTRA.tiptra
  is 'Tipo de trabajo';
