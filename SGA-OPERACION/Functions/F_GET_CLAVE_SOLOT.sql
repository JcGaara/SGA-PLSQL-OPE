CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SOLOT RETURN NUMBER IS
ln_clave number;
BEGIN
  --select nvl(max(codsolot),0)+1 into ln_clave from solot;
  select SQ_SOLOT.nextval into ln_clave from dual;
  return ln_clave;
END;
/


