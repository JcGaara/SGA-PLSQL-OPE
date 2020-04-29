--Eliminar paquetes

drop PACKAGE OPERACION.PQ_TELEFONIA_CE;
drop PACKAGE OPERACION.PQ_JANUS_CE;
drop PACKAGE OPERACION.PQ_JANUS_CE_ALTA;
drop PACKAGE OPERACION.PQ_JANUS_CE_BAJA;
drop PACKAGE OPERACION.PQ_JANUS_CE_CONEXION;
drop PACKAGE OPERACION.PQ_JANUS_CE_PROCESOS;
drop PACKAGE OPERACION.PQ_TELEFONIA_CE_DET;

--Eliminar tareas
DELETE FROM OPEWF.TAREADEF
 WHERE descripcion IN ('Activacion - Lineas Control CE',  'Desactivacion - Lineas Control CE');
 
 
 --Eliminar tipos y estados

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'TIPSRV_JANUS_CE');

DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS_CE');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL_CE');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'TIPSRV_JANUS_CE');


-- Eliminar sequence 
drop sequence operacion.sq_telefonia_ce_det;
drop sequence operacion.sq_telefonia_ce;

--Eliminar tablas

drop table  operacion.telefonia_ce;
drop table  operacion.telefonia_ce_det;

COMMIT;
