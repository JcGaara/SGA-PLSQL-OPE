CREATE OR REPLACE PROCEDURE OPERACION.p_act_solotpto_x_proyecto(a_numslc in char ) IS

cursor cur_sol is
  select codsolot, tiptra from solot where numslc = a_numslc;

BEGIN
   for lcur_sol in cur_sol loop
       P_LLENAR_SOLOTPTO_PROD(lcur_sol.codsolot);
   end loop;

/*EXCEPTION
     WHEN OTHERS THEN
       Null; */
END;
/


