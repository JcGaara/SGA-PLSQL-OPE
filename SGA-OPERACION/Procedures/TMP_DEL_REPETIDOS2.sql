CREATE OR REPLACE PROCEDURE OPERACION.TMP_DEL_REPETIDOS2 IS
tmpVar NUMBER;
l_numero inssrv.numero%type;
i number;
j number;

cursor cur1 is
   select numero,  count(numero)from inssrv where tipinssrv = 5
   group by numero
   having count(numero) > 1
   order by numero
   ;



BEGIN

	j:= 0;

	for l in cur1 loop
   	l_numero := l.numero;
      select count(*) into i from inssrv where numero = l_numero and tipinssrv = 5 and estinssrv = 1;

      if i = 1 then
      	delete inssrv where numero = l_numero and tipinssrv = 5 and estinssrv <> 1;
      end if;

   end loop;





end;
/*

   tmpVar := 0;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
END TMP_DEL_REPETIDOS;

*/
/


