--1.- ROLLBACK PARAMETROS DE BOUQUET_DTH_MSG
delete from operacion.opedd
 where tipopedd = (select t.tipopedd
                     from operacion.tipopedd t
                    where t.abrev = 'ESTAGE_AGENDA');
delete from operacion.tipopedd where abrev = 'ESTAGE_AGENDA';
commit;
