CREATE OR REPLACE FUNCTION OPERACION.F_GET_ID_INSPRD RETURN NUMBER IS
ln_clave number;
BEGIN
  select SQ_ID_INSPRD.nextval into ln_clave from dual;
  return ln_clave;
END;
/


