ALTER TABLE OPERACION.TRSOACSGA ADD fecmod date default sysdate;
ALTER TABLE OPERACION.TRSOACSGA ADD usumod varchar2(100) default user;
update operacion.opedd
   set codigoc = 2, codigon = 1
 where tipopedd = 31112
   and codigon = 2;

insert into operacion.opedd
  (codigoc, codigon, descripcion, abreviacion, tipopedd, codigon_aux)
values
  (3,
   7,
   'Tipo de Escenario Prov Incognito: CustomerID(1) o ServicesID(2) -Total (0) o Parcial(1)',
   'TIPESCPARCTOTAL',
   31112,
   1);
commit;

DECLARE
  ln_count NUMBER;
BEGIN

 --CORTE
  ln_count := 0;
  select COUNT(*)
  INTO ln_count
  from operacion.OPE_PLANTILLASOT t
  where t.DESCRIPCION = 'FTTH - BSCS- CORTE';
  IF ln_count = 0 THEN
	  
	  insert into operacion.OPE_PLANTILLASOT
	  (IDPLANSOT,
	   DESCRIPCION,
	   TIPTRA,
	   MOTOT,
	   TIPSRV,
	   DIASFECCOM,
	   AREASOL,
	   TIPTRAMAN,
	   ESTADO,
	   USUREG,
	   FECREG)
	values
	  ((select max(td.IDPLANSOT) + 1 from operacion.OPE_PLANTILLASOT td),
	   'FTTH - BSCS- CORTE',
	   841,--TIPO TRABAJO
	   13,
	   '0061',
	   0,
	   201,
	   null,
	   1,
	   user,
	   sysdate
		);
	commit;
END IF;

 --RECONEXION
   ln_count := 0;
  select COUNT(*)
  INTO ln_count
  from operacion.OPE_PLANTILLASOT t
  where t.DESCRIPCION = 'FTTH - BSCS- RECONEXION CFP';
  
IF ln_count = 0 THEN
	  
	  insert into operacion.OPE_PLANTILLASOT
	  (IDPLANSOT,
	   DESCRIPCION,
	   TIPTRA,
	   MOTOT,
	   TIPSRV,
	   DIASFECCOM,
	   AREASOL,
	   TIPTRAMAN,
	   ESTADO,
	   USUREG,
	   FECREG)
	values
	  ((select max(td.IDPLANSOT) + 1 from operacion.OPE_PLANTILLASOT td),
	   'FTTH - BSCS- RECONEXION CFP',
	   842,--TIPO TRABAJO
	   16,
	   '0061',
	   0,
	   201,
	   null,
	   1,
	   user,
	   sysdate
		);
	commit;
END IF;
	
	


end;
/

