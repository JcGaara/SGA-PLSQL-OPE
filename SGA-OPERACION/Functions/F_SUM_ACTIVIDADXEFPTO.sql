CREATE OR REPLACE FUNCTION OPERACION.f_sum_actividadxefpto( a_numslc in char, a_codinssrv in number, a_moneda in char, a_tipo in number)  RETURN NUMBER IS

l_costo number;

BEGIN

  SELECT sum(nvl(efptoetaact.costo* efptoetaact.cantidad ,0)) into l_costo
    FROM efptoetaact,
         actividad,
         ef,
         efpto
   WHERE  ef.numslc = a_numslc and
   		( efpto.codef = ef.codef ) and
   		(efpto.codinssrv = a_codinssrv ) and
         ( efpto.punto = efptoetaact.punto ) and
         ( efpto.codef = efptoetaact.codef ) and
         ( actividad.codact = efptoetaact.codact ) and
         ( actividad.espermiso = a_tipo) AND
         ( efptoetaact.moneda = a_moneda) ;

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


