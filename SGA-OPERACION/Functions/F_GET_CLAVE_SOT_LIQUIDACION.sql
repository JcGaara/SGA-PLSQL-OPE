CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SOT_LIQUIDACION RETURN NUMBER IS
ln_clave number;
BEGIN
  select SQ_sot_liquidacion.nextval into ln_clave from dual;
  return ln_clave;
END;
/


