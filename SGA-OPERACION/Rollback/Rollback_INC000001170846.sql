delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO');
delete from operacion.tipopedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO');
COMMIT
/