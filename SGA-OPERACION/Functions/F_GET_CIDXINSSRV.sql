CREATE OR REPLACE FUNCTION OPERACION.F_GET_CIDXINSSRV( ls_codinssrv in number) RETURN number IS

ls_cid number;

BEGIN
   begin
      select cid into ls_cid from acceso where codinssrv = ls_codinssrv;
      return ls_cid;

      exception
          when others then
         return null;

   end;
END;
/


