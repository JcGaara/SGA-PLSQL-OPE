CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_REPORTES_OT AS

/*  Funciones que faltan implementar */
function f_get_fecfin_PI(a_codot in number, a_punto in number) return date is
tmpvar date;
begin
   select fecfin into tmpvar from otptoeta where codot = a_codot and punto = a_punto and codeta = 5;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_fecha_Asig_ot(a_codot in number, a_punto in number,a_etapa in number) return date is
tmpvar date;
begin
   select fecini into tmpvar from otptoetainf where codot = a_codot and
          punto = a_punto and codeta = a_etapa and tipinfot = 104;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_fecha_Asig_ot_de_PI(a_codot in number, a_punto in number) return date is
begin
   return f_get_fecha_Asig_ot(a_codot,a_punto,5);
end;

function f_get_fecha_Asig_ot_de_Com(a_codot in number, a_punto in number) return date is
begin
   return f_get_fecha_Asig_ot(a_codot,a_punto,1);
end;

function f_get_ult_post(a_codot in number, a_punto in number,a_etapa in number) return varchar2 is
tmpvar tipinfot.descripcion%type;
begin
   select b.descripcion into tmpvar from otptoetainf a, tipinfot b
   where a.tipinfot = b.tipinfot and b.grupo = 'PO' and a.codot = a_codot and
          a.punto = a_punto and a.codeta = a_etapa and a.fecfin is null and
		  a.fecini = (select max(fecini) from  otptoetainf c, tipinfot d
                         where c.codot = a_codot and c.punto = a_punto and c.codeta = a_etapa and
						 c.tipinfot = d.tipinfot and d.grupo = 'PO' and c.fecfin is null );

   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_ult_post_de_PI(a_codot in number, a_punto in number) return varchar2 is
begin
	 return f_get_ult_post(a_codot, a_punto,5);
end;

function f_get_ult_post_de_Com(a_codot in number, a_punto in number) return varchar2 is
begin
	 return f_get_ult_post(a_codot, a_punto,1);
end;

function f_get_fecha_cul_PE(a_codot in number, a_punto in number) return date is
tmpvar date;
begin

   select fecini into tmpvar from otptoetainf where codot = a_codot and
          punto = a_punto and codeta = 1 and tipinfot = 8;
   return tmpvar;
   exception
     when others then
       return null;

end;

function f_get_fecha_inst_equ_PI(a_codot in number, a_punto in number) return date is
tmpvar date;
begin
   select fecfin into tmpvar from otptoetaact where codot = a_codot and
          punto = a_punto and codeta = 5 and codact = 1013;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_fecha_UM_PI(a_codot in number, a_punto in number) return date is
tmpvar date;
begin
   select fecfin into tmpvar from otptoetaact where codot = a_codot and
          punto = a_punto and codeta = 5 and codact = 1014;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_fecha_contrato(a_proyecto in char) return date is
tmpvar date;
begin
   select vtatabpspcli.fecace into tmpvar
   from vtatabpspcli,
   (select max(c.numpsp) numpsp, max(c.idopc) idopc
   from vtatabpspcli c where c.numslc = a_proyecto group by c.numpsp) b
   where vtatabpspcli.numslc = a_proyecto and
   vtatabpspcli.numpsp  = b.numpsp and
   vtatabpspcli.idopc  = b.idopc;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_fecha_ejecucion_ot(a_codot in number) return date is
tmpvar date;
begin

   select max(b.fecha) into tmpvar from ot a, docesthis b where a.docid = b.docid
   and a.codot = a_codot and docest = 3;

   return tmpvar;

   exception
     when others then
       return null;
end;


function f_get_fecinisrv(a_codot in number, a_punto in number) return date is
tmpvar date;
begin

   select trssolot.fectrs into tmpvar from ot, trssolot where ot.codsolot = trssolot.codsolot and ot.codot = a_codot and trssolot.codinssrv = a_punto;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_costo_ot_sin_permiso(a_codot in number) return number is
