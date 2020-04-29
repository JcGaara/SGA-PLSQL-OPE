CREATE OR REPLACE FUNCTION OPERACION.F_GET_SERVICIO_EF2(a_proyecto in char) RETURN char IS
ls_abrev tystipsrv.nomabr%type;
ls_tipo tystipsrv.tipsrv%type;
/* Se obtiene el servicio LA abreviatura del servicio */
BEGIN
   select max(tipsrv) into ls_tipo from vtatabpspcli where numslc = a_proyecto;
/*   if ls_tipo is not null then
      select nomabr into ls_abrev from tystipsrv where tipsrv = ls_tipo;
   end if;
   return ls_abrev;
*/
   return ls_tipo;
EXCEPTION
     WHEN OTHERS THEN
       return null;
END ;
/


