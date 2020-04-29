-- Portabilidad Validacion
-- Eliminar detalle de parametros
delete from opedd o
 where o.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'portabilidad_validacion')
   and o.abreviacion = 'liberar_num_sga';
   
commit;