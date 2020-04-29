
delete from operacion.opedd
 where tipopedd =
       (select tipopedd from tipopedd where abrev = 'SOLUCION_SISACT')
   and codigon =
       (select idsolucion from soluciones where solucion = 'FTTH SISACT-SGA');

delete from opedd
 where descripcion = 'Paquetes Masivos HFC'
   and abreviacion = 'PAQ_MASIVO_HFC';

delete from opedd
 where descripcion = 'Paquetes Masivos FTTH'
   and abreviacion = 'PAQ_MASIVO_FTTH';

delete from tipopedd
 where descripcion = 'Paquetes Masivos Fija'
   and abrev = 'PAQ_MASIVO_FIJA';

commit;
/