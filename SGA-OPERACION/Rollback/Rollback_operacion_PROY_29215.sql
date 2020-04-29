delete operacion.opedd where tipopedd = (Select tipopedd from tipopedd where abrev = 'PAR_VAL_CCI');

delete operacion.tipopedd where abrev = 'PAR_VAL_CCI';

commit;

