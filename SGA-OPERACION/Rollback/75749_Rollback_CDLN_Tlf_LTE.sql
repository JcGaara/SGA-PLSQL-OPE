-- Codigos de Larga Distancia Nacional
delete from operacion.opedd where tipopedd=(select tipopedd from tipopedd where abrev='CLDN');
delete from operacion.tipopedd where abrev='CLDN';
commit;