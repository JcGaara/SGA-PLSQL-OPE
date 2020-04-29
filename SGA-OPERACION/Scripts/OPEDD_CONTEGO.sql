
	delete from operacion.opedd where tipopedd = (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID') and codigoc in ('8','9');
	
	insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
	values ('8', 749, 'Reconexion de equipo. LTE', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID'), 110);

	insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
	values ('8', 781, 'Reconexion de equipo. LTE', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID'), 110);

	insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
	values ('9', 748, 'Suspension de equipo. LTE', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID'), 108);

	insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
	values ('9', 758, 'Suspension de equipo. LTE', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID'), 108);

	insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, TIPOPEDD, CODIGON_AUX)
	values ('9', 747, 'Desactivacion de Bouquets en equipo. LTE', (SELECT TIPOPEDD FROM OPERACION.TIPOPEDD WHERE ABREV = 'CONF_CONTEGO_TIPTRA_ACTIONID'), 105);

	COMMIT;
	/