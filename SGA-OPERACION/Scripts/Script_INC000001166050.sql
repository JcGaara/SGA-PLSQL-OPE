insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
values ('Con mas de un servicio', 'SRV_DUPLICID');

insert into OPERACION.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Con mas de un servicio', 4143, 'Codigo servicio', 'SRV_DUPLICID', (select t.tipopedd from tipopedd t where t.abrev = 'SRV_DUPLICID'), 1);

COMMIT
/