CREATE OR REPLACE FUNCTION OPERACION.F_GET_NUMSLC_HIJOS(a_solicitud in number, a_punto in number) RETURN varchar2 IS
lc_men varchar2(4000);
lc_temp varchar2(4000);
ll_cont number;
cursor cur_sol is
   select distinct b.numslcpad numslc
   from vtatabslcfac a,
   		vtadetptoenl b,
   		vtatabpspcli_v c,
		solot d
   where a.numslc = b.numslc and
   		 b.numslc = c.numslc and
   		 b.numslc = d.numslc and
   		 c.estpspcli = '02' and
   		 b.flgupg = 1 and
		 d.codsolot = a_solicitud and
		 b.numpto = a_punto;

BEGIN
ll_cont := 1;
for lcur in cur_sol loop
	if ll_cont = 1 then
	   lc_men := ' Proyectos hijos:' || lcur.numslc ||', ';
	   ll_cont := 2;
	else
	   lc_men := lc_men || lcur.numslc || ', ' ;
	 end if;
end loop;

if lc_men is not null then
   select instr(lc_men, ',') - 1 into ll_cont from dual;
   select substr(lc_men, 1, ll_cont) into lc_men from dual;
end if;

return lc_men;
exception
  when others then
     return '';

END;
/


