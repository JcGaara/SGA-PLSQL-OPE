CREATE OR REPLACE FUNCTION OPERACION.f_sum_actxpre( a_fase in number, a_codpre in number, a_moneda in char, a_tipo in number)  RETURN NUMBER IS

l_costo number;

BEGIN
   if a_fase = 1 then        -- Planta Externa
         l_costo := 0;
   elsif a_fase = 2 then     -- Dise?o
   		  select sum(cosdis * candis) into l_costo
		           from preubietaact a, actividad b
          		   where codpre = a_codpre and
				   		 a.codact = b.codact and
						 espermiso = a_tipo and
						 b.moneda = a_moneda;
   elsif a_fase = 3 then     -- Instalaciones
   		  select sum(cosins * canins) into l_costo
		           from preubietaact a, actividad b
          		   where codpre = a_codpre and
				   		 a.codact = b.codact and
						 espermiso = a_tipo and
						 b.moneda = a_moneda;
   elsif a_fase = 4 then     -- Liquidacion
   		  select sum(cosliq * canliq) into l_costo
		           from preubietaact a, actividad b
          		   where codpre = a_codpre and
				   		 a.codact = b.codact and
						 espermiso = a_tipo and
						 b.moneda = a_moneda;
   end if;

   if l_costo is null then
      l_costo := 0;
   end if;

   return l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


