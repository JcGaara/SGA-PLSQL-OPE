insert into tipopedd (DESCRIPCION, ABREV)
values ('Orden de Visita', 'OPC_ORD_VISITA');

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 1, 'Alta Servicio', 'OPERACION', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 2, 'Baja Servicio', 'OPERACION', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 3, 'Cambio de Equipo', 'OPERACION', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 4, 'Alta Total', 'OPERACION', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 5, 'Baja Total', 'OPERACION', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);
insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 0, 'No se puede dar de baja, por favor comunicarse con el area correspondiente', 'MSJ_BAJA_SRV', (select t.tipopedd from tipopedd t where t.abrev = 'OPC_ORD_VISITA'), 1);

COMMIT;