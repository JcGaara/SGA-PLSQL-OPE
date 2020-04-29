-- Detalle de parametros
delete from operacion.opedd o
 where o.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'tipo_traslados');

-- Cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'tipo_traslados';

commit;
