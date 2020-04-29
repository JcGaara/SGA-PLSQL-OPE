insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Estado de Licencia', 'ESTADO_LICENCIA_SOPORTE');

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (0, 'Vigente', 'ESTADO_LICENCIA_SOPORTE', (SELECT max(tipopedd) FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE'));

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (1, 'Vencido', 'ESTADO_LICENCIA_SOPORTE', (SELECT max(tipopedd) FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE'));

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (2, 'En Alerta', 'ESTADO_LICENCIA_SOPORTE', (SELECT max(tipopedd) FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE'));

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (3, 'Renovacion', 'ESTADO_LICENCIA_SOPORTE', (SELECT max(tipopedd) FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE'));

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
values (4, 'De Baja', 'ESTADO_LICENCIA_SOPORTE', (SELECT max(tipopedd) FROM operacion.tipopedd WHERE abrev = 'ESTADO_LICENCIA_SOPORTE'));
   
COMMIT;
/