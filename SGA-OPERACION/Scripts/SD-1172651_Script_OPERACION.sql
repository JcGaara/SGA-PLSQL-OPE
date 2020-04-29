-- Add/modify columns 
alter table OPERACION.LOG_TRS_INTERFACE_IW add proceso VARCHAR2(50);
-- Add comments to the columns 
comment on column OPERACION.LOG_TRS_INTERFACE_IW.proceso
  is 'Evento o Proceso ejecutado';