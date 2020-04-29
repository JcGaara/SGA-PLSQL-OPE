create or replace package body operacion.pkg_asignar_wf2 is

/*******************************************************************************************************
   NOMBRE:       OPERACION.pkg_asignar_wf2
   PROPOSITO:    Paquete para asignar el workflow
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       14/12/2015  Luis Flores                        SGA-SD-560640
    2.0       16/03/2016  Alfonso Mu?ante                    SGA-SD-337664 SERVICIOS ADICIONALES CABLE
    3.0       28/04/2016                                     SD-642508-1 Cambio Plan Fase II
    4.0       20/07/2016  Dorian Sucasaca                    SD_795618
    5.0       24/11/2016  Luis Guzman      Alex Alamo        PROY-20152 - IDEA-24390 - 3Play Inalambrico
    6.0       10/07/2017  Luis Guzman      Tito Huerta       PROY-27792 - IDEA-34954 - Cambio de Plan
    7.0       14/08/2018  Jose Varillas    Hans Dresda       PROY-32581 - Portabilidad LTE
    8.0       20/11/2018  Steve Panduro    Tito Huerta       FTTH
    9.0       16/01/2019  Luis Flores             	     PROY-32581 - SGA20
  *******************************************************************************************************/

  procedure asignar_wf(p_fecha date default null) is

    l_destino         varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    -- ini 4.0
    l_cuerpo          varchar2(32767);
    l_cuerpo_customer varchar2(32767);
    --l_cuerpo          opewf.cola_send_mail_job.cuerpo%type;
    --l_cuerpo_customer opewf.cola_send_mail_job.cuerpo%type;
    -- fin 4.0
    lv_tecnologia     varchar2(10);--8.0
  cursor sots(l_fecha date) is
      select t.codsolot, t.customer_id, t.cod_id, t.tiptra --8.0 
        from solot t
       where t.fecusu > l_fecha
         and t.tiptra in (658 , 830) --8.0 
         and t.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = t.codsolot
                 and f.valido = 1)
       order by t.codsolot asc;

    ld_fecha           date;
    ll_idwf            number;
    ll_cont            number;
    ll_valida_customer number;
    ln_valsolucion     number;
  begin
    if p_fecha is null then
      ld_fecha := trunc(sysdate);
    else
      ld_fecha := trunc(p_fecha);
    end if;

    l_cuerpo_customer := null;
    l_cuerpo          := null;

    for sot in sots(ld_fecha) loop

      select count(*)
        into ll_cont
        from wf f
       where f.codsolot = sot.codsolot
         and f.valido = 1;

      ln_valsolucion := f_valida_tipo_solucion(sot.codsolot);

      if ln_valsolucion = 1 then
        if sot.cod_id is null then

          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;

          ll_valida_customer := 1; -- No se asigna WF

        else
          ll_valida_customer := 0; -- Se asigna WF
        end if;
      else
        ll_valida_customer := 1; -- No se asigna WF
      end if;

      if ll_cont = 0 and ll_valida_customer = 0 then
        -- Sin WF Asignado y con customer_id
        begin

          if sot.tiptra = 658 then --8.0 
	          lv_tecnologia := 'HFC';--8.0
                  pq_solot.p_asig_wf(sot.codsolot, 1212);
          else --8.0
	           lv_tecnologia := 'FTTH';--8.0
	           pq_solot.p_asig_wf(sot.codsolot, 1363); --8.0 
          end if;--8.0

          select idwf
            into ll_idwf
            from wf
           where codsolot = sot.codsolot
             and valido = 1;

          update OPERACION.TMP_SOLOT_CODIGO
             set estado         = 4,
                 fechaejecucion = sysdate,
                 observacion    = 'Se realizo la asignacion del WF - ' ||
                                  ll_idwf || ' a la SOT'
           where codsolot = sot.codsolot
             and estado <> 6;

          commit;
        exception
          when others then

            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(sot.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || 'Codsolot = ' ||
                          to_char(sot.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;
    -- Primer Insert para enviar masivamente las SOT que se caeron en Error
    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF SISACT ' ||  lv_tecnologia, --8.0
         l_destino,
         substr(l_cuerpo, 1,4000),  --<4.0>
         '0');
      commit;
    end if;

    if l_cuerpo_customer is not null then
      l_cuerpo_customer := 'Revisar las siguientes SOT sin Customer_ID:' ||
                           chr(13) || l_cuerpo_customer;
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'SOT HFC SISACT sin Customer ID',
         l_destino,
         substr(l_cuerpo_customer, 1,4000),
         '0');

      commit;
    end if;
  end;

  procedure asignar_wf_2(p_fecha date default null) is

    l_destino         varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    -- ini 4.0
    l_cuerpo          varchar2(32767);
    l_cuerpo_customer  varchar2(32767);
    -- l_cuerpo          opewf.cola_send_mail_job.cuerpo%type;
    -- l_cuerpo_customer opewf.cola_send_mail_job.cuerpo%type;
    -- fin 4.0
    cursor sots(l_fecha date) is
      select t.codsolot, t.customer_id, t.cod_id
        from solot t
       where t.fecusu < l_fecha
         and t.tiptra = 658
         and t.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = t.codsolot
                 and f.valido = 1)
       order by t.codsolot desc;

    ld_fecha           date;
    ll_idwf            number;
    ll_cont            number;
    ll_valida_customer number;
    ln_valsolucion     number;
  begin
    if p_fecha is null then
      ld_fecha := trunc(sysdate);
    else
      ld_fecha := trunc(p_fecha);
    end if;

    l_cuerpo_customer := null;
    l_cuerpo          := null;

    for sot in sots(ld_fecha) loop

      select count(*)
        into ll_cont
        from wf f
       where f.codsolot = sot.codsolot
         and f.valido = 1;

      ln_valsolucion := f_valida_tipo_solucion(sot.codsolot);

      if ln_valsolucion = 1 then
        if sot.cod_id is null then

          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;

          ll_valida_customer := 1; -- No se asigna WF

        else
          ll_valida_customer := 0; -- Se asigna WF
        end if;
      else
        ll_valida_customer := 1; -- No se asigna WF
      end if;

      if ll_cont = 0 and ll_valida_customer = 0 then
        begin

          pq_solot.p_asig_wf(sot.codsolot, 1212);

          select idwf
            into ll_idwf
            from wf
           where codsolot = sot.codsolot
             and valido = 1;

          update OPERACION.TMP_SOLOT_CODIGO
             set estado         = 4,
                 fechaejecucion = sysdate,
                 observacion    = 'Se realizo la asignacion del WF - ' ||
                                  ll_idwf || ' a la SOT'
           where codsolot = sot.codsolot
             and estado <> 6;

          commit;
        exception
          when others then
            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(sot.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || 'Codsolot = ' ||
                          to_char(sot.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;

    -- Primer Insert para enviar masivamente las SOT que se caeron en Error
    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF SISACT HFC',
         l_destino,
         substr(l_cuerpo, 1,4000),  --<4.0>
         '0');
      commit;
    end if;

    if l_cuerpo_customer is not null then
      l_cuerpo_customer := 'Revisar las siguientes SOT sin Customer_ID:' ||
                           chr(13) || l_cuerpo_customer;
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'SOT HFC SISACT sin Customer ID',
         l_destino,
         substr(l_cuerpo_customer, 1,4000),
         '0');

      commit;
    end if;
  end;

  procedure asignar_wf_portabaja(p_fecha date default null) is

    l_destino         varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    -- ini 4.0
    l_cuerpo          varchar2(32767);
    l_cuerpo_customer varchar2(32767);
    -- l_cuerpo          opewf.cola_send_mail_job.cuerpo%type;
    -- l_cuerpo_customer opewf.cola_send_mail_job.cuerpo%type;
    -- fin 4.0
    cursor sots is
      select t.codsolot, t.customer_id, t.cod_id, t.tiptra
        from solot t
       where exists (select 1 from tipopedd tt, opedd o
                            where tt.tipopedd = o.tipopedd
                            and tt.abrev = 'TIPTRAJOB235_WF'
                            and o.abreviacion = 'JOBNUEVO'
                            and o.codigoc = 'S'
                            and o.codigon = t.tiptra)
         and t.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = t.codsolot
                 and f.valido = 1);

    ld_fecha           date;
    ll_idwf            number;
    ll_cont            number;
    ll_wfdef           number;
    ll_valida_customer number;
    ln_valsolucion     number;
  begin
    if p_fecha is null then
      ld_fecha := '01/01/2015'; -- Solo 2015
    else
      ld_fecha := trunc(p_fecha);
    end if;

    l_cuerpo_customer := null;
    l_cuerpo          := null;

    for sot in sots loop

      select count(*)
        into ll_cont
        from wf f
       where f.codsolot = sot.codsolot
         and f.valido = 1;

      ln_valsolucion := f_valida_tipo_solucion(sot.codsolot);

      if ln_valsolucion = 1 then
        if sot.cod_id is null and sot.tiptra != 7  then --<4.0>

          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;

          ll_valida_customer := 1; -- No se asigna WF

        else
          ll_valida_customer := 0; -- Se asigna WF
        end if;
      else
        ll_valida_customer := 1; -- No se asigna WF
      end if;

      if ll_cont = 0 and ll_valida_customer = 0 then
        begin

          ll_wfdef := CUSBRA.F_BR_SEL_WF(sot.codsolot);
          pq_solot.p_asig_wf(sot.codsolot, ll_wfdef);

          select idwf
            into ll_idwf
            from wf
           where codsolot = sot.codsolot
             and valido = 1;

          update OPERACION.TMP_SOLOT_CODIGO
             set estado         = 4,
                 fechaejecucion = sysdate,
                 observacion    = 'Se realizo la asignacion del WF - ' ||
                                  ll_idwf || ' a la SOT'
           where codsolot = sot.codsolot
             and estado <> 6;

          commit;
        exception
          when others then
            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(sot.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || 'Codsolot = ' ||
                          to_char(sot.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;

    -- Primer Insert para enviar masivamente las SOT que se caeron en Error
    if l_cuerpo is not null then
      l_cuerpo:=substr(l_cuerpo, 1,4000);
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF SISACT HFC PORTA',
         l_destino,
         substr(l_cuerpo, 1,4000), --<4.0>
         '0');
      commit;
    end if;

    if l_cuerpo_customer is not null then
      l_cuerpo_customer := 'Revisar las siguientes SOT de Portabilidad sin Customer_ID:' ||
                           chr(13) || l_cuerpo_customer;
      -- ini 4.0
    /*
    insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'SOT HFC SISACT - PORTABILIDAD sin Customer ID',
         l_destino,
         substr(l_cuerpo_customer, 1,4000),
         '0');
    */
      null;
    -- fin 4.0
      commit;
    end if;
  end;

  procedure p_asigna_wfbscs_siac(an_tiptransacion number default null) is

    cursor c_sotsiac is
      select c.codigoc, s.*
        from solot s, 
		(select o.codigon, o.codigoc
                 from opedd o, tipopedd t
                 where o.tipopedd = t.tipopedd
                 and t.abrev = 'ASIGNARWFBSCS'
                 and o.codigon_aux = an_tiptransacion) c
       where s.tiptra = c.codigon --9.0
         and s.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = s.codsolot
                 and f.valido = 1);

    ln_wfdef  number;
    l_destino varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    l_cuerpo  opewf.cola_send_mail_job.cuerpo%type;
    l_valcontrato number := 0; --9.0
  begin
    for c_s in c_sotsiac loop
      --Ini 9.0
      if c_s.codigoc = 'VALCONTRATO' and c_s.cod_id is null then
        l_valcontrato := 1; -- No se asigna WF siempre y cuando no tenga CO_ID asignado
      else
        l_valcontrato := 0; -- Asigna WF cumple con la restriccion
      end if;
      --Fin 9.0
      ln_wfdef := cusbra.f_br_sel_wf(c_s.codsolot);

      if ln_wfdef is not null and l_valcontrato = 0 then --9.0
        begin
          pq_solot.p_asig_wf(c_s.codsolot, ln_wfdef);
        exception
          when others then
            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(c_s.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || ' Codsolot = ' ||
                          to_char(c_s.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;

    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF BSCS SIAC',
         l_destino,
         l_cuerpo,
         '0');
      commit;

    end if;
  end;
  
  procedure p_asigna_wf_siac_sevadi(an_tiptransacion number default null) is

    cursor c_sotsiac is
      select *
        from solot s
       where s.tiptra in
             (select o.codigon
                from opedd o, tipopedd t
               where o.tipopedd = t.tipopedd
                 and t.abrev = 'ASIGNARWFBSCS'
                 and o.codigon_aux = an_tiptransacion)
         and s.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = s.codsolot
                 and f.valido = 1);

    ln_wfdef  number;
    l_destino varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    l_cuerpo  opewf.cola_send_mail_job.cuerpo%type;

  begin

    for c_s in c_sotsiac loop

      ln_wfdef := operacion.pq_sga_siac.f_obtiene_valores_scr('WFSERADI');

      if ln_wfdef is not null then
        begin
          pq_solot.p_asig_wf(c_s.codsolot, ln_wfdef);
        exception
          when others then
            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(c_s.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || ' Codsolot = ' ||
                          to_char(c_s.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;

    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF BSCS SIAC',
         l_destino,
         l_cuerpo,
         '0');
      commit;

    end if;
  end;

  -- Funcion que valida si es una solucion SISACT
  function f_valida_tipo_solucion(an_codsolot in number) return number is
    ln_value number;
  
  begin
  
    SELECT COUNT(s.codsolot)
      INTO ln_value
      FROM OPEDD O, TIPOPEDD T, VTATABSLCFAC V, SOLOT S
     WHERE O.TIPOPEDD = T.TIPOPEDD
       AND V.IDSOLUCION = O.CODIGON
       AND V.NUMSLC = S.NUMSLC
       AND S.CODSOLOT = an_codsolot
       AND T.ABREV = 'SOLUCION_SISACT';
  
    return ln_value;
  end;

  --ini 5.0
   procedure sgasu_asignar_wf_lte
   is

    l_destino          varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    l_cuerpo           varchar2(32767);
    l_cuerpo_customer  varchar2(32767);
    ld_fecha           date;
    ll_idwf            number;
    ll_cont            number;
    ll_valida_customer number;
    ln_valsolucion     number;
    ln_wf              number;

    --Ini 7.0
    cursor tiptra is
      select op.*
        from opedd op
       where op.abreviacion in ('SISACT_WLL','SISACT_WLL_PORTA')
         and op.tipopedd = (select tp.tipopedd
                          from tipopedd tp
                         where abrev='TIPTRABAJO');
    --Fin 7.0
    cursor sots(l_fecha date, l_tiptra number) is
      select t.codsolot, t.customer_id, t.cod_id
        from solot t
       where t.fecusu <= l_fecha
         and t.tiptra = l_tiptra
         and t.estsol = 11
         and not exists (select 1
                           from wf f
                          where f.codsolot = t.codsolot
                            and f.valido = 1)
       order by t.codsolot desc;

  begin

    ld_fecha := sysdate;
    l_cuerpo_customer := null;
    l_cuerpo          := null;

    --Ini 7.0
    for c_tiptra in tiptra loop
    --Fin 7.0
      for sot in sots(ld_fecha, c_tiptra.codigon) loop

        select count(*)
          into ll_cont
          from wf f
         where f.codsolot = sot.codsolot
           and f.valido = 1;

        ln_valsolucion := f_valida_tipo_solucion(sot.codsolot);

        if ln_valsolucion = 1 then
          --EN CASO NO TENGA COD_ID Y CUSTOMER_ID
          if sot.cod_id is null and sot.customer_id is null then

              if l_cuerpo_customer is null then
                l_cuerpo_customer := to_char(sot.codsolot);
              else
                l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) || to_char(sot.codsolot);
              end if;

              ll_valida_customer := -1; --No Se asigna WF

          --EN CASO NO TENGA COD_ID
          elsif sot.cod_id is null then

              if l_cuerpo_customer is null then
                l_cuerpo_customer := to_char(sot.codsolot);
              else
                l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) || to_char(sot.codsolot);
              end if;

              ll_valida_customer := -1; --No Se asigna WF

          --EN CASO NO TENGA CUSTOMER_ID
          elsif sot.customer_id is null then

              if l_cuerpo_customer is null then
                l_cuerpo_customer := to_char(sot.codsolot);
              else
                l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) || to_char(sot.codsolot);
              end if;

              ll_valida_customer := -1; -- No Se asigna WF

          else
            ll_valida_customer := 0; -- Se asigna WF
          end if;

        else
          ll_valida_customer := -1; -- No Se asigna WF
        end if;

        if ll_cont = 0 and ll_valida_customer = 0 then

          begin

            ln_wf := cusbra.f_br_sel_wf(sot.codsolot);

            pq_solot.p_asig_wf(sot.codsolot, ln_wf);

            select idwf
              into ll_idwf
              from wf
             where codsolot = sot.codsolot
               and valido = 1;

            update OPERACION.TMP_SOLOT_CODIGO
               set estado         = 4,
                   fechaejecucion = sysdate,
                   observacion    = 'Se realizo la asignacion del WF - ' || ll_idwf || ' a la SOT'
             where codsolot = sot.codsolot
               and estado <> 6;

            commit;

          exception
            when others then
              if l_cuerpo is null then
                l_cuerpo := 'Codsolot = ' || to_char(sot.codsolot) || ' ' ||  sqlerrm;
              else
                l_cuerpo := l_cuerpo || ';' || chr(13) || 'Codsolot = ' || to_char(sot.codsolot) || ' ' || sqlerrm;
              end if;
          end;
        end if;
      end loop;
    end loop;
    -- Primer Insert para enviar masivamente las SOT que se caeron en Error
    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
                  (nombre, subject, destino, cuerpo, flg_env)
           values('SGA-SoportealNegocio', 'Error en la asignacion del WF SISACT LTE', l_destino, substr(l_cuerpo, 1,4000), '0');
      commit;
    end if;

    if l_cuerpo_customer is not null then

      l_cuerpo_customer := 'Revisar las siguientes SOTs sin Customer_ID y/o Cod_ID:' || chr(13) || l_cuerpo_customer;

      insert into opewf.cola_send_mail_job
                  (nombre, subject, destino, cuerpo, flg_env)
           values ('SGA-SoportealNegocio', 'SOT LTE SISACT sin Customer ID y/o Cod_ID', l_destino, substr(l_cuerpo_customer, 1,4000), '0');

      commit;
    end if;
  end;

  function sgafun_solucioneslte(an_codsolot in number) return number
  is
     ln_value number;

  begin
    select count(s.codsolot) into ln_value
    from solot s, vtatabslcfac v,soluciones so
      where s.numslc = v.numslc
      and v.idsolucion = so.idsolucion
      and so.flg_sisact_sga = 2
      and s.codsolot = an_codsolot;

    return ln_value;
  end;

  --fin 5.0

  --ini 6.0
  procedure sgasu_asignar_wf_lte_cp is
  
    l_destino          varchar2(1500) := 'SoporteTelefoniaFijayPortales@claro.com.pe';
    l_cuerpo           varchar2(32767);
    l_cuerpo_customer  varchar2(32767);
    ld_fecha           date;
    ll_idwf            number;
    ll_cont            number;
    ll_valida_customer number;
    ln_valsolucion     number;
    ln_wf              number;
  
    cursor sots(l_fecha date) is
      select t.codsolot, t.customer_id, t.cod_id
        from solot t
       where t.fecusu <= l_fecha
         and t.estsol = 11
         and not exists (select 1
                from wf f
               where f.codsolot = t.codsolot
                 and f.valido = 1)
         and exists (select 1
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev in ('TIPTRA_HFC_LTE_CP')
                 and a.abreviacion in ('LTE_SIAC_CPLAN')
                 and a.codigon = t.tiptra)
       order by t.codsolot desc;
  
  begin
  
    ld_fecha          := sysdate;
    l_cuerpo_customer := null;
    l_cuerpo          := null;
  
    for sot in sots(ld_fecha) loop
      select count(*)
        into ll_cont
        from wf f
       where f.codsolot = sot.codsolot
         and f.valido = 1;
    
      ln_valsolucion := f_valida_tipo_solucion(sot.codsolot);
    
      if ln_valsolucion = 1 then
        --EN CASO NO TENGA COD_ID Y CUSTOMER_ID
        if sot.cod_id is null and sot.customer_id is null then
        
          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;
        
          ll_valida_customer := -1; --No Se asigna WF
        
          --EN CASO NO TENGA COD_ID
        elsif sot.cod_id is null then
        
          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;
        
          ll_valida_customer := -1; --No Se asigna WF
        
          --EN CASO NO TENGA CUSTOMER_ID
        elsif sot.customer_id is null then
        
          if l_cuerpo_customer is null then
            l_cuerpo_customer := to_char(sot.codsolot);
          else
            l_cuerpo_customer := l_cuerpo_customer || ';' || chr(13) ||
                                 to_char(sot.codsolot);
          end if;
        
          ll_valida_customer := -1; -- No Se asigna WF
        
        else
          ll_valida_customer := 0; -- Se asigna WF
        end if;
      
      else
        ll_valida_customer := -1; -- No Se asigna WF
      end if;
    
      if ll_cont = 0 and ll_valida_customer = 0 then
      
        begin
         ln_wf := cusbra.f_br_sel_wf(sot.codsolot);

          pq_solot.p_asig_wf(sot.codsolot, ln_wf);
        
          select idwf
            into ll_idwf
            from wf
           where codsolot = sot.codsolot
             and valido = 1;
        
          update OPERACION.TMP_SOLOT_CODIGO
             set estado         = 4,
                 fechaejecucion = sysdate,
                 observacion    = 'Se realizo la asignacion del WF - ' ||
                                  ll_idwf || ' a la SOT'
           where codsolot = sot.codsolot
             and estado <> 6;
        
          commit;
        
        exception
          when others then
            if l_cuerpo is null then
              l_cuerpo := 'Codsolot = ' || to_char(sot.codsolot) || ' ' ||
                          sqlerrm;
            else
              l_cuerpo := l_cuerpo || ';' || chr(13) || 'Codsolot = ' ||
                          to_char(sot.codsolot) || ' ' || sqlerrm;
            end if;
        end;
      end if;
    end loop;
  
    -- Primer Insert para enviar masivamente las SOT que se caeron en Error
    if l_cuerpo is not null then
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'Error en la asignacion del WF SIAC LTE-CAMBIO PLAN',
         l_destino,
         substr(l_cuerpo, 1, 4000),
         '0');
      commit;
    end if;
  
    if l_cuerpo_customer is not null then
    
      l_cuerpo_customer := 'Revisar las siguientes SOTs sin Customer_ID y/o Cod_ID:' ||
                           chr(13) || l_cuerpo_customer;
    
      insert into opewf.cola_send_mail_job
        (nombre, subject, destino, cuerpo, flg_env)
      values
        ('SGA-SoportealNegocio',
         'SOT LTE-CAMBIO PLAN SIAC sin Customer ID y/o Cod_ID',
         l_destino,
         substr(l_cuerpo_customer, 1, 4000),
         '0');
    
      commit;
    end if;
  end;
  --fin 6.0
end;
/