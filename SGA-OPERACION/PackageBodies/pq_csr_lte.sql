CREATE OR REPLACE PACKAGE BODY OPERACION.pq_csr_lte IS

  /************************************************************************************************
  NOMBRE:     1.  OPERACION.PQ_CSR_LTE
  PROPOSITO:  PAquete para Generacion de SOT / Cierre de SOT de Corte Suspension y Reconexion segun REQUEST de la BSCS

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      15/10/2015   Emma Guzman         Guillermo Salcedo   PAquete para Generacion de SOT / Cierre de SOT de Corte Suspension y Reconexion segun REQUEST de la BSCS
                         Justiniano Condori
   2.0      10/06/2016   Dorian Sucasaca/    Eustaquio Gibaja /  SGA-SD-794552
                         Justiniano Condori  Mauro Zegarra /
   3.0      19/08/2016   Dorian Sucasaca                         PROY-20152 IDEA-24390 Proyecto LTE - 3Play inalámbrico- SD-911688
   4.0      18/10/2016   Dorian Sucasaca     Alex Alamo          SD_931807
   5.0      09/11/2016   Dorian Sucasaca     Mauro Zegarra       STR.FALLA.PROY-20152.SD794552-SGA
   6.0      09/11/2016   Justiniano Condori  Mauro Zegarra       PROY-20152 Proyecto LTE - 3Play inalámbrico-Servicios Adicionales TV
   7.0      06/04/2017   Justiniano Condori  Fanny Najarro       STR.SOL.PROY-20152.SGA_1
   8.0      08/05/2017   Luis Guzmán  		   Fanny Najarro       INC000000774220
   9.0      07/07/2017   Bernardo Quicaña    Mauro Zegarra
   10.0     17/07/2017   Luis Guzman         Tito Huertas        PROY-27792
   11.0     30/11/2017   Alejandro Milla                         INC000000989507    
   12.0     05/10/2017   Jose Arriola        Carlos Lazarte      PROY-25599 Alineacion contego Fase II
  /************************************************************************************************/

  FUNCTION f_obtiene_sot(av_cod_id IN VARCHAR2) RETURN NUMBER IS
    ln_codsolot NUMBER;
  BEGIN
    BEGIN
      SELECT nvl(MAX(si.codsolot), 0)
        INTO ln_codsolot
        FROM sales.sot_siac si
        JOIN operacion.solot s
          ON si.codsolot = s.codsolot
        JOIN operacion.tiptrabajo t
          ON s.tiptra = t.tiptra
       WHERE TRIM(si.cod_id) = av_cod_id
         AND t.tiptrs IN (1, 2);

      IF ln_codsolot = 0 THEN
        SELECT nvl(MAX(si.codsolot), 0)
          INTO ln_codsolot
          FROM sales.sot_sisact si
          JOIN operacion.solot s
            ON si.codsolot = s.codsolot
          JOIN operacion.tiptrabajo t
            ON s.tiptra = t.tiptra
         WHERE TRIM(si.cod_id) = av_cod_id
           AND t.tiptrs IN (1, 2);
        -- Ini 4.0
        IF ln_codsolot = 0 THEN
          select max(s.codsolot)
            into ln_codsolot
            from operacion.solot s, operacion.tiptrabajo t
           where s.tiptra        = t.tiptra
             and s.cod_id  = to_number(av_cod_id)
             and t.tiptrs        = 1;
        END IF;
        -- Fin 4.0
      END IF;
    END;
    RETURN ln_codsolot;
  EXCEPTION
    WHEN OTHERS THEN
      ln_codsolot := NULL;
      RETURN ln_codsolot;
  END;

  PROCEDURE p_genera_sot(an_resultado OUT NUMBER, av_mensaje OUT VARCHAR2) IS

    -- ini 4.0
    li_rp           INTEGER;
    li_rp_aux       INTEGER;
    ln_sot          NUMBER;
    ln_sot_aux      NUMBER;
    ln_sot_ant      NUMBER;
    li_r            INTEGER;
    ln_titra        NUMBER;
    ln_motivo       operacion.solot.codmotot%TYPE;
    lv_codcli       operacion.solot.codcli%TYPE;
    ln_tipsrv       operacion.solot.tipsrv%TYPE;
    lv_areasol      operacion.solot.areasol%TYPE;
    ln_ctrl_sot     integer;
    ln_sot_pen      varchar2(1000);
    l_wf            cusbra.br_sel_wf.wfdef%TYPE;
    ln_reg          number;
    ln_result       number;
    ln_msj          varchar2(1000);
    lv_tipo         VARCHAR2(1);
    lv_tiposol      varchar2(2); --6.0
    ln_tipequ       operacion.solotptoequ.tipequ%type;
    exc_solot       exception;
    exc_config      exception;
    exc_val_sot     exception;
    exc_wf_sot      exception;
    ln_tipo         number(2);
    ln_operacion    varchar2(20);

    CURSOR c_request IS
      select r.request_padre,
             r.request,
             r.customer_id,
             r.co_id,
             r.action_id,
             r.origen_prov,
             r.tipo_prod,
             r.status
        from tim.lte_control_prov@dbl_bscs_bf r
       where r.sot is null
         and r.origen_prov in
             (select b.codigoc
                from operacion.tipopedd a, operacion.opedd b
               where a.tipopedd = b.tipopedd
                 and b.codigoc = r.origen_prov
                 and a.abrev = 'CONF_LTE_ORI_EST'
                 and b.abreviacion = 'ORIGEN-PROVISION')
         and r.action_id in
             (select b.codigon
                from operacion.tipopedd a, operacion.opedd b
               where a.tipopedd = b.tipopedd
                 and b.codigoc = r.origen_prov
                 and a.abrev = 'TAREA_PROG_LTE'
                 and b.abreviacion in ('ALTA_PROGRAMADA', 'BAJA_PROGRAMADA'))
       order by r.request_padre asc, r.tipo_prod asc;
    -- Fin 4.0
  BEGIN
    -- Ini 4.0
    an_resultado := 0;
    av_mensaje   := 'Se ejecuto con éxito OPERACION.pq_csr_lte.p_genera_sot';
    li_rp_aux    := 0;

    FOR l_c_request IN c_request LOOP
      begin
        -- Inicio Asignacion de Variables
        begin
          ln_log               := null;
          ln_sot               := null;
          ln_log.request_padre := l_c_request.request_padre;
          ln_log.request       := l_c_request.request;
          ln_log.customer_id   := l_c_request.customer_id;
          ln_log.co_id         := l_c_request.co_id;
          ln_log.action_id     := l_c_request.action_id;
          ln_log.origen_prov   := l_c_request.origen_prov;
          ln_log.tipo_prod     := l_c_request.tipo_prod;
          ln_ctrl_sot          := 0;
          li_rp                := l_c_request.request_padre;
          li_r                 := l_c_request.request;
        end;
        -- Fin   Asignacion de Variables

        -- Inicio Control Gestion de SOT
        begin
          select count(1)
            into ln_ctrl_sot
            from tim.lte_control_prov@dbl_bscs_bf p, operacion.solot s
           where p.sot = s.codsolot
             and p.co_id = l_c_request.co_id
             and s.estsol in (select estsol
                                from operacion.estsol
                               where tipestsol in (1, 2, 3, 6))
             and s.estsol<>29  -- 5.0
             and p.request_padre <> l_c_request.request_padre;

          if ln_ctrl_sot > 0 then
            ln_sot_pen := null;
            for c_val_sot in (select sot
                                from tim.lte_control_prov@dbl_bscs_bf p,
                                     operacion.solot                  s
                               where p.sot = s.codsolot
                                 and p.co_id = l_c_request.co_id
                                 and s.estsol in (select estsol
                                                    from operacion.estsol
                                                   where tipestsol in (1, 2, 3, 6))

                                 and s.estsol<>29  -- 5.0
                                 and p.request_padre <> l_c_request.request_padre
                               group by sot) loop

              if ln_sot_pen is null then
                ln_sot_pen := c_val_sot.sot;
              else
                ln_sot_pen := ln_sot_pen || ',' || c_val_sot.sot;
              end if;
            end loop;
          end if;
        exception
          when others then
            ln_ctrl_sot := 0;
        end;

        if ln_ctrl_sot > 0 then
          raise exc_val_sot;
        end if;
        -- Fin Control Gestion de SOT

        --- Inicio Consulta de Configuraciones
        begin
          select o.codigon
            into ln_tipequ
            from operacion.tipopedd t, operacion.opedd o
           where t.tipopedd    = o.tipopedd
             and t.abrev       = 'TIPEQU_DTH_CONAX'
             and o.descripcion = 'Tarjeta';

          select b.codigon_aux, b.abreviacion
            into ln_tipo, ln_operacion
            from operacion.tipopedd a, operacion.opedd b
           where a.tipopedd = b.tipopedd
             and a.abrev    = 'TAREA_PROG_LTE'
             and b.codigoc  = l_c_request.origen_prov
             and b.codigon  = l_c_request.action_id;

          select codigon, to_number(o.abreviacion)
            into ln_titra, ln_motivo
            from operacion.tipopedd t, operacion.opedd o
           where t.tipopedd    = o.tipopedd
             and t.abrev       = 'TIP_TRA_CSR'
             and o.codigon_aux = to_char(l_c_request.action_id)
             and o.codigoc     = to_char(l_c_request.origen_prov);
        exception
          when others then
            raise exc_config;
        end;
        --- Fin Consulta de Configuraciones

        -- INI 10.0
        IF ln_tipo = 1 AND l_c_request.tipo_prod=fnd_provision_dth THEN
          p_genera_sot_adi(l_c_request.request, ln_sot, an_resultado, av_mensaje);
        -- FIN 10.0
        ELSE
          -- Inicio Generacion de SOT Suspencion, Reconexion, Cancelacion de Servicios SIAC/ OAC
          IF li_rp_aux <> li_rp THEN

            --- Inicio Generacion de SOT
            begin
              ln_sot_ant := f_obtiene_sot(l_c_request.co_id);

              select s.codcli, s.tipsrv, s.areasol
                into lv_codcli, ln_tipsrv, lv_areasol
                from operacion.solot s
               where s.codsolot = ln_sot_ant;

              p_insert_sot(lv_codcli, ln_titra, ln_tipsrv, ln_motivo, lv_areasol, ln_sot);
              p_insert_solotpto(ln_sot, l_c_request.co_id); -- 5.0
              p_actualiza_sot(ln_sot, l_c_request.co_id, l_c_request.customer_id);
              p_actualiza_provision_bscs(ln_sot, li_rp, '>> Generacion de SOT: Ok', null, 4);
              ln_log.sot := ln_sot;
              p_reg_log(ln_log);
            exception
              when others then
                raise exc_solot;
            end;
            --- Fin Generacion de SOT

            --- Inicio Asignacion de WF
            begin
              select count(1)
                into ln_reg
                from opewf.wf w
               where w.codsolot = ln_sot
                 and w.valido   = 1;

              if ln_reg = 0 then
                select wfdef
                  into l_wf
                  from cusbra.br_sel_wf
                 where tiptra = (select tiptra
                                   from operacion.solot
                                  where codsolot = ln_sot);

                operacion.pq_solot.p_asig_wf(ln_sot, l_wf);
                p_actualiza_provision_bscs(ln_sot, l_c_request.request_padre, '>> Asignacion de WF: Ok', null, 4);
                commit;
              end if;
            exception
              when others then
                raise exc_wf_sot;
            end;
            --- Fin    Asignacion de WF

            --- Inicio Generacion de Tablas Intermedia Conax
            IF l_c_request.tipo_prod = fnd_provision_dth THEN
              if ln_operacion = 'BAJA_PROGRAMADA' then
                -- Suspension, Desbloqueo, Cancelacion
                lv_tipo := '1';
                lv_tiposol:='9'; --6.0 --8.0
              elsif ln_operacion = 'ALTA_PROGRAMADA' then
                -- Reconexion, Debloqueo
                lv_tipo := '2';
                lv_tiposol:='8';--6.0  --8.0
              end if;
              sp_gen_bou_bscs(l_c_request.co_id, ln_sot, ln_tipequ, ln_log, lv_tipo, lv_tiposol, ln_result, ln_msj); --6.0
              if ln_result = -1 then
                sp_gen_bou_sga(l_c_request.co_id, ln_sot, ln_tipequ, ln_log, lv_tipo, lv_tiposol, ln_result, ln_msj); --6.0
                if ln_result = 0 then
                   p_actualiza_provision_bscs(ln_sot, l_c_request.request, '>> Recuperacion de Bouquet SGA: Ok', null, 3);
                else
                  goto final_reg;
                end if;
              elsif ln_result = 0 then
                p_actualiza_provision_bscs(ln_sot, l_c_request.request, '>> Recuperacion de Bouquet BSCS: Ok', null, 3);
              end if;
            END IF;
            --- Fin    Generacion de Tablas Intermedia Conax
            ln_sot_aux := ln_sot;
          ELSE
            ln_sot := ln_sot_aux;
            --- Inicio Generacion de Tablas Intermedia Conax
            IF l_c_request.tipo_prod = fnd_provision_dth THEN
              if ln_operacion = 'BAJA_PROGRAMADA' then
                -- Suspencion, Cancelacion
                lv_tipo := '1';
                lv_tiposol:='9'; --6.0 --8.0
              elsif ln_operacion = 'ALTA_PROGRAMADA' then
                -- Reconexion
                lv_tipo := '2';
                lv_tiposol:='8';--6.0 --8.0
              end if;
              sp_gen_bou_bscs(l_c_request.co_id, ln_sot, ln_tipequ, ln_log, lv_tipo, lv_tiposol, ln_result, ln_msj); --6.0
              if ln_result = -1 then
                sp_gen_bou_sga(l_c_request.co_id, ln_sot, ln_tipequ, ln_log, lv_tipo, lv_tiposol, ln_result, ln_msj); --6.0
                if ln_result = 0 then
                  p_actualiza_provision_bscs(ln_sot, l_c_request.request, '>> Recuperacion de Bouquet SGA: Ok', 99, 2);
                else
                  goto final_reg;
                end if;
              elsif ln_result = 0 then
                p_actualiza_provision_bscs(ln_sot, l_c_request.request, '>> Recuperacion de Bouquet BSCS: Ok', null, 3);
              end if;
            END IF;
            --- Fin Generacion de Tablas Intermedia Conax
          END IF;
          li_rp_aux := li_rp;
          -- Fin    Generacion de SOT Suspencion, Reconexion, Cancelacion de Servicios SIAC/ OAC
        END IF;
        commit;
      exception
        when exc_val_sot then
          ln_log.mensaje := '>> Generacion de SOT: Se Encuentran SOT con estado Pendiente de Cierre. ' || chr(13) ||
                            '   SOT Pendiente(s):' || to_char(ln_sot_pen)         || chr(13) ||
                            '   Contrato: '        || to_char(ln_log.co_id);
          p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, null,1);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        when exc_config then
          ln_log.mensaje := '>> Generacion de SOT: Error al Recuperar los Datos de las Configuraciones.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)     || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov) || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, null,1);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        when exc_solot then
          ln_log.mensaje := '>> Generacion de SOT: Error Durante la Generacion de la SOT.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)       || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)     || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)         || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov)   || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, null,1);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        when exc_wf_sot then
          ln_log.mensaje := '>> Generacion de SOT: Error Durante la Asignacion de WF.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)       || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)     || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)         || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov)   || chr(13) ||
                            '   SOT: '           || to_char(ln_sot)               || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, null,1);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        when others then
          ln_log.mensaje := '>> Generacion de SOT: Error al Ejecutar el Proceso Generacion de SOT, se registro una Excepcion.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)     || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                            '   Customer_id: '   || to_char(ln_log.customer_id) || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov) || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, 11, 1);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
      end;
      <<final_reg>>
      exit when c_request%notfound;
    END LOOP;
    -- Fin 4.0
  END;

  PROCEDURE p_cerrar_sot(an_resultado OUT NUMBER, av_mensaje OUT VARCHAR2) IS
    -- ini 4.0

    -- Cursor Registros Pendientes Cierre
    cursor c_sot_pendientes is
      select codsolot, customer_id, cod_id
        from operacion.solot
       where tiptra in (select distinct o.codigon
                          from operacion.tipopedd t,
                               operacion.opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev    = 'TIP_TRA_CSR')
         and estsol   = fnd_est_sot_eje;
    -- fin 4.0
  BEGIN
    -- Inicio Cierre de Tareas  4.0
    an_resultado := 0;
    av_mensaje   := 'Se ejecuto con éxito OPERACION.PQ_CSR_LTE.P_CERRAR_SOT';

    for l_sot_pend in c_sot_pendientes loop
      begin
        ln_log              := null;
        ln_log.sot          := l_sot_pend.codsolot;
        ln_log.customer_id  := l_sot_pend.customer_id;
        ln_log.co_id        := l_sot_pend.cod_id;

        -- cierre de tareas.
        for c_tareas in (select w.idtareawf
                           from opewf.tareawf w
                          where w.idwf in (select idwf
                                             from opewf.wf
                                            where codsolot = l_sot_pend.codsolot
                                              and estwf = 2)
                            and w.tareadef in ( select b.codigon
                                                  from operacion.tipopedd a, operacion.opedd b
                                                 where a.tipopedd = b.tipopedd
                                                   and a.abrev    = 'CONF_TAREAS_LTE' )
                            and w.esttarea not in (select esttarea
                                                     from opewf.esttarea
                                                    where tipesttar = 4)) loop

          opewf.pq_wf.p_chg_status_tareawf(c_tareas.idtareawf,
                                 4,
                                 4,
                                 0,
                                 sysdate,
                                 sysdate);
          commit;
        end loop;
      exception
        when others then
          ln_log.mensaje := '>> Cerrar SOT: Error durante la Ejecucion del SP' || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)           || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)           || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_log.sot, null, ln_log.mensaje, null, 5);
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
      end;
      <<final_reg>>
      exit when c_sot_pendientes%notfound;
    end loop;
    commit;
    -- Fin    Cierre de Tareas  4.0
  END;

  PROCEDURE p_insert_sot(v_codcli   IN solot.codcli%TYPE,
                         v_tiptra   IN solot.tiptra%TYPE,
                         v_tipsrv   IN solot.tipsrv%TYPE,
                         v_motivo   IN solot.codmotot%TYPE,
                         v_areasol  IN solot.areasol%TYPE,
                         a_codsolot OUT NUMBER) IS

  BEGIN
    a_codsolot := f_get_clave_solot();
    INSERT INTO solot
      (codsolot, codcli, estsol, tiptra, tipsrv, codmotot, areasol)
    VALUES
      (a_codsolot, v_codcli, 10, v_tiptra, v_tipsrv, v_motivo, v_areasol);
  END;

  PROCEDURE p_insert_solotpto(an_codsolot IN solot.codsolot%TYPE,

                              an_cod_id   IN solot.cod_id%TYPE) IS -- 5.0
    -- ini 5.0
    ln_solotpto     operacion.solotpto%rowtype;
    ln_val_det      number;
    ln_punto        number;
    ln_val_inssrv   number;
    ln_val_insprd   number;

    cursor c_servicios is
      select p.codsolot, p.punto, p.codinssrv, p.pid
        from operacion.solotpto p, operacion.solot s, operacion.tiptrabajo t
       where p.codsolot = s.codsolot
         and s.tiptra = t.tiptra
         and s.cod_id = an_cod_id
         and s.estsol in (select b.codigon
                            from operacion.tipopedd a, operacion.opedd b
                           where a.tipopedd = b.tipopedd
                             and a.abrev = 'CON_EST_SGA_LTE'
                             and b.abreviacion = 'ESTSOL')
         and p.pid > 0
         and t.tiptrs = 1
       order by p.codsolot, p.punto;
    -- fin 5.0
  BEGIN
    -- ini 5.0
    for c_serv in c_servicios loop
      ln_val_det := 0;

      select count(1)
        into ln_val_det
        from solotpto
       where codsolot  = an_codsolot
         and codinssrv = c_serv.codinssrv
         and pid       = c_serv.pid;

      select count(1)
        into ln_val_inssrv
        from operacion.inssrv ins
       where ins.codinssrv = c_serv.codinssrv
         and ins.estinssrv in (select b.codigon
                                 from operacion.tipopedd a, operacion.opedd b
                                where a.tipopedd = b.tipopedd
                                  and a.abrev = 'CON_EST_SGA_LTE'
                                  and b.abreviacion = 'SRV');

      select count(1)
        into ln_val_insprd
        from operacion.insprd ip
       where ip.Pid = c_serv.pid
         and ip.estinsprd in (select b.codigon
                                from operacion.tipopedd a, operacion.opedd b
                               where a.tipopedd = b.tipopedd
                                 and a.abrev = 'CON_EST_SGA_LTE'
                                 and b.abreviacion = 'PRD');

      if ( ln_val_det = 0 and ln_val_inssrv > 0 and ln_val_insprd > 0 )then
        select *
          into ln_solotpto
          from solotpto
         where codsolot = c_serv.codsolot
           and punto    = c_serv.punto;

        ln_solotpto.codsolot := an_codsolot;
        ln_solotpto.punto    := null;
        operacion.pq_solot.p_insert_solotpto(ln_solotpto, ln_punto);
      end if;
    end loop;
    -- fin 5.0
  END;

  PROCEDURE p_bouquets_lineal(in_bouquet  IN VARCHAR2,
                              out_bouquet OUT dbms_utility.uncl_array) IS
    ln_cnt   NUMBER;
    bouquets dbms_utility.uncl_array;

  BEGIN
    dbms_utility.comma_to_table(TRIM(REPLACE('"' || in_bouquet || '"',
                                             ',',
                                             '","')),
                                ln_cnt,
                                bouquets);
    FOR i IN 1 .. ln_cnt LOOP
      out_bouquet(i) := TRIM(REPLACE(bouquets(i), '"', ''));
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20080, SQLERRM);
  END;

  PROCEDURE p_actualiza_desactiva(p_idtareawf tareawf.idtareawf%TYPE,
                                  p_idwf      tareawf.idwf%TYPE,
                                  p_tarea     tareawf.tarea%TYPE,
                                  p_tareadef  tareawf.tareadef%TYPE) IS
    l_codsolot solot.codsolot%TYPE;
    l_tiptrs   tiptrabajo.tiptrs%TYPE;
    -- ini 2.0
    ln_resp    numeric := 0;
    lv_mensaje varchar2(3000);
    l_resp_cons  number;
    l_mens_cons  varchar(4000);
    l_resp_veri  number;
    l_mens_veri  varchar(4000);
    -- fin 2.0
  BEGIN
    -- ini 2.0
    -- Consulta de SOT
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;

    -- Consulta de Archivos en Conax
    p_consultar_conax(l_codsolot,l_resp_cons,l_mens_cons);
    if (l_resp_cons = 0 or l_resp_cons = 2) then
      ln_log.sot     := l_codsolot;
      ln_log.mensaje := '  TAREA SUSPENSION/ CANCELACION: Se ejecuto el SP P_CONSULTAR_CONAX, Mensaje: ' || chr(13) || l_mens_cons;
      p_reg_log(ln_log);

      -- Verificacion de Archivos en Conax
      p_verificar_conax(l_codsolot, l_resp_veri, l_mens_veri);
      if (l_resp_veri = 0 or l_resp_veri = 2)then
        ln_log.sot     := l_codsolot;
        ln_log.mensaje := '  TAREA SUSPENSION/ CANCELACION: Se ejecuto el SP P_CONSULTAR_CONAX, Mensaje: ' || chr(13) || l_mens_veri;
        p_reg_log(ln_log);
      elsif (l_resp_veri = -1 or l_resp_veri = -2) then
          ln_log.sot     := l_codsolot;
          ln_log.mensaje := ' TAREA SUSPENSION/ CANCELACION: Error al Ejecutar SP P_VERIFICAR_CONAX, Mensaje: ' || chr(13) || l_mens_veri;
          p_reg_log(ln_log);

          -- Error: Tarea Cambia a estado Generado.
          opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                           1,
                                           1,
                                           0,
                                           sysdate,
                                           sysdate);
          return;
      end if;
    elsif (l_resp_cons = -1 or  l_resp_cons = -2 or l_resp_cons = 3) then -- 3.0
      ln_log.sot     := l_codsolot;
      ln_log.mensaje := '  TAREA SUSPENSION/ CANCELACION: Error al Ejecutar SP P_CONSULTAR_CONAX, Mensaje: ' || chr(13) || l_mens_cons;
      p_reg_log(ln_log);

      -- Error: Tarea Cambia a estado Generado.
      opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    -- Inicio Consulta de Envio y Verificacion de Archivos en Conax

    -- consulta tipo de transaccion
    select tt.tiptrs
      into l_tiptrs
      from operacion.tiptrabajo tt
      join operacion.solot s
        on s.tiptra   = tt.tiptra
     where s.codsolot = l_codsolot;

    -- tiptrs: 4 - suspension
    if l_tiptrs = 4 then
      update operacion.inssrv i
         set i.estinssrv = 2
       where i.codinssrv in (select s.codinssrv
                               from operacion.solotpto s
                              where s.codsolot = l_codsolot);

      update operacion.insprd ip
         set ip.estinsprd = 2
       where ip.pid in (select s.pid
                               from operacion.solotpto s
                              where s.codsolot = l_codsolot);

      ln_log.sot     :=  l_codsolot;
      ln_log.mensaje :=  '  TAREA SUSPENSION DE SERVICIOS: Se completo la Suspension de los Servicios en el SGA.';
      p_reg_log(ln_log);

    -- tiptrs: 5 - cancelacion, 10 - corte
    elsif l_tiptrs = 5 or l_tiptrs = 10 then

      -- Inicio Liberacion de Numeros.
      p_libera_numeros(l_codsolot, ln_resp, lv_mensaje);
      if ln_resp <> 0 then
          ln_log.sot     :=  l_codsolot;
          ln_log.mensaje :=  'TAREA CANCELACION DE SERVICIOS: Se generaron Errores al Ejecutar La Liberacion de Numero. ' || chr(13) ||
                             ' - Codigo Error: '  || to_char(ln_resp)        || chr(13) ||
                             ' - Mensaje Error: ' || to_char(lv_mensaje)     || chr(13) ||
                             ' - Linea Error: '   || dbms_utility.format_error_backtrace ;
          p_reg_log(ln_log);
          -- La tarea Cambia a Estado Generado
          opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                           1,
                                           1,
                                           0,
                                           sysdate,
                                           sysdate);
        return;
      else
        ln_log.sot     :=  l_codsolot;
        ln_log.mensaje :=  'TAREA CANCELACION DE SERVICIOS: '  ||  lv_mensaje;
        p_reg_log(ln_log);
      end if;
      -- fin   Liberacion de Numeros.

      -- Inicio Liberacion de Equipos
      p_libera_equipos(l_codsolot, ln_resp, lv_mensaje);
      if ln_resp <> 0 then
          ln_log.sot     :=  l_codsolot;
          ln_log.mensaje :=  'TAREA CANCELACION DE SERVICIOS:Se generaron Errores al Ejecutar La Liberacion de Equipos, ' || chr(13) ||
                             ' - Codigo Error: '  || to_char(ln_resp)        || chr(13) ||
                             ' - Mensaje Error: ' || to_char(lv_mensaje)        || chr(13) ||
                             ' - Linea Error: '   || dbms_utility.format_error_backtrace ;
          p_reg_log(ln_log);
          -- La tarea Cambia a Estado Generado
          opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                           1,
                                           1,
                                           0,
                                           sysdate,
                                           sysdate);
        return;
      else
        ln_log.sot     :=  l_codsolot;
        ln_log.mensaje :=  'TAREA CANCELACION DE SERVICIOS: Mensaje '  ||  lv_mensaje;
        p_reg_log(ln_log);
      end if;
      -- Fin   Liberacion de Equipos

      -- Inicio Cancelacion de Servicios del SGA
      update operacion.inssrv i
         set i.estinssrv = 3
       where i.codinssrv in (select s.codinssrv
                               from operacion.solotpto s
                              where s.codsolot = l_codsolot);

      update operacion.insprd ip
         set ip.estinsprd = 3
       where ip.pid in (select s.pid
                               from operacion.solotpto s
                              where s.codsolot = l_codsolot);

      ln_log.sot     :=  l_codsolot;
      ln_log.mensaje :=  'TAREA CANCELACION DE SERVICIOS: Se completo la Cancelacion de los Servicios en el SGA.';
      p_reg_log(ln_log);
      -- fin Cancelacion de Servicios del SGA
    end if;
  exception
    when others then
      raise_application_error(-20000,
                              'TAREA SUSPENCION/ CANCELACION DE SERVICIOS, Error al Ejecutar SP: ' || $$plsql_unit || '.P_ACTUALIZA_DESACTIVA' || chr(13) ||
                              ' - SOT: '              || to_char(l_codsolot)  || chr(13) ||
                              ' - Idtareawf: '        || to_char(p_idtareawf) || chr(13) ||
                              ' - Idwf: '             || to_char(p_idwf)      || chr(13) ||
                              ' - Tarea: '            || to_char(p_tarea)     || chr(13) ||
                              ' - Tareadef: '         || to_char(p_tareadef)  || chr(13) ||
                              ' - Codigo de Error: '  || to_char(sqlcode)     || chr(13) ||
                              ' - Mensaje de Error: ' || to_char(sqlerrm)     || chr(13) ||
                              ' - Linea de Error: '   || dbms_utility.format_error_backtrace);
    -- fin 2.0
  END;

  PROCEDURE p_actualiza_activa(p_idtareawf tareawf.idtareawf%TYPE,
                               p_idwf      tareawf.idwf%TYPE,
                               p_tarea     tareawf.tarea%TYPE,
                               p_tareadef  tareawf.tareadef%TYPE) IS
    l_codsolot solot.codsolot%TYPE;
    l_tiptrs   tiptrabajo.tiptrs%TYPE;
    -- ini 2.0
    l_resp_cons  number;
    l_mens_cons  varchar(4000);
    l_resp_veri  number;
    l_mens_veri  varchar(4000);
    -- fin 2.0
  BEGIN
    -- ini 2.0
    -- consulta sot
    select t.codsolot into l_codsolot from wf t where t.idwf = p_idwf;

    -- consulta tipo de transaccion
    select tt.tiptrs
      into l_tiptrs
      from operacion.tiptrabajo tt
      join operacion.solot s
        on s.tiptra   = tt.tiptra
     where s.codsolot = l_codsolot;

    -- tiptrs: 1 - activacion, 2 - upgrade, 3 - reconexion
    if l_tiptrs = 1 or l_tiptrs = 2 or l_tiptrs = 3 then

      -- Consulta de Archivos en Conax
      p_consultar_conax(l_codsolot,l_resp_cons,l_mens_cons);
      if (l_resp_cons = 0 or l_resp_cons = 2 ) then
        ln_log.sot     := l_codsolot;
        ln_log.mensaje := 'TAREA RECONEXION DE SERVICIOS: Se ejecuto el SP P_CONSULTAR_CONAX, Mensaje: ' || chr(13) || l_mens_cons;
        p_reg_log(ln_log);

        -- Verificacion de Archivos en Conax
        p_verificar_conax(l_codsolot, l_resp_veri, l_mens_veri);
        if (l_resp_veri = 0 or l_resp_veri = 2)then
          ln_log.sot     := l_codsolot;
          ln_log.mensaje := 'TAREA RECONEXION DE SERVICIOS: Se ejecuto el SP P_CONSULTAR_CONAX, Mensaje: ' || chr(13) || l_mens_veri;
          p_reg_log(ln_log);
        elsif (l_resp_veri = -1 or l_resp_veri = -2) then
            ln_log.sot     := l_codsolot;
            ln_log.mensaje := 'TAREA RECONEXION DE SERVICIOS: Se Generaron Errores al Ejecutar el SP P_VERIFICAR_CONAX, Mensaje: ' || chr(13) || l_mens_veri;
            p_reg_log(ln_log);

            -- Error: Tarea Cambia a estado Generado.
            opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                             1,
                                             1,
                                             0,
                                             sysdate,
                                             sysdate);
            return;
        end if;
      elsif (l_resp_cons = -1 or  l_resp_cons = -2 or l_resp_cons = 3) then -- 3.0
        ln_log.sot     := l_codsolot;
        ln_log.mensaje := 'TAREA RECONEXION DE SERVICIOS: Se Generaron Errores al Ejecutar el SP P_CONSULTAR_CONAX, mensaje: ' || chr(13) || l_mens_cons;
        p_reg_log(ln_log);

        -- Error: Tarea Cambia a estado Generado.
        opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                         1,
                                         1,
                                         0,
                                         sysdate,
                                         sysdate);
        return;
      end if;

      -- actualiza informacion del sga
      update operacion.inssrv i
         set i.estinssrv = 1
       where i.codinssrv in (select s.codinssrv
                               from operacion.solotpto s
                              where s.codsolot = l_codsolot);

      update operacion.insprd ip
         set ip.estinsprd = 1
       where ip.pid in (select s.pid
                          from operacion.solotpto s
                         where s.codsolot = l_codsolot);

      ln_log.sot     :=  l_codsolot;
      ln_log.mensaje :=  'TAREA RECONEXION DE SERVICIOS: Se completo la Reconexion de los Servicios en el SGA.';
      p_reg_log(ln_log);
    end if;
  exception
    when others then
      raise_application_error(-20000,
                              'TAREA RECONEXION DE SERVICIOS, Error al Ejecutar SP: ' || $$plsql_unit || '.P_ACTUALIZA_ACTIVA' || chr(13) ||
                              ' - SOT: '              || to_char(l_codsolot)  || chr(13) ||
                              ' - Idtareawf: '        || to_char(p_idtareawf) || chr(13) ||
                              ' - Idwf: '             || to_char(p_idwf)      || chr(13) ||
                              ' - Tarea: '            || to_char(p_tarea)     || chr(13) ||
                              ' - Tareadef: '         || to_char(p_tareadef)  || chr(13) ||
                              ' - Codigo de Error: '  || to_char(sqlcode)     || chr(13) ||
                              ' - Mensaje de Error: ' || to_char(sqlerrm)     || chr(13) ||
                              ' - Linea de Error: '   || dbms_utility.format_error_backtrace);
     -- fin 2.0
  END;

  -- Ini 2.0
  /*  PROCEDURE p_insert_serv_ad(av_cod_id   IN solot.codcli%TYPE,
                               an_codsolot     IN solot.codsolot%TYPE,
                               a_idserv    in sales.servicio_sisact.idservicio_sisact%type)
  IS
  l_count number;
  l_codsrv sales.servicio_sisact.codsrv%type;
  l_codcli solot.codcli%type;
  l_estado operacion.inssrv.estinssrv%type;
  l_tipo operacion.inssrv.tipinssrv%type;
  ls_descri varchar2(100);

  BEGIN
    select codcli into l_codcli from solot where codsolot = an_codsolot;
    select count(s.idservicio_sisact) into l_count from sales.servicio_sisact s where s.idservicio_sisact  = a_idserv;
    if l_count > 0 then
      l_tipo := 2;
      select s.codsrv into l_codsrv  from sales.servicio_sisact s where s.idservicio_sisact  = a_idserv;
      select dscsrv into ls_descri from tystabsrv where codsrv = l_codsrv;

      insert into inssrv (codcli,codsrv,tipinssrv,descripcion)
      values(l_codcli, l_codsrv, l_tipo, ls_descri );

    end if;


  END;*/
  -- Fin 2.0
  /* **********************************************************************************************/

  -- ini 2.0
 function f_obtener_codsrv(a_SNCODE in integer) return varchar2 is    --ini 11.0
  v_cod_siac        varchar2(20);
  v_codsrv          sales.servicio_sisact.codsrv%TYPE;   
  ls_gsrvc_codigo   varchar2(5); 
     
  begin
      ls_gsrvc_codigo := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('GSRVC_CODIGO');
  
      select servv_codigo
        into v_cod_siac
        from usrpvu.sisact_ap_servicio@dbl_pvudb
       where servv_id_bscs = a_SNCODE 
         and gsrvc_codigo = ls_gsrvc_codigo;     
  
      If v_cod_siac is not null then
        select ss.codsrv
          into v_codsrv
          from sales.servicio_sisact ss
         where ss.idservicio_sisact = v_cod_siac;
      End If;
    return v_codsrv;
  exception
    when others then
      return null;
  end;  -- fin 11.0  
  
  procedure p_genera_sot_adi(an_request   in number,
                             an_sot       out number,
                             an_resultado out number,
                             av_mensaje   out varchar2) is
    li_rp           integer;
    ln_sot          number;
    ln_sot_ant      number;
    li_r            integer;
    ln_solot        operacion.solot%rowtype;
    lv_codsrv       operacion.solotpto.codsrvnue%type;
    id_proc         operacion.tab_rec_csr_lte_cab.idprocess%type;
    lv_bouquet_bscs varchar2(500);
    out_bouquet     dbms_utility.uncl_array;
    lv_tipo         varchar2(1);
    lv_tiposol      varchar2(1); --6.0
    ln_solotpto     operacion.solotpto%rowtype;
    ln_punto        operacion.solotpto.punto%type;
    ln_tipequ       operacion.solotptoequ.tipequ%type;
    ln_sot_eq       operacion.solot.codsolot%type;
    ln_cnt_tar      number;
    exc_consulta    exception;
    exc_gen_sot     exception;
    exc_tarjeta     exception;
    exc_bouquet     exception;
    exc_wf_sot      exception; --6.0
    exc_sncode      exception; --6.0
    exc_status      exception; --6.0
    l_wf            number; --6.0
    ln_reg          number; --6.0
    ln_count_tar    number; --9.0
    ln_operacion    varchar2(20);
    -- ini 11.0
    ls_franjahoraria varchar2(10);
    ls_feccom        varchar2(10);
    exc_codsiac      exception;     
    -- fin 11.0
    cursor c_request is
      select r.request_padre,
            r.request,
            r.customer_id,
            r.co_id,
            r.action_id,
            r.origen_prov,
            r.tipo_prod,
            r.sncode_adic,
            r.id_servicio, --6.0
      r.userid, --6.0
      r.status --6.0
       from tim.lte_control_prov@dbl_bscs_bf r
      where r.sot is null
        and r.request_padre is not null
        and r.origen_prov in
            (select b.codigoc
               from operacion.tipopedd a, operacion.opedd b
              where a.tipopedd = b.tipopedd
                and b.codigoc  = r.origen_prov
                and a.abrev    = 'CONF_LTE_ORI_EST'
                and b.abreviacion = 'ORIGEN-PROVISION')
        and r.status in (select b.codigon
                           from operacion.tipopedd a, operacion.opedd b
                          where a.tipopedd = b.tipopedd
                            and b.codigoc  = r.tipo_prod
                            and a.abrev    = 'CONF_LTE_ORI_EST'
                            and b.abreviacion = 'ESTADO-OK')
        and r.action_id in (select b.codigon
                             from tipopedd a, opedd b
                            where a.tipopedd = b.tipopedd
                              and a.abrev = 'TAREA_PROG_LTE'
                             and b.abreviacion in ('ALTA_PROGRAMADA', 'BAJA_PROGRAMADA')
                             and b.codigon     = to_char(r.action_id)
                             and b.codigoc     = to_char(r.origen_prov)
                             and b.codigon_aux = 1)
             and r.request = an_request;

    cursor c_tarjetas is
      select s.numserie
        from operacion.solotptoequ s
       where s.codsolot = ln_sot_eq
         and s.tipequ   = ln_tipequ;

  begin
    an_resultado := 0;
    av_mensaje   := 'Servicios Adicionales LTE: se ejecuto con éxito OPERACION.PQ_CSR_LTE.P_GENERA_SOT_ADI: ';
    for l_c_request in c_request loop
      begin
        li_rp                := l_c_request.request_padre;
        li_r                 := l_c_request.request;
        lv_codsrv            := null;  -- 9.0 f_obtiene_codsrv(l_c_request.id_servicio);
        ln_sot_ant           := f_obtiene_sot(l_c_request.co_id);
        ln_log               := null;
        ln_log.request_padre := l_c_request.request_padre;
        ln_log.request       := l_c_request.request;
        ln_log.customer_id   := l_c_request.customer_id;
        ln_log.co_id         := l_c_request.co_id;
        ln_log.action_id     := l_c_request.action_id;
        ln_log.origen_prov   := l_c_request.origen_prov;
        ln_log.tipo_prod     := l_c_request.tipo_prod;

        -- Ini 6.0
        -- Validaciones
        -- Validando el SNCODE
        if l_c_request.sncode_adic is null then
            raise exc_sncode;
        end if;
        -- Validando que el status no sea 11
        if l_c_request.status <> 99 then
            raise exc_status;
        end if;
        -- Fin 6.0
        -- Inicio Bloque Consultas
        begin
          select codigon, to_number(o.abreviacion)
            into ln_solot.tiptra, ln_solot.codmotot
            from operacion.tipopedd t,
                 operacion.opedd o
           where t.tipopedd    = o.tipopedd
             and t.abrev       = 'TIP_TRA_CSR'
             and o.codigon_aux = l_c_request.action_id
             and o.codigoc     = to_char(l_c_request.origen_prov);

          select b.abreviacion
            into ln_operacion
            from tipopedd a, opedd b
           where a.tipopedd    = b.tipopedd
             and a.abrev       = 'TAREA_PROG_LTE'
             and b.codigon     = l_c_request.action_id
             and b.codigoc     = to_char(l_c_request.origen_prov)
             and b.codigon_aux = 1;

          select s.codcli, s.tipsrv, s.areasol
            into ln_solot.codcli, ln_solot.tipsrv, ln_solot.areasol
            from operacion.solot s
           where s.codsolot = ln_sot_ant;

          select descripcion, direccion, codubi, codpostal, idplataforma
            into ln_solotpto.descripcion,
                 ln_solotpto.direccion,
                 ln_solotpto.codubi,
                 ln_solotpto.codpostal,
                 ln_solotpto.idplataforma
            from operacion.solotpto
           where codsolot = ln_sot_ant
             and rownum   = 1;

          select o.codigon
            into ln_tipequ
            from operacion.tipopedd t,
                 operacion.opedd o
           where t.tipopedd    = o.tipopedd
             and t.abrev       = 'TIPEQU_DTH_CONAX'
             and o.descripcion = 'Tarjeta';

        exception
          when others then
            raise exc_consulta;
        end;
        -- Fin    Bloque Consultas

        -- Ini 9.00 Bloque Validacion
        -- funcion recupera los bouquets del bscs
        lv_bouquet_bscs := tim.pp004_siac_lte.fn_obtiene_buquets@dbl_bscs_bf(l_c_request.sncode_adic);
        if lv_bouquet_bscs is null then
          raise exc_bouquet;
        end if;
        -- funcion recupera la sot
        ln_sot_eq := f_sot_equipo(l_c_request.co_id);
        select count(s.numserie)
          into ln_count_tar
          from operacion.solotptoequ s
         where s.codsolot = ln_sot_eq
           and s.tipequ   = ln_tipequ;
        if ln_count_tar = 0 then
          raise exc_tarjeta;
        end if;
        -- Fin 9.00 Bloque Validacion

        --ini 11.0
        ls_franjahoraria     := pq_sga_iw.f_obtiene_valores_scr('franjaHoraria');
        ls_feccom            := to_char(Sysdate,'dd/mm/yyyy');
        ln_solot.feccom      := to_date(ls_feccom || ls_franjahoraria, 'dd/mm/yyyy hh24:mi');
        
      
         
        lv_codsrv            := f_obtener_codsrv(l_c_request.sncode_adic);
        if lv_codsrv is null then
           raise exc_codsiac;
        end if;
        -- fin 11.0

        -- Inicio Bloque Creacion de SOT
        begin
          ln_solot.estsol      := fnd_est_sot_gen;
          ln_solot.observacion := 'Se genero SOT Informativa para Servicios Adicionales.';
          -- generacion de solot
          operacion.pq_solot.p_insert_solot(ln_solot, ln_sot);
          -- Actualizar Datos de SOT
          p_actualiza_sot(ln_sot, l_c_request.co_id, l_c_request.customer_id);
          -- Ini 6.0
      -- Actualizando usuario de SOT
      update operacion.solot
         set codusu = l_c_request.userid
         where codsolot = ln_sot;
          -- Instanciando el Cod. de Servicio de TV de la Venta
          ln_solotpto.codinssrv := f_consul_codinssrv(ln_log.tipo_prod,ln_sot_ant);
          -- Fin 6.0
          ln_solotpto.codsolot     := ln_sot;
          ln_solotpto.codsrvnue    := lv_codsrv;
          ln_solotpto.cantidad     := 1;
          ln_solotpto.tipo         := 2;
          ln_solotpto.estado       := 1;
          ln_solotpto.visible      := 1;
          -- generacion de solotpto
          operacion.pq_solot.p_insert_solotpto(ln_solotpto, ln_punto);
        exception
          when others then
            raise exc_gen_sot; -- 9.0
        end;
        -- Fin    Bloque Creacion de SOT
        -- Inicio Bloque Generacion de estructura
        if l_c_request.tipo_prod = fnd_provision_dth then
          if ln_operacion =  'BAJA_PROGRAMADA' then
            lv_tipo := '1';
      lv_tiposol := '9';
          elsif ln_operacion = 'ALTA_PROGRAMADA'  then
            lv_tipo := '2';
      lv_tiposol := '8';
          end if;
          -- creacion de registro: tab_rec_csr_lte_cab
          insert into operacion.tab_rec_csr_lte_cab
            (idprocess, codsolot, tipo, fecreg, usureg, tiposolicitud, flg_recarga, estado) --6.0
          values
            (operacion.sq_tab_csr_lte_cab.nextval, ln_sot, lv_tipo, sysdate, user, lv_tiposol, 0, 1) --6.0
          returning idprocess into id_proc;
          -- procedimiento almacena los bouquets en un array
          p_bouquets_lineal(lv_bouquet_bscs, out_bouquet);
          for cx in c_tarjetas loop
            for i in 1 .. out_bouquet.count loop
              -- validamos que el cursor devuelva datos: tarjeta.
              ln_cnt_tar := c_tarjetas%rowcount;
              -- creacion de registro: tab_rec_csr_lte_det
              insert into operacion.tab_rec_csr_lte_det
                (idprocess_det, idprocess, bouquet, numserie_tarjeta, fecreg, usureg)
              values
                (operacion.sq_tab_csr_lte_det.nextval, id_proc, out_bouquet(i), cx.numserie, sysdate, user);
            end loop;
          end loop;
          if ln_cnt_tar <= 0 or ln_cnt_tar is null then
            raise exc_tarjeta;
          end if;
          -- Ini 6.0
          begin
              select count(1)
                into ln_reg
                from opewf.wf w
               where w.codsolot = ln_sot
                 and w.valido   = 1;

              if ln_reg = 0 then
                select wfdef
                  into l_wf
                  from cusbra.br_sel_wf
                 where tiptra = (select tiptra
                                   from operacion.solot
                                  where codsolot = ln_sot);

                operacion.pq_solot.p_asig_wf(ln_sot, l_wf);
                p_actualiza_provision_bscs(ln_sot, l_c_request.request_padre, '>> Asignacion de WF: Ok', null, 4);
                commit;
              end if;
          exception
             when others then
               raise exc_wf_sot;
          end;
          -- Fin 6.0
          ln_log.sot     := ln_sot;
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), Se Ejecuto correctamente SOT:' || ln_sot;
          p_actualiza_provision_bscs(ln_sot, li_rp, ln_log.mensaje, null,4); --6.0
          p_reg_log(ln_log);
          an_sot := ln_sot;
        end if;
        -- Fin    Bloque Generacion de estructura
      exception
        -- Ini 6.0
        when exc_sncode then
          ln_log.mensaje := '>> Generacion de SOT: Error Durante la Sustraccion de SNCODE de BSCS.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)       || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)     || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)         || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov)   || chr(13) ||
                            '   Customer_ID: '   || to_char(ln_log.customer_id)   || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, li_r, ln_log.mensaje, 11,7); --9.0
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        when exc_wf_sot then
          ln_log.mensaje := '>> Generacion de SOT: Error Durante la Asignacion de WF.' || chr(13) ||
                            '   Request: '       || to_char(ln_log.request)       || chr(13) ||
                            '   Action_ID: '     || to_char(ln_log.action_id)     || chr(13) ||
                            '   Contrato: '      || to_char(ln_log.co_id)         || chr(13) ||
                            '   Origen: '        || to_char(ln_log.origen_prov)   || chr(13) ||
                            '   SOT: '           || to_char(ln_sot)               || chr(13) ||
                            '   Codigo Error: '  || to_char(sqlcode)              || chr(13) ||
                            '   Mensaje Error: ' || to_char(sqlerrm)              || chr(13) ||
                            '   Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(ln_sot, li_r, ln_log.mensaje, 11,7); --9.0
          p_reg_log(ln_log);
          rollback;
          goto final_reg;
        -- Fin 6.0
        when exc_consulta then
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), Error en la Ejecucion de Consultas,' || chr(13) ||
                            ' - Request: '        || to_char(ln_log.request) || chr(13) ||
                            ' - Codigo Error: '   || to_char(sqlcode)        || chr(13) ||
                            ' - Mensaje Error: '  || to_char(sqlerrm)        || chr(13) ||
                            ' - Linea de Error: ' || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(null, li_r, ln_log.mensaje, 11, 7);  --9.0
          p_reg_log(ln_log);
          goto final_reg;
        when exc_gen_sot then
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), No se puede Generar la SOT,' || chr(13) ||
                            ' - Request: '        || to_char(ln_log.request) || chr(13) ||
                            ' - Codigo Error: '   || to_char(sqlcode)        || chr(13) ||
                            ' - Mensaje Error: '  || to_char(sqlerrm)        || chr(13) ||
                            ' - Linea de Error: ' || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(null, li_r, ln_log.mensaje, 11, 7); --9.0
          p_reg_log(ln_log);
          rollback; -- 9.0
          goto final_reg;
        when exc_bouquet then
          ln_log.mensaje :=  'SHELL_GENERAR_SOT: Generacion SOT(Adicional), No se puede Recuperar los Datos de la Bouquet,' || chr(13) ||
                             ' - Request: '       || to_char(ln_log.request) || chr(13) ||
                             ' - Codigo Error: '  || to_char(sqlcode)        || chr(13) ||
                             ' - Mensaje Error: ' || to_char(sqlerrm)        || chr(13) ||
                             ' - Linea Error: '   || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs( null, li_r, ln_log.mensaje, 11, 7);  --9.0
          p_reg_log(ln_log);                                     -- 3.0
          rollback; -- 9.0
          goto final_reg;                                        -- 3.0
        when exc_tarjeta then
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), No se puede Recuperar los Datos de la Tarjeta,' || chr(13) ||
                            ' - Request: '        || to_char(ln_log.request) || chr(13) ||
                            ' - Codigo Error: '   || to_char(sqlcode)        || chr(13) ||
                            ' - Mensaje Error: '  || to_char(sqlerrm)        || chr(13) ||
                            ' - Linea de Error: ' || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(null, li_r, ln_log.mensaje, 11, 7);  --9.0
          p_reg_log(ln_log);
          rollback; -- 9.0
          goto final_reg;
        when exc_codsiac then   --ini 11.0
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), No se pudo determinar el código del servicio (CODSRV),' || chr(13) ||
                            ' - Request: '                             || to_char(ln_log.request)         || chr(13) ||
                            ' - en la llamada a: '                     || 'f_obtener_codsrv'              || chr(13) ||
                            ' - Con Param. l_c_request.sncode_adic: '  || to_char(l_c_request.sncode_adic)|| chr(13) ||
                            ' - Linea de Error: '                      || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(null, li_r, ln_log.mensaje, 11, 7);  --9.0
          p_reg_log(ln_log);
          rollback; 
          goto final_reg;      --fin 11.0
        when others then
          ln_log.mensaje := 'SHELL_GENERAR_SOT: Generacion SOT(Adicional), No se Completo La generacion de la SOT, ' || chr(13) ||
                            ' - Request: '         || to_char(ln_log.request) || chr(13) ||
                            ' - Codigo Error: '    || to_char(sqlcode)        || chr(13) ||
                            ' - Mensaje Error: '   || to_char(sqlerrm)        || chr(13) ||
                            ' - Linea de Error: '  || dbms_utility.format_error_backtrace;
          p_actualiza_provision_bscs(null, li_r, ln_log.mensaje, 11, 7); --9.0
          p_reg_log(ln_log);
          rollback; -- 9.0
          goto final_reg;
      end;
      <<final_reg>>
      exit when c_request%notfound;
    end loop;
  end;

  procedure p_gen_archivo_conax_post(ac_tiposolicitud operacion.tab_rec_csr_lte_cab.tiposolicitud%type) is

    -- Ini 4.0
    ln_idsol     operacion.ope_tvsat_sltd_cab.idsol%type;
    ln_process   operacion.tab_rec_csr_lte_cab.idprocess%type;
    ln_tarjeta   operacion.tab_rec_csr_lte_det.numserie_tarjeta%type;
    ln_tipo      varchar2(1); -- 5.0
  ln_tipo_sol   number; --6.0
    lc_resultado varchar2(10);
    lc_mensaje   varchar2(4000);
    lc_error     varchar2(1000);
    lc_err_gen   varchar2(4000);
    lc_err_env   varchar2(4000);
    lc_destino   operacion.ope_parametros_globales_aux.valorparametro%type;
    lc_texto     opewf.cola_send_mail_job.cuerpo%type;
    ln_idlote    operacion.ope_lte_lote_sltd_aux.idlote%type;
    ln_lim_lote  number(10);
    ln_cant_sol  number(10) := 0;
    lv_mensaje   varchar2(1000);

    cursor cur_tmp_cab is
      select cab.idprocess, cab.codsolot, cab.tiposolicitud --6.0
        from operacion.tab_rec_csr_lte_cab cab
       where cab.tipo     = ln_tipo
         and cab.estado   = 1
         and cab.codsolot is not null
         and cab.idlote   is null;

    cursor cur_tmp_tar is
      select det.numserie_tarjeta
        from operacion.tab_rec_csr_lte_det det
       where det.idprocess = ln_process
       group by det.numserie_tarjeta;

    cursor cur_tmp_det is
      select det.idprocess,
             det.idprocess_det,
             det.numserie_tarjeta,
             det.bouquet
        from operacion.tab_rec_csr_lte_det det
       where det.idprocess        = ln_process
         and det.numserie_tarjeta = ln_tarjeta;

    cursor solicitud is
      select a.idsol
        from operacion.ope_tvsat_sltd_cab a,
             operacion.ope_tvsat_sltd_bouquete_det b
       where a.estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol         = b.idsol
         and a.tiposolicitud = ln_tipo_sol --ac_tiposolicitud --6.0
         and a.idlote        is null
       group by a.idsol
       order by 1;

    cursor lote is
      select a.idlote,
             count(distinct a.idsol) total_sol,
             count(distinct b.bouquete) total_bouquet
        from operacion.ope_tvsat_sltd_cab          a,
             operacion.ope_tvsat_sltd_bouquete_det b,
             operacion.ope_tvsat_lote_sltd_aux     c
       where a.estado in (fnd_estado_pend_ejecucion, fnd_estado_relotizar)
         and a.idsol       = b.idsol
         and a.idlote      = c.idlote
         and a.idlote      = ln_idlote
         and a.idlote      is not null
         and c.numsol      is null
         and c.numarchivos is null
       group by a.idlote
       order by 1;
    -- Fin 4.0

  begin
    -- ini 4.0
    if ac_tiposolicitud = '8' then    -- 5.0 Reconexion PostPago LTE  --8.0
      -- Alta
      ln_tipo := '2';                 -- 5.0 Reconexion PostPago LTE
    elsif ac_tiposolicitud = '9' then -- 5.0 Reconexion PostPago LTE  --8.0
      -- Baja
      ln_tipo := '1';                 -- 5.0 Reconexion PostPago LTE
    end if;

    ln_lim_lote := to_number(nvl(operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.numero_sots_envio_conax'),
                                 0)); --8.00

    -- Inicio Generar Extructura de Conax
    for c_tmp_cab in cur_tmp_cab loop
      --ini 8.00
      ln_cant_sol := ln_cant_sol + 1;

      if ln_cant_sol > ln_lim_lote then
        exit;
      end if;
      --fin 8.00

      ln_tipo_sol:=to_number(c_tmp_cab.tiposolicitud); --6.0
      ln_process := c_tmp_cab.idprocess;

      select sq_ope_tvsat_sltd_cab_idsol.nextval
        into ln_idsol
        from dummy_ope;

      insert into operacion.ope_tvsat_sltd_cab
        (codsolot, tiposolicitud, estado, flg_recarga, idsol)
      values
        (c_tmp_cab.codsolot,c_tmp_cab.tiposolicitud, 1, 1, ln_idsol); -- 5.0 --6.0 --7.0

      update operacion.tab_rec_csr_lte_cab
         set idsol     = ln_idsol,
             estado    = 2
       where idprocess = ln_process;

      for c_tmp_tar in cur_tmp_tar loop

        ln_tarjeta := c_tmp_tar.numserie_tarjeta;

        insert into operacion.ope_tvsat_sltd_det
          (idsol, serie)
        values
          (ln_idsol, c_tmp_tar.numserie_tarjeta);

        for c_tmp_det in cur_tmp_det loop
        if ln_tipo_sol in (6,7) then --6.0
          insert into operacion.ope_tvsat_sltd_bouquete_det
            (idsol, serie, bouquete, tipo)
          values
            (ln_idsol,
             c_tmp_det.numserie_tarjeta,
             lpad(c_tmp_det.bouquet, 8, 0),
             2); --6.0
        -- Ini 6.0
        elsif ln_tipo_sol in (8,9) then
          insert into operacion.ope_tvsat_sltd_bouquete_det
            (idsol, serie, bouquete, tipo)
          values
            (ln_idsol,
             c_tmp_det.numserie_tarjeta,
             lpad(c_tmp_det.bouquet, 8, 0),
             1); -- tipo adicional
        end if;
          -- Fin 6.0
          update operacion.tab_rec_csr_lte_det
             set idsol = ln_idsol
           where idprocess = c_tmp_det.idprocess
             and idprocess_det = c_tmp_det.idprocess_det;

        end loop;
      end loop;
    end loop;
    -- Fin    Generar Extructura de Conax
    lc_texto    := null;
    ln_cant_sol := 0; --8.00
    -- Actualiza el IDSOL en el Detalle y Cabecera de Tablas de Provision de TV

    if lv_mensaje is null then
      for c_sol in solicitud loop
        ln_idsol    := c_sol.idsol;
        ln_cant_sol := ln_cant_sol + 1;

        if ln_cant_sol > ln_lim_lote then
          exit;
        end if;

        if ln_cant_sol = 1 then
          select operacion.ope_tvsat_lote_sltd_aux_idlote.nextval
            into ln_idlote
            from dummy_ope;

          insert into operacion.ope_tvsat_lote_sltd_aux
            (idlote, estado)
          values
            (ln_idlote, 1);
        end if;

        update operacion.ope_tvsat_sltd_cab
           set idlote = ln_idlote
         where idsol = ln_idsol;

        update operacion.ope_tvsat_sltd_det
           set idlotefin = ln_idlote
         where idsol = ln_idsol;

        update operacion.tab_rec_csr_lte_cab
           set idlote = ln_idlote
         where idsol = ln_idsol;

        update operacion.tab_rec_csr_lte_det
           set idlote = ln_idlote
         where idsol = ln_idsol;

        operacion.pq_ope_interfaz_tvsat.p_actualiza_datos_sol_postpago(ln_idsol,
                                                                       null,
                                                                       null,
                                                                       lc_error);

        if lc_error is not null then
          rollback;
          lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                             to_char(ln_idsol) || '. ' || lc_error ||
                             chr(13) || lc_texto,
                             1,
                             4000);
        end if;
      end loop;

      for c_lote in lote loop

        lc_err_gen := null;
        lc_err_env := null;

        update operacion.ope_tvsat_lote_sltd_aux
           set numsol      = c_lote.total_sol,
               numarchivos = c_lote.total_bouquet,
               estado      = 2
         where idlote = c_lote.idlote
           and estado <> 2;

        operacion.pq_ope_interfaz_tvsat.p_genera_archivo_lote(1,
                                                              c_lote.idlote,
                                                              lc_resultado,
                                                              lc_mensaje);
        --INI 12.0
            IF AC_TIPOSOLICITUD = '8' THEN
             OPERACION.PKG_CONTEGO.SGASS_RECONEXION_LTE(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
            ELSIF AC_TIPOSOLICITUD = '9' THEN
              OPERACION.PKG_CONTEGO.SGASS_SUSPENSION_LTE(C_LOTE.IDLOTE,LC_RESULTADO,LC_MENSAJE);
            END IF;
        --fin 12.0															  

        if lc_resultado = 'OK' then

          update operacion.ope_tvsat_lote_sltd_aux
             set estado = 3
           where idlote = c_lote.idlote
             and estado <> 3;

        else
          lc_err_gen := substr('Error al generar archivos del lote Nro. ' ||
                               to_char(c_lote.idlote) || '. ' || lc_mensaje,
                               1,
                               4000);
        end if;

        if lc_err_gen is not null then
          lc_texto := substr(lc_err_gen || chr(13) || lc_texto, 1, 4000);
        end if;

        if lc_err_env is not null then
          lc_texto := substr(lc_err_env || chr(13) || lc_texto, 1, 4000);
        end if;

        if lc_err_gen is not null then
          rollback;
        else
          for c_sol in (select idsol
                          from ope_tvsat_sltd_cab
                         where idlote = c_lote.idlote) loop
            ln_idsol := c_sol.idsol;
            operacion.pq_ope_interfaz_tvsat.p_actualiza_datos_sol_postpago(c_sol.idsol,
                                                                           fnd_estado_lotizado,
                                                                           lc_err_env,
                                                                           lc_error);
            if lc_error is not null then
              rollback;
              lc_texto := substr('Error al actualizar datos de solicitud Nro. ' ||
                                 to_char(ln_idsol) || '. ' || lc_error ||
                                 chr(13) || lc_texto,
                                 1,
                                 4000);
            end if;
          end loop;
          commit;
        end if;
      end loop;
    else
      lc_texto := 'ERROR: Al ejecutar el proceso carga de DTH Postpago - ' ||
                  lv_mensaje;
    end if;

    -- Valida en envio de Correo
    if lc_texto is not null then
      lc_texto   := substr('Error en proceso autómatico de envío y generación de archivos a CONAX(Post Venta LTE)' ||
                           ', Tipo de Transacción: ' || ac_tiposolicitud ||
                           chr(13) || ', Mensaje Error: ' || lc_texto,
                           1,
                           4000);
      lc_destino := operacion.pq_ope_interfaz_tvsat.f_obt_parametro('cortesyreconexiones.correo_responsable_operaciones');
      p_envia_correo_de_texto_att('Cortes y Reconexiones(Post Venta LTE)',
                                  lc_destino,
                                  lc_texto);
      commit;
    end if;
    -- Fin 4.0
  exception
    -- ini 4.0
    when others then
      raise_application_error(-20000,'>> Error al Ejecutar SP: ' || $$plsql_unit || '.P_GEN_ARCHIVO_CONAX_POST' || chr(13) ||
                              ' - Codigo de Error: '       || to_char(sqlcode) || chr(13) ||
                              ' - Mensaje de Error: '      || to_char(sqlerrm) || chr(13) ||
                              ' - Linea de Error: '        || dbms_utility.format_error_backtrace);
    -- fin 4.0
  end;

  procedure p_genera_archivo_lote(an_tipo      in number,
                                  an_idlote    in operacion.tab_rec_csr_lte_cab.idlote%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2) is

    lc_bouquet    operacion.tab_rec_csr_lte_det.bouquet%type;
    ln_flg_recarg operacion.tab_rec_csr_lte_cab.flg_recarga%type;
    error_gen_archivo exception;

    -- Cursor Lista los Bouquet para la generacion de Archivo.
    cursor bouquet is
      select b.bouquet bouquet, a.flg_recarga
        from operacion.tab_rec_csr_lte_cab a,
             operacion.tab_rec_csr_lte_det b
       where a.idsol  = b.idsol
         and a.idlote = an_idlote
       group by b.bouquet, a.flg_recarga
       order by 1;

  begin
    for c_bq in bouquet loop
      lc_bouquet    := c_bq.bouquet;
      ln_flg_recarg := c_bq.flg_recarga;
      if ln_flg_recarg = 1 then
        -- SP Inicia Proceso de Generacion de Archivo Conax
        p_genera_archivo_conax(an_tipo,
                               an_idlote,
                               lc_bouquet,
                               ac_resultado,
                               ac_mensaje);
        if ac_resultado <> 'OK' then
          raise error_gen_archivo;
        end if;
      end if;
    end loop;
  exception
    when error_gen_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := ' -- Generacion de Archivo Lote: Error al Generar el Archivo' || chr(13) ||
                      ' -- Lote: '      || to_char(an_idlote)    || chr(13) ||
                      ' -- Bouquet: '   || to_char(lc_bouquet)   || chr(13) ||
                      ' -- Resultado: ' || to_char(ac_resultado) || chr(13) ||
                      ' -- Mensaje: '   || chr(13)               || ac_mensaje;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := ' -- Generacion de Archivo Lote: Error al Ejecutar SP P_GENERA_ARCHIVO_LOTE' || chr(13) ||
                      ' -- Lote: '               || to_char(an_idlote)  || chr(13) ||
                      ' -- Bouquet: '            || to_char(lc_bouquet) || chr(13) ||
                      ' -- Codigo de Error: '    || to_char(sqlcode)    || chr(13) ||
                      ' -- Mensaje de Error: '   || to_char(sqlerrm)    || chr(13) ||
                      ' -- Linea de Error: '     || dbms_utility.format_error_backtrace;
  end;

  procedure p_genera_archivo_conax(an_tipo      in number,
                                   an_idlote    in operacion.tab_rec_csr_lte_cab.idlote%type,
                                   ac_bouquet   in operacion.tab_rec_csr_lte_det.bouquet%type,
                                   ac_resultado in out varchar2,
                                   ac_mensaje   in out varchar2) is

    lc_tiposolicitud   operacion.tab_rec_csr_lte_cab.tiposolicitud%type;
    lc_prefijo_arch    char(2);
    lc_fecini          varchar2(12);
    lc_fecfin          varchar2(12);
    lc_fecfin_rotacion varchar2(12);
    lc_archivo         operacion.ope_lte_archivo_det.archivo%type;
    lc_num_arch        varchar2(6);
    ln_cant_serie      number(10);
    lc_cant_serie      varchar2(6);
    reg_text_io        utl_file.file_type;
    ln_existe_serie    number(10);
    connex_i           operacion.conex_intraway;
    error_crear_archivo    exception;
    error_escribir_archivo exception;

    cursor serie is
      select a.idsol, b.numserie_tarjeta
        from operacion.tab_rec_csr_lte_cab a,
             operacion.tab_rec_csr_lte_det b
       where a.idsol = b.idsol
         and a.idlote = b.idlote
         and a.idlote = an_idlote
         and b.bouquet = ac_bouquet
       order by b.numserie_tarjeta;

    cursor cur_arch_serie is
      select *
        from operacion.ope_lte_archivo_det
       where idlote = an_idlote
         and bouquet = ac_bouquet
       order by serie;

  begin
    -- Asignacion de Datos de Conexion.
    connex_i := operacion.pq_dth.f_crea_conexion_intraway;

    lc_fecini := to_char(trunc(new_time(sysdate, 'EST', 'GMT'), 'MM'),
                         'yyyymmdd') || '0000';

    select to_char(to_date(c.valor,'dd/mm/yyyy'),'dd/mm/yyyy')
      into lc_fecfin_rotacion
      from operacion.constante c
     where c.constante = 'DTHROTACION';

    select to_char(trunc(new_time(to_date(lc_fecfin_rotacion,'dd/mm/yyyy'), 'EST', 'GMT')),
                   'yyyymmdd') || '0000'
      into lc_fecfin
      from dual;

    if (to_char(trunc(sysdate), 'DD/MM/YYYY') = lc_fecfin_rotacion) then
      select add_months(lc_fecfin_rotacion, 12)
        into lc_fecfin_rotacion
        from dual;

      update operacion.constante
         set valor = lc_fecfin_rotacion
       where constante = 'DTHROTACION';
      commit;

      select to_char(trunc(new_time(to_date(lc_fecfin_rotacion,'dd/mm/yyyy'), 'EST', 'GMT')),
                     'yyyymmdd') || '0000'
        into lc_fecfin
        from dual;

    end if;

    if an_tipo = 1 then
      -- Consulta de Cantidad de Tarjetas.
      select count(b.numserie_tarjeta)
        into ln_cant_serie
        from operacion.tab_rec_csr_lte_cab a,
             operacion.tab_rec_csr_lte_det b
       where a.idsol = b.idsol
         and a.idlote = b.idlote
         and a.idlote = an_idlote
         and b.bouquet = ac_bouquet;

      -- Consulta de Tipo de Solicitudes.
      select distinct tiposolicitud
        into lc_tiposolicitud
        from operacion.tab_rec_csr_lte_cab
       where idlote = an_idlote;

      -- Asignacion de Prefijo
      if lc_tiposolicitud in ('1', '3', '5', '7','9') then --8.0
        lc_prefijo_arch := 'cs';
      else
        lc_prefijo_arch := 'ps';
      end if;
      -- Asignacion de Nombre de Archivo.
      lc_archivo  := operacion.pq_ope_interfaz_tvsat.f_genera_nombre_archivo(0,
                                                                             lc_prefijo_arch);
      lc_num_arch := lpad(substr(lc_archivo, 3, 8), 6, '0');

      -- Creacion de Registro: OPE_LTE_ARCHIVO_CAB
      insert into operacion.ope_lte_archivo_cab
        (idlote, archivo, bouquet, estado)
      values
        (an_idlote, lc_archivo, ac_bouquet, 1);
    else
      select count(1)
        into ln_cant_serie
        from operacion.ope_lte_archivo_det
       where idlote = an_idlote
         and bouquet = ac_bouquet;

      select archivo
        into lc_archivo
        from operacion.ope_lte_archivo_cab
       where idlote = an_idlote
         and bouquet = ac_bouquet;

      lc_num_arch := substr(lc_archivo, 3, 6);

    end if;

    if ln_cant_serie = 0 then
      ac_resultado := 'ERROR';
      ac_mensaje   := ' -- Generacion de Archivo Conax'               || chr(13) ||
                      ' -- Archivo: '    || to_char(lc_archivo)       || chr(13) ||
                      ' -- No se ha generado archivo, no hay bouquet con series válidas';
    else
      lc_cant_serie := lpad(ln_cant_serie, 6, '0');
      -- Abrir Archivo
      operacion.pq_dth_interfaz.p_abrir_archivo(reg_text_io,
                                                connex_i.pDirectorioLocal,
                                                lc_archivo,
                                                'W',
                                                ac_resultado,
                                                ac_mensaje);

      if ac_resultado <> 'OK' then
        raise error_crear_archivo;
      end if;

      begin
        -- Escribir Archivo
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_num_arch,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  ac_bouquet,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_fecini,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_fecfin,
                                                  '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'EMM', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'U', '1');
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                  lc_cant_serie,
                                                  '1');

        if an_tipo = 1 then
          for c_det in serie loop
            operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                      c_det.numserie_tarjeta,
                                                      '1');
            -- Consulta si se registro Registro en el Detalle
            select count(1)
              into ln_existe_serie
              from operacion.ope_lte_archivo_det
             where idlote = an_idlote
               and archivo = lc_archivo
               and bouquet = ac_bouquet
               and serie   = c_det.numserie_tarjeta;

            if ln_existe_serie = 0 then
              -- Creacion de Registro: OPE_LTE_ARCHIVO_DET
              insert into operacion.ope_lte_archivo_det
                (idlote, archivo, bouquet, serie)
              values
                (an_idlote, lc_archivo, ac_bouquet, c_det.numserie_tarjeta);
            end if;
          end loop;
        else
          for c_det in cur_arch_serie loop
            operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io,
                                                      c_det.serie,
                                                      '1');
          end loop;
        end if;
        operacion.pq_dth_interfaz.p_escribe_linea(reg_text_io, 'ZZZ', '1');
        operacion.pq_dth_interfaz.p_cerrar_archivo(reg_text_io);
      exception
        when others then
          raise error_escribir_archivo;
      end;

      ac_resultado := 'OK';
    end if;

  exception
    when error_crear_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := ' -- Generacion de Archivo Conax: Error al Abrir archivo' || chr(13) ||
                      ' -- Archivo: '    || to_char(lc_archivo)   || chr(13) ||
                      ' -- Resultado: '  || to_char(ac_resultado) || chr(13) ||
                      ' -- Mensaje: '    || chr(13) || ac_mensaje;
    when error_escribir_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := ' -- Generacion de Archivo Conax: Error al escribir archivo' || chr(13) ||
                      ' -- Archivo: '       || to_char(lc_archivo) || chr(13)   ||
                      ' -- Codigo Error: '  || to_char(sqlcode)    || chr(13)   ||
                      ' -- Mensaje Error: ' || to_char(sqlerrm)    || chr(13)   ||
                      ' -- Linea de Error: '|| dbms_utility.format_error_backtrace;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Generacion de Archivos Conax, Error al Ejecutar SP: ' || $$plsql_unit || '.SP P_GENERA_ARCHIVO_CONAX' || chr(13) ||
                      ' - Archivo: '       || to_char(lc_archivo) || chr(13) ||
                      ' - Codigo Error: '  || to_char(sqlcode)    || chr(13) ||
                      ' - Mensaje Error: ' || to_char(sqlerrm)    || chr(13) ||
                      ' - Linea de Error: '|| dbms_utility.format_error_backtrace;
  end;

  procedure p_envio_archivo_lote(an_idlote    in operacion.ope_lte_archivo_det.idlote%type,
                                 ac_resultado in out varchar2,
                                 ac_mensaje   in out varchar2) is

    error_env_archivo_bouquet exception;
    ln_bouquet                operacion.ope_lte_archivo_det.bouquet%type;
    cursor archivo is
      select * from operacion.ope_lte_archivo_det where idlote = an_idlote;
  begin
    for c_arch in archivo loop
      ln_bouquet := c_arch.bouquet;
      -- Envio de Archivo a Conax
      p_envio_archivo_conax(an_idlote,
                            c_arch.bouquet,
                            ac_resultado,
                            ac_mensaje);
      if ac_resultado <> 'OK' then
        raise error_env_archivo_bouquet;
      end if;
    end loop;
  exception
    when error_env_archivo_bouquet then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Envio Archivo Lote, Error al Ejecutar SP: ' || $$plsql_unit || '.P_ENVIO_ARCHIVO_CONAX' || chr(13) ||
                      ' - Lote: '      || to_char(an_idlote)          || chr(13) ||
                      ' - Bouquet: '   || to_char(ln_bouquet)         || chr(13) ||
                      ' - Resultado: ' || to_char(ac_resultado)       || chr(13) ||
                      ' - Mensaje: '   || chr(13) ||  ac_mensaje;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Envio Archivo Lote, Error al Ejecutar SP: ' || $$plsql_unit || '.P_ENVIO_ARCHIVO_LOTE' || chr(13) ||
                      ' - Lote: '             || to_char(an_idlote)   || chr(13) ||
                      ' - Bouquet: '          || to_char(ln_bouquet)  || chr(13) ||
                      ' - Codigo de Error: '  || to_char(sqlcode)     || chr(13) ||
                      ' - Mensaje de Error: ' || to_char(sqlerrm)     || chr(13) ||
                      ' - Linea de Error: '   || dbms_utility.format_error_backtrace;
  end;

  procedure p_envio_archivo_conax(an_idlote    in operacion.ope_lte_lote_sltd_aux.idlote%type,
                                  ac_bouquet   in operacion.ope_lte_archivo_cab.bouquet%type,
                                  ac_resultado in out varchar2,
                                  ac_mensaje   in out varchar2) is
    lc_archivo          ope_tvsat_archivo_cab.archivo%type;
    error_envio_archivo exception;
    connex_i            operacion.conex_intraway;  -- 4.0
  begin
    -- Datos de Conexion
    connex_i := operacion.pq_dth.f_crea_conexion_intraway;
    -- Consulta de Archivo
    select archivo
      into lc_archivo
      from operacion.ope_lte_archivo_cab
     where idlote  = an_idlote
       and bouquet = ac_bouquet
       and estado in (1, 2);
    begin
      -- Envio de Archivo.
      operacion.pq_dth_interfaz.p_enviar_archivo_ascii(connex_i.pHost,
                                                       connex_i.pPuerto,
                                                       connex_i.pUsuario,
                                                       connex_i.pPass,
                                                       connex_i.pDirectorioLocal,
                                                       lc_archivo,
                                                       connex_i.pArchivoRemotoReq);
    exception
      when others then
        utl_tcp.close_all_connections;
        raise error_envio_archivo;
    end;
    update operacion.ope_lte_archivo_cab
       set estado  = 2
     where idlote  = an_idlote
       and archivo = lc_archivo
       and bouquet = ac_bouquet
       and estado  <> 2;
    ac_resultado := 'OK';
  exception
    when error_envio_archivo then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Envio Archivo Conax, Error al Ejecutar SP '      || 'PQ_DTH_INTERFAZ.P_ENVIAR_ARCHIVO_ASCII' || chr(13) ||
                      ' -- Archivo: '          || to_char(lc_archivo)   || chr(13) ||
                      ' -- Codigo de Error: '  || to_char(sqlcode)      || chr(13) ||
                      ' -- Mensaje de Error: ' || to_char(sqlerrm)      || chr(13) ||
                      ' -- Linea de Error: '   || dbms_utility.format_error_backtrace;
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := 'Envio Archivo Conax, Error al Ejecutar SP '  || $$plsql_unit || '.P_ENVIO_ARCHIVO_CONAX' || chr(13) ||
                      ' -- Archivo: '          || to_char(lc_archivo)   || chr(13) ||
                      ' -- Codigo de Error: '  || to_char(sqlcode)      || chr(13) ||
                      ' -- Mensaje de Error: ' || to_char(sqlerrm)      || chr(13) ||
                      ' -- Linea de Error: '   || dbms_utility.format_error_backtrace;
  end;

  function f_obtiene_codsrv(av_id_servicio in varchar2) return varchar2 is
    ln_codsrv   sales.tystabsrv.codsrv%type;
    ln_srv_gen  sales.tystabsrv.codsrv%type;
    ln_lin_gen  sales.linea_paquete.idlinea%type;
    ls_servicio sales.pq_servicio_sisact_cp_lte.servicio_type;
    --ls_cursor   sys_refcursor;
  begin
    ln_codsrv := operacion.pq_siac_cambio_plan_lte.fnc_get_codsrv_service(av_id_servicio);
    if ln_codsrv is null then
      begin
