delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev = 'EST_RES_SAPSGA');
delete from operacion.tipopedd where abrev = 'EST_RES_SAPSGA';
commit;