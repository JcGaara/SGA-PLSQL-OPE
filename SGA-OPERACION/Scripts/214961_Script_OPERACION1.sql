alter table OPERACION.OPE_CAB_XML add xmlClob clob;
alter table OPERACION.OPE_DET_XML add orden number;
alter table OPERACION.OPE_DET_XML add descripcion varchar2(300);
alter table OPERACION.CONTRATA add proveedor_sap VARCHAR2(30);
alter table OPERACION.SOLOTPTOEQU add idppto number;
alter table OPERACION.SOLOTPTOEQU add clase_val varchar2(30);
alter table OPERACION.SOLOTPTOETAACT add idppto NUMBER;
alter table operacion.MAESTRO_SERIES_EQU add clase_val VARCHAR2(30);
alter table operacion.SOLOTPTOETA add respuesta_sap VARCHAR2(4); 
alter table operacion.agendamiento add respuesta_sap VARCHAR2(4); 

comment on column OPERACION.OPE_DET_XML.orden is 'Orden';
comment on column OPERACION.OPE_DET_XML.descripcion  is 'Descripcion Breve';
comment on column OPERACION.CONTRATA.proveedor_sap  is 'CodigoSAP de la Contrata';
comment on column OPERACION.OPE_CAB_XML.xmlclob  is 'CLOB XML';
comment on column OPERACION.SOLOTPTOEQU.idppto  is 'ID Agrupador Presupuesto';
comment on column OPERACION.SOLOTPTOEQU.clase_val  is 'Clase de Valorizacion : VALORADO NO VALORADO';
comment on column OPERACION.SOLOTPTOETAACT.idppto   is 'ID Agrupador Presupuesto';
comment on column OPERACION.MAESTRO_SERIES_EQU.clase_val is 'Clase de Valorizacion : VALORADO NO VALORADO';
comment on column operacion.SOLOTPTOETA.respuesta_sap  is 'Respuesta SAP  E: Error';
comment on column operacion.agendamiento.respuesta_sap  is 'Respuesta SAP  E: Error';

CREATE OR REPLACE TYPE OPERACION.TAREA_ACT as table of varchar2(4000);
/


