CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_ACT_EF (
	a_codef in number,
	a_punto in number,
	a_codeta in number,
	a_codact in number,
	a_candis in number default 0,
   	a_observacion in varchar2,
	a_codprec in number
) IS
l_cont number;
l_cont_eta number;
l_costo actividad.costo%type;
l_moneda actividad.moneda_id%type;
/******************************************************************************
   	NOMBRE:       		OPERACION.P_AC_UPD_ACT_EF
   	PROPOSITO:    		Permite actualizar las actividades del estudio de factibilidad.
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
    1.0        04-08-2004  Carmen Quilca
	2.0		   21/04/2005  Carmen Quilca 	Revisión y actualización con respecto
			   			   		  			a los preciarios
******************************************************************************/
BEGIN
	 if a_codact is null then
	  	raise_application_error(-20500,'Codigo de actividad no puede ser vacio.');
	end if;
	begin
		select actxpreciario.costo, actxpreciario.moneda_id into l_costo, l_moneda
		   from actividad, actxpreciario
		   where actividad.codact = actxpreciario.codact and
		   		 codprec = a_codprec and
		   		 actxpreciario.codact = a_codact;
	exception
   	when others then
      	raise_application_error(-20500,'Actividad '||a_codact||' no valida.');
	end;

   	select count(*) into l_cont_eta
	from efptoeta
	where codef = a_codef and
 		punto = a_punto and
		codeta = a_codeta;
	if l_cont_eta = 0 then
	   	  insert into efptoeta ( codef, punto, codeta )
    	  values ( a_codef, a_punto, a_codeta );
	--else
    	--raise_application_error(-20500,'Existen etapas duplicadas');
	--	return;
	end if;

	select count(*) into l_cont
	  from efptoetaact
   	  where codef = a_codef and
  		punto = a_punto and
		codeta = a_codeta and
		codact = a_codact;
	if l_cont = 0 then
	   		insert into efptoetaact ( codef, punto, codeta, codact, costo, cantidad, observacion, moneda_id, codprec)
		   	values ( a_codef, a_punto, a_codeta, a_codact, l_costo, a_candis, a_observacion, l_moneda, a_codprec );
   	else
	  	update efptoetaact set
	       costo = l_costo, cantidad = a_candis, observacion = a_observacion, moneda_id = l_moneda, codprec = a_codprec
	   	where codef = a_codef and punto = a_punto and codeta = a_codeta and codact = a_codact;
	end if;
END;
/


