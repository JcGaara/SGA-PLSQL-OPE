insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('CONFIGURACION DE ESTADOS PORTA', 'CONF_VALID_PORT');
COMMIT;
/

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 1, 'GENERADA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 2, 'APROBADA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 3, 'SUSPENDIDA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 4, 'CERRADA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 6, 'EN EJECUCION', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));

insert into operacion.opedd ( CODIGON, DESCRIPCION, TIPOPEDD)
values ( 7, 'RECHAZADA', ( select tipopedd from operacion.tipopedd where abrev = 'CONF_VALID_PORT' ));
COMMIT;
/
