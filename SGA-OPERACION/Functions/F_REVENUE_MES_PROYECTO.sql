CREATE OR REPLACE FUNCTION OPERACION.f_revenue_mes_proyecto( a_proyecto in char)  RETURN NUMBER IS

SALIDA NUMBER(15,2);
l_numpsp vtatabpspcli.numpsp%type;
l_idopc vtatabpspcli.idopc%type;
l_tipsrv ef.tipsrv%type;
l_codef ef.codef%type;

BEGIN
   select codef,tipsrv into l_codef, l_tipsrv from ef where numslc = a_proyecto;

   if l_tipsrv = '0004' then
      select nvl(f_revenue_neto_telefonia(l_codef),0) into salida from dual;
      return salida;
   end if;

   select vtatabpspcli.numpsp, vtatabpspcli.idopc into l_numpsp, l_idopc
   from vtatabpspcli,
   (select max(c.numpsp) numpsp, max(c.idopc) idopc
   from vtatabpspcli c where c.numslc = a_proyecto group by c.numpsp) b
   where vtatabpspcli.numslc = a_proyecto and
   vtatabpspcli.numpsp  = b.numpsp and
   vtatabpspcli.idopc  = b.idopc;

   SELECT SUM(COSSRV*CANTIDAD)
	INTO SALIDA
	FROM VTADETPSPCLI
	WHERE NUMPSP = l_NUMPSP
		AND IDOPC = l_IDOPC
		AND TIPDET in ( 'A','C');

  RETURN SALIDA;

exception
  when others then
   return null;

END;
/


