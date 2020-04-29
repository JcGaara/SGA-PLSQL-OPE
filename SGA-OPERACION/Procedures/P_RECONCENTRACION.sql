CREATE OR REPLACE PROCEDURE OPERACION.P_RECONCENTRACION( an_codelered number) IS
ls_codcli fibra.codcli%type;
ls_codsuc fibra.codsuc%type;
ls_numslc fibra.numslc%type;

cursor cur_elered is
  SELECT codelered_p,
         codelered_h,
         codtiprelelexele,
         estfibra
    FROM eleredxelered,
         fibra
   WHERE codelered_p = codelered and
         codelered_h = an_codelered and
         codtiprelelexele = 1;

BEGIN
for l_cursor in cur_elered loop
	select codcli,codsuc,numslc into ls_codcli,ls_codsuc,ls_numslc  from fibra
  		 where codelered = l_cursor.codelered_p;
    if l_cursor.estfibra = 3 then
      update fibra
         set estfibra = 2
         where codelered = l_cursor.codelered_p;
    else
      update fibra
         set estfibra = 1,
		 	 codsuc = null,
			 codcli = null,
			 numslc = null
         where codelered = l_cursor.codelered_p;
		P_ELIMINAR_RELACION(l_cursor.codelered_p, l_cursor.codelered_h, l_cursor.codtiprelelexele);
   end if;
   update fibra
       set codcli = ls_codcli,
	   	   codsuc = ls_codsuc,
		   numslc = ls_numslc
        where estfibra = 2 and
		  	 codelered = l_cursor.codelered_p;
end loop;

END;
/


