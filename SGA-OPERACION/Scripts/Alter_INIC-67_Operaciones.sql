-- Add/modify columns 
alter table OPERACION.EF add efn_flag_plazo_ar NUMBER(1) default 0;
-- Add comments to the columns 
comment on column OPERACION.EF.efn_flag_plazo_ar
  is 'Flag para Analisis de Rentabilidad. 1: Se puede modificar Plazo en AR/0: No Se puede modificar Plazo en AR';

-- Add/modify columns 
alter table OPERACION.SOLOT add codsolotrem NUMBER(8);
-- Add comments to the columns 
comment on column OPERACION.SOLOT.codsolotrem
  is 'Código de SOT de remplazo';