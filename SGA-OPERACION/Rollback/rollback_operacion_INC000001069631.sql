/*Eliminimos parametros*/

delete from opedd where tipopedd = 
         ( select tipopedd from tipopedd where abrev = 'VALIDA_PRIXHUNTING' );

delete from tipopedd where abrev = 'VALIDA_PRIXHUNTING';

commit;
