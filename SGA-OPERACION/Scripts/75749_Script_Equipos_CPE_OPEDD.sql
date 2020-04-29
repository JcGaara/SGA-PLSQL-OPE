-- Insercion de Cabecera de Equipos CPE para tipopedd
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Equipos CPE SISACT', 'CPE_SISACT_SGA');
-- Insercion de detalle de Equipos CPE para opedd
insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (16308, 'SIM CARD LTE', null, (select tipopedd from operacion.tipopedd where abrev='CPE_SISACT_SGA'), null);
-- Insercion de detalle de Equipos CPE para opedd
insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (16939, 'CAJA LTE TDD CPE B2268S', null, (select tipopedd from operacion.tipopedd where abrev='CPE_SISACT_SGA'), null);
commit;