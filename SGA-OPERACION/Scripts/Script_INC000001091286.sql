insert into tipopedd (DESCRIPCION, ABREV)
values ('Estado SOT Inhabilitar', 'EST_SOT_INHAB');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 15, 'Rechazado', 'EST_SOT_INHAB', (select t.tipopedd from tipopedd t where t.abrev = 'EST_SOT_INHAB'), 1);

COMMIT
/