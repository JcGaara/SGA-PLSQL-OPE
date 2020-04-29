/*Eliminar parametros*/
delete from operacion.opedd
 where tipopedd = (select tipopedd
                     from tipopedd
                    where abrev in ('PARAM_PORTA')) 
   and abreviacion in ('TTBPO', 'WBPO', 'TSCE');

commit;
/