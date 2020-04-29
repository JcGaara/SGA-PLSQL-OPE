-- Add/modify columns 
alter table OPERACION.TRS_WS_SGA add CODSOLOT number;
-- Add comments to the columns 
comment on column OPERACION.TRS_WS_SGA.CODSOLOT
  is 'sot';