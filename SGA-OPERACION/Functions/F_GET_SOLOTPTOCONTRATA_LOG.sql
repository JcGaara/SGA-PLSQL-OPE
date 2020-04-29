CREATE OR REPLACE FUNCTION OPERACION.F_GET_SOLOTPTOCONTRATA_LOG RETURN NUMBER IS
ln_clave number;
BEGIN
  select nvl(max(codigo),0)+1 into ln_clave from SOLOTPTOCONTRATA_LOG;
  return ln_clave;
END;
/


