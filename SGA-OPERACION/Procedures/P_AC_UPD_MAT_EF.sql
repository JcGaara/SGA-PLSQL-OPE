CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_MAT_EF (
	a_codef in number,
	a_punto in number,
	a_codeta in number,
	a_codmat in varchar2,
	a_candis in number default 0
) IS

l_cont number;
l_cont_eta number;
l_costo matope.costo%type;
--l_moneda matope.moneda_id%type;
l_codmat char(15);
l_orden number;
/******************************************************************************
   	NOMBRE:       		OPERACION.P_AC_UPD_MAT_EF
   	PROPOSITO:    		Permite actualizar los materiales del estudio de factibilidad.
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
    1.0        04-08-2004  Carmen Quilca
******************************************************************************/
BEGIN
   if a_codmat is null then
  	raise_application_error(-20500,'Codigo de material no puede ser vacio.');
   end if;

   l_codmat := rpad(a_codmat,15);

   begin
--select costo, moneda_id into l_costo, l_moneda from matope where codmat = a_codmat;
   	select costo into l_costo from matope where codmat = l_codmat;
   exception
   when others then
     	raise_application_error(-20500,'Material '||l_codmat||' no valido.');
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
	-- return;
   end if;

   select count(*) into l_cont
	  from efptoetamat
	  where codef = a_codef and
	  	punto = a_punto and
		codeta = a_codeta and
		codmat = l_codmat;
	if l_cont = 0 then
	   insert into efptoetamat ( codef, punto, codeta, codmat, cantidad, costo)
   		values ( a_codef, a_punto, a_codeta, l_codmat, a_candis, l_costo);
    else
		update efptoetamat
   		set cantidad = a_candis, costo = l_costo
	   	where codef = a_codef and
	  		punto = a_punto and
			codeta = a_codeta and
			codmat = l_codmat;
end if;
END;
/


