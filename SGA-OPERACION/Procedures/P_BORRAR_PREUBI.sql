CREATE OR REPLACE PROCEDURE OPERACION.P_BORRAR_preubi (a_codsolot in number, a_punto in number) IS

/*
Para borrar un punto dentro de un presupuesto,
Si noy involucradas ots dentro de otras areas que no sea PEX se borra de la sol OT
*/

L_NUM_OTS NUMBER;

BEGIN

	P_DEL_preubi (a_codsolot, a_punto);

   SELECT COUNT(*) INTO L_NUM_OTS FROM OT WHERE CODSOLOT = a_codSOLOT and area not in (10,11,12,13,14);

   /* Esta solicitud solo es para PEX -> SE ELIMINA DE LA SOL OT */
   IF L_NUM_OTS = 0 THEN
   	P_DEL_SOLOTPTO(a_codsoLOT, A_PUNTO);
   END IF;


END;
/


