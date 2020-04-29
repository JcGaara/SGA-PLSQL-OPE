CREATE OR REPLACE PROCEDURE OPERACION.P_TIPTRA_CAMBIOPLAN IS
/********************************************************************************************
  NOMBRE:       OPERACION.P_TIPTRA_CAMBIOPLAN
  PROPOSITO:    
  REVISIONES:
  Versión    Fecha       Autor         Solicitado por                            Descripción
  -------  ----------  --------------  ----------------------------------------  ---------------------------------------
   1.0     27/02/2012  Roy Concepcion REQ 161655 Mejora Proyecto Corporativos     Modificacion.
   2.0     09/10/2017  Anderson Julca Dirección de Mercado Corporativo            Optimización del query y traslado de
                                                                                  restricción de créditos hacia la aprobación
                                                                                  de la Oferta Comercial
  *********************************************************************************************/
cursor cur_aut is
select c.paquete,trim(B.NUMSLC) numslc,c.codsrv, c.idproducto, c.numpto,
       trim(B.TIPSRV) TIPSRV,
       -- ini 1.0
       --e.idclaseproducto,
       -- fin 1.0
       (select cid from inssrv where codinssrv= c.codinssrv) cid
      from vtatabslcfac B, vtadetptoenl C, cxcpspchq Q
      -- ini 1.0
      --,  tystabsrv E, vtasuccli F, vtatabdst G
      -- fin 1.0
      where to_number(B.numslc) not in (select codef from ef where codef = to_number(b.numslc))
      and b.numslc = c.numslc
      and b.numslc = q.numslc
      and b.tipo in (0,5)
      and b.estsolfac in ('03')
      -- ini 2.0
      AND TRUNC(b.fecapr)>=TRUNC(SYSDATE)-(SELECT TO_NUMBER(valor) FROM constante WHERE constante='IS_DIASDERIV')
      -- fin 2.0
      and b.tipsrv='0006'
      -- ini 1.0
      /*and c.codsrv = e.codsrv(+)
      and c.codsuc = f.codsuc(+)
      and f.ubisuc = g.codubi(+)*/
      --and e.idclaseproducto is not null
      -- fin 1.0
      and c.tiptra in(11,10,2)
      --and B.Numslc = '0001358039'
      group by c.paquete,B.NUMSLC,c.codsrv,c.idproducto,c.numpto,B.CODCLI,B.TIPSRV,
               -- ini 1.0
               -- e.idclaseproducto, 
               -- fin 1.0
               c.codinssrv;
l_idclaseproducto number;
vv_codsrv tystabsrv.codsrv%type;
vn_idclaseproducto tystabsrv.idclaseproducto%type; 

BEGIN

for l_sef in cur_aut loop
  begin --2.0
    select vv.codsrv, t.idclaseproducto
      into  vv_codsrv, vn_idclaseproducto
      from vtadetptoenl vv, tystabsrv t
      where trim(vv.numslc) = trim(l_sef.numslc)  and
      vv.numpto = l_sef.numpto and
      vv.codsrv = t.codsrv (+); 
  --<2.0
  exception
    when others then
     vv_codsrv:=null;
     vn_idclaseproducto:=null;
  end;
  --2.0>
	  if nvl(vn_idclaseproducto,0) <> 0 then
    begin
		  select  t.idclaseproducto into l_idclaseproducto
		  from
		  solot s,
		  solotpto p,
		  tystabsrv t,
		  (select  max(s.feccom) feccom from
		  solot s,
		  solotpto p,
		  tystabsrv t
		  where
		  s.codsolot=p.codsolot
		  and t.idclaseproducto is not null
		  and p.cid=l_sef.cid
		  and t.codsrv=p.codsrvnue) a
		  where
		  s.codsolot=p.codsolot
		  and t.idclaseproducto is not null
		  and p.cid=l_sef.cid
		  and t.codsrv=p.codsrvnue
		  and s.feccom=a.feccom
		  and rownum=1;
     --<2.0
     exception
        when others then
         l_idclaseproducto:=null;
      end;
      --2.0>
		  if nvl(vn_idclaseproducto,0)<>l_idclaseproducto  then
		  update vtadetptoenl set tiptra=339 where numslc=l_sef.numslc and paquete=l_sef.paquete;
		  commit;
		  end if;
	   end if;	  
end loop;

END;
/
