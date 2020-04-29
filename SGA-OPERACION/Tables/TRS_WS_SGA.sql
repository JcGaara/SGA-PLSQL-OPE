-- Create table
create table OPERACION.TRS_WS_SGA
(
  IDTRANSACCION NUMBER not null,
  IPAPLICACION  VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  USUARIOAPP    VARCHAR2(30) default USER,
  CODIGOERROR   NUMBER,
  MENSAJEERROR  VARCHAR2(400),
  FECUSU        DATE default SYSDATE,
  PCAPLICACION  VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
) ;
-- Add comments to the columns 
comment on column OPERACION.TRS_WS_SGA.IDTRANSACCION
  is 'ID transaccion';
comment on column OPERACION.TRS_WS_SGA.IPAPLICACION
  is 'IP Aplicacion';
comment on column OPERACION.TRS_WS_SGA.USUARIOAPP
  is 'Usuario APP';
comment on column OPERACION.TRS_WS_SGA.CODIGOERROR
  is 'Codigo Error';
comment on column OPERACION.TRS_WS_SGA.MENSAJEERROR
  is 'Mensaje Error';
comment on column OPERACION.TRS_WS_SGA.FECUSU
  is 'Fecha de Registro';
comment on column OPERACION.TRS_WS_SGA.PCAPLICACION
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.TRS_WS_SGA
  add constraint PK_TRS_WS_SGA primary key (IDTRANSACCION);