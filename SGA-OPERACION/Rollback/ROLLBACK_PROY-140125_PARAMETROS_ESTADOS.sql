DELETE FROM operacion.opedd
 WHERE tipopedd =
       (SELECT tipopedd FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE');

DELETE FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE';

COMMIT;
/