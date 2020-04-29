CREATE OR REPLACE FUNCTION OPERACION.f_sum_actividad_permisosxef( a_codsolot in number, a_moneda in char)  RETURN NUMBER IS

l_costo number;

BEGIN

  SELECT sum(efptoetaact.costo* efptoetaact.cantidad ) into l_costo
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

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


