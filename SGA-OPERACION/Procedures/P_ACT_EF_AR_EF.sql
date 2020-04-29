CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_EF_AR_EF (a_codef in number) IS

l_frr number;
l_costo number;

BEGIN

   select f_inversion_proyecto(a_codef) into l_costo from dual;

   P_ACT_EF_AR(a_codef, l_costo, null);

END;
/


