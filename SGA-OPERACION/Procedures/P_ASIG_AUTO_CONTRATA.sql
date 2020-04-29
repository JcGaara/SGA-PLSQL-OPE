CREATE OR REPLACE PROCEDURE OPERACION.P_ASIG_AUTO_CONTRATA ( a_tipo in char, a_codsolot in number, a_punto in number ) IS
tmpVar NUMBER;
/******************************************************************************
Realiza la asignacion automatica de contratas en base a una calificacion
******************************************************************************/

l_codcon_ant number;
l_codcon_new number;

BEGIN


/******************************************************************************
Algoritmo para dise?o
PTR_DIS es el ultimo contratista en ser asignado
CAL_DIS es la calificacion que se le da a los contratistas
CONT_DIS es el contador de las asignaciones que se le ha dado a este contratista
Se asigna hasta que todos sean CAL_DIS = CONT_DIS y luego se vuelve a comenzar
******************************************************************************/


if a_tipo = 'D' then
	/* Se hacen unas validaciones antes de empezar */
   update contrata set cont_dis = cal_dis
 	where CAL_DIS < CONT_DIS
      	and flg_dis = 1;

	select count(*) into tmpvar from contrata where CAL_DIS > 0
      	and flg_dis = 1;
   if tmpvar = 0 then
   	raise_application_error(-20500, 'Imposible asignar un contratista para dise?o, Revisar parametros.');
	end if;

	select count(*) into tmpvar from contrata where ptr_dis = 1 and flg_dis = 1;
   if tmpvar = 0 then
   	raise_application_error(-20500, 'No existe un contratisat inicial.');
	end if;

	select codcon into l_codcon_ant from contrata where ptr_dis = 1 and flg_dis = 1;
	begin
	   select min(codcon) into l_codcon_new from contrata where
      	codcon = (select min(codcon) from contrata where codcon > l_codcon_ant and CAL_DIS > CONT_DIS and flg_dis = 1)
         and CAL_DIS > CONT_DIS
         and flg_dis = 1;
      /* No se consiguio uno mayor => se escoge el primero de la lista */
      if l_codcon_new is null then
		   select min(codcon) into l_codcon_new from contrata where
	         CAL_DIS > CONT_DIS
	      	and flg_dis = 1;
      end if;


	exception
   	when no_data_found then
      	raise;
	end ;

   if l_codcon_new is null then -- No se pudo obtener un contratista entonces hay que comenzar de nuevo
   	update contrata set cont_dis = 0 where flg_dis = 1;
		P_ASIG_AUTO_CONTRATA ( a_tipo, a_codsolot, a_punto );
   else
   	update contrata set ptr_dis = 0 where codcon = l_codcon_ant;
   	update contrata set ptr_dis = 1, cont_dis = cont_dis + 1 where codcon = l_codcon_new;

		update preubi set codcon = l_codcon_new, autocon = 1 where codsolot = a_codsolot and punto = a_punto;
-- 	raise_application_error(-20500, 'Error al asignar contratista');
	end if;

end if;

END;
/


