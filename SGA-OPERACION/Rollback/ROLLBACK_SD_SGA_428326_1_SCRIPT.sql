DELETE FROM OPERACION.OPEDD
WHERE TIPOPEDD IN (
    SELECT TIPOPEDD FROM OPERACION.TIPOPEDD
    WHERE ABREV IN ('AREA-SOLOT','FLAG-ACTUALIZACION-AREA')
);


DELETE FROM OPERACION.TIPOPEDD
WHERE ABREV IN ('AREA-SOLOT','FLAG-ACTUALIZACION-AREA');


COMMIT;

