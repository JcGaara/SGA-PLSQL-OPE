CREATE OR REPLACE FUNCTION OPERACION.f_sum_material_permisosxef( a_codsolot in number )  RETURN NUMBER IS

l_costo number;

BEGIN

    SELECT sum(efptoetamat.costo * efptoetamat.cantidad ) into l_costo
    FROM efptoetamat,
         matope,
		 etapa,
		 ef,
         efpto,
         solot
   WHERE ( efptoetamat.codeta = etapa.codeta ) and
         ( efpto.codef = ef.codef ) and
         ( efpto.punto = efptoetamat.punto ) and
         ( efpto.codef = efptoetamat.codef ) and
         ( matope.codmat = efptoetamat.codmat ) and
         ( solot.numslc = ef.numslc ) and
         ( solot.codsolot = a_codsolot );

RETURN l_costo;

   EXCEPTION
      WHEN OTHERS THEN Return 0;

END;
/