/*        select to_number(nvl(rpad(substr(nvl('1', ' '), 1, 2), 2, ' '), 0)) bandwid,
               gs.gsrvc_codigo,
               rpad(substr(nvl(lpad(gs.gsrvc_padre, 3, '0'), ' '), 1, 4),
                    4,
                    ' ') gsrvc_principal,
               nvl(rpad(substr(nvl(null, 0), 1, 1), 1, ' '), 0) flag_lc,
               s.servv_codigo_ext
          into ls_servicio.bandwid,
               ls_servicio.idgrupo,
               ls_servicio.idgrupo_principal,
               ls_servicio.flag_lc,
               ls_servicio.codigo_ext
          from sisact_ap_servicio@dbl_pvudb s
         inner join sisact_ap_grupo_servicio@dbl_pvudb gs
            on gs.gsrvc_codigo = s.gsrvc_codigo
         where s.servv_codigo  = av_id_servicio;*/

        sales.pq_servicio_sisact_cp_lte.create_servicio(ls_servicio,
                                                        ln_lin_gen,
                                                        ln_srv_gen);
        ln_codsrv := ln_srv_gen;
      exception
        when others then
          return null;
      end;
    end if;
    return ln_codsrv;
  exception
    when others then
      return null;
  end;

  function f_sot_equipo(av_cod_id in varchar2) return varchar2 is
    ln_sot        operacion.solot.codsolot%type;
    ln_sot_ori    operacion.solot.codsolot%type;
    ln_sot_equ    operacion.solot.codsolot%type;
    ls_numslc     sales.regvtamentab.numslc%type;
    ln_cnt_eq     number;
    ln_cnt_eq_ori number;
    ln_cnt_ope    number;
  begin
    ln_sot := f_obtiene_sot(av_cod_id);

    select count(*)
      into ln_cnt_eq
      from operacion.solotptoequ s
     where s.codsolot = ln_sot
       and s.tipequ = (select codigon
                         from operacion.opedd
                        where tipopedd in
                              (select tipopedd
                                 from operacion.tipopedd
                                where abrev = 'TIPEQU_DTH_CONAX')
                          and descripcion = 'Tarjeta');
    if ln_cnt_eq = 0 then
      ln_cnt_ope := 0;
      while (ln_cnt_ope <= 10) loop  -- Se ejecuta un numero Limitado de veces
        begin
          ln_cnt_ope := ln_cnt_ope + 1;
          select numslc_ori
            into ls_numslc
            from sales.regvtamentab
           where numslc in ( select numslc
                               from operacion.solot
                              where codsolot = ln_sot);

          select codsolot
            into ln_sot_ori
            from operacion.solot
           where numslc = ls_numslc;

          select count(*)
            into ln_cnt_eq_ori
            from operacion.solotptoequ s
           where s.codsolot = ln_sot_ori
             and s.tipequ = (select codigon
                               from operacion.opedd
                              where tipopedd in
                                    (select tipopedd
                                       from operacion.tipopedd
                                      where abrev = 'TIPEQU_DTH_CONAX')
                                and descripcion = 'Tarjeta');

          if ln_cnt_eq_ori > 0 then
            ln_sot_equ  := ln_sot_ori;
            ln_cnt_ope  := 11;
          else
            ln_sot_equ  := null;
            ln_sot      := ln_sot_ori;
          end if;
        exception
          when others then
            ln_cnt_ope  := 11;
        end;
      end loop;
      return ln_sot_equ;
    else
      return ln_sot;
    end if;
  exception
    when others then
      return null;
  end;

  procedure p_reg_log(p_log      operacion.logrqt_csr_lte%rowtype )
  is
    l_log operacion.logrqt_csr_lte%rowtype;
    pragma autonomous_transaction;
  begin

    select operacion.sq_ope_id_rqt_csr.nextval into l_log.id from dual;
    l_log.mensaje       := p_log.mensaje;
    l_log.request_padre := p_log.request_padre;
    l_log.request       := p_log.request;
    l_log.customer_id   := p_log.customer_id;
    l_log.co_id         := p_log.co_id;
    l_log.action_id     := p_log.action_id;
    l_log.origen_prov   := p_log.origen_prov;
    l_log.tipo_prod     := p_log.tipo_prod;
    l_log.sot           := p_log.sot;
    l_log.codusucre     := user;
    l_log.fechcre       := sysdate;

    insert into operacion.logrqt_csr_lte values l_log;
    commit;
  exception
    when others then
      rollback;
  end;

  procedure p_valida_cancelacion_srv(p_idtareawf in opewf.tareawf.idtareawf%type,
                                     p_idwf      in opewf.tareawf.idwf%type,
                                     p_tarea     in opewf.tareawf.tarea%type,
                                     p_tareadef  in opewf.tareawf.tareadef%type) is

    l_codsolot  operacion.solot.codsolot%type;
    l_sot_canc  operacion.solot.codsolot%type;
    l_co_id_c   operacion.solot.cod_id%type;
    ln_resp     numeric := 0;
    lv_mensaje  varchar2(3000);
    l_resp_cons number;
    l_mens_cons varchar(4000);
    l_resp_veri number;
    l_mens_veri varchar(4000);
  begin
    -- Consulta de SOT
    select codsolot into l_codsolot from opewf.wf where idwf = p_idwf;

    -- Ejecutar Recepcion de Archivos en Conax
    p_consultar_conax(l_codsolot,l_resp_cons,l_mens_cons);
    if (l_resp_cons = -1 or l_resp_cons = -2 or l_resp_cons = 3) then
      -- Registra Mensaje en Anotaciones de SOT
      insert into opewf.tareawfseg(idtareawf,observacion,flag)
      values (p_idtareawf, 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || l_mens_cons ,1);
      -- La tarea Cambia a Estado Generado
      opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    -- Registra LOG: Recepcion en Conax
    ln_log.sot     := l_codsolot;
    ln_log.mensaje := 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || l_mens_cons;
    p_reg_log(ln_log);

    -- Ejecutar Verificacion de Archivos en Conax
    p_verificar_conax(l_codsolot,l_resp_veri,l_mens_veri);
    if (l_resp_veri = -1 or l_resp_veri = -2) then
      -- Registra Mensaje en Anotaciones de SOT
      insert into opewf.tareawfseg(idtareawf,observacion,flag)
      values (p_idtareawf, 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || l_mens_veri ,1);
      -- La tarea Cambia a Estado Generado
      opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    -- Registra LOG: Verificacion en Conax
    ln_log.sot     := l_codsolot;
    ln_log.mensaje := 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || l_mens_veri;
    p_reg_log(ln_log);

    -- Consulta el Numero de Contrato en la Tabla de Provision(BSCS)
    select distinct co_id
      into l_co_id_c
      from tim.lte_control_prov@dbl_bscs_bf
     where sot = l_codsolot;
    l_sot_canc := f_obtiene_sot(l_co_id_c);

    -- Ejecutar Liberacion de Numeros.
    p_libera_numeros(l_sot_canc, ln_resp, lv_mensaje);
    if ln_resp <> 0 then
      -- Registra Mensaje en Anotaciones de SOT
      insert into opewf.tareawfseg(idtareawf,observacion,flag)
      values (p_idtareawf, 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || lv_mensaje ,1);
      -- La tarea Cambia a Estado Generado
      opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    ln_log.sot     := l_codsolot;
    ln_log.mensaje := 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || lv_mensaje;
    p_reg_log(ln_log);

    -- Ejecutar Liberacion de Equipos
    p_libera_equipos(l_sot_canc, ln_resp, lv_mensaje);
    if ln_resp <> 0 then
      -- Registra Mensaje en Anotaciones de SOT
      insert into opewf.tareawfseg(idtareawf,observacion,flag)
      values (p_idtareawf, 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || lv_mensaje ,1);
      -- La tarea Cambia a Estado Generado
      opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    ln_log.sot     := l_codsolot;
    ln_log.mensaje := 'VALIDACION CANCELACION SERVICIOS, Mensaje: ' || lv_mensaje;
    p_reg_log(ln_log);

    -- Actualizacion Tablas del SGA
    update operacion.inssrv i
       set i.estinssrv = 3
     where i.codinssrv in (select distinct s.codinssrv
                             from operacion.solotpto s
                            where s.codsolot = l_sot_canc);
    update operacion.insprd ip
       set ip.estinsprd = 3
     where ip.pid in (select distinct s.pid
                        from operacion.solotpto s
                       where s.codsolot = l_sot_canc);

    ln_log.sot     := l_codsolot;
    ln_log.mensaje := 'VALIDACION CANCELACION SERVICIOS, Se completo la Cancelacion de los Servicios en el SGA';
    p_reg_log(ln_log);
  exception
    when others then
      raise_application_error(-20000,
                              'Validacion Cancelacion Servicios, Error al Ejecutar SP: ' ||
                              $$plsql_unit || '.P_VALIDA_CANCELACION_SRV'      || chr(13) ||
                              ' - SOT: '              ||  to_char(l_codsolot)  || chr(13) ||
                              ' - Idtareawf: '        ||  to_char(p_idtareawf) || chr(13) ||
                              ' - Idwf: '             ||  to_char(p_idwf)      || chr(13) ||
                              ' - Tarea: '            ||  to_char(p_tarea)     || chr(13) ||
                              ' - Tareadef: '         ||  to_char(p_tareadef)  || chr(13) ||
                              ' - Codigo de Error: '  ||  to_char(sqlcode)     || chr(13) ||
                              ' - Mensaje de Error: ' ||  to_char(sqlerrm)     || chr(13) ||
                              ' - Linea de Error: '   ||  dbms_utility.format_error_backtrace);
  end;

  procedure p_libera_numeros(p_solot     in  operacion.solot.codsolot%type,
                             p_respuesta out number,
                             p_mensaje   out varchar2) is
    ln_codinssrv operacion.inssrv.codinssrv%type;
    ln_numero    telefonia.numtel.numero%type;
    ln_codnumtel telefonia.numtel.codnumtel%type;
    ln_simcard   telefonia.numtel.simcard%type;
    ln_val_tel   number;
    ln_resp      numeric := 0;
    lv_mensaje   varchar2(3000);
    ln_coid      number;  -- 8.00
    ln_codsot    number;  -- 8.00
  begin
    -- Consulta Validar SI reggistra Numeros.
    select count(*)
      into ln_val_tel
      from operacion.inssrv i
     where i.codinssrv in (select distinct sp.codinssrv
                             from operacion.solotpto sp
                            where sp.codsolot = p_solot)
       and i.tipsrv    = fnd_tel
       and i.estinssrv <> 3;

    --ini 8.00

     select s.cod_id
       into ln_coid
       from solot s
      where s.codsolot = p_solot;

    if ln_val_tel = 0 then

       select count(*)
         into ln_val_tel
         from operacion.solot s, operacion.solotptoequ se
        where s.codsolot = se.codsolot
          and se.mac is not null
          and se.tipequ = 16308
          and s.cod_id = ln_coid;

    end if;
    --fin 8.00

    if ln_val_tel > 0 then

     begin --8.0
        -- Consulta de numeros telefonicos(corregir Proc venta esta Insertando MAL)
       select distinct n.numero, r.codnumtel, n.simcard, n.codinssrv
         into ln_numero, ln_codnumtel, ln_simcard, ln_codinssrv
         from telefonia.reservatel r, telefonia.numtel n
        where r.codnumtel = n.codnumtel
          and n.codinssrv in (select i.codinssrv
                                from operacion.inssrv i
                               where i.codinssrv in
                                     (select distinct sp.codinssrv
                                        from operacion.solotpto sp
                                       where sp.codsolot = p_solot));
     -- Ini 8.0
     exception
       when others then

             select max(s.codsolot)
               into ln_codsot
               from operacion.solot s, operacion.solotptoequ se
              where s.codsolot = se.codsolot
                and se.mac is not null
                and se.tipequ = 16308
                and s.cod_id = ln_coid;

             select distinct n.numero, r.codnumtel, n.simcard, n.codinssrv
               into ln_numero, ln_codnumtel, ln_simcard, ln_codinssrv
               from telefonia.reservatel r, telefonia.numtel n
              where r.codnumtel = n.codnumtel
                and n.numero=(select se.mac
                                from operacion.solot s,
                                     operacion.solotptoequ se
                               where s.codsolot = se.codsolot
                                 and se.mac is not null
                                 and se.tipequ=16308
                                 and s.codsolot = ln_codsot);
     end;
     -- Fin 8.0

      -- actualizacion de numtel
      update telefonia.numtel nt
         set nt.estnumtel = 6,
             nt.fecasg    = null,
             nt.codinssrv = null,
             nt.simcard   = null
       where nt.numero = ln_numero;

      -- actualizacion de reservatel
      update telefonia.reservatel
         set estnumtel = 1
       where codnumtel = ln_codnumtel;

      -- actualizacion de simcard y numero en inssrv(corregir Proc venta esta Insertando MAL)
      update operacion.inssrv
         set numero  = null,
             simcard = null
       where codinssrv in (select i.codinssrv
                              from operacion.inssrv i
                             where i.codinssrv in
                                   (select distinct sp.codinssrv
                                      from operacion.solotpto sp
                                     where sp.codsolot = p_solot))
         and tipinssrv = 3;

      -- Actualizacion SANS
      webservice.pq_datos_webservice.cambiar_status_sans(lpad(ln_numero,
                                                              15,
                                                              '0'),
                                                              '006',
                                                              ln_resp,
                                                              lv_mensaje);
      if ln_resp < 0 then
        p_respuesta := -1;
        p_mensaje   := '>> Liberacion de Numeros, La respuesta del Servicio no es Valida' ||
                       '   WEBSERVICE.PQ_DATOS_WEBSERVICE.CAMBIAR_STATUS_SANS'    || chr(13) ||
                       '   SOT: '                    || to_char(p_solot)       || chr(13) ||
                       '   Numero: '                 || to_char(ln_numero)     || chr(13) ||
                       '   Respuesta del Servicio: ' || to_char(ln_resp)       || chr(13) ||
                       '   Mensaje del Servicio: '   || lv_mensaje; -- 4.0
        return;
      end if;
    end if;
    p_respuesta := 0;
    p_mensaje   := '>> Liberacion de Numeros: OK'         || chr(13) ||
                   '   SOT: '    || to_char(p_solot)   || chr(13) ||
                   '   Numero: ' || to_char(ln_numero); --4.0
  exception
    when others then
      p_respuesta := -1;
      p_mensaje   := '>> Liberacion de Numeros, Error al Ejecutar SP: ' || $$plsql_unit || '.P_LIBERA_NUMEROS' || chr(13) ||
                     '   SOT: '              || to_char(p_solot)   || chr(13) ||
                     '   Numero: '           || to_char(ln_numero) || chr(13) ||
                     '   Codigo de Error: '  || to_char(sqlcode)   || chr(13) ||
                     '   Mensaje de Error: ' || to_char(sqlerrm)   || chr(13) ||
                     '   Linea de Error: '   || dbms_utility.format_error_backtrace; --4.0
  end;

  procedure p_libera_equipos(p_solot     in  operacion.solot.codsolot%type,
                             p_respuesta out number,
                             p_mensaje   out varchar2) is
  ln_serie   operacion.tabequipo_material.numero_serie%type;
  ln_cod_id  operacion.solot.cod_id%type;
  ln_sot_eq  operacion.solot.codsolot%type;

    cursor c_solotpequ is
      select spe.numserie, spe.tipequ
        from operacion.solotptoequ spe
       where spe.codsolot = ln_sot_eq
         and spe.numserie is not null;

    -- ini 5.0
    cursor c_sot_tar is
      select s.codsolot
        from operacion.solot s, operacion.tiptrabajo t
       where s.tiptra = t.tiptra
         and s.cod_id = ln_cod_id
         and s.estsol in (select b.codigon
                            from operacion.tipopedd a, operacion.opedd b
                           where a.tipopedd = b.tipopedd
                             and a.abrev = 'CON_EST_SGA_LTE'
                             and b.abreviacion = 'ESTSOL')
         and t.tiptrs = 1;
    -- fin 5.0
  begin
    select cod_id into ln_cod_id from solot where codsolot = p_solot;
    -- ini 5.0
    -- ln_sot_eq := f_obtiene_sot(ln_cod_id);
    for c_sot in c_sot_tar loop
      ln_sot_eq := c_sot.codsolot;
      for c1 in c_solotpequ loop
        ln_serie := trim(c1.numserie);
        if c1.tipequ = 7242 then
          update operacion.tabequipo_material tm
             set estado = 0
           where trim(tm.numero_serie) = trim(c1.numserie)
             and tipo   = 1;
        end if;
        if c1.tipequ in (8450, 11519, 15566) then
          update operacion.tabequipo_material tm
             set estado = 0
           where trim(tm.numero_serie) = trim(c1.numserie)
             and tipo   = 2;
        end if;
        if c1.tipequ = 16308 then
          update operacion.tabequipo_material tm
             set estado = 0
           where trim(tm.numero_serie) = trim(c1.numserie)
             and tipo   = 3;
        end if;
        if c1.tipequ = 16939 then
          update operacion.tabequipo_material tm
             set estado = 0
           where trim(tm.numero_serie) = trim(c1.numserie)
             and tipo   = 4;
        end if;
      end loop;
    end loop;
    -- Fin 5.0
    p_respuesta := 0;
    p_mensaje   := '>> Liberacion de Equipos: OK'    || chr(13) ||
                   '   SOT: '                        || to_char(ln_sot_eq)  || chr(13) ||
                   '   Contrato: '                   || to_char(ln_cod_id);  -- 4.0
  exception
    when others then
      p_respuesta := -1;
      p_mensaje   := '>> Liberacion de Equipos, Error al Ejecutar SP:' || $$plsql_unit || '.P_LIBERA_EQUIPOS' || chr(13) ||
                     '   SOT: '              || to_char(p_solot)  || chr(13) ||
                     '   Serie: '            || to_char(ln_serie) || chr(13) ||
                     '   Codigo de Error: '  || to_char(sqlcode)  || chr(13) ||
                     '   Mensaje de Error: ' || to_char(sqlerrm)  || chr(13) ||
                     '   Linea de Error: '   || dbms_utility.format_error_backtrace;  -- 4.0
  end;

  procedure p_actualiza_provision_bscs(an_solot   in operacion.solot.codsolot %type,
                                       an_request in number,
                                       an_mensaje in varchar2, -- 3.0
                                       an_estado  in number,
                                       an_opcion  in number) is
    pragma autonomous_transaction;
  begin
    if an_opcion = 1 then -- ini 4.0
      -- Actualizacion de Mensaje en Ambas Tramas
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.observacion            = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
               r.lted_fechamodificacion = sysdate
         where r.request        = an_request;
    elsif an_opcion = 2 then
      -- Actualizacion Mensaje y estado en trama de TV
      if an_request is null  then
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.status      = an_estado,
               r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
               r.lted_fechamodificacion = sysdate
         where r.sot         = an_solot
           and r.tipo_prod   = fnd_provision_dth;
      else
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.status      = an_estado,
               r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
               r.lted_fechamodificacion = sysdate
         where r.request   = an_request
           and r.tipo_prod = fnd_provision_dth;
      end if;
    elsif an_opcion = 3 then
      -- Actualizacion Mensaje en trama de TV
      if an_request is null then
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
               r.lted_fechamodificacion = sysdate
         where r.sot         = an_solot
           and r.tipo_prod   = fnd_provision_dth;
      else
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
               r.lted_fechamodificacion = sysdate
         where r.request     = an_request
           and r.tipo_prod   = fnd_provision_dth;
      end if;
    elsif an_opcion = 4 then
      -- Actualizacion sot en ambas tramas
      update tim.lte_control_prov@dbl_bscs_bf r
         set r.sot         = an_solot,
             r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
             r.lted_fechamodificacion = sysdate
       where r.request_padre = an_request;
    elsif an_opcion = 5 then
      -- Actualizacion Mensaje en ambas tramas
      update tim.lte_control_prov@dbl_bscs_bf r
         set r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
             r.lted_fechamodificacion = sysdate
       where r.sot         = an_solot;
    elsif an_opcion = 6 then
      -- Actualizacion Mensaje en trama de TEL-INT
      update tim.lte_control_prov@dbl_bscs_bf r
         set r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000), -- 5.0 --8.0
             r.lted_fechamodificacion = sysdate
       where r.sot         = an_solot
         and r.tipo_prod   in ( fnd_provision_lte, fnd_provision_int, fnd_provision_tel);
    --ini 9.0
    elsif an_opcion = 7 then
      -- Actualizacion Mensaje y estado en trama de TV
        update tim.lte_control_prov@dbl_bscs_bf r
           set r.status      = an_estado,
               r.observacion = substr(substr(trim(an_mensaje),1,1000) || chr(13) || substr(trim(r.observacion),1,3000), 1, 4000),
               r.lted_fechamodificacion = sysdate
         where r.request   = an_request;
    -- fin 9.0
    end if; -- fin 4.0
    commit;
  exception
    when others then
      -- ini 4.0
      ln_log.request := an_request;
      ln_log.sot     := an_solot;
      ln_log.mensaje := '>> Actualizacion de Tabla Provision.'       || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)     || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)     || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_reg_log(ln_log);
      -- fin 4.0
      rollback;
  end;

  procedure p_consultar_conax(p_solot     in operacion.solot.codsolot%type,
                              p_respuesta out number,
                              p_mensaje   out varchar2) is
    l_idlote            operacion.ope_lte_lote_sltd_aux.idlote%type;
    pArchivoRemotoOK    varchar2(50);
    pArchivoRemotoError varchar2(50);
    lc_nomarchivo       varchar2(50);
    lc_mensaje          varchar2(1000);
    lb_archivo_ok       boolean;
    lb_archivo_error    boolean;
    ln_cant_arch_error  number(10);
    ln_cnt_tv           number(10);
    connex_i            operacion.conex_intraway; --4.0

    -- Cursor Consultar Respuesta Conax
    cursor c_arch_env is
      select a.archivo, a.idlote, a.bouquet
        from operacion.ope_lte_archivo_cab a
       where a.idlote = l_idlote
         and a.estado = 2;
  begin
    -- Consulta si Registra Tiene una Trama de DTH
    select count(*)
      into ln_cnt_tv
      from tim.lte_control_prov@dbl_bscs_bf r
      join tim.lte_actions@dbl_bscs_bf a
        on r.action_id = a.action_id
     where r.sot       = p_solot
       and r.tipo_prod = fnd_provision_dth
       and r.action_id in (select b.codigon
                             from operacion.tipopedd a,
                                  operacion.opedd b
                            where a.tipopedd = b.tipopedd
                              and a.abrev = 'TAREA_PROG_LTE'
                              and b.abreviacion in ('ALTA_PROGRAMADA','BAJA_PROGRAMADA'));
    if ln_cnt_tv = 0 then
      -- No registra Trama de DTH
      p_respuesta := 1;
      p_mensaje   := ' - Recepcion DTH Conax'       || chr(13) ||
                     ' - SOT: ' || to_char(p_solot) || chr(13) ||
                     ' - El Registro No tiene Trama de DTH.';
      return;
    end if;

    -- Consulta si Registro ya esta Verificado.
    select count(*)
      into ln_cnt_tv
      from operacion.ope_lte_lote_sltd_aux
     where idlote = (select idlote
                       from operacion.tab_rec_csr_lte_cab
                      where codsolot = p_solot)
       and estado in (5, 6);
    if ln_cnt_tv = 1 then
      -- Ya se se consulto y Verifico el envio a Conax.
      p_respuesta := 2;
      p_mensaje   := ' - Recepcion DTH Conax'          || chr(13) ||
                     ' - SOT: ' || to_char(p_solot) || chr(13) ||
                     ' - Ya se Realizo la Recepcion de Archivos en Conax.';
      return;
    end if;
    begin
      -- Consulta de Lote
      select c.idlote
        into l_idlote
        from tim.lte_control_prov@dbl_bscs_bf a,
             operacion.tab_rec_csr_lte_cab    b,
             operacion.ope_lte_lote_sltd_aux  c
       where a.sot       = b.codsolot
         and b.idlote    = c.idlote
         and a.sot       = p_solot
         and a.tipo_prod = fnd_provision_dth
         and a.status in (select b.codigon
                            from operacion.tipopedd a,
                                 operacion.opedd b
                           where a.tipopedd    = b.tipopedd
                             and a.abrev       = 'CONF_LTE_ORI_EST'
                             and b.abreviacion = 'ESTADO-OK'
                             and b.codigoc     = fnd_provision_dth)
         and a.action_id in (select b.codigon
                               from operacion.tipopedd a,
                                    operacion.opedd b
                              where a.tipopedd = b.tipopedd
                                and a.abrev = 'TAREA_PROG_LTE'
                                and b.abreviacion in ('ALTA_PROGRAMADA','BAJA_PROGRAMADA'));
    exception
      when others then
        -- No Registra Envio de Archivos
        p_respuesta := 3;
        p_mensaje   := ' - Recepcion DTH Conax'       || chr(13) ||
                       ' - SOT: ' || to_char(p_solot) || chr(13) ||
                       ' - El Registro aun Esta Pendiente el envio de Archivos a Conax.';
        return;
    end;
    -- Datos de Conexion
    connex_i := operacion.pq_dth.f_crea_conexion_intraway;
    for c_det in c_arch_env loop
      pArchivoRemotoOK    := connex_i.pArchivoRemotoOK || c_det.archivo;
      pArchivoRemotoError := connex_i.pArchivoRemotoError || c_det.archivo;
      lc_nomarchivo       := c_det.archivo;
      lb_archivo_ok       := false;
      lb_archivo_error    := false;
      ln_cant_arch_error  := 0;
      lc_mensaje          := '';
      begin
        operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.pHost,
                                                          connex_i.pPuerto,
                                                          connex_i.pUsuario,
                                                          connex_i.pPass,
                                                          connex_i.pDirectorioLocal,
                                                          lc_nomarchivo,
                                                          pArchivoRemotoOK);
        lb_archivo_ok := true;
      exception
        when others then
          utl_tcp.close_all_connections;
          lc_mensaje    := substr(' -- Error al Realizar la Validacion en la Ruta: ' || pArchivoRemotoOK || chr(13) ||
                                  ' -- Archivo: '          || to_char(lc_nomarchivo) || chr(13) ||
                                  ' -- Codigo de Error: '  || to_char(sqlcode)       || chr(13) ||
                                  ' -- Mensaje de Error: ' || to_char(sqlerrm)       || chr(13) ||
                                  ' -- Linea de Error: '   || dbms_utility.format_error_backtrace,
                                  1,
                                  4000);
          lb_archivo_ok := false;
      end;
      if lb_archivo_ok then
        -- Actualizar Recepcion en la Cabecera
        update operacion.ope_lte_archivo_cab
           set estado  = 3
         where idlote  = l_idlote
           and bouquet = c_det.bouquet;
        -- Actualizar Recepcion en el Detalle
        update operacion.ope_lte_archivo_det
           set estado  = 'OK'
         where idlote  = l_idlote
           and bouquet = c_det.bouquet;
      else
        begin
          operacion.pq_dth_interfaz.p_recibir_archivo_ascii(connex_i.pHost,
                                                            connex_i.pPuerto,
                                                            connex_i.pUsuario,
                                                            connex_i.pPass,
                                                            connex_i.pDirectorioLocal,
                                                            lc_nomarchivo,
                                                            pArchivoRemotoError);
          lb_archivo_error := true;
        exception
          when others then
            utl_tcp.close_all_connections;
            lc_mensaje := substr(' -- Error al Realizar la Validacion en la Ruta: ' || pArchivoRemotoError || chr(13) ||
                                 ' -- Archivo: '          || to_char(lc_nomarchivo) || chr(13) ||
                                 ' -- Codigo de Error: '  || to_char(sqlcode)       || chr(13) ||
                                 ' -- Mensaje de Error: ' || to_char(sqlerrm)       || chr(13) ||
                                 ' -- Linea de Error: '   || dbms_utility.format_error_backtrace,
                                 1,
                                 4000);
        end;
        if lb_archivo_error then
          ln_cant_arch_error := ln_cant_arch_error + 1;
          -- Actualizar Estado de Error en la Cabecera
          update operacion.ope_lte_archivo_cab
             set estado  = 4
           where idlote  = l_idlote
             and bouquet = c_det.bouquet;
          -- Actualizar Estado de Error en el Detalle
          update operacion.ope_lte_archivo_det
             set estado  = 'Error'
           where idlote  = l_idlote
             and bouquet = c_det.bouquet;
        end if;
      end if;
    end loop;
    if lc_mensaje is not null then
      p_respuesta := -2;
      p_mensaje   := ' -- Recepcion DTH Conax'         || chr(13) ||
                     ' -- SOT: '  || to_char(p_solot)  || chr(13) ||
                     ' -- Lote: ' || to_char(l_idlote) || chr(13) ||
                     ' -- Se Generaron Errores al Realizar la Consulta en Conax.' || chr(13) ||  lc_mensaje;
    else
      if ln_cant_arch_error = 0 then
        -- Actualizar estado a Verificado.
        update operacion.ope_lte_lote_sltd_aux
           set estado = 5
         where idlote = l_idlote;
        p_respuesta := 0;
        p_mensaje   := ' -- Recepcion DTH Conax'         || chr(13) ||
                       ' -- SOT: '  || to_char(p_solot)  || chr(13) ||
                       ' -- Lote: ' || to_char(l_idlote) || chr(13) ||
                       ' -- Se completo la Recepcion de Archivos en Conax.';
      else
        p_respuesta := -1;
        p_mensaje   := '- Recepcion DTH Conax'          || chr(13) ||
                       ' - SOT: '  || to_char(p_solot)  || chr(13) ||
                       ' - Lote: ' || to_char(l_idlote) || chr(13) ||
                       ' - No se completo la Recepcion de Archivos en Conax.';
      end if;
    end if;
  exception
    when others then
      p_respuesta := -2;
      p_mensaje   := ' -- Recepcion DTH Conax, Error al Ejecutar SP: ' || $$plsql_unit || '.P_CONSULTAR_CONAX' || chr(13) ||
                     ' -- SOT: '              || to_char(p_solot) || chr(13) ||
                     ' -- Lote: '             || to_char(l_idlote)|| chr(13) ||
                     ' -- Codigo de Error: '  || to_char(sqlcode) || chr(13) ||
                     ' -- Mensaje de Error: ' || to_char(sqlerrm) || chr(13) ||
                     ' -- Linea de Error: '   || dbms_utility.format_error_backtrace;
  end;

  procedure p_verificar_conax(p_solot     in operacion.solot.codsolot%type,
                              p_respuesta out number,
                              p_mensaje   out varchar2) is
    ln_lote        operacion.tab_rec_csr_lte_cab.idlote%type;
    ln_lote_cons   operacion.tab_rec_csr_lte_cab.idlote%type;
    ln_estado      operacion.ope_lte_lote_sltd_aux.estado%type;
    ln_cant_valida number;
    ln_cnt_tv      number;
  begin

    -- Consulta si Registra Trama de DTH
    select count(*)
      into ln_cnt_tv
      from tim.lte_control_prov@dbl_bscs_bf r
      join tim.lte_actions@dbl_bscs_bf a
        on r.action_id = a.action_id
     where r.sot       = p_solot
       and r.tipo_prod = fnd_provision_dth
       and r.action_id in (select b.codigon
                             from operacion.tipopedd a,
                                  operacion.opedd b
                            where a.tipopedd = b.tipopedd
                              and a.abrev = 'TAREA_PROG_LTE'
                              and b.abreviacion in ('ALTA_PROGRAMADA','BAJA_PROGRAMADA'));
    if ln_cnt_tv = 0 then
      -- No registra Trama de DTH
      p_respuesta := 1;
      p_mensaje   := ' -- Verificacion DTH Conax, SOT: ' || to_char(p_solot) || ', El Registro No tiene Trama de DTH.';
      return;
    end if;

    -- Consulta si Registro ya esta Verificado.
    select count(*)
      into ln_cnt_tv
      from operacion.ope_lte_lote_sltd_aux
     where idlote = (select idlote
                       from operacion.tab_rec_csr_lte_cab
                      where codsolot = p_solot)
       and estado = 6;
    if ln_cnt_tv = 1 then
      -- Ya se se consulto y Verifico el envio a Conax.
    p_actualiza_provision_bscs(p_solot, null, null, 98, 2); -- 3.0
      p_respuesta := 2;
      p_mensaje   := ' -- Verificacion DTH Conax, SOT: ' || to_char(p_solot) || ', ya se Verifico en Conax.';
      return;
    end if;

    begin
      -- Consulta de Lote
      select c.idlote
        into ln_lote
        from tim.lte_control_prov@dbl_bscs_bf a,
             operacion.tab_rec_csr_lte_cab    b,
             operacion.ope_lte_lote_sltd_aux  c
       where a.sot       = b.codsolot
         and b.idlote    = c.idlote
         and a.sot       = p_solot
         and a.tipo_prod = fnd_provision_dth
         and a.status in (select b.codigon
                            from operacion.tipopedd a,
                                 operacion.opedd b
                           where a.tipopedd    = b.tipopedd
                             and a.abrev       = 'CONF_LTE_ORI_EST'
                             and b.abreviacion = 'ESTADO-OK'
                             and b.codigoc     = fnd_provision_dth)
         and a.action_id in (select b.codigon
                               from operacion.tipopedd a,
                                    operacion.opedd b
                              where a.tipopedd = b.tipopedd
                                and a.abrev = 'TAREA_PROG_LTE'
                                and b.abreviacion in ('ALTA_PROGRAMADA','BAJA_PROGRAMADA'));
    exception
      when others then
        ln_lote := 0;
    end;
    -- Consulta Estado de Lote
    select idlote, estado
      into ln_lote_cons, ln_estado
      from operacion.ope_lte_lote_sltd_aux
     where idlote = ln_lote;
    if ln_estado = 5 then   -- Recepcionado en Conax
      -- Consulta si existen Archivos con Error
      select count(1)
        into ln_cant_valida
        from operacion.ope_lte_archivo_cab
       where idlote = ln_lote_cons
         and estado <> 3;
      if ln_cant_valida = 0 then
        -- Se actualiza Registro a Verificado
        update operacion.ope_lte_lote_sltd_aux
           set estado = 6
         where idlote = ln_lote_cons
           and estado <> 6;
        -- Aprovision de Request: TV
        p_actualiza_provision_bscs(p_solot, null, null, 98, 2); -- 3.0
        p_respuesta := 0;
        p_mensaje   := ' -- Verificacion DTH Conax'      || chr(13) ||
                       ' -- SOT: '   || to_char(p_solot) || chr(13) ||
                       ' -- Lote: '  || to_char(ln_lote) || chr(13) ||
                       ' -- Se completo la Verificacion de Archivos en Conax.';
      else
        p_respuesta := -1;
        p_mensaje   := ' -- Verificacion DTH Conax'      || chr(13) ||
                       ' -- SOT: '   || to_char(p_solot) || chr(13) ||
                       ' -- Lote: '  || to_char(ln_lote) || chr(13) ||
                       ' -- No se completo la Verificacion de Archivos en Conax, aun hay Archivos con Error.';
      end if;
    elsif ln_estado = 6 then -- Verificado en conaz
    p_actualiza_provision_bscs(p_solot, null, null, 98, 2); -- 3.0
      p_respuesta := 2;
      p_mensaje   := ' -- Verificacion DTH Conax'      || chr(13) ||
                     ' -- SOT: '   || to_char(p_solot) || chr(13) ||
                     ' -- Lote: '  || to_char(ln_lote) || chr(13) ||
                     ' -- ya se Realizo la Verificacion de Archivos en Conax.';
    end if;
  exception
    when others then
      p_respuesta := -2;
      p_mensaje   := ' -- Verificacion DTH Conax, Error al Ejecutar SP: ' || $$plsql_unit || '.P_VERIFICAR_CONAX' || chr(13) ||
                     ' -- SOT: '              || to_char(p_solot) || chr(13) ||
                     ' -- Lote: '             || to_char(ln_lote) || chr(13) ||
                     ' -- Codigo de Error: '  || to_char(sqlcode) || chr(13) ||
                     ' -- Mensaje de Error: ' || to_char(sqlerrm) || chr(13) ||
                     ' -- Linea de Error: '   || dbms_utility.format_error_backtrace;
  end;

  procedure p_actualiza_sot(p_sot         in  operacion.solot.codsolot%type,
                            p_cod_id      in  operacion.solot.codsolot%type,
                            p_customer_id in  operacion.solot.codsolot%type)
    is
  begin
    -- Actualiza Datos de La SOT
    update operacion.solot
       set cod_id      = p_cod_id,
           customer_id = p_customer_id
     where codsolot    = p_sot;
  end;
  -- fin 2.0
  -- ini 4.0
  /****************************************************************
  '* Nombre SP :          sp_sncode_lineal
  '* Propósito :          Descomponer los Datos de los Canales en un Array
  '* Input :              Sncode(Canales)
  '* Output :             Array
  '* Creado por :         Dorian Sucasaca
  '* Fec Creación :       17/10/2016
  '* Fec Actualización :  17/10/2016
  '****************************************************************/
  procedure sp_sncode_lineal(in_sncode  in varchar2,
                            out_sncode out dbms_utility.uncl_array) is
    ln_cnt  number;
    sncodes dbms_utility.uncl_array;

  begin
    dbms_utility.comma_to_table(trim(replace('"' || in_sncode || '"',
                                             ',',
                                             '","')),
                                ln_cnt,
                                sncodes);
    for i in 1 .. ln_cnt loop
      out_sncode(i) := trim(replace(sncodes(i), '"', ''));
    end loop;
  exception
    when others then
      raise_application_error(-20080, sqlerrm);
  end;

  /****************************************************************
  '* Nombre SP :            sp_valida_trama_dth
  '* Propósito :            SP que valida la trama de DTH al Activarse la Tarea
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_trama_dth( a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) is
    ln_sot        operacion.solot.codsolot%type;
    ln_val_tv     number;
    ln_val_status number;
  begin
     select w.codsolot
       into ln_sot
       from opewf.wf w
      where w.idwf = a_idwf;

    select count(1)
      into ln_val_tv
      from tim.lte_control_prov@dbl_bscs_bf
     where sot        = ln_sot
       and tipo_prod  = fnd_provision_dth;

    if ln_val_tv = 0 then
      --cambia a estado no interviene
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       sysdate,
                                       sysdate);
    else
      begin
        select status
          into ln_val_status
          from tim.lte_control_prov@dbl_bscs_bf
         where sot        = ln_sot
           and tipo_prod  = fnd_provision_dth;
      exception
        when others then
          ln_val_status := 0;
      end;
      if ln_val_status = 11 then
        --cambia a estado Con Error
        opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                         2,
                                         19,
                                         0,
                                         sysdate,
                                         sysdate);
      end if;
    end if;
  exception
    when others then
      ln_log.mensaje := '>> Validar Trama Conax: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_valida_trama_il_janus
  '* Propósito :            SP que valida la trama de TEL-INT al Activarse la Tarea
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_trama_il_janus( a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    ln_sot        operacion.solot.codsolot%type;
    ln_val_tel    number;
    ln_val_status number;
  begin

     SELECT w.codsolot
       into ln_sot
       from opewf.wf w
      where w.idwf = a_idwf;

    select count(1)
      into ln_val_tel
      from tim.lte_control_prov@dbl_bscs_bf
     where sot        = ln_sot
       and tipo_prod  in ( fnd_provision_lte, fnd_provision_int, fnd_provision_tel );

    --Verificar que la SOT tenga servicio Telefonico
    if ln_val_tel > 0 then
      select count(1)
      into ln_val_tel
        from solotpto s, inssrv i
       where s.codsolot = ln_sot
         and s.codinssrv = i.codinssrv
         and i.tipinssrv = 3;
    end if;
    
    if ln_val_tel = 0 then
      --cambia a estado no interviene
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       sysdate,
                                       sysdate);
    else
      begin
        select status
          into ln_val_status
          from tim.lte_control_prov@dbl_bscs_bf
         where sot        = ln_sot
           and tipo_prod  in ( fnd_provision_lte, fnd_provision_int, fnd_provision_tel );
      exception
        when others then
          ln_val_status := 0;
      end;

      if ln_val_status = 11 then
        --cambia a estado Con Errores
        opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                         2,
                                         19,
                                         0,
                                         sysdate,
                                         sysdate);
      end if;
    end if;
  exception
    when others then
      ln_log.mensaje := '>> Validar Trama IL/JANUS: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_valida_prov_il
  '* Propósito :            SP que valida la Provision de IL
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_prov_il( a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is
    ln_sot        operacion.solot.codsolot%type;
    ln_val_status number;
  begin
    select w.codsolot
      into ln_sot
      from opewf.wf w
     where w.idwf = a_idwf;

    ln_val_status := tim.bscsfun_provlte@dbl_bscs_bf(ln_sot);

    if ( ln_val_status =  7 or  ln_val_status = 100 )then
      p_actualiza_provision_bscs(ln_sot, null, '>> Validacion en IL: Ok', null, 6);
    elsif ( ln_val_status = 11 ) then
      --cambia a estado Con Errores
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       2,
                                       19,
                                       0,
                                       sysdate,
                                       sysdate);
    else
      --cambia a estado Generado
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
    end if;
  exception
    when others then
      ln_log.mensaje := '>> Validar Prov. IL: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_valida_prov_dth
  '* Propósito :            SP que valida la Provision de Conax
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_valida_prov_dth( a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
    ln_sot        operacion.solot.codsolot%type;
    ln_val_estado number;
    ln_val_status number;
    ln_val_tv     number;
	LV_RPTA_CONTEGO VARCHAR2(5);--v12.0
    LV_MSJ_CONTEGO  VARCHAR2(100);--v12.0
    LN_FLAG       	NUMBER:=0;--v12.0
  begin
    select w.codsolot
      into ln_sot
      from opewf.wf w
     where w.idwf = a_idwf;

    select count(1)
      into ln_val_tv
      from prov_bscs_il_lte
     where sot        = ln_sot
       and tipo_prod  = fnd_provision_dth;

    if ln_val_tv = 1 then
      select status
        into ln_val_status
        from prov_bscs_il_lte
       where sot        = ln_sot
         and tipo_prod  = fnd_provision_dth;

      if ln_val_status = 99 then
        begin
          select estado
            into ln_val_estado
            from operacion.ope_tvsat_lote_sltd_aux
           where idlote = (select idlote
                             from operacion.tab_rec_csr_lte_cab
                            where codsolot = ln_sot);
        --ini v12.0
        OPERACION.PKG_CONTEGO.SGASS_VALPROVISION(LN_SOT,LV_RPTA_CONTEGO,LV_MSJ_CONTEGO);
        IF LV_RPTA_CONTEGO = 'OK' AND LV_MSJ_CONTEGO = FND_MSJ_PROVISION_OK THEN
          LN_FLAG :=1;
        END IF;
        --fin v12.0

        exception
          when others then
            ln_val_estado := 0;
        end;
        if ln_val_estado > 0 then
          if ln_val_estado =  6 OR LN_FLAG = 1 then--V12.0

            update operacion.tab_rec_csr_lte_cab
               set estado    = 3
             where codsolot = ln_sot;
            commit;
            p_actualiza_provision_bscs(ln_sot, null, '>> Validacion de Generacion y Envio a CONAX: Ok', 98, 2);
          else
            --cambia a estado En Ejecucion
            opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                             2,
                                             2,
                                             0,
                                             sysdate,
                                             sysdate);
          end if;
        elsif ln_val_estado = 0 then
          --cambia a estado Generado
          opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                           1,
                                           1,
                                           0,
                                           sysdate,
                                           sysdate);
        end if;
      else
        --cambia a estado Con Errores
        opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                         2,
                                         19,
                                         0,
                                         sysdate,
                                         sysdate);
      end if;
    end if;
  exception
    when others then
      ln_log.mensaje := '>> Validar Prov. Conax: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_valida_prov_janus
  '* Propósito :            SP que valida la Provision de JANUS
  '* Input :                a_idtareawf: ID de la tarea.
                            a_idwf:      ID de la instancia de workflow.
                            a_tarea:     ID de la tarea para una definición de wf.
                            a_tareadef:  Tipo de Tarea.
  '* Output :               --
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    25/10/2016
  '****************************************************************/
  procedure sp_valida_prov_janus( a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is
    ln_sot        operacion.solot.codsolot%type;
    ln_numero     operacion.inssrv.numero%type;
    ln_tar_wf     number;
    ln_action     number;
    ln_coid       number;
    ln_res_bscs   number;
    ln_origen     varchar2(10);
    ln_est_linea  varchar(20);
    ln_msj_bscs   varchar2(1000);
    ln_mensaje    varchar2(1000);
    ln_resultado  number;
    ln_res_janus  number;
    ln_msj_janus  varchar2(1000);
    ln_cust_janus varchar2(100);
    ln_plan_janus number(10);
    ln_prod_janus varchar2(100);
    ln_fec_janus  date;
    ln_est_janus  varchar2(50);
    ln_cic_janus  varchar2(50);
    ln_count_baja number; --8.00

  begin
    -- Consulta SOT
    select w.codsolot
      into ln_sot
      from opewf.wf w
     where w.idwf = a_idwf
       and estwf = 2;

     begin
          for c_val_tareas in (select b.codigon
                                 from operacion.tipopedd a,
                                      operacion.opedd b
                                where a.tipopedd = b.tipopedd
                                  and a.abrev    = 'CONF_TAREAS_LTE'
                                  and b.abreviacion = 'PRE') loop

            select count(1)
              into ln_tar_wf
              from opewf.tareawf w
             where w.idwf in (select idwf
                                from opewf.wf
                               where codsolot = ln_sot
                                 and estwf = 2)
               and w.tareadef = c_val_tareas.codigon
               and w.esttarea in (select esttarea
                                    from opewf.esttarea
                                   where tipesttar = 4);
                                   
             if (ln_tar_wf = 0) then --Error de Cancelaciones 
                    begin
                      
                      select count(1)
                        into ln_tar_wf
                        from opewf.tareawf w
                       where w.idwf in (select idwf
                                          from opewf.wf
                                         where codsolot = ln_sot
                                           and estwf = 2)
                         and w.tareadef = c_val_tareas.codigon
                         and w.esttarea in
                             (select esttarea
                                    from opewf.esttarea
                                   where tipesttar = 2
                                   and esttarea = 19);
                               
                    exception
                      when others then
                       ln_tar_wf := 0;
                    end; 
              End  if;  

             -- exit si existe una Tarea Pendiente de Cierre
             exit when ln_tar_wf = 0;
          end loop;
     exception
       when others then
         ln_tar_wf := 0;
     end;

    -- Inicio Ejecucion en Janus
    if ( ln_tar_wf =  1 ) then
      -- Inicio Consulta Action/Contrato
      begin
        select action_id, co_id, origen_prov
          into ln_action, ln_coid, ln_origen
          from prov_bscs_il_lte
         where sot = ln_sot
           and tipo_prod   in ( fnd_provision_lte, fnd_provision_tel);-- 5.0

        select b.codigoc
          into ln_est_linea
          from operacion.tipopedd a, operacion.opedd b
         where a.tipopedd    = b.tipopedd
           and a.abrev       = 'CONF_LTE_JANUS'
           and b.abreviacion = ln_origen  -- 5.0
           and codigon       = ln_action;

      exception
        when others then
          begin
            select action_id, co_id, origen_prov
              into ln_action, ln_coid, ln_origen
              from operacion.logrqt_csr_lte
             where sot = ln_sot
               and tipo_prod   in ( fnd_provision_lte, fnd_provision_tel) --5.0
               and action_id is not null
               and origen_prov is not null
               and rownum = 1;

            select b.codigoc
              into ln_est_linea
              from operacion.tipopedd a, operacion.opedd b
             where a.tipopedd    = b.tipopedd
               and a.abrev       = 'CONF_LTE_JANUS'
               and b.abreviacion = ln_origen  -- 5.0
               and codigon       = ln_action;
          exception
            when others then
              ln_action := null;
              ln_coid   := null;
          end;
      end;
      -- Fin    Consulta Action/Contrato

      -- Inicio Consulta de Numero.
      begin
       select i.numero
         into ln_numero
         from operacion.inssrv i
        where i.codinssrv in (select codinssrv
                                from operacion.solotpto
                               where codsolot = ln_sot)
          and i.tipsrv = '0004'; --8.0
       -- Ini 8.0
       if ln_numero is null or trim(ln_numero)='' then
         select distinct se.mac
           into ln_numero
           from operacion.solot s,
                operacion.solotptoequ se
          where s.codsolot = se.codsolot
            and se.mac is not null
            and se.tipequ=16308
            and s.cod_id=ln_coid;
       end if;
       -- Fin 8.0
      exception
       when others then
        ln_numero := null;

		 -- ini 8.0
         if ln_numero is null then
	         select distinct se.mac
	           into ln_numero
	           from operacion.solot s,
	                operacion.solotptoequ se
	          where s.codsolot = se.codsolot
	            and se.mac is not null
	            and se.tipequ=16308
	            and s.cod_id=ln_coid;
         end if;
		 -- fin 8.0
      end;
      -- Fin   Consulta de Numero.
      ln_log.sot    := ln_sot;
      ln_log.co_id  := ln_coid;

      -- Ejecutar SP del BSCS Consulta a JANUS
      tim.bscsss_janusprv@dbl_bscs_bf(ln_coid, ln_action, ln_res_bscs, ln_msj_bscs);

      if ln_res_bscs = -1 then
        ln_msj_bscs := 'Pendiente';
      end if;

      --ini 8.00
      --Se valida que sea una SOT de BAJA
      select count(*)
        into ln_count_baja
        from operacion.tiptrabajo tra
       where tra.tiptrs = 5
         and tra.tiptra in (select s.tiptra
                              from operacion.solot s
                             where s.codsolot = ln_sot);

      --fin 8.00

      if ln_count_baja = 0 then -- 8.00
        --Ejecutar SP del SGA Consulta a Janus x Linea
        operacion.pq_sga_janus.p_cons_linea_janus(ln_numero,
                                                  1,
                                                  ln_res_janus,
                                                  ln_msj_janus,
                                                  ln_cust_janus,
                                                  ln_plan_janus,
                                                  ln_prod_janus,
                                                  ln_fec_janus,
                                                  ln_est_janus,
                                                  ln_cic_janus);
      -- ini 8.00
      else
        -- Valida que no existe la linea en Janus
        operacion.pq_sga_janus.p_cons_existe_linea_janus(ln_numero,
                                                         ln_res_janus,
                                                         ln_msj_janus);

        if ln_res_janus = 1 then
            ln_log.mensaje := '>>La linea aún se encuentra registrada en JANUS, no se puede realizar la BAJA';
            p_reg_log(ln_log);
            --cambia a estado Generado
            opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                             1,
                                             1,
                                             0,
                                             sysdate,
                                             sysdate);
            return;
        else
          ln_est_janus := 'Terminado';
        end if;
      end if;
      -- fin 8.00

      if ( ln_res_bscs =  1 and upper(ln_est_linea) = upper(ln_est_janus) )then
        p_actualiza_provision_bscs(ln_sot, null, '>> Validacion en JANUS: ' || ln_msj_bscs || '/' || ln_est_janus, null, 6);
        sp_actualizar_servicios(ln_sot ,ln_resultado ,ln_mensaje );
        if ln_resultado = 0 then
          ln_log.mensaje := ln_mensaje;
          p_reg_log(ln_log);
        else
          ln_log.mensaje := ln_mensaje;
          p_actualiza_provision_bscs(ln_sot, null, ln_log.mensaje, null, 6);
          p_reg_log(ln_log);
          --cambia a estado Con Errores
          opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                           2,
                                           19,
                                           0,
                                           sysdate,
                                           sysdate);
          return;
        end if;
      else
        ln_log.mensaje  := ln_msj_bscs;
        p_actualiza_provision_bscs(ln_sot, null, '>> Validacion en JANUS: ' || ln_msj_bscs  || '/' || ln_est_janus, null, 6); -- 5.0
        p_reg_log(ln_log);
        --cambia a estado Con Errores
        opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                         2,
                                         19,
                                         0,
                                         sysdate,
                                         sysdate);
        return;
      end if;
    else
      --cambia a estado Generado
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       1,
                                       1,
                                       0,
                                       sysdate,
                                       sysdate);
      return;
    end if;
    -- Fin Ejecucion en Janus
  exception
    when others then
      ln_log.mensaje := '>> Validar Prov. JANUS: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_actualizar_servicios
  '* Propósito :            SP Actuliza las Instancia de Servicio y Producto del SGA
  '* Input :                an_sot:      codigo de la SOLOT
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    17/10/2016
  '****************************************************************/
  procedure sp_actualizar_servicios(an_sot       in operacion.solot.codsolot%type,
                                   an_resultado out number,
                                   an_mensaje   out varchar2) is
    ln_tiptrs  operacion.tiptrabajo.tiptra%type;
    ln_cod_id  operacion.solot.cod_id%type;
    ln_opcion  number;
    lv_mensaje varchar2(1000);
    ln_resp    number;
  begin

    select tt.tiptrs, s.cod_id
      into ln_tiptrs, ln_cod_id
      from operacion.tiptrabajo tt
      join operacion.solot s
        on s.tiptra   = tt.tiptra
     where s.codsolot = an_sot;


    ln_log        := null;
    ln_log.sot    := an_sot;
    ln_log.co_id  := ln_cod_id;

    if ( ln_tiptrs = 1 or ln_tiptrs = 2 or ln_tiptrs = 3 ) then
      ln_opcion := 1;
      ln_log.mensaje := '>> Reconexion de Servicios SGA: OK.';
    elsif ( ln_tiptrs = 4 ) then
      ln_opcion := 2;
      ln_log.mensaje := '>> Suspension de Servicios SGA: OK.';
    elsif ( ln_tiptrs = 5 or ln_tiptrs = 10 ) then
      ln_opcion := 3;
      -- Ejecutar Liberacion de Numero
      p_libera_numeros(an_sot, ln_resp, lv_mensaje);
      if ln_resp = 0 then
        ln_log.mensaje := lv_mensaje;
        p_reg_log(ln_log);
      else
        ln_log.mensaje := lv_mensaje;
        p_reg_log(ln_log);
        an_resultado  := -1;
        an_mensaje    := ln_log.mensaje;
        return;
      end if;
      -- Ejecutar Liberacion de Equipos
      p_libera_equipos(an_sot, ln_resp, lv_mensaje);
      if ln_resp = 0 then
        ln_log.mensaje := lv_mensaje;
        p_reg_log(ln_log);
      else
        ln_log.mensaje := lv_mensaje;
        p_reg_log(ln_log);
        an_resultado  := -1;
        an_mensaje    := ln_log.mensaje;
        return;
      end if;
      ln_log.mensaje := '>> Cancelacion de Servicios SGA: OK.';
    end if;

    -- Actualizacion Inssrv
    update operacion.inssrv i
       set i.estinssrv = ln_opcion
     where i.codinssrv in (select distinct s.codinssrv
                             from operacion.solotpto s
                            where s.codsolot = an_sot);

    -- Actualizacion Insprd
    update operacion.insprd ip
       set ip.estinsprd = ln_opcion
     where ip.pid in (select distinct s.pid
                        from operacion.solotpto s
                       where s.codsolot = an_sot);

    an_resultado   := 0;
    an_mensaje     := 'Ok';
    p_actualiza_provision_bscs(an_sot, null, ln_log.mensaje, null, 5);
  exception
    when others then
      ln_log.mensaje := '>> Actualizar Servicios SGA, Error al Ejecutar SP: ' || $$plsql_unit || '.SP_ACTUALIZAR_SERVICIOS' || chr(13) ||
                        '   SOT: '                || to_char(an_sot)      || chr(13) ||
                        '   Codigo de Error: '    || to_char(sqlcode)     || chr(13) ||
                        '   Mensaje de Error: '   || to_char(sqlerrm)     || chr(13) ||
                        '   Linea de Error: '     || dbms_utility.format_error_backtrace;
      an_resultado   := -1;
      an_mensaje     := 'Error';
      p_reg_log(ln_log);
  end;

  /****************************************************************
  '* Nombre SP :            sp_gen_bou_bscs
  '* Propósito :            SP extrae los Bouquet del BSCS
  '* Input :                an_coid:      Contrato
                            an_sot:       Codigo de SOLOT
                            an_tipequ:    Tipo de Equipo
                            an_log:       Datos del LOG
                            an_tipo:      Tipo de Operacion
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    25/10/2016
  '****************************************************************/
  procedure sp_gen_bou_bscs( an_coid       in operacion.solot.cod_id%type,
                             an_sot        in operacion.solot.codsolot%type,
                             an_tipequ     in operacion.solotptoequ.tipequ%type,
                             an_log        in operacion.logrqt_csr_lte%rowtype,
                             an_tipo       in varchar2,
                             an_tiposol    in varchar2, --6.0
                             an_resultado  out number,
                             an_mensaje    out varchar2) is

    id_proc             operacion.tab_rec_csr_lte_cab.idprocess%type;
    ln_sot              operacion.solot.codsolot%type;
    out_sncode          dbms_utility.uncl_array;
    out_bouquet         dbms_utility.uncl_array;
    lv_sncode_bscs      varchar2(1000);
    lv_sncode           varchar2(1000);
    lv_bouquet_bscs     varchar2(1000); -- 5.0
    lc_proc             varchar2(200);
    exc_sncode          exception;
    exc_tarjeta         exception;
    exc_bouquet         exception;
    cnt_sncode          number;
    cnt_bouquets        number;
    cnt_tarjetas        number;
    cnt_val_tar         number; -- 5.0

    cursor c_sot_tar is
      select s.codsolot
        from operacion.solot s, operacion.tiptrabajo t
       where s.tiptra = t.tiptra
         and s.cod_id = an_coid
         and s.estsol in (select b.codigon
                            from operacion.tipopedd a, operacion.opedd b
                           where a.tipopedd = b.tipopedd
                             and a.abrev = 'CON_EST_SGA_LTE'
                             and b.abreviacion = 'ESTSOL')
         and t.tiptrs = 1; -- 5.0

    cursor c_tarjetas is
      select distinct se.numserie
        from operacion.solotptoequ se
       where se.codsolot = ln_sot
         and se.tipequ   = an_tipequ;
  begin
    ln_log.request_padre := an_log.request_padre;
    ln_log.request       := an_log.request;
    ln_log.customer_id   := an_log.customer_id;
    ln_log.co_id         := an_log.co_id;
    ln_log.action_id     := an_log.action_id;
    ln_log.origen_prov   := an_log.origen_prov;
    ln_log.tipo_prod     := an_log.tipo_prod;
    ln_log.sot           := an_sot;
    -- Inicio Consulta SNCODE
    lv_sncode_bscs := tim.bscsfun_servlte@dbl_bscs_bf(an_coid);
    if lv_sncode_bscs is null then
      lc_proc := 'TIM.BSCSFUN_SERVLTE@DBL_BSCS_BF';
      raise exc_sncode;
    end if;
    sp_sncode_lineal(lv_sncode_bscs, out_sncode);
    if out_sncode is null then
      lc_proc := 'OPERACION.PQ_CSR_LTE.SP_SNCODE_LINEAL';
      raise exc_sncode;
    end if;
    -- Fin Consulta SNCODE

    -- Generacion de Cabecera Para DTH
    insert into operacion.tab_rec_csr_lte_cab
      (idprocess, codsolot, tipo, estado, fecreg, usureg, tiposolicitud)
    values
      (operacion.sq_tab_csr_lte_cab.nextval, an_sot, an_tipo, 1, sysdate, user, an_tiposol) --6.0
    returning idprocess into id_proc;

    -- Recorre los Datos de los SNCODE recuperados
    cnt_sncode := 0;
    for x in 1 .. out_sncode.count loop
      cnt_sncode := cnt_sncode + 1;
      lv_sncode  := out_sncode(x);
      -- Funcion del BSCS devuelve los Bouquets
      lv_bouquet_bscs := tim.pp004_siac_lte.fn_obtiene_buquets_co_id@dbl_bscs_bf(an_coid, out_sncode(x));
      if lv_bouquet_bscs is null then
        lc_proc := 'TIM.PP004_SIAC_LTE.FN_OBTIENE_BUQUETS_CO_ID';
        raise exc_bouquet;
      end if;

      -- Funcion recupera Array de Bouquets
      p_bouquets_lineal(lv_bouquet_bscs, out_bouquet);
      if out_bouquet is null then
        lc_proc := 'OPERACION.PQ_CSR_LTE.P_BOUQUETS_LINEAL';
        raise exc_bouquet;
      end if;

      -- Recupera de SOT(Recuperacion de Datos de la Tarjeta)
      --ln_sot := f_obtiene_sot_sga(an_coid);

      -- Recorre los Datos de los Bouquets
      cnt_bouquets := 0;
      for i in 1 .. out_bouquet.count loop
        cnt_bouquets := cnt_bouquets + 1;
        cnt_tarjetas := 0;
        for c_sot in c_sot_tar loop
          ln_sot := c_sot.codsolot;
          for cx in c_tarjetas loop
            -- ini 5.0
            select count(1)
              into cnt_val_tar
              from operacion.tab_rec_csr_lte_det
             where idprocess        = id_proc
               and bouquet          = out_bouquet(i)
               and numserie_tarjeta = cx.numserie;
            if cnt_val_tar = 0 then
              cnt_tarjetas := cnt_tarjetas + 1;
              insert into operacion.tab_rec_csr_lte_det (idprocess_det, idprocess, bouquet, numserie_tarjeta, fecreg, usureg)
              values
                (operacion.sq_tab_csr_lte_det.nextval, id_proc, out_bouquet(i), cx.numserie, sysdate, user);
            end if;
            -- fin 5.0
          end loop;
        end loop;
        -- ini 5.0
        if cnt_tarjetas = 0 then
          raise exc_tarjeta;
        end if;

        -- fin 5.0
      end loop;
      if cnt_bouquets = 0 then
        raise exc_bouquet;
      end if;
    end loop;
    if cnt_sncode = 0 then
      raise exc_bouquet;
    end if;
    an_resultado  := 0;
    an_mensaje    := '>> Recuperacion de Bouquet BSCS: OK';
  exception
    when exc_sncode then
      an_resultado  := -1;
      ln_log.mensaje := '>> Recuperacion de Bouquet BSCS: Error No se Puede Recuperar los Datos del SNCODE.' || chr(13) ||
                        '   SP: '            || to_char(lc_proc)            || chr(13) ||
                        '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                        '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(an_sot, ln_log.request, ln_log.mensaje, null, 3);
      p_reg_log(ln_log);
      rollback;
    when exc_tarjeta then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet BSCS: Error No se Pueden Recuperar los Datos de la Tarjeta.' || chr(13) ||
                        '   SP: '            || to_char(lc_proc)            || chr(13) ||
                        '   BOUQUETS: '      || to_char(lv_bouquet_bscs)    || chr(13) ||
                        '   SNCODE: '        || to_char(lv_sncode)          || chr(13) ||
                        '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                        '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(an_sot, ln_log.request, ln_log.mensaje, null, 3);
      p_reg_log(ln_log);
      rollback;
    when exc_bouquet then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet BSCS: Error No se puede Recuperar los Datos de la Bouquet.' || chr(13) ||
                        '   SP: '            || to_char(lc_proc)            || chr(13) ||
                        '   BOUQUETS: '      || to_char(lv_bouquet_bscs)    || chr(13) ||
                        '   SNCODE: '        || to_char(lv_sncode)          || chr(13) ||
                        '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                        '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                        '   Origen: '        || to_char(ln_log.origen_prov) || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(an_sot, ln_log.request, ln_log.mensaje, null, 3);
      p_reg_log(ln_log);
      rollback;
    when others then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet BSCS: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   SP: '            || to_char('OPERACION.PQ_CSR_LTE.SP_GEN_BOU_BSCS') || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(an_sot, ln_log.request, ln_log.mensaje, null, 3);
      p_reg_log(ln_log);
      rollback;
  end;

  /****************************************************************
  '* Nombre SP :            p_gen_bou_sga
  '* Propósito :            SP extrae los Bouquet del SGA
  '* Input :                an_coid:      Contrato
                            an_sot:       Codigo de SOLOT
                            an_tipequ:    Tipo de Equipo
                            an_log:       Datos del LOG
                            an_tipo:      Tipo de Operacion
  '* Output :               an_resultado:codigo de respuesta 0:OK -1: Error
                            an_mensaje:  mensaje de Respuesta
  '* Creado por :           Dorian Sucasaca
  '* Fec Creación :         17/10/2016
  '* Fec Actualización :    25/10/2016
  '****************************************************************/
  procedure sp_gen_bou_sga( an_coid       in operacion.solot.cod_id%type,
                            an_sot        in operacion.solot.codsolot%type,
                            an_tipequ     in operacion.solotptoequ.tipequ%type,
                            an_log        in operacion.logrqt_csr_lte%rowtype,
                            an_tipo       in varchar2,
                            an_tiposol    in varchar2, --6.0
                            an_resultado  out number,
                            an_mensaje    out varchar2) is

    id_proc             operacion.tab_rec_csr_lte_cab.idprocess%type;
    ln_sot              operacion.solot.codsolot%type;
    ln_sot_sga          operacion.solot.codsolot%type;
    ln_numslc           operacion.solot.numslc%type;
    out_bouquet         dbms_utility.uncl_array;
    lv_bouquet_bscs     varchar2(1000); -- 5.0
    exc_tarjeta         exception;
    exc_bouquet         exception;
    cnt_bouquets_sga    number;
    cnt_bouquets        number;
    cnt_tarjetas        number;

    cnt_val_tar         number; -- 5.0

    cursor c_bouquet_inst is
      select v.numslc,
             trim(operacion.pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo)) cod_ext
        from sales.vtadetptoenl v, sales.tystabsrv t, sales.tys_tabsrvxbouquet_rel r
       where v.numslc = ln_numslc
         and v.flgsrv_pri = 1
         and v.codsrv = t.codsrv
         and t.codsrv = r.codsrv
         and r.estbou = 1
         and r.stsrvb = 1
    group by v.numslc, trim(operacion.pq_ope_bouquet.f_conca_bouquet_c(r.idgrupo));

    cursor c_sot_tar is
      select s.codsolot
        from operacion.solot s, operacion.tiptrabajo t
       where s.tiptra = t.tiptra
         and s.cod_id = an_coid
         and s.estsol in (select b.codigon
                            from operacion.tipopedd a, operacion.opedd b
                           where a.tipopedd = b.tipopedd
                             and a.abrev = 'CON_EST_SGA_LTE'
                             and b.abreviacion = 'ESTSOL')
         and t.tiptrs = 1; -- 5.0

    cursor c_tarjetas is
      select distinct se.numserie
        from operacion.solotptoequ se
       where se.codsolot in (ln_sot_sga)
        and se.tipequ = an_tipequ;
  begin
    -- Log
    ln_log.request_padre := an_log.request_padre;
    ln_log.request       := an_log.request;
    ln_log.customer_id   := an_log.customer_id;
    ln_log.co_id         := an_log.co_id;
    ln_log.action_id     := an_log.action_id;
    ln_log.origen_prov   := an_log.origen_prov;
    ln_log.tipo_prod     := an_log.tipo_prod;
    ln_log.sot           := an_sot;
    -- Inicio Consulta SNCODE
    ln_sot               := f_obtiene_sot(an_coid);

    select numslc
      into ln_numslc
      from solot
     where codsolot = ln_sot;


    -- Fin Consulta SNCODE

    -- Generacion de Cabecera Para DTH
    insert into operacion.tab_rec_csr_lte_cab
      (idprocess, codsolot, tipo, estado, fecreg, usureg, tiposolicitud) --6.0
    values
      (operacion.sq_tab_csr_lte_cab.nextval, an_sot, an_tipo, 1, sysdate, user, an_tiposol) --6.0
    returning idprocess into id_proc;

    cnt_bouquets_sga := 0;
    for c_b_inst in c_bouquet_inst loop

      lv_bouquet_bscs := c_b_inst.cod_ext;
      cnt_bouquets_sga:= cnt_bouquets_sga + 1;
      cnt_bouquets    := 0;
      pq_csr_lte.p_bouquets_lineal(lv_bouquet_bscs, out_bouquet);
      if out_bouquet is null then
        raise exc_bouquet;
      end if;
      for i in 1 .. out_bouquet.count loop
        cnt_bouquets := cnt_bouquets + 1;
        cnt_tarjetas := 0;
        for c_sot in c_sot_tar loop
          ln_sot_sga := c_sot.codsolot;
          for cx in c_tarjetas loop
            -- ini 5.0
            select count(1)
              into cnt_val_tar
              from operacion.tab_rec_csr_lte_det
             where idprocess        = id_proc
               and bouquet          = out_bouquet(i)
               and numserie_tarjeta = cx.numserie;

            if cnt_val_tar = 0 then
              cnt_tarjetas := cnt_tarjetas + 1;
              insert into operacion.tab_rec_csr_lte_det
                (idprocess_det,
                 idprocess,
                 bouquet,
                 numserie_tarjeta,
                 fecreg,
                 usureg)
              values
                (operacion.sq_tab_csr_lte_det.nextval,
                 id_proc,
                 out_bouquet(i),
                 cx.numserie,
                 sysdate,
                 user);
            end if;
            -- fin 5.0
          end loop;
        end loop;
        -- ini 5.0
        if cnt_tarjetas = 0 then
          raise exc_tarjeta;
        end if;

        -- fin 5.0
      end loop;
      if cnt_bouquets = 0 then
        raise exc_bouquet;
      end if;
    end loop;
    if cnt_bouquets_sga = 0 then
      raise exc_bouquet;
    end if;
    an_resultado  := 0;
    an_mensaje    := '>> Recuperacion de Bouquet SGA: OK';
  exception
    when exc_tarjeta then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet SGA: Error No se Pueden Recuperar los Datos de la Tarjeta..' || chr(13) ||
                        '   SP: '            || to_char('sp_gen_bou_sga')            || chr(13) ||
                        '   BOUQUETS: '      || to_char(lv_bouquet_bscs)    || chr(13) ||
                        '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                        '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                        '   Origen: '        || to_char(ln_log.origen_prov) || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, 11, 2);
      p_reg_log(ln_log);
      rollback;
    when exc_bouquet then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet SGA: Error No se puede Recuperar los Datos de la Bouquet.' || chr(13) ||
                        '   SP: '            || to_char('sp_gen_bou_sga')                    || chr(13) ||
                        '   BOUQUETS: '      || to_char(lv_bouquet_bscs)    || chr(13) ||
                        '   Action_ID: '     || to_char(ln_log.action_id)   || chr(13) ||
                        '   Contrato: '      || to_char(ln_log.co_id)       || chr(13) ||
                        '   Origen: '        || to_char(ln_log.origen_prov) || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, 11, 2);
      p_reg_log(an_log);
      rollback;
    when others then
      an_resultado  := -1;
      an_mensaje    := 'Error';
      ln_log.mensaje := '>> Recuperacion de Bouquet SGA: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   SP: '            || to_char('OPERACION.PQ_CSR_LTE.SP_GEN_BOU_SGA') || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      p_actualiza_provision_bscs(ln_sot, ln_log.request, ln_log.mensaje, 11, 2);
      p_reg_log(ln_log);
      rollback;
  end;
  -- fim 4.0
  -- Ini 6.0
  function f_consul_codinssrv(p_tipo in varchar2,
                              p_sot in number)
  return number
  is
  lv_tipsrv varchar2(5);
  ln_codinssrv number;
  begin
   if p_tipo=fnd_provision_dth then
     lv_tipsrv:='0062';
   end if;

   select i.codinssrv
     into ln_codinssrv
     from operacion.inssrv i
    where i.codinssrv in (select codinssrv
                            from operacion.solotpto
                           where codsolot = p_sot)
      and i.tipsrv=lv_tipsrv;
   return ln_codinssrv;
  exception
    when others then
      ln_codinssrv:=null;
      return ln_codinssrv;
  end;

  procedure p_valida_act_des_srv_ad(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number)
  is
    ln_sot         number;
    ln_val_estado  number;
    ln_val_status  number;
    ln_val_tv      number;
    ln_alt_baj     number;
    ln_customer_id number;
    ln_co_id       number;
    ln_request     number;
    ln_cod         number;
    lv_mensaje     varchar2(400);
    LV_RPTA_CONTEGO VARCHAR2(5);--v12.0
    LV_MSJ_CONTEGO  VARCHAR2(100);--v12.0
    LN_FLAG         NUMBER:=0;--v12.0	
  begin
    select w.codsolot
      into ln_sot
      from opewf.wf w
     where w.idwf = a_idwf;

    select count(1)
      into ln_val_tv
      from prov_bscs_il_lte
     where sot        = ln_sot
       and tipo_prod  = fnd_provision_dth;

    if ln_val_tv = 1 then
      select status,action_id
        into ln_val_status,ln_alt_baj
        from prov_bscs_il_lte
       where sot        = ln_sot
         and tipo_prod  = fnd_provision_dth;

      if ln_val_status = 99 then
        begin
          select estado
            into ln_val_estado
            from operacion.ope_tvsat_lote_sltd_aux
           where idlote = (select idlote
                             from operacion.tab_rec_csr_lte_cab
                            where codsolot = ln_sot);

        --ini v12.0
        OPERACION.PKG_CONTEGO.SGASS_VALPROVISION(LN_SOT,LV_RPTA_CONTEGO,LV_MSJ_CONTEGO);
        IF LV_RPTA_CONTEGO = 'OK' AND LV_MSJ_CONTEGO = FND_MSJ_PROVISION_OK THEN
          LN_FLAG :=1;
        END IF;
        --fin v12.0
		
        exception
          when others then
            ln_val_estado := 0;
        end;
        if ln_val_estado > 0 then
          if ln_val_estado =  6 OR LN_FLAG = 1 then--V12.0

            -- Actualizando la tabla previa de act/dsc de lte para que ya no siga procesando
            update operacion.tab_rec_csr_lte_cab
               set estado    = 3
             where codsolot = ln_sot;
            commit;
            -- Actualizando registros en BSCS
            p_actualiza_provision_bscs(ln_sot, null, '>> Validacion de Generacion y Envio a CONAX: Ok', 98, 2);
          else
            --cambia a estado En Ejecucion
            opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                             2,
                                             2,
                                             0,
                                             sysdate,
                                             sysdate);
          end if;
        elsif ln_val_estado = 0 then
          --cambia a estado Generado
          opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                           1,
                                           1,
                                           0,
                                           sysdate,
                                           sysdate);
        end if;
      elsif ln_val_status = 11 then
        --cambia a estado Con Errores
        opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                         2,
                                         19,
                                         0,
                                         sysdate,
                                         sysdate);
      end if;
    end if;
  exception
    when others then
      ln_log.mensaje := '>> Validar Prov. Conax: Error durante la Ejecucion del Proceso' || chr(13) ||
                        '   Codigo Error: '  || to_char(sqlcode)            || chr(13) ||
                        '   Mensaje Error: ' || to_char(sqlerrm)            || chr(13) ||
                        '   Linea Error: '   || dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  end;
  -- Fin 6.0
  PROCEDURE sp_atender_sot_baja(p_idtareawf tareawf.idtareawf%TYPE,
                                p_idwf      tareawf.idwf%TYPE,
                                p_tarea     tareawf.tarea%TYPE,
                                p_tareadef  tareawf.tareadef%TYPE) IS
    ln_sot       solot.codsolot%TYPE;
    c_baja_total  CONSTANT NUMBER(2) := 2;
  BEGIN

    SELECT DISTINCT wf.codsolot
      INTO ln_sot
      FROM wf wf, solot s, prov_bscs_il_lte p
     WHERE wf.idwf = p_idwf
       AND wf.codsolot = s.codsolot
       AND s.estsol = fnd_est_sot_eje
       AND p.sot = s.codsolot
       AND p.action_id = c_baja_total
       AND s.tiptra IN (SELECT DISTINCT o.codigon
                          FROM operacion.tipopedd t, operacion.opedd o
                         WHERE t.tipopedd = o.tipopedd
                           AND t.abrev = 'TIP_TRA_CSR')
       ;

    operacion.pq_solot.p_chg_estado_solot(ln_sot, 29);
  EXCEPTION
    WHEN OTHERS THEN
      ln_log.mensaje := '>> Atender SOT BAJA: Error durante la Ejecucion del Proceso' ||
                        chr(13) || '   Codigo Error: ' || to_char(SQLCODE) ||
                        chr(13) || '   Mensaje Error: ' || to_char(SQLERRM) ||
                        chr(13) || '   Linea Error: ' ||
                        dbms_utility.format_error_backtrace;
      ln_log.sot     := ln_sot;
      p_reg_log(ln_log);
  END;  


  procedure sp_baja_sans (p_idtareawf tareawf.idtareawf%TYPE,
                          p_idwf      tareawf.idwf%TYPE,
                          p_tarea     tareawf.tarea%TYPE,
                          p_tareadef  tareawf.tareadef%TYPE)
  IS
     ln_sot  solot.codsolot%TYPE;
     ln_numero operacion.inssrv.numero%TYPE;
     ln_code NUMBER;
     lv_msg  VARCHAR2(1000);

     ln_code2 NUMBER;
     lv_msg2  VARCHAR2(1000);

     c_baja_total CONSTANT NUMBER(2) := 2;
  BEGIN
    SELECT DISTINCT wf.codsolot
    INTO ln_sot
    FROM wf wf, solot s , prov_bscs_il_lte p
    WHERE wf.idwf = p_idwf
    AND wf.codsolot = s.codsolot
    AND s.estsol = fnd_est_sot_eje
    AND p.sot = s.codsolot
    AND p.action_id = c_baja_total
    AND s.tiptra IN (SELECT DISTINCT o.codigon
                      FROM operacion.tipopedd t , operacion.opedd o
                      WHERE t.tipopedd = o.tipopedd
                      AND t.abrev = 'TIP_TRA_CSR');


   -- Obtener línea
   select i.numero
   into ln_numero
   from operacion.inssrv i
   where i.codinssrv in (select distinct codinssrv
                         from operacion.solotpto
                         where codsolot = ln_sot)
   and i.tipinssrv = 3;


   -- Baja de línea en SANS
   SANS.PKG_SANS_SIST_COMERCIALES.USP_ZNS_ZNSI0021_UPD_SGA@DBL_SANDB(user,ln_numero,to_char(sysdate,'DDMMYYYY'),ln_code,lv_msg);


   IF ln_code <> 1 THEN
     raise_application_error(-20500, ln_code || ' - ' || lv_msg);
   END IF;

   SANS.PKG_SANS_SIST_COMERCIALES.USP_ZNS_ZSDI0054_UPD_SGA@DBL_SANDB('006',ln_numero,user,ln_code2,lv_msg2);

   IF ln_code2 <> 1 THEN
     raise_application_error(-20500, ln_code2 || ' - ' || lv_msg2);
   END IF;


   commit;

   EXCEPTION
     WHEN OTHERS THEN
        IF ln_code IS NULL THEN
          lv_msg := SQLERRM;
        END IF;
        ln_log.mensaje := '>> Dar de baja en SANS: Error durante la Ejecucion del Proceso' ||
                      chr(13) || '   Codigo Error: ' || to_char(SQLCODE) ||
                      chr(13) || '   Mensaje Error: ' || to_char(lv_msg) ||
                      chr(13) || '   Linea Error: ' ||
                      dbms_utility.format_error_backtrace;
        ln_log.sot     := ln_sot;
        p_reg_log(ln_log);


  END;

END;
/