--delete registry operacion

delete from operacion.tipopedd where abrev = 'CIERAUTUPCRP';
commit;

delete from operacion.opedd where tipopedd = (select tipopedd from tipopedd where abrev = 'CIERAUTUPCRP');
commit;
