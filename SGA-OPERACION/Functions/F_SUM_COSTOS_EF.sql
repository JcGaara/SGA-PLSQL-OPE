CREATE OR REPLACE FUNCTION OPERACION.f_sum_costos_ef( a_codsolot in number, a_moneda in char)  RETURN NUMBER IS

l_costo1 number;
l_costo2 number;
l_costo3 number;
l_total number;

BEGIN

  SELECT nvl(sum(efptoetaact.costo* efptoetaact.cantidad ),0) into l_costo1
    FROM efptoetaact,
         actividad,
         etapa,
         ef,
         efpto,
         solot
   WHERE ( efptoetaact.codeta = etapa.codeta ) and
         ( efpto.codef = ef.codef ) and
         ( efpto.punto = efptoetaact.punto ) and
         ( efpto.codef = efptoetaact.codef ) and
         ( actividad.codact = efptoetaact.codact ) and
         ( solot.numslc = ef.numslc ) and
         ( solot.codsolot = a_codsolot ) AND
         ( actividad.espermiso = 1) AND
         ( efptoetaact.moneda = a_moneda);

  SELECT nvl(sum(efptoetaact.costo* efptoetaact.cantidad ),0) into l_costo2
    FROM efptoetaact,
         actividad,
         etapa,
         ef,
         efpto,
         solot
   WHERE ( efptoetaact.codeta = etapa.codeta ) and
         ( efpto.codef = ef.codef ) and
         ( efpto.punto = efptoetaact.punto ) and
         ( efpto.codef = efptoetaact.codef ) and
         ( actividad.codact = efptoetaact.codact ) and
         ( solot.numslc = ef.numslc ) and
         ( solot.codsolot = a_codsolot ) AND
         ( actividad.espermiso = 0) AND
         ( efptoetaact.moneda = a_moneda);

  SELECT nvl(sum(efptoetamat.costo* efptoetamat.cantidad ),0) into l_costo3
    FROM efptoetamat,
         etapa,
         ef,
         efpto,
         solot
   WHERE ( efptoetamat.codeta = etapa.codeta ) and
         ( efptoetamat.punto = efpto.punto ) and
         ( efptoetamat.codef = efpto.codef ) and
         ( efpto.codef = ef.codef ) and
         ( solot.numslc = ef.numslc ) and
         ( solot.codsolot = a_codsolot );
   if a_moneda = 'D' then
      l_total := l_costo1 + l_costo2 + l_costo3;
   else
      l_total := l_costo1 + l_costo2;
   end if;

RETURN l_total;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


