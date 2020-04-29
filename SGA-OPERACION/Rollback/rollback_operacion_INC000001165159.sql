/*Eliminimos parametros*/

delete from operacion.opedd where tipopedd = 
         ( select tipopedd from operacion.tipopedd where abrev = 'SGA_VAL_ESTADO_CONTRATO' );
delete from operacion.tipopedd where abrev = 'SGA_VAL_ESTADO_CONTRATO';

commit;

