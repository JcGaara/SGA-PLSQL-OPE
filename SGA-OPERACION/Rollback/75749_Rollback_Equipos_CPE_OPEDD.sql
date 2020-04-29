delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CPE_SISACT_SGA');
delete from operacion.tipopedd where abrev='CPE_SISACT_SGA';
commit;