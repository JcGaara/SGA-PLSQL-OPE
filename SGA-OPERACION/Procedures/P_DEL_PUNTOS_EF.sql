CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_PUNTOS_EF (A_CODEF IN NUMBER ) IS

cursor c1 is
select punto punto from efpto where codef = A_CODEF
minus
select to_number(numpto) from vtadetptoenl where numslc = A_CODEF;


tmpVar NUMBER;
BEGIN

	for lc1 in c1 loop
   	p_del_efpto(a_codef, lc1.punto);
   end loop;
END;
/


