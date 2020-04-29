alter table OPERACION.SOLOTPTOEQU drop column semana_liq; 
alter table OPERACION.SOLOTPTOEQU drop column cant_despacho; 
alter table OPERACION.SOLOTPTOEQU drop column saldo_despacho; 
alter table OPERACION.SOLOTPTOEQU drop column doc_sap_despacho; 
alter table OPERACION.SOLOTPTOEQU drop column fecha_despacho; 
alter table OPERACION.RECONEXION_APC drop column customer_id;
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA drop column estsol;
alter table OPERACION.CONTRATA drop column tipo_contrata;
alter table OPERACION.SOLOT drop column revisado;

drop table OPERACION.ESTAGENDAAREAHFC;
