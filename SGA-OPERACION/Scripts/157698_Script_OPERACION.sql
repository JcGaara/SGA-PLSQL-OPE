-- Add/modify columns 
alter table OPERACION.CFG_ENV_CORREO_CONTRATA add ORDEN number default 1;
-- Add comments to the columns 
comment on column OPERACION.CFG_ENV_CORREO_CONTRATA.ORDEN
  is 'Orden de Ejecucion';