insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
values ('Mensaje de Serie de NC', 'MSJ_SERIE_NC');

insert into OPERACION.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Serie no esta en CONTROLNUMERA', null, 'Mensaje', 'MSJ_SERIE_NC', (select t.tipopedd from tipopedd t where t.abrev = 'MSJ_SERIE_NC'), 1);

COMMIT
/