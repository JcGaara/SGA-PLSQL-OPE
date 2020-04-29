   
create table OPERACION.MOT_SOLUCIONXTIPTRA_ACT
(
  TIPTRA          NUMBER not null,
  CODMOT_SOLUCION NUMBER  not null,
  CANTIDAD        NUMBER DEFAULT 1 NOT NULL,
  CODACT         NUMBER  NOT NULL,
  CODETA         NUMBER  NOT NULL,
  USUREG          VARCHAR2(30) default user not null,
  FECREG          DATE default sysdate not null,
  USUMOD          VARCHAR2(30) default user,
  FECMOD          DATE default sysdate
);

-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.TIPTRA
  is 'Tipo de trabajo';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.CODMOT_SOLUCION
  is 'Motivo de Solucon';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.CANTIDAD
  is 'Cantidad';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.CODACT
  is 'Actividad de MO';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.CODETA
  is 'Etapa';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.USUREG
  is 'Usuario de registro';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.FECREG
  is 'Fecha de registro';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.USUMOD
  is 'Usuario de modificacion';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_ACT.FECMOD
  is 'Fecha de modificacion';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOT_SOLUCIONXTIPTRA_ACT
  add constraint pk_MOT_SOLUCIONXTIPTRA_ACT primary key (TIPTRA, CODMOT_SOLUCION,   CODACT);