tmpvar number;
begin
   select nvl(sum(a.COSto * a.cantidad),0) into tmpvar
    FROM otptoetaact a, actividad b
   WHERE a.codact = b.codact and b.espermiso = 0 and a.codot = a_codot;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_costo_ot_con_permiso(a_codot in number) return number is
tmpvar number;
begin
   select nvl(sum(a.COSto * a.cantidad),0) into tmpvar
    FROM otptoetaact a, actividad b
   WHERE a.codact = b.codact and b.espermiso = 1 and a.codot = a_codot;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_costo_ot_con_permiso_m(a_codot in number, a_moneda in char) return number is
tmpvar number;
begin
   select nvl(sum(a.COSto * a.cantidad),0) into tmpvar
    FROM otptoetaact a, actividad b
   WHERE a.codact = b.codact and b.espermiso = 1 and a.codot = a_codot AND A.MONEDA = a_moneda;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_costo_ot_SIN_permiso_m(a_codot in number, a_moneda in char) return number is
tmpvar number;
begin
   select nvl(sum(a.COSto * a.cantidad),0) into tmpvar
    FROM otptoetaact a, actividad b
   WHERE a.codact = b.codact and b.espermiso = 0 and a.codot = a_codot AND A.MONEDA = a_moneda;

   return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_contratista_etapa(a_codot in number, a_punto in number, a_etapa in number) return varchar2 is
tmpvar contrata.nombre%type;
begin

select b.nombre into tmpvar from otptoetacon a, contrata b
where a.codot = a_codot and a.punto = a_punto and a.codeta = a_etapa and a.codcon = b.codcon
and rownum = 1;

return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_num_postes(a_codot in number, a_punto in number, a_act in number) return number is
tmpvar number;
begin
   select cantidad into tmpvar from otptoetaact where codot = a_codot and
          punto = a_punto and codeta = 4 and codact = a_act and rownum =1;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_obs_pex_ef(a_codot in number) return varchar2 is
tmpvar solefxarea.observacion%type;
begin
   select solefxarea.observacion into tmpvar from solefxarea, solot, ot where ot.codot = a_codot and
          solot.codsolot = ot.codsolot and
          solefxarea.numslc = solot.numslc and solefxarea.coddpt = '0031' ;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_obs_ef(a_codot in number) return varchar2 is
tmpvar ef.observacion%type;
begin
   select ef.observacion into tmpvar from ef, solot, ot where ot.codot = a_codot and
          solot.codsolot = ot.codsolot and
          ef.numslc = solot.numslc;
   return tmpvar;
   exception
     when others then
       return null;
end;

function f_get_etapa_pex_ef (a_codot in number, a_punto in number ) return varchar2 is
tmpvar etapa.descripcion%type;
l_codef number;
begin

select ef.codef into l_codef from ot, solot, ef where
          ot.codot = a_codot and
          solot.codsolot = ot.codsolot and
          ef.numslc = solot.numslc ;

select b.descripcion into tmpvar from efpto e, efptoeta a, etapa b
where e.codef = l_codef and e.codef = a.codef and e.codinssrv = a_punto and a.punto = e.punto and a.codeta = b.codeta and rownum = 1;

return tmpvar;

   exception
     when others then
       return null;
end;

function f_get_feccom_pex(a_codsolot in number) return date is
l_fec date;
begin

   select ot.feccom into l_fec from ot where ot.area = 10 and ot.codsolot = a_codsolot and rownum = 1;

	return l_fec;
   exception
     when others then
       return null;

end;

function f_get_diascom_OC(a_numpsp in char, a_idopc in char) return number is
l_dias number;
begin
	SELECT b.VALNUM INTO l_dias FROM VTACNDCOMPSPCLI a, VTATABCNDCOM b
			WHERE a.IDCNDCOM IN ('015','016','017') AND -- estos son los que tienen el valor de compromiso de instalacion
				  a.NUMPSP=a_numpsp AND
				  a.idopc=a_idopc AND
				  a.idcndcom = b.idcndcom;
	return l_dias;
   exception
     when others then
       return null;

end;




END;
/


