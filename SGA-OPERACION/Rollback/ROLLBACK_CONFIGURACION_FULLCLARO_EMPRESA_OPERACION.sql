--Delete  operaciones
delete from operacion.opedd where tipopedd = (select tipopedd from operacion.tipopedd where abrev = 'CIERAUTUPCRP');
commit;

delete from operacion.tipopedd where abrev = 'CIERAUTUPCRP';
commit;
