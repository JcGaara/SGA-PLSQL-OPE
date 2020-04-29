CREATE OR REPLACE PROCEDURE OPERACION.P_CREAR_CID_TEMP(a_codsol in number, a_punto in number) IS
ln_clave number;

cursor cur_sol is
   select punto, descripcion, direccion from solotpto
      where codsolot = a_codsol and
            punto = a_punto;

BEGIN
   for cur_pto in cur_sol loop

     -- select nvl(max(codinssrv),0)+1 into ln_clave from inssrv;
     select operacion.F_GET_CLAVE_SID into ln_clave from dual; --23/10/2007

      insert into inssrv(codinssrv, codcli, codsrv, estinssrv, tipinssrv, descripcion, direccion)
         values (ln_clave, '00006932', '0000', 4, 1, cur_pto.descripcion, cur_pto.direccion);

      update solotpto
         set codinssrv = ln_clave
         where codsolot = a_codsol and
               punto = a_punto;

	end loop;

END;
/


