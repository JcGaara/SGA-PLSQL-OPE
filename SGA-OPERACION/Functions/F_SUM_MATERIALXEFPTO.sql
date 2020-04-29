CREATE OR REPLACE FUNCTION OPERACION.f_sum_materialxefpto( a_numslc in char,a_codinssrv in number)  RETURN NUMBER IS

l_costo number;

BEGIN

  SELECT nvl(sum(nvl(efptoetamat.costo * efptoetamat.cantidad,0) ),0) into l_costo
    FROM efptoetamat,
         ef,
         efpto
   WHERE ef.numslc = a_numslc and
   		( efpto.codef = ef.codef ) and
         efpto.codinssrv = a_codinssrv and
         ( efpto.punto = efptoetamat.punto ) and
         ( efpto.codef = efptoetamat.codef ) ;

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


