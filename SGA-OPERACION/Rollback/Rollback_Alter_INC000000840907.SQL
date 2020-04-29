delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' );
commit;
/

delete from  operacion.tipopedd where abrev = 'CONF_VALID_PORT';
COMMIT;
/