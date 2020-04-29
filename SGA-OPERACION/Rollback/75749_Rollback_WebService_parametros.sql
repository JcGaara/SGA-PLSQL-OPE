delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='datos_param_sans');
delete from operacion.tipopedd where abrev='datos_param_sans';
commit;