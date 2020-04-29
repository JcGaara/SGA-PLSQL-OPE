INSERT INTO OPERACION.OPEDD(codigon, descripcion, tipopedd, abreviacion)
VALUES (2,'DEMORA EN SEGUNDOS - SOLICITADO POR BSCS', (SELECT a.tipopedd FROM operacion.tipopedd a WHERE upper(a.abrev) = 'PLAT_JANUS'), 'TIMER');

COMMIT;
