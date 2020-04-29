CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_VIGILANTE AS

/**********************************************************************
Inserta un registro en la tabla de Vigilante
**********************************************************************/
procedure p_insert_registro(
   ar_vig  in vigresumen%rowtype
)
is
l_id vigresumen.id%type;
l_vig vigresumen%rowtype;
l_tiptrs vigresumen.tiptrs%type;
l_etapa vigresumen.fase%type;
l_atraso vigresumen.dias_atraso%type;

begin
	l_vig := ar_vig;
   if ar_vig.tipo = 1 then
   	  begin
	  	  select idetapa, id into l_etapa, l_id
	  		 from vigresumen
			 where numslc = ar_vig.numslc and
			 	   numpto = ar_vig.numpto and
				   tipo = ar_vig.tipo and
				   estado = 1;
			   exception
			   when others then
			   l_etapa := 0;
	  end;
   	  l_vig.id := l_id;
	  if l_etapa = ar_vig.idetapa then
		  p_actualizar_registro(ar_vig);
	  elsif l_etapa > 0 then
	  	  p_insert_registro_log(ar_vig);
	  	  p_actualizar_registro(ar_vig);
	  elsif l_etapa = 0 then
		   insert into vigresumen (
		      id, fase, tipo, idetapa,
			  numslc, numpto, codsolot, codinssrv,
			  distrito, areaope, flgcliente, fecinicio,
			  feccom, dias_atraso, estado, observacion,
			  tipsrv, tiptrs, estado_wf, pid,
			  feccompry, fecapr, tiptra, codsegmark,
			  sede, punto
		       ) values (
		      l_id, ar_vig.fase, ar_vig.tipo, ar_vig.idetapa,
			  ar_vig.numslc, ar_vig.numpto, ar_vig.codsolot, ar_vig.codinssrv,
			  ar_vig.distrito, ar_vig.areaope, ar_vig.flgcliente, ar_vig.fecinicio,
			  ar_vig.feccom, ar_vig.dias_atraso, ar_vig.estado, ar_vig.observacion,
			  ar_vig.tipsrv, l_tiptrs, ar_vig.estado_wf, ar_vig.pid,
			  ar_vig.feccompry, ar_vig.fecapr, ar_vig.tiptra, ar_vig.codsegmark,
			  ar_vig.sede, ar_vig.punto);

	   end if;
   elsif ar_vig.tipo = 2 then
	   begin
		   select idetapa, id into l_etapa, l_id
	   		  from vigresumen
			  where codsolot = ar_vig.codsolot and
			  		punto = ar_vig.punto and
					pid = ar_vig.pid;
				exception
				   	when others then
					l_etapa := 0;
       end;
   	   l_vig.id := l_id;
	   if l_etapa = ar_vig.idetapa then
		  p_actualizar_registro(l_vig);
	   elsif l_etapa > 0 then
	   	  p_insert_registro_log(l_vig);
	  	  p_actualizar_registro(l_vig);
	   elsif l_etapa = 0 then
	   		insert into vigresumen (
		      fase, tipo, idetapa,
			  numslc, numpto, codsolot, codinssrv,
			  distrito, areaope, flgcliente, fecinicio,
			  feccom, dias_atraso, estado, observacion,
			  tipsrv, tiptrs, estado_wf, pid,
			  feccompry, fecapr, tiptra, codsegmark, sede, punto
		       ) values (
		      ar_vig.fase, ar_vig.tipo, ar_vig.idetapa,
			  ar_vig.numslc, ar_vig.numpto, ar_vig.codsolot, ar_vig.codinssrv,
			  ar_vig.distrito, ar_vig.areaope, ar_vig.flgcliente, ar_vig.fecinicio,
			  ar_vig.feccom, ar_vig.dias_atraso, ar_vig.estado, ar_vig.observacion,
			  ar_vig.tipsrv, ar_vig.tiptrs, ar_vig.estado_wf, ar_vig.pid,
			  ar_vig.feccompry, ar_vig.fecapr, ar_vig.tiptra, ar_vig.codsegmark, ar_vig.sede, ar_vig.punto );
	   end if;
   end if;
   commit;
end;

/**********************************************************************
Actualiza un registro en la tabla de Vigilante
**********************************************************************/
procedure p_actualizar_registro(ar_vig  in vigresumen%rowtype)
is
begin

 	 update vigresumen
	 	set fase = ar_vig.fase,
			tipo = ar_vig.tipo,
			idetapa = ar_vig.idetapa,
			numslc = ar_vig.numslc,
			numpto = ar_vig.numpto,
			codsolot = ar_vig.codsolot,
			codinssrv = ar_vig.codinssrv,
			distrito = ar_vig.distrito,
			areaope = ar_vig.areaope,
			flgcliente = ar_vig.flgcliente,
			fecinicio = ar_vig.fecinicio,
			feccom = ar_vig.feccom,
			dias_atraso = ar_vig.dias_atraso,
			estado = ar_vig.estado,
			observacion = ar_vig.observacion,
			tipsrv = ar_vig.tipsrv,
			tiptrs = ar_vig.tiptrs,
			estado_wf = ar_vig.estado_wf,
			pid = ar_vig.pid,
			feccompry = ar_vig.feccompry,
			fecapr = ar_vig.fecapr,
			tiptra = ar_vig.tiptra,
			codsegmark = ar_vig.codsegmark,
			sede = ar_vig.sede,
			punto = ar_vig.punto
		where id = ar_vig.id;

end;

