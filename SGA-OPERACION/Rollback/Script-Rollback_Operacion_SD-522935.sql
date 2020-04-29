/*Eliminamos variables creadas*/
delete operacion.opedd
 where tipopedd = (select tipopedd 
                               from tipopedd 
                              where abrev = 'EST_SOL_DEC_ADI');

delete operacion.tipopedd
 where abrev = 'EST_SOL_DEC_ADI';
 
 commit;
 
 /* Regresar default a OPERACION.SOLOT.areasol */
alter table OPERACION.SOLOT modify areasol default null;
