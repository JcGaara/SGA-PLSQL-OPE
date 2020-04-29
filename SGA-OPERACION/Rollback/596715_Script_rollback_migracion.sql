DELETE FROM operacion.opedd WHERE tipopedd IN ( SELECT tipopedd FROM tipopedd WHERE abrev = 'SOT_ALTA_MIGRA');
DELETE FROM operacion.tipopedd WHERE abrev = 'SOT_ALTA_MIGRA'; 
COMMIT;
                       