insert into tipopedd (DESCRIPCION, ABREV)
values ('Estados EF para imprimir OC', 'ESTD_EF_IMPR_OC');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 6, 'Ejecucion', 'ESTD_EF', (select t.tipopedd from tipopedd t where t.abrev = 'ESTD_EF_IMPR_OC'), 1);

COMMIT;