insert into operacion.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, 7, 'CONSENTIDO', null, (select TIPOPEDD from operacion.tipopedd where abrev = 'OPEESTLICGOB'), 0);

insert into operacion.OPEDD (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ((select max (IDOPEDD)+1 from operacion.opedd), null, 9, 'OBSERVADO', null, (select TIPOPEDD from operacion.tipopedd where abrev = 'OPEESTLICGOB'), 0);

update operacion.OPEDD set DESCRIPCION = 'SUSPENDIDO' where DESCRIPCION = 'CARTA SUSPENSION' and TIPOPEDD in 
(select TIPOPEDD from operacion.tipopedd where abrev = 'OPEESTLICGOB') ;
commit;
