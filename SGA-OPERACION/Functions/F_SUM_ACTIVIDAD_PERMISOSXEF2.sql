CREATE OR REPLACE FUNCTION OPERACION.f_sum_actividad_permisosxef2( a_codef in number, a_moneda in char)  RETURN NUMBER IS

l_costo number;

BEGIN

  SELECT sum(efptoetaact.costo* efptoetaact.cantidad ) into l_costo
    FROM efptoetaact,
         actividad,
         etapa,
         ef,
         efpto
   WHERE ( efptoetaact.codeta = etapa.codeta ) and
         ( efpto.codef = ef.codef ) and
         ( efpto.punto = efptoetaact.punto ) and
         ( efpto.codef = efptoetaact.codef ) and
         ( actividad.codact = efptoetaact.codact ) and
         ( ef.codef = a_codef ) and
         ( actividad.espermiso = 1) AND
         ( efptoetaact.moneda = a_moneda);

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


