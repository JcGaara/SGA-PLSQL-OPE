DELETE FROM CONSTANTE WHERE CONSTANTE IN ('MIGRT_IC_TOT','MIGRT_DAC_IC');
DROP TABLE INTRAWAY.SGAT_CMTS_INC;
DELETE FROM OPERACION.OPEDD WHERE TIPOPEDD = (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'MAIL_IC');
DELETE FROM OPERACION.TIPOPEDD  WHERE ABREV = 'MAIL_IC';
commit;