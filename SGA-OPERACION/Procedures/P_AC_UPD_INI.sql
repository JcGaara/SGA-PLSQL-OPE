CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_INI (
	a_tipo in number,
	a_codsolot in number,
	a_punto in number
)    IS
tmpVar NUMBER;
/******************************************************************************
******************************************************************************/

cursor cur_eta is
select p.codeta, p.orden
   from solotptoeta p
   where codeta in (select codeta from etapaxarea where area in (10,11,12,13,14,80)) and
	  	 p.codsolot = a_codsolot and
		 p.punto = a_punto;

BEGIN
if a_tipo = 1 then

	for l in cur_eta loop

		delete solotptoetaact where codsolot = a_codsolot and punto = a_punto and orden = l.orden;
		delete solotptoetamat where codsolot = a_codsolot and punto = a_punto and orden = l.orden;
		delete predoc where codsolot = a_codsolot and punto = a_punto and codeta = l.codeta;
--		delete preubieta where codpre = a_codpre and idubi = a_idubi and codeta = l.codeta;
	--	delete preubipos where codpre = a_codpre and idubi = a_idubi ;
	end loop;
	delete solotptopos where codsolot = a_codsolot and punto = a_punto;

else
	-- no se hace nada especifico con los datos
   -- podria hacerse un update de los datos de liq a 0 ??

	null;
end if;



END;
/


