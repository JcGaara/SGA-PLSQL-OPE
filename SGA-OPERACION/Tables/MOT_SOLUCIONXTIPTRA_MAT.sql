   
create table OPERACION.MOT_SOLUCIONXTIPTRA_MAT
(
  TIPTRA          NUMBER not null,
  CODMOT_SOLUCION NUMBER  not null,
  CODETA         NUMBER  NOT NULL,
  CODMAT          VARCHAR2(15) NOT NULL,
  CANTIDAD        NUMBER DEFAULT 1 NOT NULL,
  USUREG          VARCHAR2(30) default user not null,
  FECREG          DATE default sysdate not null,
  USUMOD          VARCHAR2(30) default user,
  FECMOD          DATE default sysdate
);

-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.TIPTRA
  is 'Tipo de trabajo';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.CODMOT_SOLUCION
  is 'Motivo de Solucon';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.CODETA
  is 'Etapa';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.CANTIDAD
  is 'Cantidad';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.CODMAT
  is 'Material';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.USUREG
  is 'Usuario de registro';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.FECREG
  is 'Fecha de registro';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.USUMOD
  is 'Usuario de modificacion';
comment on column OPERACION.MOT_SOLUCIONXTIPTRA_MAT.FECMOD
  is 'Fecha de modificacion';

-- Create/Recreate primary, unique and foreign key constraints 
alter table OPERACION.MOT_SOLUCIONXTIPTRA_MAT
  add constraint pk_MOT_SOLUCIONXTIPTRA_MAT primary key (TIPTRA, CODMOT_SOLUCION,   CODMAT);