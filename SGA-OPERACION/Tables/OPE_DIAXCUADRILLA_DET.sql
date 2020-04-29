-- Create table
create table OPERACION.OPE_DIAXCUADRILLA_DET
(
  ID_OPE_CUADRILLAXDISTRITO_DET NUMBER not null,
  DIA                           NUMBER not null,
  ACTIVO                        NUMBER default 0,
  DIAS_FUTURO                   NUMBER default 0,
  USUREG                        VARCHAR2(30) default user,
  FECREG                        DATE default sysdate,
  USUMOD                        VARCHAR2(30) default user,
  FECMOD                        DATE default sysdate
) ;
-- Add comments to the columns 
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.ID_OPE_CUADRILLAXDISTRITO_DET
  is 'ID de tabla';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.DIA
  is 'dia de agenda';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.ACTIVO
  is 'estado';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.DIAS_FUTURO
  is 'Dias Futuro';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.USUREG
  is 'usuario de registro';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.FECREG
  is 'fecha de registro';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.USUMOD
  is 'usuario modificacion';
comment on column OPERACION.OPE_DIAXCUADRILLA_DET.FECMOD
  is 'fecha modificacion';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_DIAXCUADRILLA_DET
  add constraint PK_OPE_DIAXCUADRILLA_DET primary key (ID_OPE_CUADRILLAXDISTRITO_DET, DIA ) ;