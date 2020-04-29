
insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION TAREAS LTE', 'CONF_TAREAS_LTE');

insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONF. ACCIONES LTE-JANUS', 'CONF_LTE_JANUS');
commit;

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('CONAX', (select tareadef from tareadef where descripcion = 'Validacion TRX CONAX'), 'Validacion TRX CONAX', 'PRE', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAREAS_LTE' ), null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('IL', (select tareadef from tareadef where descripcion = 'Validacion TRX IL'), 'Validacion TRX IL', 'PRE', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAREAS_LTE' ), null);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('JANUS', (select tareadef from tareadef where descripcion = 'Validacion TRX JANUS'), 'Validacion TRX JANUS', 'POST', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_TAREAS_LTE' ), null);
commit;


insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Activo', 10, 'DESBLOQUEO', 'OAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Activo', 11, 'RECONEXION', 'OAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Suspendido', 9, 'BLOQUEO', 'OAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Terminado', 2, 'CANCELACION', 'OAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);
commit;
