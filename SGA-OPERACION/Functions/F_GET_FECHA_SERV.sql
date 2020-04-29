CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHA_SERV( a_codot in number, a_punto in number) RETURN date IS

ls_fecha otpto.fecfin%type;

BEGIN

   begin
      select fecinisrv into ls_fecha
	  	from otpto
		where otpto.codot = a_codot and
			  otpto.punto = a_punto;

	  return ls_fecha;

      exception
	        when others then
     		return null;

   end;
END;
/


