insert into operacion.tipopedd (descripcion, abrev)
values ('Estados de reserva SAP - SGA', 'EST_RES_SAPSGA');
commit;

insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (1, 'Generado', (select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (2, 'Salida Final', (select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (3, 'Salida Parcial', (select max(tipopedd) from operacion.tipopedd));
insert into operacion.opedd (codigon, descripcion, tipopedd) 
values (9, 'Borrado', (select max(tipopedd) from operacion.tipopedd));
commit;