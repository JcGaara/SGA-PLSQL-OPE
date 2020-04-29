-- Add/modify columns 
alter table RED.DETMANT modify VALOR VARCHAR2(30);

-- Drop columns 
alter table OPERACION.SOT_LIQUIDACION drop column MONEDA_ID;