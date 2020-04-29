
delete from   operacion.opedd    where tipopedd in ( select tipopedd from operacion.tipopedd where descripcion =  'OPE-VAL-SOT' );
delete from operacion.tipopedd where descripcion =  'OPE-VAL-SOT';
commit;

delete from operacion.opedd    where tipopedd in ( select tipopedd from operacion.tipopedd where descripcion =  'OPE-VAL-ESTADOS' );
delete from operacion.tipopedd where descripcion =  'OPE-VAL-ESTADOS';
commit;



