-- Add/modify columns 
alter table OPERACION.TRS_WS_SGA add fecactws date;
-- Add comments to the columns 
comment on column OPERACION.TRS_WS_SGA.fecactws
  is 'Fecha Modificacion WS';