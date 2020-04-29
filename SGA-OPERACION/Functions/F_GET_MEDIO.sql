CREATE OR REPLACE FUNCTION OPERACION.F_GET_MEDIO( a_codsolot in number, a_punto in number ) RETURN varchar IS

ls_medio tipfibra.descripcion%type;
ln_codinssrv solotpto.codinssrv%type;
ln_numslc solot.numslc%type;


BEGIN

   begin
      select numslc, codinssrv into ln_numslc, ln_codinssrv
	  	from solot, solotpto
		where solot.codsolot = solotpto.codsolot and
			  solot.codsolot = a_codsolot and
			  punto = a_punto;

	  select tipfibra.descripcion into ls_medio
  		 from efpto, tipfibra
		 where efpto.codtipfibra = tipfibra.codtipfibra and
		 	   efpto.codef = to_number(ln_numslc) and
			   efpto.codinssrv = ln_codinssrv and
			   rownum = 1;

	  return ls_medio;

      exception
	        when others then
     		return null;

   end;
END;
/


