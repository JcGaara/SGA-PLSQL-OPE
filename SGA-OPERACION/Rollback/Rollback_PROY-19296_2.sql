delete from operacion.OPEDD where DESCRIPCION in ('CONSENTIDO','OBSERVADO') and TIPOPEDD in 
(select TIPOPEDD from operacion.tipopedd where abrev = 'OPEESTLICGOB');

update operacion.OPEDD set DESCRIPCION = 'CARTA SUSPENSION' where DESCRIPCION = 'SUSPENDIDO' and TIPOPEDD in 
(select TIPOPEDD from operacion.tipopedd where abrev = 'OPEESTLICGOB') ;

commit;