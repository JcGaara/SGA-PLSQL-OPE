-- Actions de APC
insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Activo', 11, 'RECONEXION', 'SIAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Suspendido', 8, 'SUSPENSION', 'SIAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('Terminado', 2, 'CANCELACION', 'SIAC', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_LTE_JANUS' ), 1);
commit;

-- Estados de JANUS
insert into tipopedd ( DESCRIPCION, ABREV)
values ('CONF. ESTADOS SERV LTE', 'CON_EST_SGA_LTE');
commit;

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 1, 'ACTIVO', 'SRV', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 2, 'SUSPENDIDO', 'SRV', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 1, 'ACTIVO', 'PRD', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 2, 'SUSPENDIDO', 'PRD', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 12, 'CERRADA', 'ESTSOL', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values ( 29, 'ATENDIDA', 'ESTSOL', ( select tipopedd from operacion.tipopedd where abrev = 'CON_EST_SGA_LTE' ));
commit;

-- Tipo de DTH
insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( '8', 'Reconexion Postpago LTE', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SLTD_ENV_CONAX' ));

insert into operacion.opedd ( CODIGOC, DESCRIPCION, TIPOPEDD)
values ( '9', 'Suspension Postpago LTE', ( select tipopedd from operacion.tipopedd where abrev = 'TIPO_SLTD_ENV_CONAX' ));
commit;
/