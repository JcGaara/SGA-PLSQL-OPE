CREATE OR REPLACE FUNCTION OPERACION.f_sum_matxpreubi( a_fase in number, a_codpre in number, a_idubi in number)  RETURN NUMBER IS

l_costo number;

BEGIN

   if a_fase = 1  then -- PEX
      l_costo := 0;
   elsif a_fase = 2 then
      select sum(nvl(cosdis * candis,0)) into l_costo
         from preubietamat
           where codpre = a_codpre and
                 idubi = a_idubi;
   elsif a_fase = 3 then
      select sum(cosins * canins) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi;
   elsif a_fase = 4 then
      select sum(cosliq * canliq) into l_costo
         from preubietamat
         where codpre = a_codpre and
               idubi = a_idubi;
   end if;

   return l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


