insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
values ('VALIDA - ASIGNA NUMERO', 'SGA_ASIGNAR_NUMERO');

insert into OPERACION.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('1', null, 'Valida Asignacion de Numeros', 'SGA_ASIGNAR_NUMERO', (select t.tipopedd from tipopedd t where t.abrev = 'SGA_ASIGNAR_NUMERO'), 1);

COMMIT
/