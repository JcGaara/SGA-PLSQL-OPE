--1.- ROLLBACK PARAMETROS DE BOUQUET_DTH_MSG
delete from operacion.opedd
 where tipopedd = (select t.tipopedd
                     from operacion.tipopedd t
                    where t.abrev = 'UPDATE_DIR_CONVERGENTE');
delete from operacion.tipopedd where abrev = 'UPDATE_DIR_CONVERGENTE';
commit;
