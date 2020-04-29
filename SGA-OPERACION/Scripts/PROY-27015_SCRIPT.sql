INSERT INTO OPERACION.CONSTANTE(CONSTANTE,DESCRIPCION,TIPO,VALOR) VALUES('MIGRT_IC_TOT','Control Ejecución Directa Incognito','C','0');
INSERT INTO OPERACION.CONSTANTE(CONSTANTE,DESCRIPCION,TIPO,VALOR) VALUES('MIGRT_DAC_IC','Control Incognito Directo DAC','C','1');

INSERT INTO TIPOPEDD (TIPOPEDD, DESCRIPCION, ABREV)
VALUES ((SELECT MAX(TIPOPEDD) + 1 FROM TIPOPEDD), 'CORREO ERROR IC', 'MAIL_IC');
        
INSERT INTO OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
VALUES ((SELECT MAX(IDOPEDD) + 1 FROM OPEDD), 'marco.delacruz@claro.com.pe',null, 'MAIL',null,
(SELECT MAX(TIPOPEDD) FROM TIPOPEDD WHERE UPPER(ABREV)='MAIL_IC'), NULL);

COMMIT;
