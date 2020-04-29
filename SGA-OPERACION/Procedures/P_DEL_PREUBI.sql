CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_preubi(an_CODSOLOT SOLOTPTO.CODSOLOT%type, a_punto in number) IS

l_codpre number;
l_idubi number;

BEGIN
	begin
	   select codpre, idubi into l_codpre , l_idubi from PREUBI where CODSOLOT = an_CODSOLOT and punto = a_punto;
	exception when others then
   	-- no existe ninguno
		return;
	end;

   -- Se borra el detalle*
	delete PREUBIeta where codpre = l_codpre and idubi = l_idubi;
	delete PREUBIest where codsolot = an_codsolot and punto = a_punto;

   delete PREUBI where CODSOLOT = an_CODSOLOT and punto = a_punto;


END;
/


