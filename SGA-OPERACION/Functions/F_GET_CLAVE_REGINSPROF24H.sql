CREATE OR REPLACE FUNCTION OPERACION.F_GET_CLAVE_REGINSPROF24H RETURN VARCHAR2 IS
l_clave varchar2(500);
id number;
BEGIN
  --select nvl(max(codsolot),0)+1 into ln_clave from solot;
  SELECT OPERACION.SQ_REGINSPROF24H.nextval into id from dual;
  l_clave:= LPAD(id, 10, '0');
  return l_clave ;
END;
/


