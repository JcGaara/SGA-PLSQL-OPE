CREATE OR REPLACE FUNCTION OPERACION.F_GET_OT_X_SOL_AREA( a_solot in number, a_area in char) rETURN NUMBER IS
tmpVar NUMBER;

BEGIN

   select count(*) into tmpvar from ot where codsolot = a_solot and coddpt = a_area;
   if tmpvar = 0 then
      return null;
   elsif tmpvar = 1 then
   	select codot into tmpvar from ot where codsolot = a_solot and coddpt = a_area;
      return tmpvar;
   else
      begin
         select codot into tmpvar from ot where codsolot = a_solot and coddpt = a_area and estot <> 5;
         return tmpvar;
     exception
         WHEN OTHERS THEN
            -- si tiene mas de una ot no anulada se devuelve la primera
            select codot into tmpvar from ot where codsolot = a_solot and coddpt = a_area and estot <> 5 and rownum = 1;
            return tmpvar;
      end;
   end if;

   return NULL;

   EXCEPTION
     WHEN OTHERS THEN
       Null;
END;
/


