/*Eliminamos el parametro creado*/

delete from operacion.opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'PROY_R_IW' );
delete from operacion.tipopedd where abrev = 'PROY_R_IW';
commit;
/