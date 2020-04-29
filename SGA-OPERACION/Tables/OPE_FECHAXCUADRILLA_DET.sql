-- Create table
create table OPERACION.OPE_FECHAXCUADRILLA_DET
(
  ID_OPE_CUADRILLAXDISTRITO_DET NUMBER not null,
  FECHADIARIA date not null,
  HORA VARCHAR2(15) not null,
  FLG_ACTIVO NUMBER(1) default 0 null,
  USUREG VARCHAR2(30) default user null,
  FECREG DATE default sysdate null,
  USUMOD VARCHAR2(30) default user null,
  FECMOD DATE default sysdate null
);

-- Add comments to the columns 
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.ID_OPE_CUADRILLAXDISTRITO_DET
  is 'ID de tabla';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.FECHADIARIA
  is 'Fecha diaria';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.HORA
  is 'Hora';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.FLG_ACTIVO
  is 'Estado';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.USUREG
  is 'Usuario de Registro';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.FECREG
  is 'Fecha de Registro';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.USUMOD
  is 'Usuario de Modificacion';
comment on column OPERACION.OPE_FECHAXCUADRILLA_DET.FECMOD
  is 'Fecha de Modificacion';

-- Create/Recreate primary, unique and foreign key constraints
alter table OPERACION.OPE_FECHAXCUADRILLA_DET
  add constraint PK_OPE_FECHAXCUADRILLA_DET primary key (ID_OPE_CUADRILLAXDISTRITO_DET,FECHADIARIA,HORA);