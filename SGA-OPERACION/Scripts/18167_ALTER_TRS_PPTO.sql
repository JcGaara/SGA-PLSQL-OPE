-- Add/modify columns 
alter table OPERACION.TRS_PPTO add N_REINTENTOS_PPTO number;
-- Add comments to the columns 
comment on column OPERACION.TRS_PPTO.N_REINTENTOS_PPTO
  is 'Numero de reintentos de presupuesto.';

-- Update rows
update OPERACION.TRS_PPTO set N_REINTENTOS_PPTO = 0;


-- Add/modify columns 
alter table OPERACION.TRS_PPTO modify N_REINTENTOS_PPTO default 0 not null;