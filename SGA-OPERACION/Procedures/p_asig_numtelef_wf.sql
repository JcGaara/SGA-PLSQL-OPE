create or replace procedure operacion.p_asig_numtelef_wf(a_idtareawf in number,
                                                         a_idwf      in number,
                                                         a_tarea     in number,
                                                         a_tareadef  in number) is
  ln_codsolot         solot.codsolot%type;
  vv_numslc           solot.numslc%type;
  ln_flagportable     vtatabslcfac.flg_portable%type;
  ln_idtareawf        number;
  ln_tarea            number;
  ln_tareadef         number;
  l_countcola         number;
  vn_cantvtadetptoenl number;
  vn_cantreserva      number;
  vv_numeroini        numtel.numero%type;
  vn_codnumtel        numtel.codnumtel%type;
  exceptioncodsuc     exception;
  exceptioninventario exception;
  exceptionnumtel     exception;
  v_mensaje         varchar2(3000);
  v_error           number;
  l_zona            number;
  ln_producto       number;
  ln_central        number;
  l_zona3Play_aut   number;
  l_zona_TPILim_aut number;
  ln_prodfax        number;
  ln_faxserver      number;
  ln_cod_error      number;
  ls_des_error      varchar2(1000);
  ls_email          varchar2(100);
  ln_codinssrv      numtel.codinssrv%type;
  lc_imei           numtel.imei%type;
  lc_simcard        numtel.simcard%type;
  l_subject         VARCHAR2(200);
  l_cuerpo          VARCHAR2(4000);
  l_pre_mail        tareawfcpy.pre_mail%TYPE;
  cnt_res_num       number;
  ls_codnumtel      numtel.codnumtel%type;

  cursor c1 is
    select a.numslc, a.numpto, a.ubipto, a.codsuc, e.codcli, e.idsolucion --<34.0>
      from vtadetptoenl a, tystabsrv b, producto c, vtatabslcfac e
     where a.codsrv = b.codsrv
       and b.idproducto = c.idproducto
       and a.numslc = e.numslc
       and a.numslc = vv_numslc
       and c.idtipinstserv = 3
       and a.flgsrv_pri = 1
     order by a.numpto;

  procedure p_asignar_numeros_ce(p_numslc  in varchar2,
                                 o_mensaje in out varchar2,
                                 o_error   in out number) IS
    ln_cabecera          number;
    ln_codcab            number;
    ln_codgrupo          number;
    ln_cant_reser        number;
    ln_cant_inssrv       number;
    ln_codinssrv         number;
    v_mensaje            varchar2(3000);
    v_error              number;
    ln_mayor_numpto_prin vtadetptoenl.numpto_prin%type;
    l_orden              number;

    cursor c_numeros is
      select r.idseq,
             r.codnumtel,
             r.numpto,
             n.numero,
             r.publicar,
             flg_portable
        from reservatel r, numtel n
       where r.codnumtel = n.codnumtel
         and r.numslc = p_numslc
         and r.valido = 1
      -- and r. estnumtel = 3
       order by r.idseq;

  BEGIN

    select count(*)
      into ln_cant_reser
      from reservatel
     where trim(numslc) = trim(p_numslc)
       and valido = 1;

    If ln_cant_reser > 0 then

      select count(*)
        into ln_cant_inssrv
        from inssrv
       where numslc = p_numslc
         and tipinssrv = 3
         and numero is null;

      if ln_cant_reser <> ln_cant_inssrv then
        v_error   := -1;
        v_mensaje := 'No coincide numeros reservados vs los servicios creados';
      else

        ln_mayor_numpto_prin := intraway.pq_intraway_proceso.f_obt_numpto_princ(p_numslc);

        select codnumtel
          into ln_cabecera
          from reservatel
         where numslc = p_numslc
           and numpto = ln_mayor_numpto_prin;

        For cur_in in c_numeros loop

          select codinssrv
            into ln_codinssrv
            from inssrv
           where tipinssrv = 3
             and numero is null
             and numslc = p_numslc
             and numpto = cur_in.numpto
             and rownum = 1;

          update TELEFONIA.NUMTEL
             set codinssrv = ln_codinssrv,
                 estnumtel = 2,
                 publicar  = cur_in.publicar
           where codnumtel = cur_in.codnumtel;

          update inssrv
             set numero = cur_in.numero
           where codinssrv = ln_codinssrv;

          update reservatel set valido = 1 where idseq = cur_in.idseq;

        end loop;

        select nvl(max(codcab), 0) + 1 into ln_codcab from hunting;

        insert into hunting
          (codcab, codnumtel)
        values
          (ln_codcab, ln_cabecera);

        pq_telefonia.p_crear_grupotel(ln_cabecera, ln_codcab, ln_codgrupo);

        for c_num in c_numeros loop
          pq_telefonia.p_crear_numxgrupotel(c_num.codnumtel,
                                            ln_codcab,
                                            ln_codgrupo,
                                            l_orden);
        end loop;
        v_error   := 0;
        v_mensaje := 'Se asignó automaticamente el número: ';
      End if;

    End if;

    o_error   := v_error;
    o_mensaje := v_mensaje;

  END;
