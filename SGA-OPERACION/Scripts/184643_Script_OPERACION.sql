-- Add/modify columns 
alter table OPERACION.CANDIDATO_ROLLOUT add fecini date;
-- Add comments to the columns 
comment on column OPERACION.CANDIDATO_ROLLOUT.fecini
  is 'Fecha de Inicio de trabajos';