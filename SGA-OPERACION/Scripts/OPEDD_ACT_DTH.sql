	insert into OPERACION.TIPOPEDD (DESCRIPCION, ABREV)
	values ('CONF. CONTEGO DTH ACTIONS', 'CONF_CONTEGO_DTH_ACTIONS');

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('103', 2000, 'Agregar decodificador a contrato', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('103', 8, 'Agregar un servicio', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('105', 5, 'Desactivacion de un contrato suspendido', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('108', 4, 'Suspension de un contrato', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('110', 3, 'Reactivacion de un contrato', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));

	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('103', 1, 'Activacion inicial de un contrato', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));
	
	insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD)
	values ('108', 0, 'default', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_DTH_ACTIONS'));
	
	COMMIT
	/

	