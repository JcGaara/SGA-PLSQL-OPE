CREATE OR REPLACE PROCEDURE OPERACION.P_CREA_MOTOT ( a_codmotot in char, a_descripcion in char, a_coddpt in char, codeta in number,
abr1 in char, abr2 in char, abr3 in char ) IS
tmpVar NUMBER;
/******************************************************************************
Crea un  otivo y toda las tablas para telefonia
******************************************************************************/

l_nuevo boolean;
l_cod number;
l_tip number;

BEGIN

l_nuevo := false;
begin
 l_cod := to_number(a_codmotot);
exception
   when others then
    select max(codmotot) + 1 into l_cod from motot;
      l_nuevo := true;
end;


if l_nuevo then

 insert into motot( codmotot, descripcion, GRUPODESC ) values (l_cod, abr1||' - '||a_descripcion, abr3 );

   select max( tipinfot) + 1 into l_tip from tipinfot;

   insert into tipinfot (TIPINFOT, DESCRIPCION, GRUPO, GRUPODESC)
   values (  l_tip , a_descripcion, abr2, abr3 ) ;

   insert into TIPINFOTXMOTOT (CODMOTOT, TIPINFOT) values ( l_cod, l_tip );

end if;

insert into mototxarea( codmotot, coddpt) values (l_cod, a_coddpt );

END;
/


