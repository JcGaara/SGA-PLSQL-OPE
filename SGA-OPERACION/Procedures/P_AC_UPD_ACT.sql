CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_ACT (
   a_tipo in number,
   a_codsolot in number,
   a_punto in number,
   a_codeta in number,
   a_idact in number,
   a_codact in number,
   a_observacion in varchar2,
   a_candis in number default 0,
   a_canliq in number default null,
   a_contrata in number default 0,
   a_codprec in number
) IS

l_cont number;
l_cont_eta number;
l_costo actividad.costo%type;
l_moneda actividad.moneda_id%type;
l_orden number;
/******************************************************************************
   	NOMBRE:       		OPERACION.P_AC_UPD_ACT
   	PROPOSITO:    		Permite actualizar las actividades del estudio de factibilidad.
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
	1.0		   21/04/2005  Carmen Quilca 	Revisión y actualización con respecto
			   			   		  			a los preciarios
******************************************************************************/
BEGIN

if a_tipo in ( 1, 2) then -- dise?o y liq
	if a_codact is null then
	  	raise_application_error(-20500,'La actividad no puede ser vacia.');
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
end if;

if a_tipo in ( 1 ) then -- dise?o
   select count(*) into l_cont_eta
	  from solotptoeta
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			codeta = a_codeta;
   if l_cont_eta = 0 then
   	  select nvl(max(orden),0) + 1 into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto;

   	  insert into solotptoeta ( codsolot, punto, orden, codeta )
	  	 	 values ( a_codsolot, a_punto, l_orden, a_codeta );
   elsif l_cont_eta = 1 then
   	  select orden into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto and
			   codeta = a_codeta;
   else
      raise_application_error(-20500,'Existen etapas duplicadas');
   end if;

   select count(*) into l_cont
	  from solotptoetaact
   	  where codsolot = a_codsolot and
	  		punto = a_punto and
			orden = l_orden and
			idact = a_idact;
   if l_cont = 0 then
		insert into solotptoetaact ( codsolot, punto, orden, idact, codact, moneda_id, candis, cosdis, observacion, codprecdis)
		   	values ( a_codsolot, a_punto, l_orden, a_idact, a_codact, l_moneda, a_candis, l_costo, a_observacion, a_codprec);
   else
	  	update solotptoetaact set
	      codact = a_codact, moneda_id = l_moneda, candis = a_candis, cosdis = l_costo, codprecdis = a_codprec
	   where codsolot = a_codsolot and punto = a_punto and orden = l_orden and idact = a_idact;
   end if;
else   -- Liq
   select count(*) into l_cont_eta
	  from solotptoeta
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			codeta = a_codeta;
   if l_cont_eta = 0 then
     	raise_application_error(-20500,'Etapa no valida');
   elsif l_cont_eta = 1 then
   	  select orden into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto and
			   codeta = a_codeta;
   else
      raise_application_error(-20500,'Existen etapas duplicadas');
   end if;

   select count(*) into l_cont
	  from solotptoetaact
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			orden = l_orden and
			idact = a_idact;
   if l_cont = 0 then
	  insert into solotptoetaact ( codsolot, punto, orden, idact, codact, moneda_id, candis, cosdis, observacion, canliq, contrata, codprecliq )
   	  		 values ( a_codsolot, a_punto, l_orden, a_idact, a_codact, l_moneda, 0, 0, a_observacion, a_canliq, a_contrata, a_codprec  );
   else
  	   update solotptoetaact set
	      codact = a_codact, moneda_id = l_moneda, canliq = a_canliq, contrata = a_contrata, codprecliq = a_codprec
	   where codsolot = a_codsolot and punto = a_punto and orden = l_orden and idact = a_idact;
   end if;
end if;

END;
/


