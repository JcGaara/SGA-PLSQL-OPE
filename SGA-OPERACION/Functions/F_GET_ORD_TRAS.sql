CREATE OR REPLACE FUNCTION OPERACION.F_GET_ORD_TRAS RETURN NUMBER IS
ln_clave number;
BEGIN
  select OPERACION.SEQ_ORD_TRAS.nextval into ln_clave from dual;
  return ln_clave;
END;
/


