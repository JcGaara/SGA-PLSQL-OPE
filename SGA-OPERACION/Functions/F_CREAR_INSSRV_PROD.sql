CREATE OR REPLACE FUNCTION OPERACION.F_CREAR_INSSRV_PROD(a_codef in number, a_punto in number)  RETURN NUMBER IS
/******************************************************************************
 Retorna el numero del SID,
 Se crea una SID,
 Se actualiza este numero en la solic EF y en el EF
******************************************************************************/
ln_clave NUMBER;
ln_cid NUMBER;
ln_existe number := 0;
lc_numslcpad vtadetptoenl.numslcpad%type;
lc_numptopad vtadetptoenl.numptopad%type;
ln_flgupg vtadetptoenl.flgupg%type;
lc_codcli vtatabslcfac.codcli%type;
lc_codsuc vtadetptoenl.codsuc%type;
lc_codsrv vtadetptoenl.codsrv%type;
lc_flgpto tystabsrv.flgpto%type;
ln_bw efpto.bw%type;
ln_aux number;

lc_tipsrv1 tystabsrv.tipsrv%type;
lc_tipsrv2 tystabsrv.tipsrv%type;
l_flg_sid tystabsrv.flg_sid%type;


BEGIN

   -- Se valida que la instancia de servicio exista
   select codsrv, bw, codinssrv into lc_codsrv, ln_bw, ln_clave from efpto
   where efpto.codef = a_codef and efpto.punto = a_punto;

   -- Si ya tiene se devuelve el numero
   if ln_clave is not null then
      return ln_clave;
   end if;

   -- Se verifica que el tipo de servicio no sea del tipo valor agregado
   lc_flgpto := '1';
   begin
     select nvl(flgpto,'1') into lc_flgpto from tystabsrv where codsrv = lc_codsrv;
   exception
     when others then
	    lc_flgpto := '1';
   end;

   -- Si no encontro
   if ln_existe = 0 then
      -- por aca, se busca por la sucursal, si el servicio es por sucursal
	  if lc_flgpto = '1' then
         SELECT ef.codcli, efpto.codsuc into lc_codcli, lc_codsuc
         FROM ef,
              efpto
         WHERE ef.codef = a_codef and
      		   efpto.codef = ef.codef and
               efpto.punto = a_punto;

         -- Se encuentra el numero del CID  ////////////////////////////// Modificar esto para que jale del EF
         SELECT max(vtadetptoenl.numckt) into ln_clave
         FROM vtadetptoenl,
               vtatabslcfac
         WHERE vtadetptoenl.codsuc = lc_codsuc and
               vtatabslcfac.codcli = lc_codcli and
      		    vtadetptoenl.numslc = vtatabslcfac.numslc;

		 begin
		 	  select codinssrv into ln_aux from inssrv where codinssrv = ln_clave and estinssrv <> 3;
		 exception
		   when others then
		   	  ln_clave := null;
		 end;


      end if;

      if ln_clave is null then
   	     ln_existe := 0;
   	  else
   	     ln_existe := 1;
      end if;
   end if;

   -- se hace una ultima validacion antes de NO CREAR la IS
   -- los dos nuevos servicios (el que esta en inssrv y el de efpto deben ser del mismo tipo se servicio
   if ln_existe = 1 then
      begin
         SELECT tystabsrv.tipsrv into lc_tipsrv1
            FROM efpto, tystabsrv
            WHERE efpto.codef = a_codef and
               efpto.punto = a_punto and efpto.codsrv = tystabsrv.codsrv;

         SELECT tystabsrv.tipsrv into lc_tipsrv2
            FROM inssrv, tystabsrv
            WHERE inssrv.codinssrv = ln_clave and
                inssrv.codsrv = tystabsrv.codsrv;

       if lc_tipsrv1 <> lc_tipsrv2 then
          ln_existe := 0;  -- son dos tipos de servicio diferentes, se debe crear otro CID
       end if;
  		 exception
		   when others then
            null;
		 end;
   end if;

   /* Se valida el flag de SID FLG_SID */
   if ln_existe = 1 then
	   begin
      select flg_sid into l_flg_sid from tystabsrv where codsrv = lc_codsrv ;
      if l_flg_sid = 1 then
      	ln_existe := 0;
      end if;

  		 exception
		   when others then
            null;
		 end;
   end if;




   if ln_existe = 0 then -- Se crea la instancia de Servicio
      if lc_tipsrv1 is null then
	     begin
		 	select tipsrv into lc_tipsrv1 from tystabsrv where codsrv = lc_codsrv;
  		 exception
		   when others then
            null;
		 end;

      end if;

      ln_clave := f_get_clave_sid;
      insert into inssrv( codinssrv,codcli,codsrv,
            estinssrv,tipinssrv,
            descripcion,direccion,codsuc,bw,numslc,numpto , codubi, pop, tipsrv )
      SELECT ln_clave,ef.codcli,nvl(efpto.codsrv,'0000'),
		    4,  -- El estado inicial es sin activar
			1,  -- Tipo Datos
            nvl(efpto.descripcion,'Vacio'),efpto.direccion,efpto.codsuc,efpto.bw,lpad(efpto.codef,10,'0'),lpad(efpto.punto,5,'0'), efpto.codubi, efpto.pop, lc_tipsrv1
         FROM ef,
              efpto
         WHERE ef.codef = a_codef and
      		   efpto.codef = ef.codef and
               efpto.punto = a_punto;


   else -- Se actualiza la instancia de Servicio
	   update inssrv set (descripcion,direccion, pop, codubi) = (
             select nvl(efpto.descripcion,nvl(inssrv.descripcion,'Vacio')), nvl(efpto.direccion,inssrv.direccion),
			         efpto.pop, efpto.codubi
             FROM efpto
             WHERE efpto.codef = a_codef and efpto.punto = a_punto )
	   where codinssrv = ln_clave and exists
             ( select * FROM efpto WHERE efpto.codef = a_codef and efpto.punto = a_punto );

	end if;

	-- Se actualiza el punto de enlace en el proyecto
	select to_number(numero) into ln_cid from inssrv where codinssrv = ln_clave;

	update vtadetptoenl set
	numckt = ln_clave,
	cid = ln_cid
	where vtadetptoenl.numslc = lpad(a_codef,10,'0') and vtadetptoenl.numpto = lpad(a_punto,5,'0');

	update efpto set
	codinssrv = ln_clave
	where efpto.codef = a_codef and efpto.punto = a_punto;

	return ln_clave;
/*
EXCEPTION
     WHEN NO_DATA_FOUND THEN
       return Null;
     WHEN OTHERS THEN
       return Null;
*/
END;
/


