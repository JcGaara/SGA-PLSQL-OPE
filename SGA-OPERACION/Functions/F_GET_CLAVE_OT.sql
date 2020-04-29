CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_OT RETURN NUMBER IS
  ln_clave number;
BEGIN
  --select nvl(max(codot),0)+1 into ln_clave from ot;
  select SQ_CODOT.nextval into ln_clave from dual;
  return ln_clave;
END;
/


