CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHA_TRN_MAT (a_req in char) RETURN date IS
tmpVar date;
BEGIN

	select min(fectrn) into tmpvar from almtrnalmcab where numdoc = a_req;
   RETURN tmpVar;

END;
/


