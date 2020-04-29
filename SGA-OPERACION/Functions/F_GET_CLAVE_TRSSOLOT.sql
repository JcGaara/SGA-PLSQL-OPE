CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_TRSsolot RETURN NUMBER IS
ln_clave number;
BEGIN
--  select nvl(max(codtrs),0)+1 into ln_clave from trssolot;

  select SQ_TRSSOLOT_ID.nextval into ln_clave  from dual;

  return ln_clave;
END;
/


