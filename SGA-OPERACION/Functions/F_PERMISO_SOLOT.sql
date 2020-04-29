CREATE OR REPLACE FUNCTION OPERACION.F_PERMISO_SOLOT (
   a_codsolot in number,
   a_usuario in char
) RETURN NUMBER
IS

tmpVar NUMBER;
/******************************************************************************
Determina si el usuario puede modificar esta solicitud
Devuelve 0 No puede
Devuelve 1 Puede modificar
Devuelve 2 Puede cambiar el estado
******************************************************************************/

l_cont number;
l_estsol number;
l_areasol number;
l_tipestsol number;

BEGIN

   -- Valida el estado de la Solicitud
   select s.estsol, s.areasol, e.tipestsol into l_estsol, l_areasol, l_tipestsol
      from solot s, estsol e
      where s.codsolot = a_codsolot and
      s.estsol = e.estsol;

   if l_tipestsol in ( 4, 5 ) then -- Anul, Cerr
      return 0;
   end if;

   -- Si puede cambiar estado
   select count(*) into l_cont from accusudpt
      where accusudpt.codusu = rtrim(a_usuario) and area = l_areasol and
		   accusudpt.tipo = 2  and aprob = 1 ;
   if l_cont > 0 then
      return 2;
   end if;

   -- Si puede modificar la sol.
   select count(*) into l_cont from accusudpt
      where accusudpt.codusu = rtrim(a_usuario) and area = l_areasol and
		   accusudpt.tipo = 2  and acceso = 1 ;
   if l_cont > 0 then
      return 1;
   end if;

	return 0;

   EXCEPTION
     WHEN OTHERS THEN
	   RETURN 0;

END;
/


