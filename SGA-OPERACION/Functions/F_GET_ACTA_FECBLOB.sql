CREATE OR REPLACE FUNCTION OPERACION.F_GET_ACTA_FECBLOB (a_cid in number, parte_like in varchar2) RETURN date IS
l_resultado DATE;
cursor c1 is
select fecusu from ciddocblob where cid = a_cid and descripcion like parte_like;

BEGIN

    l_resultado := '';

  	for l in c1 loop
     	begin

         l_resultado := l_resultado || l.fecusu || ', ';

      end;

     end loop;

         return l_resultado;

       EXCEPTION
          WHEN OTHERS THEN
          return Null;

END;
/


