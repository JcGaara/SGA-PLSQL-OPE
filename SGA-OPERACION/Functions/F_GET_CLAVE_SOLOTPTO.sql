CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SOLOTPTO ( a_codsolot in number default null ) RETURN NUMBER IS
ln_clave number;
BEGIN
	if a_codsolot is null then
   	select SQ_SOLOTPTO_PUNTO.nextval into ln_clave from dual;
   else
		select nvl(max(punto),0)+1 into ln_clave from solotpto where codsolot = a_codsolot ;
   end if;

  return ln_clave;
END;
/