/**********************************************************************
Inserta un registro log para el historico
**********************************************************************/
procedure p_insert_registro_log(ar_vig  in vigresumen%rowtype)
is
begin
	 insert into vigresumen_log (
 		id,fase, tipo, idetapa,
		numslc, numpto, codsolot, codinssrv,
		distrito, areaope, flgcliente, fecinicio,
		feccom, dias_atraso, estado, observacion,
		tipsrv, tiptrs, estado_wf, pid,
		feccompry, fecapr, tiptra, codsegmark
		) values (
		ar_vig.id,ar_vig.fase, ar_vig.tipo, ar_vig.idetapa,
		ar_vig.numslc, ar_vig.numpto, ar_vig.codsolot, ar_vig.codinssrv,
		ar_vig.distrito, ar_vig.areaope, ar_vig.flgcliente, ar_vig.fecinicio,
		ar_vig.feccom, ar_vig.dias_atraso, ar_vig.estado, ar_vig.observacion,
		ar_vig.tipsrv, ar_vig.tiptrs, ar_vig.estado_wf, ar_vig.pid,
		ar_vig.feccompry, ar_vig.fecapr, ar_vig.tiptra, ar_vig.codsegmark);
end;

/**********************************************************************
Identifica en que estado esta el proyecto, punto de inicio vtatabslcfac
**********************************************************************/
procedure p_fase_proyecto_gral
is

cursor c_preventa is
	(select b.numslc
	  from vtatabslcfac a,
   	  	   (select distinct numslc from vtadetptoenl where tipo_vta is not null) b
	  where a.numslc = b.numslc and
	  		a.flgestcom = 1 and
			tipo <> 5
	minus
	select numslc from vigresumen  where tipo = 1 and estado = 2)
	minus
	select b.numslc
	  from vtatabslcfac a,
   	  	   (select distinct numslc from vtadetptoenl where tipo_vta is not null) b,
		   vtatabpspcli_v c
	  where a.numslc = b.numslc and
	  		a.numslc = c.numslc and
			c.estpspcli not in ('00');

cursor c_venta is
	select b.numslc
	  from vtatabslcfac a,
   	  	   (select distinct numslc from vtadetptoenl where tipo_vta is not null) b,
		   vtatabpspcli_v c
	  where a.numslc = b.numslc and
	  		a.numslc = c.numslc and
			c.estpspcli not in ('00') and
			tipo <> 5
	minus
	select numslc from vigresumen  where tipo = 1 and estado = 2;

cursor c_operacion_cliente is
	select b.numslc, d.codsolot, d.estsol,e.punto
	   from vtatabslcfac a,
	   		(select distinct numslc from vtadetptoenl where tipo_vta is not null) b,
       		vtatabpspcli_v c,
			solot d,
	        solotpto e
	 where a.numslc = b.numslc
 	   and a.numslc = c.numslc
	   and a.numslc = d.numslc
	   and c.numpsp = d.numpsp
	   and c.idopc = d.idopc
	   and d.codsolot = e.codsolot
	   and c.estpspcli in ('02', '05')
	   and a.tipo <> 5
   	   and estsol not in (12,13)
	   and d.tiptra in (select tiptra from vigfasextrabajo)
	   and d.codsolot in (select codsolot from solot where estsol not in (12,13)
	   			 		  		   minus
						  select codsolot from vigresumen  where tipo = 2 and estado = 2);

cursor c_operacion_interno is
   select solot.numslc, solot.codsolot, estsol, punto
	  from solot,
	  	   solotpto,
		   tiptrabajo
   where solot.codsolot = solotpto.codsolot
   	   and solot.tiptra = tiptrabajo.tiptra
	   and tiptrabajo.tiptrs is not null
	   and estsol not in (12,13)
	   and numpsp is null
	   and solot.tiptra in (select tiptra from vigfasextrabajo)
	   and solot.codsolot in (select codsolot from solot where estsol not in (12,13)
	   			 		  		   minus
						  select codsolot from vigresumen  where tipo = 2 and estado = 2);

cursor c_operacion_cerrado is
   select solot.numslc, solot.codsolot, estsol, punto
	  from solot,
		   solotpto,
		   tiptrabajo
   where solot.codsolot = solotpto.codsolot
   	   and solot.tiptra = tiptrabajo.tiptra
	   and estsol in (12,13)
	   and tiptrabajo.tiptrs is not null
	   and solot.tiptra in (select tiptra from vigfasextrabajo)
	   and solot.codsolot in (select codsolot from solot where estsol in (12,13)
   	   			 		  		   minus
						   select codsolot from vigresumen  where tipo = 2 and estado = 2);

ar_vig  vigresumen%rowtype;
l_estsolfac vtatabslcfac.estsolfac%type;
l_flgestcom vtatabslcfac.flgestcom%type;
l_derivado vtatabslcfac.derivado%type;
l_estapr cxcpspchq.estapr%type;
l_estef ef.estef%type;
l_estar ar.estar%type;
l_rentable ar.rentable%type;
l_estpspcli vtatabpspcli.estpspcli%type;
l_codestado contrato.codestado%type;

