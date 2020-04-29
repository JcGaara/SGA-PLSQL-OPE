insert into operacion.opedd (codigon, descripcion, tipopedd, codigon_aux)
values ((SELECT tiptra FROM operacion.tiptrabajo where descripcion = 'WLL/SIAC - BAJA ADMINISTRATIVA'),'WLL/SIAC - BAJA ADMINISTRATIVA',1235,5 );

insert into operacion.opedd (codigon, descripcion, tipopedd, codigon_aux)
values ((SELECT tiptra FROM operacion.tiptrabajo where descripcion = 'WLL/SIAC - BAJA TOTAL DE SERVICIO'),'WLL/SIAC - BAJA TOTAL DE SERVICIO',1235,5 );

commit;
/