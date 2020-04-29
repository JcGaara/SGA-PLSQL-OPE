-- Eliminar detalle de parametros
delete from opedd d  where d.tipopedd = (select t.tipopedd from tipopedd t where t.abrev = 'PARAM_FACT_SGA');
-- Eliminar cabecera de parametros
delete from operacion.tipopedd where abrev = 'PARAM_FACT_SGA';

COMMIT;
