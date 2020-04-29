CREATE OR REPLACE PROCEDURE OPERACION.P_BORRAR_OTPTO (a_codot in number, a_punto in number) IS

/*
Para borrar un punto dentro de una OT,
Se verifica que se borre dentro de la Solicitud si fuera necesario
*/

l_solot ot.codsolot%type;
l_numslc solot.numslc%type;
L_NUM_OTS NUMBER;

CURSOR CUR_PTO IS
   select PUNTO from otpto where codot = a_codot;

BEGIN

   select ot.codsolot, solot.numslc into l_solot, l_numslc from ot, solot where
   ot.codot = a_codot and ot.codsolot = solot.codsolot;

	p_del_otpto( a_codot, a_punto );

   SELECT COUNT(*) INTO L_NUM_OTS FROM OT WHERE CODSOLOT = L_SOLOT;

   /* ESTA ES LA UNICA OT INVOLUCRADA -> SE ELIMINA DE LA OT */
   IF L_NUM_OTS = 1 THEN
   	P_DEL_SOLOTPTO(L_SOLOT, A_PUNTO);
   END IF;


END;
/


