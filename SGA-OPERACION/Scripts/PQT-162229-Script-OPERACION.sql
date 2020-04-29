
insert into operacion.tipopedd (DESCRIPCION, ABREV)
values ('OPE-VAL-SOT', null);

commit;

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 408, 'HFC - BAJA TOTAL DE SERVICIO', null, ( select tipopedd from operacion.tipopedd where descripcion = 'OPE-VAL-SOT' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 409, 'HFC - CORTE POR FALTA DE PAGO', null, ( select tipopedd from operacion.tipopedd where descripcion = 'OPE-VAL-SOT' ), 1);

insert into operacion.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, 411, 'HFC - SUSPENSIÓN DEL SERVICIO', null, ( select tipopedd from operacion.tipopedd where descripcion = 'OPE-VAL-SOT' ), 1);

commit;



insert into operacion.tipopedd ( DESCRIPCION, ABREV)
values ('OPE-VAL-ESTADOS', null);

commit;

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 11, 'Aprobado', null, ( select tipopedd from operacion.tipopedd where descripcion = 'OPE-VAL-ESTADOS' ), 1);

insert into operacion.opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null, 17, 'En Ejecución', null, ( select tipopedd from operacion.tipopedd where descripcion = 'OPE-VAL-ESTADOS' ), 1);

commit;



