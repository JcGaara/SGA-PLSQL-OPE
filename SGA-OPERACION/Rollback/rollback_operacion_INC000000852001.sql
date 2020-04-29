/*Eliminimos parametros*/

delete from opedd where tipopedd = 
         ( select tipopedd from tipopedd where abrev = 'PORTABILIDAD_NUM_FIJA' );

delete from tipopedd where abrev = 'PORTABILIDAD_NUM_FIJA';

commit;
