CREATE OR REPLACE PROCEDURE OPERACION.TMP_DEL_REPETIDOS IS
tmpVar NUMBER;
l_numero inssrv.numero%type;
i number;
j number;

cursor cur1 is
   select numero, codcli, count(numero)from inssrv where tipinssrv = 5
   group by numero, codcli
   having count(numero) > 1
   order by numero
   ;

cursor cur2 is
select codinssrv, estinssrv from inssrv where numero = l_numero and tipinssrv = 5
order by estinssrv;


BEGIN

	j:= 0;

	for l in cur1 loop
   	l_numero := l.numero;
      exit when j > 100;

      i := 0;
      for a in cur2 loop
      	if i > 0 then
         	delete inssrv where codinssrv = a.codinssrv;

         end if;
         i := i + 1;

      end loop;
      j := j + 1;

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


