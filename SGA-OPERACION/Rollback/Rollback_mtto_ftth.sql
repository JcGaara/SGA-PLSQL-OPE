delete from operacion.opedd where tipopedd = (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'TIPO_TRANS_SIAC')
 and codigon  = (select tiptra from operacion.tiptrabajo where descripcion = 'FTTH - MANTENIMIENTO');
 
delete from operacion.opedd where CODIGON = (SELECT wfdef FROM opewf.wfdef where descripcion = 'MANTENIMIENTO FTTH');
 
delete from operacion.tiptrabajo where descripcion='FTTH - MANTENIMIENTO';
delete from operacion.subtipo_orden_adc where descripcion = 'MANTENIMIENTO FTTH';
delete from operacion.tipo_orden_adc where descripcion = 'FTTH MANTENIMIENTO';

commit
/