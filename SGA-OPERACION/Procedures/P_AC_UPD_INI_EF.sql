CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_INI_EF (
	a_codef in number,
	a_punto in number,
	a_codeta in number
)    IS
l_cont_act number;
l_cont_mat number;
/******************************************************************************
   	NOMBRE:       		OPERACION.P_AC_UPD_MAT_EF
   	PROPOSITO:    		Permite inicializar la informacion del estudio de factibilidad.
	PROGRAMADO EN JOB:	NO

   	REVISIONES:
   	Ver        Fecha        Autor           Descripcion
   	---------  ----------  ---------------  ------------------------
    1.0        04-08-2004  Carmen Quilca
******************************************************************************/
BEGIN

--PARA LAS ACTIVIDADES
select count(*) into l_cont_act from efptoetaact
where codef = a_codef
and punto = a_punto
and codeta = a_codeta;
/*if l_cont_act > 0 then
	delete from efptoetaact where codef = a_codef
	and punto = a_punto
	and codeta = a_codeta;
end if;*/

--PARA LOS MATERIALES
select count(*) into l_cont_mat from efptoetamat
where codef = a_codef
and punto = a_punto
and codeta = a_codeta;
/*if l_cont_mat > 0 then
	delete from efptoetamat where codef = a_codef
	and punto = a_punto
	and codeta = a_codeta;
end if;*/
END;
/


