create table OPERACION.MOT_SOLUCION_GRUPO
(
  CODMOT_GRUPO  NUMBER(3) not null,
  DESCRIPCION     VARCHAR2(200) not null,
  USUREG          VARCHAR2(30) default user not null,
  FECREG          DATE default sysdate not null,
  USUMOD          VARCHAR2(30) default user not null,
  FECMOD          DATE default sysdate not null,
  ESTADO          NUMBER(1) default 0 not null
);

-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCION_GRUPO.CODMOT_GRUPO
  is 'Grupo de Solucion';
comment on column OPERACION.MOT_SOLUCION_GRUPO.DESCRIPCION
  is 'Descripcion';
comment on column OPERACION.MOT_SOLUCION_GRUPO.USUREG
  is 'Usuario de Registro';
comment on column OPERACION.MOT_SOLUCION_GRUPO.FECREG
  is 'Fecha de Registro';
comment on column OPERACION.MOT_SOLUCION_GRUPO.USUMOD
  is 'Usuario de modificacion';
comment on column OPERACION.MOT_SOLUCION_GRUPO.FECMOD
  is 'Fecha de modificacion';
comment on column OPERACION.MOT_SOLUCION_GRUPO.ESTADO
  is 'Estado';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOT_SOLUCION_GRUPO
  add constraint pk_MOT_SOLUCION_GRUPO primary key (CODMOT_GRUPO);