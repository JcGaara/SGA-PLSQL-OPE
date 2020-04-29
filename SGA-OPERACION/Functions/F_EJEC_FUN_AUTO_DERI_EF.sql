CREATE OR REPLACE FUNCTION OPERACION.F_EJEC_FUN_AUTO_DERI_EF(
	   pnomfun IN VARCHAR2,
	   p1 IN VARCHAR2
) return INTEGER IS
  query_str_fun VARCHAR2(200);
  query_str VARCHAR2(2500);
  l_return  INTEGER;
BEGIN

    IF ( pnomfun is not null) then
      query_str_fun := pnomfun ||'( :1 )';
      query_str :='select '|| query_str_fun || 'into ' || l_return ||' from dual; ';
      EXECUTE IMMEDIATE	query_str
      USING p1;
    end if;

    return l_return;
END;
/


