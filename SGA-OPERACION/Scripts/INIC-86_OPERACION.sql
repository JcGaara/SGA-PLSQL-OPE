alter table OPERACION.SGAT_MOTOTSUB add  MOTON_CODSUBTYPE number(3);
-- Add comments to the columns 
comment on column OPERACION.SGAT_MOTOTSUB.MOTON_CODSUBTYPE
  is 'Tipo de INCIDENCIA';