begin
	for r_proy in c_preventa loop
		--Validar Solicitud de Estudio de Factibilidad.
		-----------------------------------------------------------------------------
		select estsolfac, flgestcom, derivado
			   into l_estsolfac, l_flgestcom, l_derivado
		   from vtatabslcfac a
		   where a.numslc = r_proy.numslc;

		if l_estsolfac = '00' then
		   --Pendiente por venta ****************************************************
		   p_fase_preventa(r_proy.numslc, 'Estado del Proyecto: Generado por Ejecutivo de Cuenta');
		elsif l_estsolfac in ('01', '03') then
		-- Validar el Analisis Crediticio.
		-----------------------------------------------------------------------------
			select estapr into l_estapr
			   from cxcpspchq
			   where numslc = r_proy.numslc;
		    if l_estapr = 'P' then
			   -- Pendiente por Creditos  *******************************************
	   		   p_fase_analisis_crediticio(r_proy.numslc,'Estado del Proyecto: Pendiente por Creditos');
			elsif l_estapr = 'R' then
		   		  --Pendiente por venta *********************************************
		   		  p_fase_preventa(r_proy.numslc,'Estado del Proyecto: Rechazado por Credito');
			elsif l_estapr = 'A' then
		-----------------------------------------------------------------------------
			  -- Validar el Estudio de Factibilidad.
			  if l_derivado = 1 then
			  	 --Analizamos el EF.
				 select estef into l_estef from ef where numslc = r_proy.numslc;
				 if l_estef = 1 or l_estef = 3 then
				 --Pendiente por Operaciones de EF ******************************
				  p_fase_ef(r_proy.numslc, 'Estado del Proyecto: Pendiente el Estudio de Factibilidaad');
				 elsif l_estef = 2  then
				 	--verificar si existe ar
					begin
						select estar, rentable into l_estar, l_rentable
						   from ar where codef = to_number(r_proy.numslc);
						exception
					   	when others then
							 l_estar := 0;
					end;
					if l_estar = 0 then
			      	   p_fase_oc(r_proy.numslc,'Estado del OC: Generado por Ejecutivo de Cuenta');
				 	elsif l_estar = 1 or l_estar = 2 or l_estar = 5 then
					   --Pendiente por Planeamiento Financiero ******************
				 	   p_fase_ar(r_proy.numslc, 'Estado del Proyecto: Pendiente Planeamiento Financiero');
					elsif l_estar = 3 or l_estar = 4 then
						if l_rentable = 1 then
						   p_fase_oc(r_proy.numslc, 'Estado de la OC: Pendiente la Aprobacion de Gerencia Comercial');
						else
						   p_fase_preventa(r_proy.numslc, 'Estado del Proyecto: Rechazado por Planeamiento Financiero');
						end if;
					end if;
				 elsif l_estef = 4 then
				 --Pendiente por Ventas *****************************************
				 p_fase_preventa(r_proy.numslc,'Estado del Proyecto: Rechazado por Operaciones');
				 elsif l_estef = 5 then
				 --Pendiente por Ventas *****************************************
				 p_fase_preventa(r_proy.numslc,'Estado del Proyecto: Pendiente en Ventas');
				 end if;
			  elsif l_derivado = 0 then
		  		 if l_estsolfac = '01' then
				 	p_fase_preventa(r_proy.numslc,'Estado del Proyecto: Pendiente la Aprobacion de Gerencia Comercial');
				 elsif l_estsolfac = '03' then
			 	    --Pendiente por provisionning **************************************
				    p_fase_efxprovisioning(r_proy.numslc, 'Estado del Proyecto: Pendiente de Derivar a Operaciones');
				 end if;
			  end if;
			end if;
		elsif l_estsolfac = '04' then
		  --Pendiente por Ventas *****************************************************
		   p_fase_preventa(r_proy.numslc,'Estado del Proyecto: Faltan Datos');
		elsif l_estsolfac = '02' then
		   p_fase_preventa_cerrada(r_proy.numslc,'Estado del Proyecto: Rechazado por Preventa');
		elsif l_estsolfac = '05' then
		   p_fase_preventa_cerrada(r_proy.numslc,'Estado del Proyecto: Rechazado por Limite de Tiempo');
		elsif l_estsolfac = '06' then
		   p_fase_preventa_cerrada(r_proy.numslc,'Estado del Proyecto: Rechazado por Gerencia Comercial');
		else
		   p_fase_preventa_cerrada(r_proy.numslc,'Estado del Proyecto: Rechazado por Gerencia Comercial');
		end if;
	end loop;

	for r_venta in c_venta loop
		--Validar la Oferta Comercial.
		-----------------------------------------------------------------------------
		select estpspcli into l_estpspcli from vtatabpspcli_v where numslc = r_venta.numslc;
		--Pendiente por Contratos **************************************************
		if l_estpspcli in ('01') then
		   p_fase_contrato(r_venta.numslc,'Estado de la OC: Pendiente la Aprobacion de Cliente');
		elsif l_estpspcli = '02' then
		   p_fase_oc_cerrada(r_venta.numslc,'Estado de la OC: Aprobado Cliente');
		elsif l_estpspcli = '03' then
		   p_fase_oc_cerrada(r_venta.numslc,'Estado de la OC: Rechazado por Gerencial Comercial');
		elsif l_estpspcli = '04' then
		   p_fase_oc_cerrada(r_venta.numslc,'Estado de la OC: Rechazado por Cliente');
		elsif l_estpspcli = '05' then
		   p_fase_oc_cerrada(r_venta.numslc,'Estado de la OC: Aprobado para pruebas');
		else
		   p_fase_oc_cerrada(r_venta.numslc,'Estado de la OC: Rechazado');
		end if;
	end loop;

	for r_operacion in c_operacion_cliente loop
	  --Validar por Operaciones **************************************************
	  p_fase_operacion_cliente(r_operacion.numslc,r_operacion.codsolot,r_operacion.punto,r_operacion.estsol);
	end loop;

	for r_operacion in c_operacion_interno loop
	  p_fase_operacion_interno(r_operacion.numslc,r_operacion.codsolot,r_operacion.punto,r_operacion.estsol);
	end loop;

	for r_operacion in c_operacion_cerrado loop
	  p_fase_operacion_cerrado(r_operacion.numslc,r_operacion.codsolot,r_operacion.punto,r_operacion.estsol);
	end loop;

	commit;

--	raise_application_error (-20500, 'Finalizo: ' || to_char(sysdate,'dd/mm/yyyy hh:mm') );
end;

