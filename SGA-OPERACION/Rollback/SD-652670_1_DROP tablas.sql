DROP TABLE OPERACION.REG_TRANSACCION_SGA;

DROP SEQUENCE OPERACION.SQ_REG_TRANSACCION_SGA;
DROP SEQUENCE OPERACION.SQ_LOG_ERROR_TRANSAC_SGA;

DELETE FROM OPERACION.CONSTANTE WHERE CONSTANTE = 'OPTHFCMAIL';    
COMMIT;