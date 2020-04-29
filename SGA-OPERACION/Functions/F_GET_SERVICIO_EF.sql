CREATE OR REPLACE FUNCTION OPERACION.F_GET_SERVICIO_EF(a_proyecto in char) RETURN varchar2 IS
ls_abrev tystipsrv.nomabr%type;
ls_tipo tystipsrv.tipsrv%type;
/* Se obtiene el servicio LA abreviatura del servicio */
BEGIN
   select max(tipsrv) into ls_tipo from vtatabpspcli where numslc = a_proyecto;
   if ls_tipo is not null then
      select nomabr into ls_abrev from tystipsrv where tipsrv = ls_tipo;
   end if;
   return ls_abrev;
   EXCEPTION
     WHEN OTHERS THEN
       return null;
END F_GET_SERVICIO_EF;
/


