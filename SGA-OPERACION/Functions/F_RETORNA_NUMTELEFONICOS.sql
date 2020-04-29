CREATE OR REPLACE FUNCTION OPERACION.F_RETORNA_NUMTELEFONICOS(p_codsolot in number)
 return varchar2
 is
 v_cont number;
 v_numerotelef varchar2(200);
 cursor c1 is
  select c.dscsrv,a.codinssrv,v.numero from solotpto a,INSPRD i, TYSTABSRV c,PRODUCTO p,inssrv v
  where a.pid = i.pid and
        a.codsrvnue = c.codsrv and
        c.idproducto = p.idproducto and
        a.codinssrv = v.codinssrv and
        a.codsolot = p_codsolot and
        c.tipsrv = '0004' and
        i.flgprinc = 1 and
        p.idtipinstserv = 3;
 begin
      v_cont := 0;
      v_numerotelef := null;

      for c1_tel in c1 loop
          if v_cont = 0 then
             v_numerotelef := c1_tel.numero;
             v_cont := 0;
          else
             v_numerotelef := v_numerotelef + ' ' + c1_tel.numero;
          end if;
      end loop;

      return v_numerotelef;
 end;
/


