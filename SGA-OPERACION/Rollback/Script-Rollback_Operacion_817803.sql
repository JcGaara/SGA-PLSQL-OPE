/*Eliminamos los parametros*/

DELETE operacion.opedd
 where tipopedd = (select tipopedd from tipopedd where abrev = 'PRC_HFC_OPT_OV')
   and abreviacion = 'TIPTRA_VAL_OV';

commit;   
/