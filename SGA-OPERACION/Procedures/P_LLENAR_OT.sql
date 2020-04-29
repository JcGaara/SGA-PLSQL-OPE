CREATE OR REPLACE PROCEDURE OPERACION.P_LLENAR_OT (a_codot in number) IS

ls_area ot.coddpt%type;
l_cont number;
l_solot ot.codsolot%type;
l_codot ot.codot%type;
l_tiptra ot.tiptra%type;
l_numslc solot.numslc%type;



BEGIN

   select count(*) into l_cont from otpto where codot = a_codot;
   if l_cont > 0 then  -- ya esta llena no hay que hacer nada
   	  return;
   end if;

   select rtrim(ot.coddpt), ot.codsolot, ot.tiptra, solot.numslc into ls_area, l_solot, l_tiptra, l_numslc from ot, solot where
   ot.codot = a_codot and ot.codsolot = solot.codsolot;




   -- INSTALACIONES DE PEX
   if ls_area = '0042' then
   	  -- buscamos la ot de dise?o y copiamos de ella
	  begin
	  	  select codot into l_codot from ot where codsolot = l_solot and coddpt = '0040  ';
	  EXCEPTION
	    WHEN OTHERS THEN
      	   Null;
      end;
	  if l_codot is not null then
	  	 p_copia_ot(l_codot, a_codot);
      else
	    p_llena_otpto_de_solotpto(a_codot);
      end if;
      p_llena_presupuesto_de_sol(l_solot);

   --  AUTORIZACIONES DE PEX
   elsif  ls_area = '0041' then
   	  -- buscamos la ot de dise?o y copiamos de ella
	  begin
	  	  select codot into l_codot from ot where codsolot = l_solot and coddpt = '0040  ';
	  EXCEPTION
	    WHEN OTHERS THEN
      	   Null;
      end;
	  if l_codot is not null then
	  	 p_copia_ot_permisos(l_codot, a_codot);
      else
	    p_llena_otpto_de_solotpto(a_codot);
      end if;
      p_llena_presupuesto_de_sol(l_solot);

   -- DISE?O
   elsif  ls_area = '0040' then   -- se actualizan datos del proyecto
      -- se llena los punto de la solicitud, luego se copia la informacion de EF
      p_llena_otpto_de_solotpto(a_codot);
      p_llena_presupuesto_de_sol(l_solot);

   -- PLANTA EXTERNA ASIGNACIONES
   elsif  ls_area = '0031' and l_tiptra not in (2,3) and l_numslc is not null then    	  -- se actualizan datos del proyecto
      -- se llena los punto de la solicitud, luego se copia la informacion de EF
      p_llena_otpto_de_solotpto(a_codot);
      p_llena_presupuesto_de_sol(l_solot);
--     cambio pedido por pex
--      P_LLENA_OTACT_DE_EF(a_codot);
--      P_LLENA_OTMAT_DE_EF(a_codot);

	  update ot set observacion = (select decode(ot.observacion, null, '', ot.observacion)|| ' EF: '||ef.observacion from ef where ef.numslc = l_numslc )
	  where codot = a_codot ;

   else
      p_llena_otpto_de_solotpto(a_codot);
   end if;

END;
/


