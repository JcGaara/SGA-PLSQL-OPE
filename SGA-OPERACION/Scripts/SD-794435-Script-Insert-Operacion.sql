insert into tipopedd (DESCRIPCION, ABREV)
values ('Usuarios derivacion EBONDING', 'USR_EBONDING');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('1', 29, 'OPERACION_NOC', 'USR_CNOC', (Select tipopedd from tipopedd where abrev = 'USR_EBONDING'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('8', 29, 'OPERACION_NOC', 'USR_CNOC', (Select tipopedd from tipopedd where abrev = 'USR_EBONDING'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('22', 29, 'OPERACION_NOC', 'USR_CNOC', (Select tipopedd from tipopedd where abrev = 'USR_EBONDING'), 1);

commit;
