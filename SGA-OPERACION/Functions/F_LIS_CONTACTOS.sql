CREATE OR REPLACE FUNCTION OPERACION.F_LIS_CONTACTOS (a_codcli in char) RETURN varchar2 IS

cursor cur_cnt is
select c.codcnt, m.idmedcom, t.DSCCNT ||' ' || c.nomcnt descr,  m.numcomcnt tel from vtatabcntcli c, vtamedcomcnt m, vtatipcnt t
where t.TIPCNT= c.TIPCNT and c.codcnt = m.codcnt (+) and m.idmedcom in ('001', '003' ) and c.codcli = a_codcli
order by c.codcnt, m.idmedcom;

l_cnt vtatabcntcli.codcnt%type;
l_sep varchar2(2);

l_s varchar2(4000);


BEGIN
	l_sep := '';
	for lc1 in cur_cnt loop
   	if l_cnt is null or l_cnt <> lc1.codcnt then
      	l_s := l_s || l_sep || lc1.descr || ' ' || lc1.tel;
      else
      	l_s := l_s || ' ' || lc1.tel;
      end if;
		l_cnt := lc1.codcnt;
      l_sep := ', ';

   end loop;

	return l_s;

   EXCEPTION
     WHEN OTHERS THEN
			return l_s;
END;
/


