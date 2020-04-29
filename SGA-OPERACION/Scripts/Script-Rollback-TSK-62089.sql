---------------------------------- PORTABILIDAD_USERS_AUTO
-- Eliminar detalle de parametros
delete from operacion.opedd o  where o.tipopedd = (select t.tipopedd from operacion.tipopedd t where t.abrev = 'PORTABILIDAD_USERS_AUTO');
-- Eliminar cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'PORTABILIDAD_USERS_AUTO';
------------------------------------------ PORTABILIDAD_MSG_CP
update opedd o
   set o.codigon_aux = 0
 where o.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PORTABILIDAD_MSG_CP')
   and o.abreviacion = 'REC01ABD11';
------------------------------------------ PORTABILIDAD_MSG
update opedd o
   set o.codigon_aux = 0
 where o.tipopedd =
       (select t.tipopedd from tipopedd t where t.abrev = 'PORTABILIDAD_MSG')
   and o.abreviacion = '05R03';
---------------------------------- PORTABILIDAD_VALIDACION
-- Eliminar detalle de parametros
delete from operacion.opedd o  where o.tipopedd = (select t.tipopedd from operacion.tipopedd t where t.abrev = 'portabilidad_validacion');
-- Eliminar cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'portabilidad_validacion';

COMMIT;
/
