CREATE OR REPLACE FUNCTION OPERACION.F_GETCOSTO_BLOQUEOS(p_codinssrv number)
return varchar2
IS
v_numslc  inssrv.numslc%type;
v_numpto  inssrv.numpto%type;
v_ncos    inssrv.ncos%type;
v_monedaid   vtadetptoenl.moneda_id%type;
v_codsrv     ncos.codsrv_moneda1%type;
vv_retorno    varchar2(30);
v_retorno    number;
i            number;
BEGIN
      i := 0;

      BEGIN
          select numslc,numpto,ncos into v_numslc,v_numpto,v_ncos from inssrv where codinssrv = p_codinssrv;
          select moneda_id into v_monedaid from vtadetptoenl where numslc = v_numslc and numpto = v_numpto;
          if v_monedaid = 1 then
             select codsrv_moneda1 into v_codsrv from ncos where ncos = v_ncos;
          else
             select codrv_moneda2 into v_codsrv from ncos where ncos = v_ncos;
          end if;
      EXCEPTION
      WHEN OTHERS THEN
          vv_retorno := 0;
          i := 1;
      END;

      IF i = 0 THEN
         BEGIN
             Select cosins into v_retorno From define_precio Where (moneda_id,plazo,codsrv) in(
             Select Distinct e.moneda_id, b.plazo_srv,v_codsrv
              from vtatabslcfac b, insprd d, vtadetptoenl e
             where d.numslc = e.numslc
               and d.numpto = e.numpto
               and b.numslc = d.numslc
               and d.codinssrv = p_codinssrv);
             if v_monedaid = 1 then
                vv_retorno := 'S/. ' || to_char(v_retorno)|| ' ';
             else
                vv_retorno := '$ ' || to_char(v_retorno)|| ' ';
             end if;

         EXCEPTION
         WHEN others THEN
             vv_retorno := 0;
         END;
      END IF;

      return vv_retorno;
END;
/


