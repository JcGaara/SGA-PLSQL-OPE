-- Drop columns 
alter table TELEFONIA.NUMTEL drop column IMEI;
alter table TELEFONIA.NUMTEL drop column SIMCARD;

-- Drop columns 
alter table HISTORICO.TEL_NUMTEL_LOG drop column IMEI;
alter table HISTORICO.TEL_NUMTEL_LOG drop column SIMCARD;

drop package OPERACION.PQ_BAM;