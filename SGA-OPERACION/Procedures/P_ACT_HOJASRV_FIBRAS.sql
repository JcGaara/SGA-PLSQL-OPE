CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_HOJASRV_FIBRAS (a_codhoja in number) IS
l_fibra_ant fibra.codelered%type;
l_fibra_new fibra.codelered%type;
l_cant NUMBER;

cursor cur_hoja is
    select numslc , codinssrv from hojasrv
        where codhoja = a_codhoja;

BEGIN

for row_hoja in cur_hoja loop
   select nvl(max(b.codfibra),0) into l_fibra_ant
   from inssrv,
   		pex_fibra b
   where inssrv.codinssrv  = row_hoja.codinssrv and
      	 b.numslc  = row_hoja.numslc and
         inssrv.codinssrv = b.codinssrv and
		 b.codestfibra = 2;

   select nvl(max(b.codfibra),0) into l_fibra_new
   from inssrv,
   		pex_fibra b
   where inssrv.codinssrv  = row_hoja.codinssrv and
      	 b.numslc  = row_hoja.numslc and
         inssrv.codinssrv = b.codinssrv and
		 b.codestfibra = 3;

 update hojasrv set fibra_ant = l_fibra_ant,
          fibra_new = l_fibra_new
   where numslc = row_hoja.numslc
   and   codinssrv = row_hoja.codinssrv;
end loop;

END;
/


