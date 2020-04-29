--Eliminar tablas
DROP TABLE operacion.IW_REPORT;
DROP TABLE operacion.IW_DOCSIS;
DROP TABLE operacion.IW_PACKETCABLE;
DROP TABLE operacion.IW_DAC;
DROP TABLE operacion.IW_ENDPOINTS;
DROP TABLE operacion.IW_CALLFEATURES;
DROP TABLE operacion.IW_SOFTSWITCH;
DROP TABLE operacion.IW_SERVICIOS;


-- Drop columns 
alter table OPERACION.TRS_WS_SGA drop column RESPUESTAXML;
alter table OPERACION.TRS_WS_SGA drop column ESQUEMAXML;
alter table OPERACION.TRS_WS_SGA drop column FECMOD;
alter table OPERACION.TRS_WS_SGA drop column ENDPOINTS;
alter table OPERACION.TRS_WS_SGA drop column SERVICIOS;
alter table OPERACION.TRS_WS_SGA drop column CALLFEATURES;
alter table OPERACION.TRS_WS_SGA drop column SOFTSWITCH;
alter table OPERACION.TRS_WS_SGA drop column TIPOACCION;
alter table OPERACION.TRS_WS_SGA drop column RESULTADO;
alter table OPERACION.TRS_WS_SGA drop column ERROR;
alter table OPERACION.TRS_WS_SGA drop column RESULTADO_WS;
alter table OPERACION.TRS_WS_SGA drop column ERROR_WS;


