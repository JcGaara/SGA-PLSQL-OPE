/*Eliminamos variables creadas*/
delete operacion.opedd
 where tipopedd = (select tipopedd 
                               from tipopedd 
                              where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL');

delete operacion.tipopedd
 where abrev = 'HFC_SIAC_SERVICIO_ADICIONAL';
 
delete operacion.tiptrabajo
 where descripcion in ('HFC/SIAC SERVICIOS ADICIONALES', 'HFC/SIAC BAJA SERVICIOS ADICIONALES') 

delete operacion.constante
 where constante in ('DATESADSIACINI', 'DATEBSADSIACINI');

COMMIT;
/