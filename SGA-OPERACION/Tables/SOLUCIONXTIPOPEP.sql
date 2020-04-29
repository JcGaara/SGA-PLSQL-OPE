-- Create table
create table OPERACION.SOLUCIONXTIPOPEP
(
  id_seq       NUMBER not null,
  idsolucion   NUMBER not null,
  ipaplicacion VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  pcaplicacion VARCHAR2(50) default SYS_CONTEXT('USERENV', 'TERMINAL'),
  codusu       VARCHAR2(30) default user,
  fecusu       DATE default sysdate
)
tablespace OPERACION_DAT;
comment on column OPERACION.SOLUCIONXTIPOPEP.id_seq
  is 'ID Seq';
comment on column OPERACION.SOLUCIONXTIPOPEP.idsolucion
  is 'Codigo de Solucion de Venta';
alter table OPERACION.SOLUCIONXTIPOPEP
  add constraint PK_SOLUCIONXTIPOPEP_001 primary key (ID_SEQ, IDSOLUCION)
  using index 
  tablespace OPERACION_DAT;
