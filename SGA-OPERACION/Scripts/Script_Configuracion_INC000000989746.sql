insert into tipopedd (DESCRIPCION, ABREV)
values ('ESTADOS PARA CAMBIO DE PLAN', 'EST_CAMB_PLAN');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, null, 'ESTINSSRV_CP', (select t.tipopedd from tipopedd t where t.abrev = 'EST_CAMB_PLAN'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 2, null, 'ESTINSSRV_CP', (select t.tipopedd from tipopedd t where t.abrev = 'EST_CAMB_PLAN'), 1);

COMMIT
/