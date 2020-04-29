/*Eliminamos los parametros creados*/
delete opedd
 where abreviacion in ('ORIGEN_EXP_DATOS', 'DESTINO_EXP_DATOS')
   and tipopedd = (select tipopedd
                     from tipopedd
                    where abrev = 'CARACTER_ESPECIAL_EXP_DAT');
commit;

delete tipopedd
 where abrev = 'CARACTER_ESPECIAL_EXP_DAT';
commit;
/