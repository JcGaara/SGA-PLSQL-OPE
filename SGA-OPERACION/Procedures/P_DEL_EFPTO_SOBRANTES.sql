CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_EFPTO_SOBRANTES (a_codef in number) IS
tmpVar NUMBER;

cursor cur1 is
select punto from efpto where codef = a_codef
minus
select to_number(numpto) from vtadetptoenl
 where numslc = a_codef;



BEGIN

 for e in cur1 loop
	 p_del_efpto(a_codef , e.punto);
 end loop;

END;
/


