-- Drop columns 
alter table OPERACION.SECUENCIA_ESTADOS_AGENDA drop column APLICA_CONTRATA;
-- Drop columns 
alter table HISTORICO.SECUENCIA_ESTADOS_AGENDA_LOG drop column APLICA_CONTRATA;


--Actualizacion
update INTRAWAY.configuracion_itw set codigo_ext ='DTA' WHERE idconfigitw = 54;
COMMIT; 