CREATE OR REPLACE FUNCTION OPERACION.F_GET_FLG_FIN_SOLOT_DEMO (a_sol in number) RETURN number IS
tmpVar number;
BEGIN

	return 0;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          RETURN Null;
     WHEN OTHERS THEN
          RETURN Null;

END;
/


