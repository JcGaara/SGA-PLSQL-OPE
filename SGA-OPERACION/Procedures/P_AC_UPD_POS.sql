CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_POS (
	a_tipo in number,
	a_codsolot in number,
	a_punto in number,
	a_orden in number,
   a_poste in char,
   a_propietario in char,
   a_tipo_pos in char,
   a_tamano in number,
   a_codubi in char,
   a_obs in char default '',
   a_flgproy in number default 0
) IS


l_cont number;
l_cont_eta number;
l_costo actividad.costo%type;
l_moneda actividad.moneda%type;
BEGIN

if a_tipo = 1 then -- dise?o
/*	begin
		select costo, moneda into l_costo, l_moneda from actividad where codact = a_codact;
   exception
   	when others then
      	raise_application_error(-20500,'Actividad '||a_codact||' no valida.');
   end;

   select count(*) into l_cont_eta from preubieta
	   where codpre = a_codpre and idubi = a_idubi and codeta = a_codeta;
   if l_cont_eta = 0 then
   	insert into preubieta (	CODPRE, IDUBI, CODETA )
   	values ( a_CODPRE, a_IDUBI, a_CODETA );
   end if;
*/
   select count(*) into l_cont from solotptopos
	   where codsolot = a_codsolot and punto = a_punto and orden = a_orden ;
	if l_cont = 0 then
		insert into solotptopos ( codsolot, punto, ORDEN, POSTE, PROPIETARIO, TIPO, TAMANO, CODUBI, OBSERVACION, FLGPROY)
   	values ( a_CODsolot, a_punto, a_orden, a_POSTE, a_PROPIETARIO, a_TIPO_pos, a_TAMANO, a_CODUBI, a_OBS, a_FLGPROY);
   else
	  	update solotptopos set
	      poste = a_POSTE, propietario = a_PROPIETARIO, tipo = a_TIPO_pos, tamano = a_TAMANO, codubi = a_CODUBI,
         observacion = a_OBS, flgproy = a_FLGPROY
	   where codsolot = a_codsolot and punto = a_punto and orden = a_orden ;
   end if;

else
	raise_application_error(-20500,'Actividad '||''||' no valida.');
	null;
end if;

END;
/


