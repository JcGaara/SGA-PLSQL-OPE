delete from operacion.opedd where tipopedd in (select tipopedd from operacion.tipopedd where abrev = 'DTH_AUTOMATICO_FAC');
delete from operacion.tipopedd where abrev = 'DTH_AUTOMATICO_FAC';
commit;