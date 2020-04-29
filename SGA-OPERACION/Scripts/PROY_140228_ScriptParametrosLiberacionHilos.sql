insert into operacion.tipopedd (descripcion, abrev)
values ('Dias Para Liberar Fibra', 'DIAS_LIBERAR_HILOS');

insert into operacion.opedd (codigon, descripcion, abreviacion, tipopedd)
values (60, 'Dias', 'DIAS', (select tipopedd from operacion.tipopedd where abrev = 'DIAS_LIBERAR_HILOS'));

insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Disponibilidad de Hilos', 'DISPONIBILIDAD_HILOS');

insert into operacion.opedd (CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (142, 'Corp con LH', 'LIBERAR', (SELECT tipopedd FROM operacion.tipopedd WHERE abrev = 'DISPONIBILIDAD_HILOS'), 1);

insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('Tipos de trabajo/liberar hilos', 'TIPTRA_LIBERAR_HILOS');

insert into operacion.opedd (codigon, descripcion, abreviacion, tipopedd)
values (1, 'INSTALACION', 'ALTA', (select tipopedd from operacion.tipopedd where abrev = 'TIPTRA_LIBERAR_HILOS'));

insert into operacion.opedd (codigon, descripcion, abreviacion, tipopedd)
values (80, 'TRASLADO EXTERNO', 'ALTA', (select tipopedd from operacion.tipopedd where abrev = 'TIPTRA_LIBERAR_HILOS'));

COMMIT;
/
