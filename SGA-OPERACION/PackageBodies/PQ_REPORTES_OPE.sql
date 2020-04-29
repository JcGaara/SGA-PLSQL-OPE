CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_REPORTES_OPE AS

/*********************************************************************************************************************/
-- Funcion que obtiene la observacion de EF de PEX--
/*********************************************************************************************************************/
function f_get_obs_pex_ef(a_codsolot in number) return varchar2 is
tmpvar solefxarea.observacion%type;
begin
   select solefxarea.observacion into tmpvar
   	  from solefxarea, solot
	  where solot.codsolot = a_codsolot and
           solefxarea.numslc = solot.numslc and
		   solefxarea.area = 10;
   return tmpvar;
   exception
     when others then
       return null;
end;


/*********************************************************************************************************************/
-- Funcion que obtiene la observacion de EF --
/*********************************************************************************************************************/
function f_get_obs_ef(a_codsolot in number) return varchar2 is
tmpvar ef.observacion%type;
begin
   select ef.observacion into tmpvar
   	  from ef, solot where
           solot.codsolot = a_codsolot and
           ef.numslc = solot.numslc;
   return tmpvar;
   exception
     when others then
       return null;
end;

/*********************************************************************************************************************/
-- Funcion que obtine la etapa del EF
/*********************************************************************************************************************/
function f_get_etapa_pex_ef (a_codsolot in number, a_punto in number ) return varchar2 is
tmpvar etapa.descripcion%type;
l_codef number;
begin

select ef.codef into l_codef
	from solot, ef
	where solot.codsolot = a_codsolot and
          ef.numslc = solot.numslc;

select b.descripcion into tmpvar
	from efpto e, efptoeta a, etapa b
	where e.codef = l_codef and
		  e.codef = a.codef and
		  e.codinssrv = a_punto and
		  a.punto = e.punto and
		  a.codeta = b.codeta and
		  rownum = 1;

return tmpvar;

   exception
     when others then
       return null;
end;

/*********************************************************************************************************************/
-- Funcion que obtine la fecha e contrato de la tabla vtatabpspcli --
/*********************************************************************************************************************/
function f_get_fecha_contrato(a_numslc in char) return date is
tmpvar date;
begin
   select vtatabpspcli.fecace into tmpvar
   from vtatabpspcli,
   (select max(c.numpsp) numpsp, max(c.idopc) idopc
   from vtatabpspcli c where c.numslc = a_numslc group by c.numpsp) b
   where vtatabpspcli.numslc = a_numslc and
   vtatabpspcli.numpsp  = b.numpsp and
   vtatabpspcli.idopc  = b.idopc;

   return tmpvar;

   exception
     when others then
       return null;
end;

/*********************************************************************************************************************/
-- Funcion que obtine la observacion de Planta Externa en su OT --
/*********************************************************************************************************************/
function f_get_observa_ot_pex (a_codsolot in number) return varchar2 is
tmpVar varchar2(4000);

begin

  tmpvar :='';

  select ot.observacion into tmpvar
	 from ot
	   where ot.area = 10 and
	   		 ot.codsolot = a_codsolot;

  return tmpvar;

end;


/*********************************************************************************************************************/
-- Funcion que obtine la observacion de Planta Externa en su OT --
/*********************************************************************************************************************/
function f_get_feccom_ot(a_codsolot in number, a_area in number) return date is
tmpvar date;
begin
	select max(ot.feccom) into tmpvar
		from ot
	   	where ot.area = a_area and
	   		  ot.codsolot = a_codsolot;

	return tmpvar;

	exception
     when others then
       return null;

end;

/*********************************************************************************************************************/
-- Funcion que la fecha de servicio del punto--
/*********************************************************************************************************************/
function f_get_fecha_servicio( a_codsolot in number, a_punto in number) RETURN date IS

ls_fecha solotpto.fecfin%type;

   begin
      select fecinisrv into ls_fecha
	  	from solotpto
		where solotpto.codsolot = a_codsolot and
			  solotpto.punto = a_punto;

	  return ls_fecha;

      exception
	        when others then
     		return null;

   end;

/*********************************************************************************************************************/
-- Funcion que obtiene la fecha de planta interna de un punto--
/*********************************************************************************************************************/
function F_GET_FECHA_PIN( a_codsolot in number, a_punto in number) RETURN date IS
ls_fecha solotpto.fecfin%type;
ln_codsolot solot.codsolot%type;
ln_fecha number;

BEGIN
 	begin
		select fecfin into ls_fecha
	  	from tareawf, wf
		where tareawf.idwf = wf.idwf and
	   	tareadef in (82,372) and
		wf.codsolot = a_codsolot and
		estwf <> 5 and  rownum = 1;
	    exception
		    when others then
	     		 null;
	end;
	if ls_fecha is null then
	   begin
      	  select fecfin into ls_fecha
	  		from solotpto
			where solotpto.codsolot = a_codsolot and
				  solotpto.punto = a_punto;
		  exception
	        when others then
     			 null;
	   end;
	end if;
    return ls_fecha;

    exception
	when others then
    	 return null;

END;

END;
/


