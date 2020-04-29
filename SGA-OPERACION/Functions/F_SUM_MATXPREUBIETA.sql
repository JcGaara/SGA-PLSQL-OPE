CREATE OR REPLACE FUNCTION OPERACION.f_sum_matxpreubieta( a_fase in number, a_codpre in number, a_idubi in number, a_codeta in number)  RETURN NUMBER IS

l_costo number;

BEGIN

   if a_fase = 1 then
   	  l_costo := 0;
   elsif a_fase = 2 then
      select sum(cosdis * candis) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi and
               codeta = a_codeta;
   elsif a_fase = 3 then
      select sum(cosins * canins) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi and
               codeta = a_codeta;
   elsif a_fase = 4 then    	  -- se actualizan datos del proyecto
      select sum(cosliq * canliq) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi and
               codeta = a_codeta;
   end if;

   if l_costo is null then
      return 0;
   else
      return l_costo;
   end if;

--   EXCEPTION
--      WHEN OTHERS THEN Return 0;

END;
/


