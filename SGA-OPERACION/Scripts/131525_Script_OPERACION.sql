-- Add/modify columns 
alter table OPERACION.MOT_SOLUCION add CODMOT_GRUPO number;
-- Add comments to the columns 
comment on column OPERACION.MOT_SOLUCION.CODMOT_GRUPO
  is 'Grupo de Solucion';