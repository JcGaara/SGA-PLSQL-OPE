-- Create table
create table OPERACION.OPE_RANGO
( ID_RANGO   NUMBER not null,
  TIEMPO     NUMBER,
  TIPTRA     NUMBER,
  CODUBI     CHAR(10),
  FLG_ACTIVO NUMBER(1) default 1,
  USUREG     VARCHAR2(30) default USER,
  FECREG     DATE default SYSDATE,
  USUMOD     VARCHAR2(30) default USER,
  FECMOD     DATE default SYSDATE
);
-- Add comments to the columns 
comment on column OPERACION.OPE_RANGO.ID_RANGO
  is 'ID de cuadrilla por distrito';
comment on column OPERACION.OPE_RANGO.TIEMPO
  is 'Tiempo de atencion maximo';
comment on column OPERACION.OPE_RANGO.TIPTRA
  is 'Tipo de Trabajo';
comment on column OPERACION.OPE_RANGO.CODUBI
  is 'codigo de ubicacion';
comment on column OPERACION.OPE_RANGO.FLG_ACTIVO
  is '1: activo, 0:inactivo';
comment on column OPERACION.OPE_RANGO.USUREG
  is 'Usuario que ingreso registro';
comment on column OPERACION.OPE_RANGO.FECREG
  is 'Fecha que inserto el registro';
comment on column OPERACION.OPE_RANGO.USUMOD
  is 'Usuario que modifico el registro';
comment on column OPERACION.OPE_RANGO.FECMOD
  is 'Fecha que se  modifico el registro';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_RANGO
  add constraint PK_OPE_RANGO primary key (ID_RANGO);