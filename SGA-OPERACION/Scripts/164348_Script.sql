-- Add/modify columns 
alter table RED.DETMANT modify VALOR VARCHAR2(100);

alter table OPERACION.SOT_LIQUIDACION add MONEDA_ID NUMBER default 1;
-- Add comments to the columns 
comment on column OPERACION.SOT_LIQUIDACION.MONEDA_ID
  is 'Moneda';