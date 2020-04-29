-- Create table
create table OPERACION.OPE_ESTADOMENSAJE_DET
(
  IDESTADO NUMBER(1) not null,
  NOMBRE   VARCHAR2(20),
  ACTIVO   NUMBER(1) default 1,
  USUREG   VARCHAR2(30) default USER,
  FECREG   DATE default SYSDATE,
  USUMOD   VARCHAR2(30) default USER,
  FECMOD   DATE default SYSDATE
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_ESTADOMENSAJE_DET
  is 'DETALLE DE LOS ESTADO DE LOS MENSAJES ENVIADOS A INTRAWAY';
-- Add comments to the columns 
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.IDESTADO
  is 'IDENTIFICADOR DEL ESTADO';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.NOMBRE
  is 'NOMBRE DEL ESTADO';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.ACTIVO
  is 'ACTIVO 1 INACTIVO 0';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.USUREG
  is 'USU REG';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.FECREG
  is 'FEC REG';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.USUMOD
  is 'USU MOD';
comment on column OPERACION.OPE_ESTADOMENSAJE_DET.FECMOD
  is 'FEC MOD';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_ESTADOMENSAJE_DET
  add constraint PK_FLUJOESTADO primary key (IDESTADO)
  using index 
  tablespace OPERACION_DAT
  ;
