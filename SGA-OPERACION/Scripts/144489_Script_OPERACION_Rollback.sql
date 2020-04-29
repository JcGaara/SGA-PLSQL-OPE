-- Drop columns 
alter table OPERACION.TRS_WS_SGA drop column ID_CLIENTE;
alter table OPERACION.SOLOT drop column NUMSEC;
alter table OPERACION.SOLOT drop column FLG_RETENCION;

--2. Eliminar Indice
drop index OPERACION.IDX_RETEN;