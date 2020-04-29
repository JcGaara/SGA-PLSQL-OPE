BEGIN
	INSERT INTO OPERACION.CONSTANTE(CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
	VALUES ('CTTO_DIAS_REGUL', 'Numero de dias para regularizar contratos', 'N',  '7', 'Numero de dias para regularizar contratos');
	COMMIT;
END;
/