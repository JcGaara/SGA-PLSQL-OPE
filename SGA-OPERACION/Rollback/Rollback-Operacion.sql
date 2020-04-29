delete opedd where tipopedd = (Select tipopedd from tipopedd where abrev = 'ebonding');

commit;

delete tipopedd where abrev = 'ebonding';

commit;

drop table OPERACION.WIMAX_ESCENARIOS;
drop table OPERACION.WIMAX_PARAM_ING;
drop table OPERACION.WIMAX_WEBSERVICE;

commit;
