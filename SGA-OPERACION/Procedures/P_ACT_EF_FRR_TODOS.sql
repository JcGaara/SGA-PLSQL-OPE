CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EF_FRR_TODOS IS
tmpVar NUMBER;

cursor cur_ef is
select codef, numslc, cosmo + cosmat + cosequ costo from ef; --- and codef > 5500;

l_ingreso number;
l_costo number;
l_factor number;
l_req number;
l_frr number;

BEGIN
/*
   for lef in cur_ef loop

      l_ingreso := f_revenue_mes_proyecto(lef.numslc);
      if lef.costo = 0 then
         l_factor := 0;
      else
         l_factor := l_ingreso / lef.costo;
      end if;

      update ef set frr = l_factor where codef = lef.codef;

   end loop;
*/
 null;
END;
/


