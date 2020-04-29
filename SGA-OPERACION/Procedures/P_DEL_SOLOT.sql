CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_SOLOT (a_codsolot in number) IS

cursor ots is
select codot from ot where codsolot = a_codsolot;

BEGIN
	for l in ots loop
   	p_del_ot(l.codot);
   end loop;

   P_DEL_PRESUPUESTO(a_codsolot);
   delete solotpto where codsolot = a_codsolot;
   delete solot where codsolot = a_codsolot;


END;
/


