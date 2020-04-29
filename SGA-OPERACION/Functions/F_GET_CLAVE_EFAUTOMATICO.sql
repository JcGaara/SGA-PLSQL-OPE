CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_EFAUTOMATICO RETURN NUMBER IS
ln_clave number;
BEGIN
  select nvl(max(ID),0)+1 into ln_clave from EFAUTOMATICO;
  return ln_clave;
END;
/


