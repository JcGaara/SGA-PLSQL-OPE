insert into tipopedd (DESCRIPCION, ABREV)
values ('Lista de Sentencias', 'LIST_STATEMENT');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('DELETE', null, null, 'STATEMENT_VALID', (select t.tipopedd from tipopedd t where t.abrev = 'LIST_STATEMENT'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('DROP', null, null, 'STATEMENT_VALID', (select t.tipopedd from tipopedd t where t.abrev = 'LIST_STATEMENT'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TRUNCATE', null, null, 'STATEMENT_VALID', (select t.tipopedd from tipopedd t where t.abrev = 'LIST_STATEMENT'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('ALTER', null, null, 'STATEMENT_VALID', (select t.tipopedd from tipopedd t where t.abrev = 'LIST_STATEMENT'), 1);

COMMIT;