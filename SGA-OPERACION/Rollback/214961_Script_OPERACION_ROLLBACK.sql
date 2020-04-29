revoke select, insert, update on SGASAP.SGASAP_RATES from WEBSERVICE;

drop table OPERACION.RESERVA_DET;
drop table OPERACION.RESERVA_CAB;
drop table OPERACION.VERIFMATERIAL;
DROP table OPERACION.LOG_ERROR_SGASAP;
DROP table OPERACION.ID_SITIO;
DROP table OPERACION.UBI_TECNICA;
DROP table OPERACION.OPE_WS_SGASAP;
DROP table OPERACION.REL_ORDEN;
DROP table OPERACION.ACTIVIDAD_SAP;
DROP table OPERACION.GRAFO;
DROP table OPERACION.PEP;
drop table OPERACION.TIPROY_SINERGIA;
drop table OPERACION.TIPROY_SINERGIA_PEP;
drop table OPERACION.PROYECTO_SAP;
drop table OPERACION.TRS_GRAFO_ACT;
drop table operacion.TRS_PPTO;
drop table operacion.SOLUCIONXTIPOPEP;
drop table operacion.ETAPAXTIPOPEP;
drop table operacion.UBITECXPROY;


drop sequence operacion.SQ_ID_RES;
drop sequence operacion.SQ_ID_SITIO;
drop sequence operacion.SQ_ID_VERIF;
drop sequence operacion.SQ_IDACTIVIDAD;
drop sequence operacion.SQ_IDGRAFO;
drop sequence operacion.SQ_IDLOTEPPTO;
drop sequence operacion.SQ_IDPEP;
drop sequence operacion.SQ_IDPPTO;
drop sequence operacion.SQ_IDPROYECTO;
drop sequence operacion.SQ_IDRELACION;
drop sequence operacion.SQ_IDTRSGRAFOACT;
drop sequence operacion.SQ_LOG_ERROR_SGASAP;
drop sequence operacion.SQ_OPE_DET_XML;
drop sequence operacion.SQ_OPE_WS_SGASAP;
drop sequence operacion.SQ_PROC_TRSGRAFO;
drop sequence operacion.SQ_PROYECTO_SAP;
drop sequence operacion.SQ_UBITECNICA;

alter table OPERACION.OPE_CAB_XML drop column xmlclob;
alter table OPERACION.OPE_DET_XML drop column orden;
alter table OPERACION.OPE_DET_XML drop column descripcion;
alter table OPERACION.CONTRATA drop column  proveedor_sap;
alter table OPERACION.SOLOTPTOEQU drop column  idppto;
alter table OPERACION.SOLOTPTOEQU drop column  clase_val;
alter table OPERACION.MAESTRO_SERIES_EQU drop column clase_val;
alter table OPERACION.SOLOTPTOETAACT drop column idppto;
alter table OPERACION.SOLOTPTOETA drop column respuesta_sap;
alter table OPERACION.AGENDAMIENTO drop column respuesta_sap;

DROP TYPE OPERACION.TAREA_ACT;

