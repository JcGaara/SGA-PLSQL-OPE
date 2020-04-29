-- Habilitar Funcionalidad
-- Eliminar detalle de parametros
delete from opedd o  where o.tipopedd = (select t.tipopedd from operacion.tipopedd t where t.abrev = 'habilita_sot_tpi');

-- Eliminar cabecera de parametros
delete from operacion.tipopedd t where t.abrev = 'habilita_sot_tpi';

commit;