insert into tipopedd (DESCRIPCION, ABREV)
values ('Decos HD', 'DECO_HD');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AGHE', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AGIE', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AGJC', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AGHP', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('8262', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AHCW', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AAPV', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AHEL', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('9289', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AAFM', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AAQT', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('AFXW', null, null, 'DECO_HD', (select t.tipopedd from tipopedd t where t.abrev = 'DECO_HD'), 1);

COMMIT;