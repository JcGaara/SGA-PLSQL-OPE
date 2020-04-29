CREATE OR REPLACE PROCEDURE OPERACION.P_BORRAR_SOLOTPTO (a_codsolot in number, a_punto in number) IS

/*
Para borrar todo lo relacionado con la solicitud y el punto,
*/

l_solot ot.codsolot%type;
l_numslc solot.numslc%type;
L_NUM_OTS NUMBER;

CURSOR CUR_PTO IS
   select otpto.codot, otpto.PUNTO from otpto, ot where ot.codot = otpto.codot and ot.codsolot = a_codsolot;

BEGIN

	for l in cur_pto loop
 		p_del_otpto( l.codot, l.punto );
   end loop;

 	P_DEL_SOLOTPTO(a_codSOLOT, A_PUNTO);


END;
/


