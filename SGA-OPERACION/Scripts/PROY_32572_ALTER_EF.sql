-- Add/modify columns 
alter table OPERACION.EF add efn_flag_ar NUMBER(1) default 0;
-- Add comments to the columns 
comment on column OPERACION.EF.efn_flag_ar
  is 'Flag para Analisis de Rentabilidad. 1: Procesado/0:No Procesado';