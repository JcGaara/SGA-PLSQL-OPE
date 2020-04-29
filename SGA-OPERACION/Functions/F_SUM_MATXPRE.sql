CREATE OR REPLACE FUNCTION OPERACION.f_sum_matxpre( a_fase in number , a_codpre in number)  RETURN NUMBER IS

l_costo number;

BEGIN
   if a_fase = 1 then     -- PEX
   	  l_costo := 0;
   elsif a_fase = 2 then  --Dise?o
      select sum(cosdis * candis) into l_costo
         from preubietamat
         where codpre = a_codpre;
   elsif a_fase = 3 then   --Instalaciones
      select sum(cosins * canins) into l_costo
         from preubietamat
         where codpre = a_codpre;
   elsif a_fase = 4 then   --Liquidaciones
      select sum(cosliq * canliq) into l_costo
         from preubietamat
         where codpre = a_codpre;
   end if;

   if l_costo is null then
      l_costo := 0;
   end if;

   return l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


