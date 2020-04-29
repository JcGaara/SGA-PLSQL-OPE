INSERT INTO OPERACION.CONSTANTE(CONSTANTE, DESCRIPCION, TIPO, VALOR)
   VALUES ('CAMBIOSANULASOT', 'CAMBIOS DE ANULACION SOT HFC PORTABILIDAD', 'N', 1);

insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
values ('TIPO TRABAJO ANULA SOT ', 'TTRAANULA');
insert into OPERACION.tipopedd (DESCRIPCION, ABREV)
values ('ESTADO ANULACION SOT', 'ESTANULASOT');

insert into OPERACION.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('', 676, 'TIPO DE TRABAJO PARA ANULACION  DE SOT HFC PORTA', 'TTRAANULA', (select t.tipopedd from OPERACION.tipopedd t where t.abrev = 'TTRAANULA'), 0);
insert into OPERACION.opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ('', 4, 'ESTADO DE ANULACION DE SOT HFC PORTABILIDAD', 'ESTANULASOT', (select t.tipopedd from OPERACION.tipopedd t where t.abrev = 'ESTANULASOT'), 0);

COMMIT
/
 
