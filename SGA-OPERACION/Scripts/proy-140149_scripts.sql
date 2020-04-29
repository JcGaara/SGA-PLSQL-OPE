insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Datos de agenda para APP CH', 'DATAGENDACH');

insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Estados agenda visita APP CH', 'ESTVIAGECH');

insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Motivo cancela agenda APP CH', 'MOTCANORDCH');

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 16, '', 'ESTVIA16', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, '', 'ESTVIA1', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 104, '', 'ESTVIA104', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 89, '', 'ESTVIA89', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 118, '', 'ESTVIA118', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 87, '', 'ESTVIA87', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 22, '', 'ESTVIA22', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'ESTVIAGECH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 684, 'No deseo la instalación', 'CLIDESINT', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 12, 'Salí de casa', 'CLIAUSEN', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 13, 'Problema resuelto', 'CLISEROKLIN', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 204, 'Problema resuelto', 'CLISEROKVITE', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 14, 'No deseo la visita', 'CLINOVITEC', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 326, 'No tengo disponibilidad', 'CLINODIS', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'MOTCANORDCH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Reagendamiento desde APP Claro SMART HOME', 'OBSREAGEAPP', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Cancelacion desde APP Claro SMART HOME', 'OBSCANAPP', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 3, 'Nuevo estado SOT', 'NEWESTSOT', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Reagendamiento desde TOA', 'OBSREAGETOA', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH'), 1);

insert into OPERACION.OPEDD (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Cancelacion desde TOA', 'OBSCANTOA', (select o.tipopedd from operacion.tipopedd o where o.abrev = 'DATAGENDACH'), 1);


/