begin

  select s.codsolot,
         s.numslc,
         v.flg_portable,
         f.idtareawf,
         f.tarea,
         f.tareadef
    into ln_codsolot,
         vv_numslc,
         ln_flagportable,
         ln_idtareawf,
         ln_tarea,
         ln_tareadef
    from wf w, solot s, vtatabslcfac v, tareawf f
   where w.codsolot = s.codsolot
     and s.numslc = v.numslc
     and w.idwf = f.idwf
     and w.valido = 1
     and w.idwf = a_idwf
     and rownum = 1;

  vv_numeroini := null;

  select to_number(valor)
    into l_zona3Play_aut
    from constante
   where trim(constante) = 'ZONA3PLAY_AUT';

  select to_number(valor)
    into l_zona_TPILim_aut
    from constante
   where trim(constante) = 'ZONA_TPILIM_AUT';

  if ln_flagportable = 0 then

    select count(1)
      into vn_cantreserva
      from reservatel
     where numslc = vv_numslc;

    select count(1)
      into vn_cantvtadetptoenl
      from vtadetptoenl a, tystabsrv b, producto c
     where a.codsrv = b.codsrv
       and b.idproducto = c.idproducto
       and a.numslc = vv_numslc
       and c.idtipinstserv = 3;

    if vn_cantreserva <> vn_cantvtadetptoenl then

      for cn1 in c1 loop

        If nvl(cn1.codsuc, 'X') = 'X' then
          raise exceptioncodsuc;
        End if;

        select valor
          into ln_producto
          from constante
         where constante = 'CVIRTUAL_PRD';

        select count(1)
          into ln_central
          from vtadetptoenl a, tystabsrv b, producto c, vtatabslcfac e
         where a.codsrv = b.codsrv
           and b.idproducto = c.idproducto
           and a.numslc = e.numslc
           and a.numslc = vv_numslc
           and (b.codsrv in
               (select valor
                   from constante
                  where constante = 'CVIRTUAL_SRV') or
               c.idproducto in
               (select valor
                   from constante
                  where constante = 'CVIRTUAL_PRD'));

        if ln_central > 0 then
          select distinct codzona
            into l_zona
            from serietel
           where codzona in
                 (select codzona
                    from zonatel
                   where codplan in
                         (select codplan
                            from planproducto
                           where idproducto = ln_producto))
             and codubi = cn1.ubipto
             and rownum = 1;

        elsif operacion.pq_cuspe_ope.exist_paquete_tpi_gsm(vv_numslc) then

          select distinct codzona
            into l_zona
            from serietel
           where codzona in
                 (select codzona
                    from zonatel
                   where codplan in
                         (SELECT o.codigon
                            FROM operacion.tipopedd t
                           INNER JOIN operacion.opedd o
                              ON (t.tipopedd = o.tipopedd)
                           WHERE o.abreviacion = 'TPIGSM/codplan'
                             AND t.descripcion = 'OPE-Config TPI - GSM'));

        else

          select to_number(codigoc)
            into ln_prodfax
            from opedd
           where tipopedd = 1085
             and abreviacion = 'CFAXSERVER_PRD';

          select count(1)
            into ln_faxserver
            from vtadetptoenl a
           where a.codsrv in
                 (select codigoc
                    from opedd
                   where tipopedd = 1085
                     and abreviacion = 'CFAXSERVER_SRV')
             and a.idproducto = ln_prodfax
             and a.numslc = cn1.numslc
             and a.numpto = cn1.numpto;

          if ln_faxserver > 0 then

            select distinct codzona
              into l_zona
              from serietel
             where codzona in
                   (select codzona
                      from zonatel
                     where codplan in
                           (select codplan
                              from planproducto
                             where idproducto = ln_prodfax))
               and codzona in
                   (select to_number(codigoc)
                      from opedd
                     where tipopedd = 1085
                       and abreviacion = 'CFAXSERVER_ZONA')
               and codubi = cn1.ubipto
               and rownum = 1;

          else

            l_zona := l_zona3Play_aut;
            if intraway.pq_sots_agendadas.f_verif_tp_tpi_coaxial(ln_idtareawf,
                                                                 a_idwf,
                                                                 ln_tarea,
                                                                 ln_tareadef) > 0 then

              l_zona := l_zona_TPILim_aut;
            end if;

          end if;
        end if;

        loop
          begin
            select count(*)
              into cnt_res_num
              from solot
             where codsolot = ln_codsolot
               and tiptra in
                   (select codigon
                      from crmdd
                     where abreviacion = trim('TIPTRA_ALT_NUM'));

            if cnt_res_num = 1 then

              select codnumtel
                into ls_codnumtel
                from reservatel
               where numslc = vv_numslc;

              select numero
                into vv_numeroini
                from numtel
               where codnumtel = ls_codnumtel;

              update inssrv
                 set estinssrv = 4
               where numslc = cn1.numslc
                 and tipinssrv = 3;
            else
              vv_numeroini := '';
            end if;

          exception
            when others then
              vv_numeroini := '';
              cnt_res_num  := 0;
          end;

          if vv_numeroini is null or vv_numeroini = '' then

            select f_get_numero_tel_itw(l_zona, cn1.ubipto)
              into vv_numeroini
              from dummy_ope;

          end if;

          if vv_numeroini is null or vv_numeroini = '0' then
            raise exceptioninventario;
          end if;

          select codnumtel
            into vn_codnumtel
            from numtel
           where numero = vv_numeroini;

          update numtel set estnumtel = 5 where codnumtel = vn_codnumtel;

          operacion.pq_cuspe_ope2.p_valida_numtel(vv_numeroini,
                                                  cn1.codcli,
                                                  ln_cod_error,
                                                  ls_des_error);

          if ln_cod_error < 0 then

            update numtel set estnumtel = 2 where numero = vv_numeroini;

            ls_des_error := 'Se cambio a estado Asignado al numero telefonico ' ||
                            vv_numeroini ||
                            ' ya que servicio se encuentra activo, hacer seguimiento. ' ||
                            ls_des_error;

            select d.descripcion
              into ls_email
              from tipopedd m, opedd d
             where m.tipopedd = d.tipopedd
               and m.abrev = 'EMAIL_PLAT_FIJA';

            insert into opewf.cola_send_mail_job
              (nombre, subject, destino, cuerpo, flg_env)
            values
              ('SGA-SoportealNegocio',
               'Asignacion de Numero Telefonico para Paquetes Intraway',
               ls_email,
               ls_des_error,
               '0');

            commit;

          else

            if cnt_res_num = 0 then
              insert into reservatel
                (codnumtel,
                 numslc,
                 numpto,
                 valido,
                 codcli,
                 estnumtel,
                 publicar)
              values
                (vn_codnumtel, vv_numslc, cn1.numpto, 1, cn1.codcli, 2, 0);
              commit;
            end if;

            exit;
          end if;
        end loop;

      end loop;

      p_asignar_numeros_ce(vv_numslc, v_mensaje, v_error);

      IF v_error = 0 THEN

        if operacion.pq_cuspe_ope.exist_paquete_tpi_gsm(vv_numslc) then

          SELECT n.imei, n.simcard, n.codinssrv
            INTO lc_imei, lc_simcard, ln_codinssrv
            FROM telefonia.reservatel r
           INNER JOIN numtel n
              ON (r.codnumtel = n.codnumtel)
           WHERE r.numslc = vv_numslc
             AND r.valido = 1;

          UPDATE operacion.inssrv
             SET imei = lc_imei, simcard = lc_simcard
           WHERE codinssrv = ln_codinssrv;

          operacion.pq_cuspe_ope.p_mail_wf_solot_tpigsm(a_idtareawf,
                                                        1,
                                                        l_subject,
                                                        l_cuerpo);

          SELECT tc.pre_mail
            INTO l_pre_mail
            FROM tareawfcpy tc
           WHERE tc.idtareawf = a_idtareawf;

          IF l_pre_mail IS NOT NULL THEN
            p_envia_correo_de_texto_att(l_subject, l_pre_mail, l_cuerpo);
          END IF;
        end if;

      ELSE
        RAISE exceptioninventario;
      END IF;
    end if;
  else
    telefonia.pq_portabilidad.p_asignacion_port_corp(ln_idtareawf,
                                                     a_idwf,
                                                     ln_tarea,
                                                     ln_tareadef);
  end if;

EXCEPTION
  WHEN exceptioncodsuc THEN
    select SQ_COLA_SEND_MAIL_JOB.nextval into l_countcola from DUMMY_OPWF;

    insert into opewf.cola_send_mail_job
      (idmail, nombre, subject, destino, cuerpo, flg_env)
    values
      (l_countcola,
       'SGA-SoportealNegocio',
       'Asignacion de Numero Telefonico para Paquetes Intraway',
       'SoporteTelefoniaFijayPortales@claro.com.pe',
       'No se realizo correctamente la asignacion de Numero Telefonico para el paquete de Intraway en el Proyecto ' ||
       vv_numslc,
       '0');

  WHEN exceptioninventario THEN
    select SQ_COLA_SEND_MAIL_JOB.nextval into l_countcola from DUMMY_OPWF;
    insert into opewf.cola_send_mail_job
      (idmail, nombre, subject, destino, cuerpo, flg_env)
    values
      (l_countcola,
       'SGA-SoportealNegocio',
       'Asignacion de Numero Telefonico para Paquetes Intraway',
       'DL-PE-Conmutacion@claro.com.pe',
       'No se asignó Numero telefonico por falta de disponibilidad para el proyecto:' ||
       vv_numslc,
       '0');

    commit;
end;
/
