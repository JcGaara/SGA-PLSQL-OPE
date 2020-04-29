CREATE OR REPLACE FUNCTION OPERACION.F_PERMISO_ACTIVAR_SOLOT (a_codsolot in number, a_usuario in char) RETURN NUMBER IS
tmpVar NUMBER;
/******************************************************************************
Determina si el usuario puede modificar activar esta solicitud
******************************************************************************/

l_cont number;

l_estsol number;
l_areasol number;

BEGIN

   /* falta validar */

   return 1;

   EXCEPTION
     WHEN OTHERS THEN
	   RETURN 0;

END;
/


