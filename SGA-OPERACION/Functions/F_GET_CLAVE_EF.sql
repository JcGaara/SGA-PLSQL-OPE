CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_EF RETURN NUMBER IS
ln_clave number;
BEGIN
  select nvl(max(codef),0)+1 into ln_clave from ef;
  return ln_clave;
END;
/


