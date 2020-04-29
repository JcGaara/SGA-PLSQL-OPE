CREATE OR REPLACE FUNCTION OPERACION.F_GET_ESTADO_CID( a_codot in number, a_punto in number) RETURN varchar IS

ls_estado estotpto.descripcion%type;

BEGIN

   begin
      select estotpto.descripcion into ls_estado
	  	from otpto, estotpto
		where otpto.estotpto = estotpto.estotpto and
			  otpto.codot = a_codot and
			  otpto.punto = a_punto;

	  return ls_estado;

      exception
	        when others then
     		return null;

   end;
END;
/


