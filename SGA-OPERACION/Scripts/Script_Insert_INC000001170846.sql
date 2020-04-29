insert into operacion.tipopedd (DESCRIPCION, ABREV) values ('TIPO DOCUMENTO', 'TIPDOC_FCO');

insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('N/C', 'NOTA DE CREDITO', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('N/D', 'NOTA DE DEBITO', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('B/V', 'BOLETA', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('FAC', 'FACTURA', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('LET', 'LETRA', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('REC', 'RECIBO', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HRE', 'HOJA RESUMEN', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('HIN', 'HOJA INFORMATIVA', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('D/A', 'DOCUMENTO AUTORIZADO', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('CUO', 'CUOTA', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('TIC', 'TICKET', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
insert into operacion.opedd (CODIGOC, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('COR', 'CORPORATIVO', 'TIPDOC_FCO', (select tipopedd from operacion.tipopedd where abrev='TIPDOC_FCO'), 1);
COMMIT
/