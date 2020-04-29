-- Add/modify columns 
alter table OPERACION.OPE_DET_XML add estado number default 1;
-- Add comments to the columns 
comment on column OPERACION.OPE_DET_XML.estado
  is 'Activo:1 0 Inactivo';