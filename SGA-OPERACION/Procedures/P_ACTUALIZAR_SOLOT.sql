CREATE OR REPLACE PROCEDURE OPERACION.p_actualizar_solot(a_codsolot in number) IS

BEGIN
	-- se actualiza la inf de la solicitud y de las OT Involucradas
	p_llena_otpto_de_solotpto_all (a_codsolot);


END;
/


