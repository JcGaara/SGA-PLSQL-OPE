CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EF_AR(a_codef in number, a_costo in number, a_constante in number) IS

l_factor number;
l_req number;
l_ingreso number;
l_tipsrv ef.tipsrv%type;
l_numlinea number;
l_costo number;
l_constante number;
l_rentabilidad number;

BEGIN

/*
Posibles estados
Req      Rentable
-------- ---------
null     null
1        1
1        0
0        1

*/
/******************************************************************************
   	Ver        Fecha        Autor           Descripción
   	---------  ----------  ---------------  ------------------------
    1.0        07-03-2005  Victor Valqui	Se modifico en caso de que el FRR sea mayor que 1000,
			   			   		  			entonces se grabe 999.99.
******************************************************************************/
      select tipsrv into l_tipsrv from ef where codef = a_codef;

      /*  solo es valido para FN, NW y TEL */
      if l_tipsrv  not in ( '0004', '0014','0019','0005','0006') then
         update ef
         set req_ar = 0,
             frr = 0,
             rentable = 1
         where codef = a_codef;
      end if;

      l_costo := f_inversion_proyecto(a_codef);

      IF a_constante is null then
         if l_tipsrv = '0004' then
            select valor into l_constante from constante where constante = 'FRRTEL';
         else
            select PQ_CONSTANTES.f_get_frr into l_constante from dual;
         end if;

      else
         l_constante := a_constante;
      end if;

--      l_ingreso := f_revenue_mes_proyecto(ltrim(rtrim(to_char(a_codef,'0000000000'))));
	  l_ingreso := F_GET_MONTOS_PSPCLI(ltrim(rtrim(to_char(a_codef,'0000000000'))),'CR');
      if l_costo = 0 then
         l_factor := 0;
      else
         l_factor := l_ingreso / l_costo;
      end if;

      if l_factor = 0 then
         l_req := 0;
         l_rentabilidad := 1;
      elsif l_constante > l_factor then
         l_req := 1;
         l_rentabilidad := 0;
      else
         l_req := 0;
         l_rentabilidad := 1;
      end if;

/*      update ef
         set req_ar = l_req,
             frr = l_factor,
             rentable = l_rentabilidad
         where codef = a_codef;
*/
  	  if l_factor > 1000 then
	  	 l_factor := 999.99;
	  end if;

      update ef
         set  frr = l_factor
         where codef = a_codef;

END;
/


