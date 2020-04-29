-- Detalle de parametros
delete from operacion.opedd o
 where o.tipopedd = (select t.tipopedd
                       from operacion.tipopedd t
                      where t.abrev = 'suspension');

-- Cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'suspension';

-- Constante

delete from operacion.constante c where c.constante = 'DATESUSSIACINI';

delete from operacion.constante c where c.constante = 'DATERECSIACINI';

commit;
