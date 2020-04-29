CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_EF (A_CODEF IN NUMBER ) IS

cursor c1 is
select punto punto from efpto where codef = A_CODEF;

BEGIN

	for lc1 in c1 loop
   	p_del_efpto(a_codef, lc1.punto);
   end loop;

   delete solefxarea where codef = a_codef;

   delete ef where codef = a_codef;

   update vtatabslcfac set derivado = 0 where numslc = a_codef;
END;
/


