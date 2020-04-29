CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SUCXCONTRATA RETURN NUMBER IS
ln_clave number;
BEGIN
  select OPERACION.SQ_SUCXCONTRATA.nextval into ln_clave from dual;
  return ln_clave;
END;
/


