CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHA_PINT( a_codot in number, a_punto in number) RETURN date IS
ls_fecha otpto.fecfin%type;
ln_codsolot solot.codsolot%type;
ln_fecha number;

BEGIN
	select codsolot into ln_codsolot from ot where codot = a_codot;
    begin
   		select fecfin into ls_fecha
  			from tareawf, wf
		 	where tareawf.idwf = wf.idwf and
   		 		  tareadef in (82,372) and
			   	  wf.codsolot = ln_codsolot and
				  estwf <> 5 and
				  rownum = 1;
      exception
	        when others then
     			null;
	end;
	if ls_fecha is null then
	   begin
      	  select fecfin into ls_fecha
	  		from otpto
			where otpto.codot = a_codot and
				  otpto.punto = a_punto;
		  exception
	        when others then
     			 null;
	   end;
	end if;
    return ls_fecha;

    exception
	when others then
    	 return null;

END;
/


