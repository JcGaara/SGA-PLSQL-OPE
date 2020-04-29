-- Add/modify columns 
alter table OPERACION.OPE_RESERVAHFC_BSCS add codsolot number;
-- Add comments to the columns 
comment on column OPERACION.OPE_RESERVAHFC_BSCS.codsolot
  is 'SOT';