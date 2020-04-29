--ROLLBACK
ALTER TABLE OPERACION.TRSOACSGA drop column fecmod;
ALTER TABLE OPERACION.TRSOACSGA drop column usumod;
update operacion.opedd
   set codigoc = null, codigon = 2
 where tipopedd = 31112
   and codigoc = 2
   and codigon = 1;

delete from operacion.opedd
 where tipopedd = 31112
   and codigoc = 3
   and abreviacion = 'TIPESCPARCTOTAL';
commit;

delete from operacion.OPE_PLANTILLASOT
where  DESCRIPCION = 'FTTH - BSCS- CORTE'; 
commit;

delete from operacion.OPE_PLANTILLASOT
where  DESCRIPCION = 'FTTH - BSCS- RECONEXION CFP'; 
commit;


/
