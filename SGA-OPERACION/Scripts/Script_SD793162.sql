insert into constante (CONSTANTE, DESCRIPCION, TIPO, VALOR)
values ('ERR_GEN_SOT', 'Control de Errores', 'N', '1');

insert into tipopedd (DESCRIPCION, ABREV)
values ('Duplicidad Equipo', 'VALGRUPEQDOB');

insert into tipopedd (DESCRIPCION, ABREV)
values ('Equipo no configurado', 'VALGRUPEQNOCONFIG');

insert into tipopedd (DESCRIPCION, ABREV)
values ('Estado SOT Numero Portable', 'ESTSOTVALPORTHFC');

insert into tipopedd (DESCRIPCION, ABREV)
values ('Config. Numeros Portables', 'CONF_NUM_PORTAB');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('009', null, 'Comodato', 'GRUPO', (select t.tipopedd from tipopedd t where t.abrev = 'VALGRUPEQDOB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('001', null, 'Telefonía Fija', 'GRUPO_PRINC', (select t.tipopedd from tipopedd t where t.abrev = 'VALGRUPEQDOB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('002', null, 'Internet Fijo', 'GRUPO_PRINC', (select t.tipopedd from tipopedd t where t.abrev = 'VALGRUPEQDOB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('008', null, 'Alquiler de Equipos', 'GRUPO', (select t.tipopedd from tipopedd t where t.abrev = 'VALGRUPEQNOCONFIG'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('009', null, 'Comodato', 'GRUPO', (select t.tipopedd from tipopedd t where t.abrev = 'VALGRUPEQNOCONFIG'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('ATENDIDA', 29, 'Atendida', null, (select t.tipopedd from tipopedd t where t.abrev = 'ESTSOTVALPORTHFC'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('RECHAZADA', 15, 'Rechazada', null, (select t.tipopedd from tipopedd t where t.abrev = 'ESTSOTVALPORTHFC'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('EJECUCION', 17, 'En Ejecucion', null, (select t.tipopedd from tipopedd t where t.abrev = 'ESTSOTVALPORTHFC'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 412, 'HFC - TRASLADO EXTERNO', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 427, 'HFC - CAMBIO DE PLAN', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 620, 'CLARO EMPRESAS HFC - SERVICIOS MENORES', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 658, 'HFC - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 676, 'HFC - PORTABILIDAD INSTALACIONES PAQUETES CLARO', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 678, 'HFC/SISACT - MIGRACION SISACT', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 693, 'HFC/SIAC - TRASLADO EXTERNO', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 694, 'HFC/SIAC - TRASLADO INTERNO', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HFC', 695, 'HFC/SIAC - CAMBIO DE PLAN', 'ALTA', (select t.tipopedd from tipopedd t where t.abrev = 'CONF_NUM_PORTAB'), 1); 

COMMIT;
