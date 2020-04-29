DELETE FROM OPERACION.OPEDD
WHERE tipopedd IN (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS')
AND abreviacion = 'TIMER';

COMMIT;
