-- Create table
create table OPERACION.OPE_RESERVAHFC_BSCS
(
  idtrs        NUMBER not null,
  tipo         VARCHAR2(10),
  respuestaxml VARCHAR2(600),
  esquemaxml   CLOB,
  cod_id       NUMBER,
  resultado    NUMBER,
  error        VARCHAR2(400),
  ipapp        VARCHAR2(30) default SYS_CONTEXT('USERENV','IP_ADDRESS'),
  usuarioapp   VARCHAR2(30) default USER,
  fecusu       DATE default SYSDATE,
  pcapp        VARCHAR2(100) default SYS_CONTEXT('USERENV', 'TERMINAL')
)
tablespace OPERACION_DAT;
-- Add comments to the table 
comment on table OPERACION.OPE_RESERVAHFC_BSCS
  is 'Transacciones de Reserva';
-- Add comments to the columns 
comment on column OPERACION.OPE_RESERVAHFC_BSCS.idtrs
  is 'Id trs';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.tipo
  is 'Tipo';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.respuestaxml
  is 'Res XML';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.esquemaxml
  is 'Esq XML';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.cod_id
  is 'CO ID';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.resultado
  is 'RESULTADO';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.error
  is 'Error';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.ipapp
  is 'IP Aplicacion';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.usuarioapp
  is 'Usuario APP';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.fecusu
  is 'Fecha de Registro';
comment on column OPERACION.OPE_RESERVAHFC_BSCS.pcapp
  is 'PC Aplicacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_RESERVAHFC_BSCS
  add constraint PK_RESERVAHFC_BSCS primary key (IDTRS)
  using index 
  tablespace OPERACION_DAT;
