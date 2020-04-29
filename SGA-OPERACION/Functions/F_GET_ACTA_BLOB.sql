CREATE OR REPLACE FUNCTION OPERACION.F_GET_ACTA_BLOB (a_cid in number, parte_like in varchar2) RETURN varchar2 IS
l_resultado varchar2(4000);
cursor c1 is
select descripcion from ciddocblob where cid = a_cid and descripcion like parte_like;

BEGIN

    l_resultado := '';
  	for l in c1 loop
     	begin
         l_resultado := l_resultado || l.descripcion || ', ';
      end;

     end loop;

        return l_resultado;
       EXCEPTION
          WHEN OTHERS THEN
          return Null;
END;
/


