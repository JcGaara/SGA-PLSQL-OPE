CREATE OR REPLACE FUNCTION OPERACION.F_GET_ASIGNACION_CID (an_cid in number) return varchar2 is--, an_numslc in char) return varchar2 is
result varchar2(4000);
cadena varchar2(400);
ubicacion varchar2(200);
an_fibra number;
an_cajter number;
an_cable number;
an_pop number;
an_nodo number;
an_tipo number;
tipo number;
l_pex varchar2(4000);
l_puertos varchar2(400);
l_um varchar2(400);
l_analog varchar2(400);
l_numero varchar2(400);
l_sid number;
begin
-- Primero asignacion de PEX
-- 20070403 RBA

select codinssrv into l_sid from acceso where cid = an_cid;

l_pex := PQ_ASIGNACION_PEX.f_get_asignacion (l_sid);

/*Ya no es necesario.....
begin
 select codinssrv into l_sid from acceso where cid = an_cid;
   select b.codelered_p into an_fibra
   from inssrv a,eleredxelered b
      where a.codelered = b.codelered_h and
            a.codinssrv = l_sid and
            CODTIPRELELEXELE = 1;
/*
   select b.codelered_p, b.codelered_h into an_fibra, an_cid
   from inssrv a,eleredxelered b
      where a.codelered = b.codelered_h and
            a.codinssrv = an_sid and
            CODTIPRELELEXELE = 1;

   select b.codelered_p into an_cajter
      from fibra a,eleredxelered b
      where a.codelered = b.codelered_h and
            a.codelered = an_fibra and
            CODTIPRELELEXELE = 1;
   select codtipelered into an_tipo
      from elered
      where codelered = an_cajter;
   if an_tipo = 6 then
      select b.codelered_p into an_cable from cajter a,eleredxelered b
         where a.codelered = b.codelered_h and
               a.codelered = an_cajter and
               CODTIPRELELEXELE = 1;
   elsif an_tipo = 5 then
      an_cable := an_cajter;
   end if;
   select b.codelered_p into an_pop from cable a,eleredxelered b
      where a.codelered = b.codelered_h and
            a.codelered = an_cable and
            CODTIPRELELEXELE = 1;
   select b.codelered_p into an_nodo from pop a,eleredxelered b
      where a.codelered = b.codelered_h and
            a.codelered = an_pop and
            CODTIPRELELEXELE = 1;
   select codigo into result from pop
      where codelered = an_pop;
   select descripcion into cadena from pop
      where codelered = an_pop;
   result := 'Pop: ' || result || '-' || cadena;
   select descripcion, codtipcab into cadena, tipo from cable
      where codelered = an_cable;
   result := result || ', Cable:  ' || cadena;
   if an_tipo = 6 then
      select descripcion, ubicacion into cadena, ubicacion from cajter
         where codelered = an_cajter;
      result := result || ',Caja Terminal: ' || cadena || ' en ' || ubicacion;
   end if;
   select fibra.descripcion ||' - '|| tipcajter.descripcion into cadena
	from fibra,
		 eleredxelered,
		 cajter,
		 tipcajter
	where fibra.codelered = eleredxelered.codelered_h and
		  eleredxelered.codelered_p = cajter.codelered and
		  cajter.codtipcajter = tipcajter.codtipcajter and
		  fibra.codelered = an_fibra;
   if an_tipo = 5 then
  	  select fibra.descripcion into cadena
	  from fibra
	  where fibra.codelered = an_fibra;
	  end if;
   if tipo = 1 then
      result := result || ', Fibra: ' || cadena;
   elsif tipo = 2 then
      result := result || ', Par: ' || cadena;
   end if;
	l_pex := result;
   select decode(l_pex, null, '', '[PEX  ] '||l_pex||chr(13)) into l_pex from dual;
exception
when others then
 	null;
end;
*/

-- Asignacion de Puertos
begin
  SELECT '[ASIG ] '||ubired.descripcion ||' Equipo: '|| equipored.descripcion || ' Tarjeta: '|| nvl(tarjetaxequipo.descripcion,'')||' Puerto: '||puertoxequipo.puerto
   into l_puertos
    FROM acceso,
         equipored,
         puertoxequipo,
         tarjetaxequipo,
         ubired
   WHERE ( equipored.codequipo  = puertoxequipo.codequipo) and
         tarjetaxequipo.codtarjeta(+) = puertoxequipo.codtarjeta and
         ( ubired.codubired (+) = equipored.codubired) and
         ( acceso.cid = puertoxequipo.cid ) and
         acceso.cid = an_cid;

   select decode(l_puertos, null, '', l_puertos||chr(13)) into l_puertos from dual;

exception
when others then
	null;
end;


-- asignacion de Ultima Milla
begin
  SELECT '[UM   ] '||ubired.descripcion||' Eq.UM: '||chasis.abrevi||' Slot: '||slotxchasis.slot
    into l_um
    FROM chasis,
         slotxchasis,
         ubired
   WHERE chasis.codchasis = slotxchasis.codchasis and
         ubired.codubired = chasis.codubired and
         slotxchasis.cid = an_cid ;

   select decode(l_um, null, '', l_um||chr(13)) into l_um from dual;
exception
when others then
	null;
end;

-- Asignacion de Temporales de Puertos analogicos
begin
    SELECT '[ANALO]'||' MDF: '||PAN.mdf||' L3: '||PAN.l3, t.numero
    into l_analog, l_numero
    FROM PUERTOXEQUIPO P, PUERTOXEQUIPO_AN PAN,
   ACCESO A, NUMTEL T
   WHERE
   P.CODPUERTO = PAN.CODPUERTO AND
   PAN.CODNUMTEL = T.CODNUMTEL (+) AND
   P.CID = A.CID AND A.CID = an_cid;

   select decode(l_analog, null, '', l_analog||chr(13)) into l_analog from dual;

exception
when others then
	null;
end;

-- Utilizo PRIXCABECERA para determinar el # telefonico ******* Cambiar y buscar por CID y con NUMTEL

--COmentado POR CC 030128

begin
	if l_numero is null then
		select '[TELEF] '||'Numero Telefonico: '||n.numero into l_numero from
	    	   pritel p,
	   		   hunting h,
			   numtel n,
			   inssrv i
		WHERE  n.codnumtel = h.codnumtel and
			   p.codcab = h.codcab and
			   p.codinssrv = i.codinssrv and
			   i.codinssrv = l_sid;
   else
   	l_numero := '[TELEF] '||'Numero Telefonico: '||l_numero ;
   end if;

   select decode(l_numero, null, '', l_numero||chr(13)) into l_numero from dual;

exception
when others then
	null;
end;


result := l_pex|| l_um || l_puertos|| l_analog|| l_numero;

return result;

end;
/


