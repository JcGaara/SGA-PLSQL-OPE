CREATE OR REPLACE FUNCTION OPERACION.f_get_monto_pex( a_codef in number)  RETURN NUMBER IS

l_costo1 number;
l_costo2 number;
l_costo3 number;
l_tipocambio number;

BEGIN

	l_tipocambio := F_TIPOCAMBIO (sysdate, 'C' );

  SELECT sum(efptoetaact.costo* efptoetaact.cantidad ) into l_costo1
    FROM efptoetaact
   WHERE efptoetaact.codef = a_codef and
         efptoetaact.moneda = 'D';

  SELECT sum(efptoetaact.costo* efptoetaact.cantidad ) / l_tipocambio into l_costo2
    FROM efptoetaact
   WHERE efptoetaact.codef = a_codef and
         efptoetaact.moneda = 'S';


  SELECT sum(efptoetamat.costo * efptoetamat.cantidad ) into l_costo3
    FROM efptoetamat
   WHERE efptoetamat.codef = a_codef ;

  return nvl(l_costo1,0) + nvl(l_costo2,0) + nvl(l_costo3,0);

END;
/


