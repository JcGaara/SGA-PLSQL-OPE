delete from OPERACION.OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM TIPOPEDD WHERE ABREV = 'BSCS_CONTRATO') AND CODIGON = 1817;

COMMIT;

ALTER TABLE OPERACION.SGAT_SRVEQU_INCOGNITO
DROP (CODSOLOT_BAJA, ID_ACCION)

/