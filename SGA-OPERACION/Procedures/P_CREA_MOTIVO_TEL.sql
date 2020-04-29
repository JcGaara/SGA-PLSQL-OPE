CREATE OR REPLACE PROCEDURE OPERACION.P_CREA_MOTIVO_TEL ( a_codmotot in char, a_descripcion in char, a_coddpt in char ) IS
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

 insert into motot( codmotot, descripcion, GRUPODESC ) values (l_cod, 'TEL - '||a_descripcion, 'TELEFONIA' );

   select max( tipinfot) + 1 into l_tip from tipinfot;

   insert into tipinfot (TIPINFOT, DESCRIPCION, GRUPO, GRUPODESC)
   values (  l_tip , a_descripcion, 'TE', 'TELEFONIA' ) ;

   insert into TIPINFOTXMOTOT (CODMOTOT, TIPINFOT) values ( l_cod, l_tip );

end if;

insert into mototxarea( codmotot, coddpt) values (l_cod, a_coddpt );

END;
/


