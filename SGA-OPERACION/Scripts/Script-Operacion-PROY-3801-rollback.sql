DELETE FROM OPERACION.OPEDD WHERE UPPER(ABREVIACION) LIKE '%REG_DTH%';
DELETE FROM OPERACION.OPEDD WHERE UPPER(ABREVIACION) LIKE '%ACT_DTH%';
DELETE FROM OPERACION.OPEDD WHERE UPPER(ABREVIACION) LIKE '%PROG_DTH%';
DELETE FROM OPERACION.OPEDD WHERE UPPER(ABREVIACION) LIKE '%INSTALADOR_DTH%';

DELETE FROM OPERACION.TIPOPEDD WHERE UPPER(ABREV) LIKE '%IVR_DTH%';

COMMIT;

--Eliminar Packages
drop package OPERACION.PQ_IVR_DTH;
/
