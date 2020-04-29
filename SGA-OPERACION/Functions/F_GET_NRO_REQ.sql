CREATE OR REPLACE FUNCTION OPERACION.F_GET_NRO_REQ( a_codsolot in number, a_punto in number,
a_codeta in number DEFAULT NULL) RETURN varchar2 IS

ls_nroreq varchar2(500);

cursor cur_cnt is
select nroped
  	from slcpedmatcab
	where codsolot = a_codsolot and
		  punto = a_punto
--		  trim(ordtra) = a_codot and
--		  (codinssrv = a_punto)
	order by nroped;


cursor cur_cnt_eta is
select nroped
  	from slcpedmatcab
	where codsolot = a_codsolot and
		  punto = a_punto and
		  codeta = a_codeta
--		  trim(ordtra) = a_codot and
--		  (codinssrv = a_punto)
	order by nroped;

BEGIN

   ls_nroreq := '';
   if a_codeta is null then
	   for lc1 in cur_cnt loop
	   	  ls_nroreq := ls_nroreq || ' ' || lc1.nroped;
	   end loop;
   else
   	   for lc2 in cur_cnt_eta loop
	   	   ls_nroreq := ls_nroreq || ' ' || lc2.nroped;
	   end loop;
   end if;

   return ls_nroreq;

   exception
   		when others then
     		return null;
END;
/


