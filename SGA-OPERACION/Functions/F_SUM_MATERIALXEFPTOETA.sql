CREATE OR REPLACE FUNCTION OPERACION.f_sum_materialxefptoeta( a_codsolot in number,a_codeta in number)  RETURN NUMBER IS

l_costo number;

BEGIN

  SELECT nvl(sum(efptoetamat.costo* efptoetamat.cantidad ),0) into l_costo
    FROM efptoetamat,
         ef,
         efpto,
         solot
   WHERE ( efpto.codef = ef.codef ) and
         ( efpto.punto = efptoetamat.punto ) and
         ( efpto.codef = efptoetamat.codef ) and
         ( solot.numslc = ef.numslc ) and
         ( solot.codsolot = a_codsolot ) and
		 ( efptoetamat.codeta = a_codeta);

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


