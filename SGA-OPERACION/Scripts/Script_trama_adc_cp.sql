-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add codocc number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.codocc
  is 'Codigo OCC de BSCS (SNCODE)';

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add num_cuota number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.num_cuota
  is 'Número de cuotas OCC';

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add monto number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.monto
  is 'Monto de OCC';

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add coment varchar2(2000);

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add tope number;
alter table OPERACION.SIAC_POSTVENTA_PROCESO add co_ser number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.tope
  is 'Monto de Tope de consumo';

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add flag_lc number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.flag_lc
  is 'Flag de LowCost';
 
-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add flag_topemenor number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.coment
  is 'Concatenado para OCC';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.co_ser
  is 'Cod de servicio de Tope de Consumo';
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.flag_topemenor
  is 'Flag de Tope menor, 0:Cuando el usuario digita el costo, 1: Cuando se lista';

-- Add/modify columns 
alter table OPERACION.SIAC_POSTVENTA_PROCESO add reclamo_caso number;
-- Add comments to the columns 
comment on column OPERACION.SIAC_POSTVENTA_PROCESO.reclamo_caso
 is 'Reclamo Caso';