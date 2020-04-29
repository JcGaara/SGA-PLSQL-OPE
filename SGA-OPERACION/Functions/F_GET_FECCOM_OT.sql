CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECCOM_OT( a_codsolot in number, a_area in char ) RETURN date IS

ls_proyecto solot.numslc%type;
l_diapla_ef number;
l_codef ef.codef%type;
l_area char(6);
l_diapla number;


BEGIN
   L_AREA := RPAD(a_area,6);

   begin
      select s.numslc into ls_proyecto from solot s, vtatabslcfac v
      where
      	s.NUMSLC= V.NUMSLC AND
	      s.codsolot = a_codsolot and
         ( S.numpsp is not null or V.coddpt in ('0013  ', '0010  ') );
      if ls_proyecto is null then
         return null;
      end if;
      l_codef := to_number(ls_proyecto);

	   select numdiapla into l_diapla_ef from ef where numslc = ls_proyecto;
   exception
      when others then
         return null;
   end;


   if l_area = '0031  ' then -- PEX
   begin
      select sum(numdiapla) into l_diapla from solefxarea where codef = l_codef and coddpt in ('0031  ', '0041  ');
      if l_diapla is null then
         l_diapla := l_diapla_ef;
      end if;
      return sysdate + l_diapla;

      exception
         when others then
            return null;

   end;
/*   elsif l_area = '0047  ' then -- Instalaciones
   begin

      select sum(numdiapla) into l_diapla from solefxarea where codef = l_codef and coddpt in ( '0031  ','0047  ');
      if nvl(l_diapla,0) = 0 then
         l_diapla := l_diapla_ef;
      end if;
      return sysdate + l_diapla;

      exception
         when others then
            return null;
   end;

   elsif l_area = '0047  ' then -- Instalaciones
   begin

      select sum(numdiapla) into l_diapla from solefxarea where codef = l_codef and coddpt in ( '0031  ','0047  ');
      if nvl(l_diapla,0) = 0 then
         l_diapla := l_diapla_ef;
      end if;
      return sysdate + l_diapla;

      exception
         when others then
            return null;
   end;


*/

   else
      return sysdate + l_diapla_ef;
   end if;

END;
/