/**********************************************************************
Almacena los cambios de etapas
**********************************************************************/
procedure p_fase_preventa(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
	select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	 		b.numslc numslc,
	   		b.numpto numpto,
	   		b.codinssrv codinssrv,
	   		b.ubipto distrito,
	   		decode(a.area,null,102,a.area) area, --Area responsable Ventas.
	   		trunc(a.fecestcom,'dd') fecini,
	   		a.tipsrv tipsrv,
			decode (b.tiptra, null,1, b.tiptra) tiptra,
			f.codsecmark,
			b.descpto sede,
			1 tipo,
			0 flgcliente,
			0 estado_wf,
			1 estado
	from vtatabslcfac a,
	   	 vtadetptoenl b,
		 vtatabpspcli_v e,
		 vtatabcli f
	where a.numslc = b.numslc and
		  a.codcli = f.codcli and
		  a.numslc = e.numslc(+) and
		  a.numslc = as_numslc;

ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 1; --Generacion del Proyecto.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop
	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 ar_vig.areaope 	:= r_vig.area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 ar_vig.fecinicio 	:= r_vig.fecini;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;

 		 p_insert_registro(ar_vig);
	 end loop;

end;

procedure p_fase_analisis_crediticio(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
	select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	 		b.numslc numslc,
	   		b.numpto numpto,
	   		b.codinssrv codinssrv,
	   		b.ubipto distrito,
	   		decode (a.area,null,102,a.area) area, --Area responsable Ventas.
	   		trunc(a.fecapr,'dd') fecini,
			(select trunc(max(fecusu), 'dd') from genhisest
				where genhisest.numslc = b.numslc and
		   		 genhisest.codtab = '00001' and
				 genest = '01') ult_fecini,
	   		a.tipsrv tipsrv,
			decode (b.tiptra, null,1, b.tiptra) tiptra,
			f.codsecmark,
			b.descpto sede,
			1 tipo,
			0 flgcliente,
			0 estado_wf,
			1 estado
	from vtatabslcfac a,
	   	 vtadetptoenl b,
		 vtatabpspcli e,
		 vtatabcli f
	where a.numslc = b.numslc and
		  a.codcli = f.codcli and
		  a.numslc = e.numslc(+) and
		  a.numslc = as_numslc;

ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 2; --Analisis Crediticios.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 ar_vig.areaope 	:= r_vig.area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;

 		 p_insert_registro(ar_vig);
	 end loop;
end;


procedure p_fase_preventa_cerrada(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
	select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	 		b.numslc numslc,
	   		b.numpto numpto,
	   		b.codinssrv codinssrv,
	   		b.ubipto distrito,
	   		decode (a.area,null,102,a.area) area, --Area responsable Ventas.
	   		trunc(a.fecapr,'dd') fecini,
			(select trunc(max(fecusu), 'dd') from genhisest
				where genhisest.numslc = b.numslc and
		   		 genhisest.codtab = '00001' and
		 		 oldest in ('00', '01', '04')) ult_fecini,
	   		a.tipsrv tipsrv,
			decode (b.tiptra, null,1, b.tiptra) tiptra,
			f.codsecmark,
			b.descpto sede,
			1 tipo,
			0 flgcliente,
			0 estado_wf,
			2 estado
	from vtatabslcfac a,
	   	 vtadetptoenl b,
		 vtatabpspcli_v e,
		 vtatabcli f
	where a.numslc = b.numslc and
		  a.codcli = f.codcli and
		  a.numslc = e.numslc(+) and
		  a.numslc = as_numslc;

ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 3; --Proyecto rechazado.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 ar_vig.areaope 	:= r_vig.area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;

 		 p_insert_registro(ar_vig);
	 end loop;

end;


procedure p_fase_efxprovisioning(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
	select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	 		b.numslc numslc,
	   		b.numpto numpto,
	   		b.codinssrv codinssrv,
	   		b.ubipto distrito,
	   		1 area, --Area responsable Provisioning.
	   		trunc(a.fecapr,'dd') fecini,
			(select trunc(max(fecusu), 'dd') from genhisest
				where genhisest.numslc = b.numslc and
		   		 genhisest.codtab = '00001' and
		 		 genest in ('01', '03')) ult_fecini,
	   		a.tipsrv tipsrv,
			decode (b.tiptra, null,1, b.tiptra) tiptra,
			f.codsecmark,
			b.descpto sede,
			1 tipo,
			0 flgcliente,
			0 estado_wf,
			1 estado
	from vtatabslcfac a,
	   	 vtadetptoenl b,
		 vtatabpspcli_v e,
		 vtatabcli f
	where a.numslc = b.numslc and
		  a.codcli = f.codcli and
		  a.numslc = e.numslc(+) and
		  a.numslc = as_numslc;


ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 4; --Generacion del EF

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 ar_vig.areaope 	:= r_vig.area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;

 		 p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_ef(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
	select a.codef,
	   PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	   lpad(b.codef,10,'0') numslc,
	   lpad(b.punto,5,'0') numpto,
	   b.codinssrv codinssrv,
	   b.codubi distrito,
	   trunc(a.fecusu,'dd') fecini,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (1,3)) ult_fecini,
   	   a.tipsrv tipsrv,
	   decode (b.tiptra, null,1, b.tiptra) tiptra,
	   c.codsecmark,
	   b.descripcion sede,
	   1 tipo,
	   0 flgcliente,
	   0 estado_wf,
	   1 estado,
	   a.fecapr fecapr,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (2)) ult_fecapr
   from ef a,
       efpto b,
	   vtatabcli c,
	   vtatabslcfac d,
	   vtatabpspcli_v e
   where a.codef = b.codef and
   		 a.codcli = c.codcli and
		 a.numslc = d.numslc and
		 d.numslc = e.numslc (+) and
		 a.numslc = as_numslc;


ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;
al_area areaope.area%type;

begin
	 al_etapa := 5; --Aprobacion del EF.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 --Calculo del area responsable.
		 begin
	 	  	  select area into al_area
		  		 from solefxarea
				 where esresponsable = 1 and
				 	   codef = r_vig.codef;
		      exception
			  when others then
			  	   al_area := 1;
		 end;
	 	 ar_vig.areaope := al_area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;
		 if r_vig.ult_fecapr is null or r_vig.fecapr >= r_vig.ult_fecapr then
		 	ar_vig.fecapr:= r_vig.fecapr;
		 else
		 	ar_vig.fecapr:= r_vig.ult_fecapr;
		 end if;

 		 p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_ar(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
select a.codef,
	   PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	   lpad(b.codef,10,'0') numslc,
	   lpad(b.punto,5,'0') numpto,
	   b.codinssrv codinssrv,
	   b.codubi distrito,
	   trunc(ar.fecusu,'dd') fecini,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = ar.docid and docestold in (5)) ult_fecini,
   	   a.tipsrv tipsrv,
	   decode (b.tiptra, null,1, b.tiptra) tiptra,
	   c.codsecmark,
	   b.descripcion sede,
	   1 tipo,
	   0 flgcliente,
	   0 estado_wf,
	   1 estado,
	   ar.fecapr fecapr,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = ar.docid and docest in (3,4)) ult_fecapr
   from ar,
   		ef a,
   		efpto b,
	   vtatabcli c,
	   vtatabslcfac d,
	   vtatabpspcli_v e
   where ar.codef = a.codef and
   		 a.codef = b.codef and
   		 a.codcli = c.codcli and
		 a.numslc = d.numslc and
		 d.numslc = e.numslc (+) and
		 a.numslc = as_numslc;


ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 6; --Finalizar Analisis de Rentabilidad;

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
------------------------------------------------------------------
		 ar_vig.areaope := 101; --areaope a definir r_vig.area;
------------------------------------------------------------------
		 ar_vig.flgcliente 	:= r_vig.flgcliente;
		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;
		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;
		 if r_vig.ult_fecapr is null or r_vig.fecapr >= r_vig.ult_fecapr then
		 	ar_vig.fecapr:= r_vig.fecapr;
		 else
		 	ar_vig.fecapr:= r_vig.ult_fecapr;
		 end if;

  		 p_insert_registro(ar_vig);

	 end loop;
end;

procedure p_fase_oc(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
  select a.codef,
	   PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	   lpad(b.codef,10,'0') numslc,
	   lpad(b.punto,5,'0') numpto,
	   b.codinssrv codinssrv,
	   b.codubi distrito,
	   trunc(ar.fecapr,'dd') fecha_ar,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (3,4)) ult_fecha_ar,
	   trunc(a.fecapr,'dd') fecha_ef,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (2)) ult_fecha_ef,
   	   a.tipsrv tipsrv,
	   decode (b.tiptra, null,1, b.tiptra) tiptra,
	   c.codsecmark,
	   b.descripcion sede,
	   1 tipo,
	   0 flgcliente,
	   0 estado_wf,
	   1 estado,
	   e.fecapr fecapr
   from ar,
   		ef a,
   		efpto b,
	   vtatabcli c,
	   vtatabslcfac d,
	   vtatabpspcli_v e
   where a.codef = ar.codef (+) and
   		 a.codef = b.codef and
   		 a.codcli = c.codcli and
		 a.numslc = d.numslc and
		 d.numslc = e.numslc (+) and
		 a.numslc = as_numslc;

ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;
ad_fecha  vigresumen.fecapr%type;
ad_fecha_ar  vigresumen.fecapr%type;
ad_fecha_ef  vigresumen.fecapr%type;

begin
	 al_etapa := 7; --Aprobacion de la Oferta Comercial.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
------------------------------------------------------------------
		 ar_vig.areaope 	:= 102; --areaope a definir r_vig.area;
------------------------------------------------------------------
		 ar_vig.flgcliente 	:= r_vig.flgcliente;

		 if r_vig.ult_fecha_ar is null or r_vig.fecha_ar >= r_vig.ult_fecha_ar then
		 	ad_fecha_ar		:= r_vig.fecha_ar;
		 else
		 	ad_fecha_ar		:= r_vig.ult_fecha_ar;
		 end if;
		 if r_vig.ult_fecha_ef is null or r_vig.fecha_ef >= r_vig.ult_fecha_ef then
		 	ad_fecha_ef		:= r_vig.fecha_ef;
		 else
		 	ad_fecha_ef		:= r_vig.ult_fecha_ef;
		 end if;
		 if ad_fecha_ar >= ad_fecha_ef then
		 	ar_vig.fecinicio:= ad_fecha_ar;
		 else
		 	ar_vig.fecinicio:= ad_fecha_ef;
		 end if;

		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;
		 ar_vig.fecapr		:= r_vig.fecapr;

 		 p_insert_registro(ar_vig);

	 end loop;
end;

procedure p_fase_oc_cerrada(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
  select a.codef,
	   PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	   lpad(b.codef,10,'0') numslc,
	   lpad(b.punto,5,'0') numpto,
	   b.codinssrv codinssrv,
	   b.codubi distrito,
	   trunc(ar.fecapr,'dd') fecha_ar,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (3,4)) ult_fecha_ar,
	   trunc(a.fecapr,'dd') fecha_ef,
	   (select trunc(max(fecha),'dd') from docesthis
   		   where docid = a.docid and docest in (2)) ult_fecha_ef,
   	   a.tipsrv tipsrv,
	   decode (b.tiptra, null,1, b.tiptra) tiptra,
	   c.codsecmark,
	   b.descripcion sede,
	   1 tipo,
	   0 flgcliente,
	   0 estado_wf,
	   2 estado,
	   e.fecapr fecapr
  from ar,
  		ef a,
   		efpto b,
	   vtatabcli c,
	   vtatabslcfac d,
	   vtatabpspcli_v e
   where a.codef = ar.codef (+) and
   		 a.codef = b.codef and
   		 a.codcli = c.codcli and
		 a.numslc = d.numslc and
		 d.numslc = e.numslc (+) and
		 a.numslc = as_numslc;

ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;
ad_fecha  vigresumen.fecapr%type;
ad_fecha_ar  vigresumen.fecapr%type;
ad_fecha_ef  vigresumen.fecapr%type;

begin
	 al_etapa := 9; --Proyecto Cerrado.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
------------------------------------------------------------------
		 ar_vig.areaope 	:= 102; --areaope a definir r_vig.area;
------------------------------------------------------------------

		 ar_vig.flgcliente 	:= r_vig.flgcliente;

		 if r_vig.ult_fecha_ar is null or r_vig.fecha_ar >= r_vig.ult_fecha_ar then
		 	ad_fecha_ar		:= r_vig.fecha_ar;
		 else
		 	ad_fecha_ar		:= r_vig.ult_fecha_ar;
		 end if;
		 if r_vig.ult_fecha_ef is null or r_vig.fecha_ef >= r_vig.ult_fecha_ef then
		 	ad_fecha_ef		:= r_vig.fecha_ef;
		 else
		 	ad_fecha_ef		:= r_vig.ult_fecha_ef;
		 end if;
		 if ad_fecha_ar >= ad_fecha_ef then
		 	ar_vig.fecinicio:= ad_fecha_ar;
		 else
		 	ar_vig.fecinicio:= ad_fecha_ef;
		 end if;

	 	 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;
		 ar_vig.fecapr		:= r_vig.fecapr;

 		 p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_contrato(
	as_numslc in vtatabslcfac.numslc%type, as_obs in vigresumen.observacion%type
)
is
cursor c_vig is
		select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
	 		b.numslc numslc,
	   		b.numpto numpto,
	   		b.codinssrv codinssrv,
	   		b.ubipto distrito,
	   		101 area, --Area responsable Ventas.
	   		trunc(e.fecusu,'dd') fecini,
			(select trunc(max(fecusu), 'dd') from genhisest
				where genhisest.numslc = b.numslc and
		   		 genhisest.codtab = '00013' and
		 		 genest in ('01')) ult_fecini,
	   		a.tipsrv tipsrv,
			decode (b.tiptra, null,1, b.tiptra) tiptra,
			f.codsecmark,
			b.descpto sede,
			1 tipo,
			0 flgcliente,
			0 estado_wf,
			1 estado,
			(select trunc(max(fecusu), 'dd') from genhisest
				where genhisest.numslc = b.numslc and
		   		 genhisest.codtab = '00013' and
		 		 genest in ('02')) fecapr
	from vtatabslcfac a,
	   	 vtadetptoenl b,
		 vtatabpspcli_v e,
		 vtatabcli f
	where a.numslc = b.numslc and
		  a.codcli = f.codcli and
		  a.numslc = e.numslc(+) and
		  a.numslc = as_numslc;


ar_vig  vigresumen%rowtype;
al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;

begin
	 al_etapa := 8; --Aprobacion del Cliente.

	 select duracion into al_duracion from vigetapa where idetapa = al_etapa;

	 for r_vig in c_vig loop

	 	 ar_vig.fase 		:= r_vig.fase;
		 ar_vig.idetapa 	:= al_etapa;
		 ar_vig.tipo 		:= r_vig.tipo;
		 ar_vig.numslc 		:= r_vig.numslc;
		 ar_vig.numpto 		:= r_vig.numpto;
		 ar_vig.codinssrv	:= r_vig.codinssrv;
		 ar_vig.distrito 	:= r_vig.distrito;
		 ar_vig.areaope 	:= r_vig.area; --areaope a definir r_vig.area;
		 ar_vig.flgcliente 	:= r_vig.flgcliente;

		 if r_vig.ult_fecini is null or r_vig.fecini >= r_vig.ult_fecini then
		 	ar_vig.fecinicio:= r_vig.fecini;
		 else
		 	ar_vig.fecinicio:= r_vig.ult_fecini;
		 end if;

		 ar_vig.feccom 		:= ar_vig.fecinicio + al_duracion;
		 ar_vig.dias_atraso := trunc(sysdate,'dd') - trunc(ar_vig.feccom);
		 ar_vig.tipsrv 		:= r_vig.tipsrv;
		 ar_vig.tiptra 		:= r_vig.tiptra;
		 ar_vig.estado_wf 	:= r_vig.estado_wf;
		 ar_vig.codsegmark 	:= r_vig.codsecmark;
 		 ar_vig.observacion := as_obs;
		 ar_vig.sede 		:= r_vig.sede;
		 ar_vig.estado 		:= r_vig.estado;
		 ar_vig.fecapr		:= r_vig.fecapr;

 		 p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_operacion_etapa(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type,
	ar_vig out vigresumen%rowtype)
is

al_duracion vigetapa.duracion%type;
al_etapa vigetapa.idetapa%type;
al_fecinicio solotchgest.fecha%type;
al_estado_wf vigresumen.estado_wf%type;
as_estado estsol.descripcion%type;

begin
	 --Calculo de la ultima fecha de cambio de estado.
	 select decode(max(fecha),null,max(fecha),solot.fecusu) into al_fecinicio
 		from solotchgest, solot
		where solotchgest.codsolot (+) = solot.codsolot and
   			  solot.codsolot = as_codsolot
		group by solot.fecusu;

	 select descripcion into as_estado from estsol where estsol = as_estsol;

	 --Evaluas el estado de la solot.

	 ------------------------ TIPO GENERADO -------------------------------------------------
	 if as_estsol = 10 then
	 	al_etapa := 10; --Operacion - Generado.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;
	 	select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   al_fecinicio + al_duracion,
			   sysdate - (al_fecinicio + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;
	 ------------------------ TIPO GENERADO -------------------------------------------------
	 elsif as_estsol = 15 then
	 	al_etapa := 11; --Operacion - Rechazado.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   al_fecinicio + al_duracion,
			   sysdate - (al_fecinicio + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;
	 ------------------------ TIPO APROBADO -------------------------------------------------
	 elsif as_estsol = 11 then
	 	al_etapa := 12; --Operacion - Aprobada.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select fecapr,
			   tiptrs,
			   fecapr + al_duracion,
			   sysdate - (fecapr + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;


	 ------------------------ TIPO SUSPENDIDO -------------------------------------------------
	 elsif as_estsol = 14 then
	 	al_etapa := 13; --Operacion - Suspendida-Pendiente de Pago.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 1;
		ar_vig.areaope := 102;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   feccom,
			   sysdate - (al_fecinicio + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 ------------------------ TIPO SUSPENDIDO -------------------------------------------------
	 elsif as_estsol in (18,21) then
	 	al_etapa := 14; --Operacion - Suspendida-En Revision.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   feccom,
			   sysdate - (al_fecinicio + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 ------------------------ TIPO SUSPENDIDO -------------------------------------------------
	 elsif as_estsol = 19 then
	 	al_etapa := 15; --Operacion - Suspendida-Postergado por el Cliente.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 1;
		ar_vig.areaope := 1;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   feccom,
			   sysdate - (al_fecinicio + al_duracion)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 ------------------------ TIPO EN EJECUCION -----------------------------------------------
	 elsif as_estsol in (17,27,28) then
	 	al_etapa := 16; --Operacion - En Ejecucion - En Ejecucion
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   decode(feccom,null,al_fecinicio + 30,feccom),
			   sysdate - decode(feccom,null,al_fecinicio+30,feccom)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 ------------------------ TIPO EN EJECUCION -----------------------------------------------
	 elsif as_estsol in (29) then
	 	al_etapa := 17; --Operacion - En Ejecucion - Atendida
		ar_vig.observacion := 'Estado de la Solicitud OT: Pendiente en Contratos';
		ar_vig.estado := 1;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 101;

		select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   decode(feccom,null,al_fecinicio,feccom),
			   sysdate - decode(feccom,null,al_fecinicio,feccom)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 ------------------------ TIPO EJECUTADO -------------------------------------------------
	 elsif as_estsol in (12,13) then
	 	al_etapa := 18; --Operacion - Cerrado.
		ar_vig.observacion := 'Estado de la Solicitud OT: '|| as_estado;
		ar_vig.estado := 2;
		ar_vig.flgcliente := 0;
		ar_vig.areaope := 1;

	 	select duracion into al_duracion from vigetapa where idetapa = al_etapa;

		select al_fecinicio,
			   tiptrs,
			   feccom,
			   sysdate - decode(feccom,null,al_fecinicio,feccom)
		   into ar_vig.fecinicio,
				ar_vig.tiptrs,
				ar_vig.feccom,
				ar_vig.dias_atraso
			from solot, tiptrabajo
			where solot.tiptra = tiptrabajo.tiptra(+) and
				  codsolot = as_codsolot;

	 end if;

	 --Calculo del estado del WF.
	 select decode(nvl(count(*),0),0,1,1,2) into al_estado_wf
 		from wf
		where wf.codsolot = as_codsolot and
			  wf.valido = 1;

	 ar_vig.estado_wf := al_estado_wf;
	 --Fin del calculo.

	 ar_vig.idetapa := al_etapa;

end;

procedure p_fase_operacion_cliente(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type,
	as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
)
is
cursor c_vig is
	select PQ_CONSOLIDADO_VENTAS.F_GET_TIPOVENTA(a.numslc) fase,
		   2 tipo,
		   a.numslc numslc,
		   c.numpto numpto,
		   a.codsolot,
		   b.punto,
		   b.codinssrv codinssrv,
		   c.pid pid,
		   b.codubi distrito,
		   a.tipsrv tipsrv,
		   decode (a.tiptra, null,1, a.tiptra) tiptra,
		   a.feccom feccompry,
		   e.fecapr fecapr,
		   d.codsecmark,
		   b.descripcion sede
	from solot a,
		 solotpto b,
		 insprd c,
		 vtatabcli d,
		 vtatabslcfac e
	where a.codsolot = b.codsolot and
		  b.pid = c.pid (+) and
		  a.codcli = d.codcli and
		  a.numslc = e.numslc (+)and
		  b.codsolot = as_codsolot and
		  b.punto = as_punto;

ar_vig  vigresumen%rowtype;
al_fecinicio solotchgest.fecha%type;
al_flgbil trssolot.flgbil%type;

begin

	 p_fase_operacion_etapa(as_numslc, as_codsolot, as_punto, as_estsol, ar_vig);

	 for r_vig in c_vig loop
	 	 if ar_vig.idetapa = 17 then
		 	 begin
				select distinct flgbil, feceje into al_flgbil, ar_vig.fecinicio
				   from trssolot
				   where codsolot = r_vig.codsolot and
				   		 punto = r_vig.punto and
						 pid = r_vig.pid;

				exception
				   	when others then
					al_flgbil := 0;
					ar_vig.fecinicio := al_fecinicio;
			end;

			if al_flgbil not in (0,1) then
			   ar_vig.estado := 2;
			   ar_vig.estado_wf := 2;
			   ar_vig.observacion := 'Estado de la Solicitud OT: Cerrado en Contratos ';
			end if;
		end if;
		ar_vig.fase := r_vig.fase;
		ar_vig.tipo := 2; --Servicio.
		ar_vig.numslc := r_vig.numslc;
		ar_vig.numpto := r_vig.numpto;
		ar_vig.codsolot := r_vig.codsolot;
		ar_vig.codinssrv := r_vig.codinssrv;
		ar_vig.pid := r_vig.pid;
		ar_vig.distrito := r_vig.distrito;
		if ar_vig.dias_atraso < 0 then
		   ar_vig.dias_atraso := 0;
		end if;
		ar_vig.tipsrv := r_vig.tipsrv;
		ar_vig.tiptra := r_vig.tiptra;
		ar_vig.feccompry := r_vig.feccompry;
		ar_vig.fecapr := r_vig.fecapr;
		ar_vig.codsegmark := r_vig.codsecmark;
		ar_vig.sede := r_vig.sede;
		ar_vig.punto := r_vig.punto;
 		p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_operacion_interno(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type, as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
)
is
cursor c_vig is
	select (select fase from vigfasextrabajo vig where vig.tiptra = a.tiptra) fase,
		   2 tipo,
		   a.numslc numslc,
		   c.numpto numpto,
		   a.codsolot,
		   b.punto,
		   b.codinssrv codinssrv,
		   c.pid pid,
		   b.codubi distrito,
		   a.tipsrv tipsrv,
		   decode (a.tiptra, null,1, a.tiptra) tiptra,
		   a.feccom feccompry,
		   e.fecapr fecapr,
		   d.codsecmark,
		   b.descripcion sede
	from solot a,
		 solotpto b,
		 insprd c,
		 vtatabcli d,
		 vtatabslcfac e
	where a.codsolot = b.codsolot and
		  b.pid = c.pid (+) and
		  a.codcli = d.codcli and
		  a.numslc = e.numslc (+)and
		  b.codsolot = as_codsolot and
		  b.punto = as_punto;

ar_vig  vigresumen%rowtype;
al_fecinicio solotchgest.fecha%type;
al_flgbil trssolot.flgbil%type;
al_contador number;

begin
	 p_fase_operacion_etapa(as_numslc, as_codsolot, as_punto, as_estsol, ar_vig);

	 for r_vig in c_vig loop
	 	 if ar_vig.idetapa = 17 then
		 	 select nvl(count(*),0) into al_contador
		 		from trssolot
				where codsolot = r_vig.codsolot and
					  punto = r_vig.punto and
					  pid = r_vig.pid;
			 if al_contador > 0 then
			 	begin
					select distinct flgbil, feceje into al_flgbil, ar_vig.fecinicio
					   from trssolot
					   where codsolot = r_vig.codsolot and
					   		 punto = r_vig.punto and
							 pid = r_vig.pid;

					exception
					   	when others then
						al_flgbil := 0;
						ar_vig.fecinicio := al_fecinicio;
		 		end;
				if al_flgbil not in (0,1) then
				   ar_vig.estado := 2;
				   ar_vig.estado_wf := 2;
				   ar_vig.observacion := 'Estado de la Solicitud OT: Cerrado en Contratos';
				   ar_vig.areaope := 101;
				end if;
			 else
		 	 	 select nvl(count(*),0) into al_contador
	 		 		from trssolot
					where codsolot = r_vig.codsolot and
						  punto = r_vig.punto and
					  	  codinssrv = r_vig.codinssrv;
				 if al_contador > 0 then
				 	begin
						select min(flgbil), min(feceje) into al_flgbil, ar_vig.fecinicio
						   from trssolot
						   where codsolot = r_vig.codsolot and
						   		 punto = r_vig.punto and
								 codinssrv = r_vig.codinssrv;

						exception
						   	when others then
							al_flgbil := 0;
							ar_vig.fecinicio := al_fecinicio;
			 		end;
					if al_flgbil not in (0,1) then
					   ar_vig.estado := 2;
					   ar_vig.estado_wf := 2;
					   ar_vig.observacion := 'Estado de la Solicitud OT: Cerrado en Contratos';
					   ar_vig.areaope := 101;
					end if;
				 else
				  	 ar_vig.observacion := 'Estado de la Solicitud OT: Fase Administrativa - Atendida';
				 	 ar_vig.areaope := 1;
				end if;
			 end if;
		end if;
		ar_vig.fase := r_vig.fase;
		ar_vig.tipo := 2; --Servicio.
		ar_vig.numslc := r_vig.numslc;
		ar_vig.numpto := r_vig.numpto;
		ar_vig.codsolot := r_vig.codsolot;
		ar_vig.codinssrv := r_vig.codinssrv;
		ar_vig.pid := r_vig.pid;
		ar_vig.distrito := r_vig.distrito;
		if ar_vig.dias_atraso < 0 then
		   ar_vig.dias_atraso := 0;
		end if;
		ar_vig.tipsrv := r_vig.tipsrv;
		ar_vig.tiptra := r_vig.tiptra;
		ar_vig.feccompry := r_vig.feccompry;
		ar_vig.fecapr := r_vig.fecapr;
		ar_vig.codsegmark := r_vig.codsecmark;
		ar_vig.sede := r_vig.sede;
		ar_vig.punto := r_vig.punto;
 		p_insert_registro(ar_vig);
	 end loop;
end;

procedure p_fase_operacion_cerrado(
	as_numslc in vtatabslcfac.numslc%type, as_codsolot in solot.codsolot%type, as_punto in solotpto.punto%type, as_estsol in solot.estsol%type
)
is
cursor c_vig is
	select (select fase from vigfasextrabajo vig where vig.tiptra = a.tiptra) fase,
		   2 tipo,
		   a.numslc numslc,
		   c.numpto numpto,
		   a.codsolot,
		   b.punto,
		   b.codinssrv codinssrv,
		   c.pid pid,
		   b.codubi distrito,
		   a.tipsrv tipsrv,
		   decode (a.tiptra, null,1, a.tiptra) tiptra,
		   a.feccom feccompry,
		   e.fecapr fecapr,
		   d.codsecmark,
		   b.descripcion sede
	from solot a,
		 solotpto b,
		 insprd c,
		 vtatabcli d,
		 vtatabslcfac e
	where a.codsolot = b.codsolot and
		  b.pid = c.pid (+) and
		  a.codcli = d.codcli and
		  a.numslc = e.numslc (+) and
		  b.codsolot = as_codsolot and
		  b.punto = as_punto;

ar_vig  vigresumen%rowtype;
al_fecinicio solotchgest.fecha%type;
al_flgbil trssolot.flgbil%type;
al_contador number;

begin
	 p_fase_operacion_etapa(as_numslc, as_codsolot, as_punto, as_estsol, ar_vig);

	 for r_vig in c_vig loop
	 	ar_vig.fase := r_vig.fase;
		ar_vig.tipo := 2; --Servicio.
		ar_vig.numslc := r_vig.numslc;
		ar_vig.numpto := r_vig.numpto;
		ar_vig.codsolot := r_vig.codsolot;
		ar_vig.codinssrv := r_vig.codinssrv;
		ar_vig.pid := r_vig.pid;
		ar_vig.distrito := r_vig.distrito;
		if ar_vig.dias_atraso < 0 then
		   ar_vig.dias_atraso := 0;
		end if;
		ar_vig.tipsrv := r_vig.tipsrv;
		ar_vig.tiptra := r_vig.tiptra;
		ar_vig.feccompry := r_vig.feccompry;
		ar_vig.fecapr := r_vig.fecapr;
		ar_vig.codsegmark := r_vig.codsecmark;
		ar_vig.sede := r_vig.sede;
		ar_vig.punto := r_vig.punto;
		ar_vig.estado_wf := 2;
 		p_insert_registro(ar_vig);
	 end loop;
end;

END PQ_VIGILANTE;
/


