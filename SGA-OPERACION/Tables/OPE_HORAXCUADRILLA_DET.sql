-- Create table
create table OPERACION.OPE_HORAXCUADRILLA_DET
(
  ID_OPE_CUADRILLAXDISTRITO_DET NUMBER not null,
  DIA NUMBER not null,
  HORA VARCHAR2(15) not null,
  ACTIVO NUMBER default 0 null,
  USUREG VARCHAR2(30) default user null,
  FECREG DATE default sysdate null,
  USUMOD VARCHAR2(30) default user null,
  FECMOD DATE default sysdate null
);

-- Add comments to the columns 
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.ID_OPE_CUADRILLAXDISTRITO_DET
  is 'ID de tabla';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.DIA
  is 'dia de agenda';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.HORA
  is 'hora de agenda';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.ACTIVO
  is 'estado';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.USUREG
  is 'usuario de registro';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.FECREG
  is 'fecha de registro';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.USUMOD
  is 'usuario modificacion';
comment on column OPERACION.OPE_HORAXCUADRILLA_DET.FECMOD
  is 'fecha modificacion';

-- Create/Recreate primary, unique and foreign key constraints
alter table OPERACION.OPE_HORAXCUADRILLA_DET
  add constraint PK_OPE_HORAXCUADRILLA_DET primary key (ID_OPE_CUADRILLAXDISTRITO_DET,DIA,HORA);

