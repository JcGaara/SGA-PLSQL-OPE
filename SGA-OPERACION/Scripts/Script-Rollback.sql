--Eliminar paquetes

drop PACKAGE operacion.pq_janus_procesos;
drop PACKAGE operacion.pq_janus_ejecucion; 
drop PACKAGE operacion.pq_janus_rechazo;
drop PACKAGE operacion.pq_janus_suspension;
drop PACKAGE operacion.pq_janus_reconexion; 
drop PACKAGE operacion.pq_janus_traslado_externo;
drop PACKAGE operacion.pq_janus_utl; 
drop PACKAGE operacion.pq_abierta;
drop PACKAGE operacion.pq_tellin_conexion;
drop PACKAGE operacion.pq_tellin_cambio_plan;
drop PACKAGE operacion.pq_tellin_baja;
drop PACKAGE operacion.pq_tellin_alta;
drop PACKAGE operacion.pq_tellin;
drop PACKAGE operacion.pq_janus_conexion; 
drop PACKAGE operacion.pq_janus_cambio_plan; 
drop PACKAGE operacion.pq_janus_baja;
drop PACKAGE operacion.pq_janus_alta; 
drop PACKAGE operacion.pq_janus; 
drop PACKAGE operacion.pq_int_telefonia_log;
drop PACKAGE operacion.pq_int_telefonia; 
drop PACKAGE operacion.pq_plataforma_janus; 


--Eliminar tareas

DELETE FROM OPEWF.TAREADEF
 WHERE descripcion IN ('Verificacion de Transaccion en JANUS',
                       'Traslado Externo - Lineas Control',
                       'Cambio de Plan - Lineas Control',
                       'Desactivacion - Lineas Control',
                       'Activacion - Lineas Control',
                       'Suspension en Plataforma Telefonica',
		       'Reconexion en Plataforma Telefonica Janus',
                       'Corte en Plataforma Telefonica Janus');

--Eliminar tipos y estados

DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_VERIFICA_TX');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE');
DELETE FROM operacion.opedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO');


DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'BSCS_SHELL_PLAT_TEL');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_VERIFICA_TX');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_OPE');
DELETE FROM operacion.tipopedd WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'JANUS_SOT_RECHAZO');

-- Eliminar sequence 
drop sequence operacion.sq_int_telefonia;
drop sequence operacion.sq_int_telefonia_log;


--Eliminar tablas

drop table  operacion.int_telefonia;
drop table  operacion.int_telefonia_log;

commit;

