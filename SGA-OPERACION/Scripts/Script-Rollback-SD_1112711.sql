--BORRAR REGISTROS

   DELETE FROM operacion.opedd
    WHERE tipopedd IN (SELECT a.tipopedd
                         FROM operacion.tipopedd a
                        WHERE upper(a.abrev) = 'PLAT_JANUS')
      AND abreviacion IN ('DIRSUC', 'REFERENCIA');

COMMIT;
