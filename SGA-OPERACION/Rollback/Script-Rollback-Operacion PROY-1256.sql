
DELETE FROM OPERACION.OPEDD WHERE UPPER(ABREVIACION) LIKE '%PROY_TELEFONIA_FIJA%';
DELETE FROM OPERACION.TIPOPEDD WHERE UPPER(ABREV) LIKE '%APROB_AUT_SEF_COR%';
DELETE FROM OPERACION.CONSTANTE WHERE UPPER(constante) = TRIM('APROB_PROY_GERE'); 
DELETE FROM OPERACION.CONSTANTE WHERE UPPER(constante) = TRIM('APROB_PROY_PREV'); 

COMMIT;




