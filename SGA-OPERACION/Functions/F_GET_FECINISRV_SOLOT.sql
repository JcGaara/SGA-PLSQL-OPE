CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECINISRV_SOLOT (a_sol in number) RETURN date IS
tmpVar date;
BEGIN

	select min(fectrs) into tmpvar from trssolot where codsolot = a_sol and esttrs = 2;

   RETURN tmpVar;

   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          RETURN Null;
     WHEN OTHERS THEN
          RETURN Null;

END;
/


