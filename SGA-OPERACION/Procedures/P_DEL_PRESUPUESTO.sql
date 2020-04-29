CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_PRESUPUESTO(an_codsolot number) is
an_codpre number;
BEGIN

	select codpre into an_codpre from presupuesto where codsolot = an_codsolot;
	delete from preubietamat where codpre = an_codpre;
	delete from preubietaact where codpre = an_codpre;
	delete from mulcon where codpre = an_codpre;
 	delete from preubietaest where codpre = an_codpre;
	delete from preubieta where codpre = an_codpre;
 	delete from preubiest where codsolot = an_codsolot;
   delete from predoc where codpre = an_codpre;
   delete from preubi where codsolot = an_codsolot;
	delete from preest where codpre = an_codpre;
 	delete from presupuesto  where codpre = an_codpre;

  	exception
   	when no_data_found then
      	return;

END;
/


