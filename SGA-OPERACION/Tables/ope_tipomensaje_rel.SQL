-- Create table
create table OPERACION.OPE_TIPOMENSAJE_REL
(
  CODTIPO    NUMBER not null,
  NOMBRETIPO VARCHAR2(30),
  ESTTIPO    NUMBER,
  USUREG     VARCHAR2(30) default USER,
  FECREG     DATE default SYSDATE,
  USUMOD     VARCHAR2(30) default USER,
  FECMOD     DATE default SYSDATE
)
tablespace OPERACION_DAT
;
-- Add comments to the table 
comment on table OPERACION.OPE_TIPOMENSAJE_REL
  is 'TABLA RELACIONAL DE TIPOS DE MENSAJES';
-- Add comments to the columns 
comment on column OPERACION.OPE_TIPOMENSAJE_REL.CODTIPO
  is 'CODIGO DE TIPO';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.NOMBRETIPO
  is 'NOMBRE DEL TIPO';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.ESTTIPO
  is 'ESTADO DEL TIPO';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.USUREG
  is 'USAURIO DE REGSITRO';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.FECREG
  is 'FECHA DE REGISTRO';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.USUMOD
  is 'USAURIO DE MODIFICACION ';
comment on column OPERACION.OPE_TIPOMENSAJE_REL.FECMOD
  is 'FECHA DE MODIFICACION';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.OPE_TIPOMENSAJE_REL
  add constraint PK_OPE_TIPOMENSAJE_REL primary key (CODTIPO)
  using index 
  tablespace OPERACION_DAT
 ;
