CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SOLEF RETURN char IS
ln_clave number;
BEGIN
  select nvl(max(numslc),0)+1 into ln_clave from vtatabslcfac;
  return lpad(ln_clave,10,'0');
END;
/


