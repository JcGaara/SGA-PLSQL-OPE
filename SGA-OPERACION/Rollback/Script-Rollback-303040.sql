-- Eliminar detalle
delete from operacion.opedd
 where tipopedd = (select operacion.tipopedd.tipopedd
                     from operacion.tipopedd
                    where abrev = 'PUN_ANEX_TIP');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd where abrev = 'PUN_ANEX_TIP';

commit;

