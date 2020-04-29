insert into OPERACION.CONSTANTE (CONSTANTE, DESCRIPCION, TIPO, VALOR, OBS)
values ('ERR_GEN_SOT_TOA', 'Control de Errores', 'N', '1', null);

insert into tipopedd (DESCRIPCION, ABREV)
values ('Estados Servicios SGA', 'ESTSRVSGA');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Activo', 'ESTSRVSGA', (select t.tipopedd from tipopedd t where t.abrev = 'ESTSRVSGA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 2, 'Suspendido', 'ESTSRVSGA', (select t.tipopedd from tipopedd t where t.abrev = 'ESTSRVSGA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 4, 'Sin Activar', 'ESTSRVSGA', (select t.tipopedd from tipopedd t where t.abrev = 'ESTSRVSGA'), 1);

COMMIT;
/