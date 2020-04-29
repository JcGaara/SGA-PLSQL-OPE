CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_INSSRVXINSSRV RETURN NUMBER IS
ln_clave number;
BEGIN
  select nvl(max(codinssrvxinssrv),0)+1 into ln_clave from inssrvxinssrv;
  return ln_clave;
END;
/


