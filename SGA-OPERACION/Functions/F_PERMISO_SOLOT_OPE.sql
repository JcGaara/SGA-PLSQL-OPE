CREATE OR REPLACE FUNCTION OPERACION.F_PERMISO_SOLOT_OPE (a_codsolot in number, a_usuario in char) RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
Determina si el usuario puede modificar esta solicitud, durante la ejecucion
Devuelve 0 No puede
Devuelve 1 Puede modificar
Devuelve 2 Puede cambiar el estado
******************************************************************************/

l_cont number;

l_estsol number;
l_areasol number;
l_wf number;

BEGIN

   -- Valida el estado de la Solicitud
   select estsol, areasol into l_estsol, l_areasol from solot where codsolot = a_codsolot;
   if l_estsol in ( 12, 13 ) then
      return 0;
   end if;

   -- Valida si tiene un WF
   select F_GET_WF_SOLOT (a_codsolot) into l_wf from dual ;

   if l_wf is null then -- si no tiene no se puede moificar
      return 0;
   else
      return 1;
      ----------- Falta Completa - CC
   end if;


	return 0;

   EXCEPTION
     WHEN OTHERS THEN
	   RETURN 0;

END;
/


