-- Drop indexes 
drop index OPERACION.IDX_SOLOTPTO_007;
-- Drop columns 
alter table OPERACION.TRS_WS_SGA drop column REPORTOBJOUTPUT;
alter table OPERACION.TRS_WS_SGA drop column DOCSISREPORT;
alter table OPERACION.TRS_WS_SGA drop column PACKETCABLEREPORT;
alter table OPERACION.TRS_WS_SGA drop column DAC;
