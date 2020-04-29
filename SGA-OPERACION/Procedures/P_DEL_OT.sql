CREATE OR REPLACE PROCEDURE OPERACION.P_DEL_OT (a_codot in number) IS
tmpVar NUMBER;
BEGIN

	delete otptoequcmp where codot = a_codot;
	delete otptoequ where codot = a_codot;
	delete otptoeta where codot = a_codot;
	delete otpto where codot = a_codot;
	delete ot where codot = a_codot;

END;
/


