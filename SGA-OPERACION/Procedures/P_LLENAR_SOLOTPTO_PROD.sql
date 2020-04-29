CREATE OR REPLACE PROCEDURE OPERACION.p_llenar_solotpto_prod(a_codsolot in number) IS
/******************************************************************************
 Se llena el detalle de la solicitud
******************************************************************************/
lc_numslc solot.numslc%type;

ln_sid  solotpto.punto%type;
lc_codsrvant solotpto.codsrvant%type;
ln_bwant solotpto.bwant%type;
ln_codef efpto.codef%type;
ln_pop  solotpto.pop%type;
l_servicio number;
l_tipo number;

--inicio vvs
tipo_servicio tystabsrv.tipsrv%type;
--fin vvs
tmpvar number;

-- Por defecto si no se especifica es 1 = Instalacion
cursor cur_puntos(an_codef in char) is
  select codef, punto, codsrv, bw, descripcion, direccion, codubi, pop, tiptraef from efpto where codef = an_codef ;

BEGIN
--   VVS
--   P_ELIMINAR_INSSRVXINSSRV(a_codsolot);

   delete operacion.solotpto where codsolot = a_codsolot;

   -- Se obtiene el proyecto asociado
   select numslc into lc_numslc from solot where codsolot = a_codsolot;
   ln_codef := to_number(lc_numslc);

   -- se inserta el detalle de los puntos
   for l_punto in cur_puntos(ln_codef) loop
      ln_sid := F_CREAR_INSSRV_PROD(l_punto.codef, l_punto.punto);
	  --Se obtienen los datos anteriores
	  select codsrv, bw into lc_codsrvant, ln_bwant from inssrv where codinssrv = ln_sid;
	  -- Se inserta el detalle
	  select count(*) into tmpvar from solotpto where codsolot = a_codsolot and punto = ln_sid;
	  if tmpvar = 0 then

		  -- Se ubica el pop si no lo encontrara
     	 if l_punto.pop is null and ln_sid is not null then
        	begin
				select e.codubired into ln_pop from puertoxequipo p, equipored e, inssrv i where
				p.codequipo = e.codequipo and p.cid = i.cid and i.codinssrv = ln_sid;
       			exception
			   	when others then
            		ln_pop := null;
   			end;
         end if;

	  	 insert into solotpto(CODSOLOT, PUNTO, EFPTO,CODINSSRV, CODSRVANT, BWANT,
                             CODSRVNUE, BWNUE, CID, DESCRIPCION, DIRECCION, TIPO,
                             ESTADO, VISIBLE, PUERTA, POP,CODUBI, TIPTRAEF )
			values( a_codsolot, l_punto.punto, l_punto.punto, ln_sid,lc_codsrvant,
                   ln_bwant, l_punto.codsrv, l_punto.bw, null, l_punto.descripcion,
                   l_punto.direccion, 1 /* Tipo 1 cuando vienen de proyectos */, 1,
                   1,null , l_punto.pop, l_punto.codubi, l_punto.tiptraef);
	  end if;

   end loop;

-- Comentado CC 03-0313
/*   
--inicio telefonia...idenitifcar de donde se va obtener los servicios
  select tipsrv into tipo_servicio from solot where  codsolot = a_codsolot;

  if tipo_servicio = '0044' or tipo_servicio = '0004' or tipo_servicio = '0043' then
--        P_LLENAR_SOLOTPTO_TELEF_PROD(a_codsolot, ln_sid, l_punto.punto, l_servicio);
  	  TELEFONIA.P_CREAR_PRITEL(a_codsolot);
  end if;
     --fin telefonia.
*/

/*EXCEPTION
     WHEN OTHERS THEN
       Null; */
END;
/


