-- Portabilidad Servicios
-- Eliminar detalle de  parametros
delete from opedd o
 where o.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'PORTABILIDAD_SERVICIOS')
   and o.abreviacion = 'CORPORATIVO';
   
commit;
