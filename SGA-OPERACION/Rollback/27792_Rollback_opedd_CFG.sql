delete from operacion.opedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV');
delete from operacion.tipopedd where tipopedd=(select tipopedd from operacion.tipopedd where abrev='CFG_SU_MTV');
commit;