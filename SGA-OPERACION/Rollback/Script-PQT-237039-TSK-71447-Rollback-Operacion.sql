-- Elimniar detalle de parametros
delete from operacion.opedd
 where tipopedd = (select operacion.tipopedd.tipopedd
                     from operacion.tipopedd
                    where abrev = 'CONFAC_CLOUD');
-- Eliminar cabecera de parametros
delete from operacion.tipopedd where abrev = 'CONFAC_CLOUD';
commit;