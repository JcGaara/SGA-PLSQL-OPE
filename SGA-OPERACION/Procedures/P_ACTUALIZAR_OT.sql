CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_OT (a_codot in number) IS

/*
despues de que una OT cambia se actualiza los datos de Esta y se valida con la informacion
de la Solicitud
*/

l_solot ot.codsolot%type;
l_numslc solot.numslc%type;
L_NUM_OTS NUMBER;

CURSOR CUR_PTO IS
   select PUNTO from otpto where codot = a_codot;

BEGIN

   select ot.codsolot, solot.numslc into l_solot, l_numslc from ot, solot where
   ot.codot = a_codot and ot.codsolot = solot.codsolot;

   SELECT COUNT(*) INTO L_NUM_OTS FROM OT WHERE CODSOLOT = L_SOLOT;

	FOR LC1 IN CUR_PTO LOOP

   	NULL;
   	/* SE VA A HACER ALGO */
   END LOOP;

END;
/


