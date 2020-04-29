-- Add/modify columns 
alter table OPERACION.SOLOT add cargo number(8,2);
-- Add comments to the columns 
comment on column OPERACION.SOLOT.CARGO is 'Cargo al cliente';

-- Add/modify columns 
alter table OPERACION.LOG_TRS_INTERFACE_IW modify texto VARCHAR2(3000);
