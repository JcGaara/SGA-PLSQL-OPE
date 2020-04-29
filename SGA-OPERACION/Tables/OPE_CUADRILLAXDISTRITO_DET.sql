-- Create table
create table OPERACION.OPE_CUADRILLAXDISTRITO_DET
(
  ID_OPE_CUADRILLAXDISTRITO_DET NUMBER,
  TIPTRA NUMBER ,
  CODCON NUMBER ,
  CODCUADRILLA VARCHAR2(30),
  CODUBI CHAR(10) null,
  FLG_ACTIVO NUMBER  default 1,
  USUREG VARCHAR2(30) default USER,
  FECREG DATE default SYSDATE,
  USUMOD VARCHAR2(30) default USER,
  FECMOD DATE default SYSDATE
);

-- Add comments to the columns
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.ID_OPE_CUADRILLAXDISTRITO_DET
  is 'ID de cuadrilla por distrito';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.TIPTRA
  is 'Tipo de Trabajo';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.CODCON
  is 'ID de cuadrilla por distrito';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.CODCUADRILLA
  is 'Codigo de cuadrilla';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.CODUBI
  is 'codigo de ubicacion';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.FLG_ACTIVO
  is '1: activo, 0:inactivo';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.USUREG
  is 'Usuario que ingreso registro';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_CUADRILLAXDISTRITO_DET.FECMOD
  is 'Fecha que se  modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints
alter table OPERACION.OPE_CUADRILLAXDISTRITO_DET
  add constraint PK_OPE_CUADRILLAXDISTRITO_DET primary key (ID_OPE_CUADRILLAXDISTRITO_DET);