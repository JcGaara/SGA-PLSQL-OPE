CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_SID RETURN NUMBER IS
ln_clave number;
BEGIN
  --select nvl(max(codinssrv),0)+1 into ln_clave from inssrv;
  select operacion.SQ_ID_INSSRV.nextval into ln_clave from dual;
  return ln_clave;
END;
/


