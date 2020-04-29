-- Create table
create table OPERACION.MOT_SOLUCIONXFOR
( CODFOR NUMBER not null,
  TIPTRA NUMBER not null,
  CODMOT_SOLUCION  NUMBER not null,
  USUREG          VARCHAR2(30) default user not null,
  FECREG          DATE default sysdate not null,
  USUMOD          VARCHAR2(30) default user not null,
  FECMOD          DATE default sysdate not null,
  ESTADO          NUMBER(1) default 0 not null  
) ;
-- Add comments to the table 
comment on table OPERACION.MOT_SOLUCIONXFOR
  is 'Tabla para instanciar las formulas por el Tipo de Trabajo de la SOT';
-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXFOR.CODFOR
  is 'Codigo de formula';
comment on column OPERACION.MOT_SOLUCIONXFOR.TIPTRA
  is 'Tipo de Trabajo';
comment on column OPERACION.MOT_SOLUCIONXFOR.CODMOT_SOLUCION
  is 'Codigo de motivo de la orden de trabajo';
comment on column OPERACION.MOT_SOLUCIONXFOR.USUREG
  is 'Usuario que insertó el registro';
comment on column OPERACION.MOT_SOLUCIONXFOR.FECREG
  is 'Fecha de registro';
comment on column OPERACION.MOT_SOLUCIONXFOR.USUMOD
  is 'Usuario que modificó el registro';
comment on column OPERACION.MOT_SOLUCIONXFOR.FECMOD
  is 'Fecha que se modificó el registro';
comment on column OPERACION.MOT_SOLUCIONXFOR.ESTADO
  is 'Estado del Motivo';
-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOT_SOLUCIONXFOR
  add constraint PK_MOT_SOLUCIONXFOR primary key (CODFOR, TIPTRA,CODMOT_SOLUCION) ;

