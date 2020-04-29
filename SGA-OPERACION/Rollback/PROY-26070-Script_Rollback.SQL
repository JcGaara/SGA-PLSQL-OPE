/*********  Eliminar Constantes ************/
delete from operacion.constante where constante = 'PORT_CP_EST_CP';
delete from operacion.constante where constante = 'PORT_CP_EST_POR';
delete from operacion.constante where constante = 'PORT_CP_FEC_PRG';
delete from operacion.constante where constante = 'PORT_CP_MAX';
delete from operacion.constante where constante = 'PORT_CP_MAX_MSJ';
delete from operacion.constante where constante = 'PORT_CP_PRO_ROL';
delete from operacion.constante where constante = 'PORT_CP_REC_TO';
delete from operacion.constante where constante = 'PORT_CP_TIME_OU';
delete from operacion.constante where constante = 'PORT_CP_URL';
commit;

/*********  Eliminar Tipos y Estados  ************/

delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'CAMP_PORT_CORP' );
delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'CON_REC_VAL_PORT' );
delete from operacion.opedd where tipopedd = ( select tipopedd from operacion.tipopedd where abrev = 'CONF_EST_PORT' );
commit;

delete from  operacion.tipopedd where abrev = 'CAMP_PORT_CORP';
delete from  operacion.tipopedd where abrev = 'CON_REC_VAL_PORT';
delete from  operacion.tipopedd where abrev = 'CONF_EST_PORT';
commit;
/
