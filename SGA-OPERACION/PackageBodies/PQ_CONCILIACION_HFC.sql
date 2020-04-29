CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONCILIACION_HFC IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_CONCILIACION_HFC
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       01/03/2017  Luis Flores      Luis Flores       Conciliación HFC
  *******************************************************************************************************/

  PROCEDURE p_hfc_venta_ln IS
    ln_hilos     NUMBER;
    ln_idproceso NUMBER;
    lv_username  VARCHAR2(100);
    lv_password  VARCHAR2(100);
    lv_url       VARCHAR2(200);
    lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||'.p_hfc_venta_bl';
  BEGIN

    SELECT operacion.sq_tab_conciliacion_hfc.nextval
      INTO ln_idproceso
      FROM dual;

    -- Obtener datos iniciales
    ln_hilos    := to_number(operacion.pq_conciliacion_hfc.f_getConstante('NUMH_HFC_VENTA')); --modificar config
    lv_username := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCUSER');
    lv_password := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCPWD');
    lv_url      := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCURL');

    -- Cargar datos
    insert into /*+ append */
    operacion.tab_th_venta
      (idproceso, id_contrato, id_tarea, estado)
      select ln_idproceso, q.id_contrato, rownum, 0
        from (select c.contn_numero_contrato id_contrato
                from usrpvu.sisact_ap_contrato@dbl_pvudb c
               where c.contc_tipo_producto = '05') q;

    commit;

    --agrupar los hilos
    update /*+ parallel(b,4)*/ operacion.tab_th_venta b
       SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    --Ejecutamos los Hilos
    operacion.pq_conciliacion_hfc.p_ThreadRun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp,
                                              ln_idproceso,
                                              ln_hilos);

    COMMIT;

  END;

  PROCEDURE p_hfc_venta_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

    cursor cur_venta is
      select t.id_contrato
        from operacion.tab_th_venta t
       where t.idproceso = an_idproceso
         and t.id_tarea = an_idtarea;

    TYPE tb_venta IS TABLE OF cur_venta%rowtype INDEX BY BINARY_INTEGER;
    ltb_venta tb_venta;
    le_error EXCEPTION;
    ln_limit_in NUMBER := 1000;
    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;
  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_VENTA_PVU_BL';

    --insertar en tabla
    OPEN cur_venta;

    LOOP
      FETCH cur_venta BULK COLLECT
        INTO ltb_venta limit ln_limit_in;
      FOR c_t IN 1 .. ltb_venta.COUNT LOOP
        BEGIN

          INSERT INTO OPERACION.TAB_VENTA
            (IDLOTE,
             TIPSRV,
             ID_CONTRATO,
             NUMSEC,
             NRODOCUMENTO,
             CUSTOMER_ID,
             SOT,
             ESTADO,
             FECCONTRATO,
             CO_ID,
             SLPLN_CODIGO,
             CAMPV_CODIGO,
             TMCODE,
             IDSERVICIO,
             DESSERVICIO,
             CF_PRECIO,
             FLGPRINCIPAL,
             SNCODE,
             CODPROV_IW,
             DATA_N1,
             DATA_N2,
             DATA_N3)
            select an_idproceso,
                   decode(se.gsrvc_codigo,
                          '1',
                          'Telefonia',
                          '6',
                          'Telefonia',
                          '2',
                          'Internet',
                          '3',
                          'Television',
                          '4',
                          'Television',
                          '5',
                          'Television',
                          '8',
                          'Television',
                          '7',
                          'Internet',
                          'Revisar'),
                   c.contn_numero_contrato id_contrato,
                   c.contn_numero_sec,
                   c.contv_nro_doc_cliente,
                   c.contn_customer_id,
                   c.contn_numero_sot,
                   c.contc_estado,
                   c.contd_fecha_contrato,
                   b.co_id,
                   p.slpln_codigo,
                   p.campv_codigo,
                   p.tmcode,
                   d.idservicio,
                   d.servicio,
                   d.cf_precio, --
                   d.flg_principal,
                   d.sncode,
                   se.servv_des_ext,
                   (select count(1)
                      from usrpvu.sisact_info_venta_sga@dbl_pvudb s
                     where s.id_contrato = b.id_contrato) flg_sga,
                   (select count(1)
                      from usrpvu.sisact_contrato_activacion@dbl_pvudb ca
                     where ca.sub_contrato = b.sub_contrato) flg_act,
                   se.servv_id_bscs sncode2
              from usrpvu.sisact_ap_contrato_det@dbl_pvudb    b,
                   usrpvu.sisact_ap_contrato@dbl_pvudb        c,
                   usrpvu.sisact_solicitud_plan_hfc@dbl_pvudb p,
                   usrpvu.sisact_solicitud_det_hfc@dbl_pvudb  d,
                   usrpvu.sisact_ap_servicio@dbl_pvudb        se
             where b.id_contrato = c.contn_numero_contrato
               and c.contn_numero_sec = p.solin_codigo
               and p.slpln_codigo = d.slpln_codigo
               and d.idservicio = se.servv_codigo
               and c.contc_tipo_producto = '05'
               and se.prdc_codigo = '05'
                  --and se.gsrvc_codigo in ('2', '7')
               and c.contn_numero_contrato = ltb_venta(c_t).id_contrato;

          COMMIT;
        exception
          when others then

             rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'PVU';
            lt_conci_hfc.codsolot := ltb_venta(c_t).id_contrato;
            lt_conci_hfc.co_id := 0;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);

        END;

      END LOOP;

      EXIT WHEN cur_venta%notfound;
    END LOOP;

    CLOSE cur_venta;

  END;

  PROCEDURE p_hfc_instalacion_ln IS
    ln_hilos     NUMBER;
    ln_idproceso NUMBER;
    lv_username  VARCHAR2(100);
    lv_password  VARCHAR2(100);
    lv_url       VARCHAR2(200);
    lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||'.p_hfc_instalacion_bl';

    lv_nsp_equ   VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||'.p_hfc_equipos_sga_bl';

  BEGIN

    SELECT operacion.sq_tab_conciliacion_hfc.nextval INTO ln_idproceso FROM dual;

    -- Obtener datos iniciales
    ln_hilos    := to_number(operacion.pq_conciliacion_hfc.f_getConstante('NUMH_HFC_SGA')); --modificar config
    lv_username := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCUSER');
    lv_password := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCPWD');
    lv_url      := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCURL');

    -- Cargar datos
    insert into /*+ append */
    operacion.tab_th_instalacion
      (idproceso,
       codsolot,
       id_tarea,
       estado,
       estsol,
       tiptra,
       tipsrv,
       customer_id,
       cod_id,
       cod_id_old,
       data_v1,
       ntdide)
      select ln_idproceso,
             q.codsolot,
             rownum,
             0,
             q.estsol,
             q.tiptra,
             q.tipsrv,
             q.customer_id,
             q.cod_id,
             q.cod_id_old,
             q.codcli,
             q.ntdide
        from (select s.codsolot,
                     s.estsol,
                     s.tiptra,
                     s.tipsrv,
                     s.customer_id,
                     s.cod_id,
                     s.cod_id_old,
                     s.codcli,
                     (select cli.ntdide
                        from vtatabcli cli
                       where cli.codcli = s.codcli) ntdide
                from solot s, tiptrabajo t
               where s.tiptra = t.tiptra
                 and t.tiptrs = 1
                 and not exists
               (select 1
                        from tipopedd tt, opedd o
                       where tt.tipopedd = o.tipopedd
                         and tt.abrev = 'TIPTRA_NO_CONCILIACION_SGA_HFC'
                         and o.codigon = t.tiptra)
                 and s.tipsrv in ('0061', '0073')) q;

    COMMIT;

    --Agrupar los hilos
    update /*+ parallel(b,4)*/ operacion.tab_th_instalacion b
       set b.id_tarea = decode(mod(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               mod(b.id_tarea, ln_hilos))
     where b.idproceso = ln_idproceso;

    COMMIT;

    --ejecutamos los hilos
    operacion.pq_conciliacion_hfc.p_threadrun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp,
                                              ln_idproceso,
                                              ln_hilos);

    commit;

    --ejecutamos los hilos
    operacion.pq_conciliacion_hfc.p_threadrun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp_equ,
                                              ln_idproceso,
                                              ln_hilos);
    commit;


  END;

  PROCEDURE p_hfc_instalacion_bl(an_idproceso NUMBER,
                                     an_idtarea   NUMBER) IS

    cursor cur_solot is
      select t.codsolot
        from operacion.tab_th_instalacion t
       where t.idproceso = an_idproceso
         and t.id_tarea = an_idtarea;

    TYPE tb_solot IS TABLE OF cur_solot%rowtype INDEX BY BINARY_INTEGER;
    ltb_solot tb_solot;
    le_error EXCEPTION;
    ln_limit_in NUMBER := 1000;
    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_INSTALACION_BL';

    --insertar en tabla
    OPEN cur_solot;

    LOOP
      FETCH cur_solot BULK COLLECT
        INTO ltb_solot limit ln_limit_in;
      FOR cur_tbsolot IN 1 .. ltb_solot.COUNT LOOP
        BEGIN

          INSERT INTO OPERACION.TAB_INSTALACION
            (IDLOTE,
             ORI_REG,
             CODCLI,
             NUMSLC,
             CODSOLOT,
             TIPTRA,
             ESTSOL,
             TIPSRVS,
             FECREG,
             CUSTOMER_ID,
             CO_ID,
             CO_ID_OLD,
             NUMSEC,
             CODSRV_PVU,
             TIPOSRV,
             CODSRV,
             SERVICIO,
             ESTINSPRD,
             CODINSSRV,
             PID,
             MONTOCR,
             TIPSRV,
             FLGPRINC,
             NUMERO,
             FECINI,
             FECFIN,
             CODPROV_IW,
             CODPROV_J,
             ciclo)
            select an_idproceso,
                   nvl(operacion.pq_conciliacion_hfc.f_get_es_idproducto_sisact(t.idproducto),
                       'SGA') ori_reg,
                   s.codcli,
                   i.numslc,
                   pto.codsolot,
                   s.tiptra,
                   s.estsol,
                   s.tipsrv tipsrvs,
                   s.fecusu fecreg,
                   s.customer_id,
                   s.cod_id,
                   s.cod_id_old,
                   i.numsec,
                   (select x.idservicio_sisact
                      from sales.servicio_sisact x
                     where x.codsrv = t.codsrv) codsrv_pvu,
                   operacion.pq_conciliacion_hfc.f_get_desc_tiposerv(i.tipsrv) tiposrv,
                   p.codsrv,
                   t.dscsrv || ' ' ||
                   (select a.id_ident
                      from cusper.tmp_migracion a
                     where a.campo2 = i.codinssrv
                       and a.campo1 = p.codsrv) ||
                   (select decode(v.dscequ, null, '', ' - ' || v.dscequ)
                      from vtaequcom v
                     where v.codequcom = p.codequcom) servicio,
                   p.estinsprd,
                   i.codinssrv,
                   p.pid,
                   (select sum(ip.montocr)
                      from instxproducto ip
                     where ip.pid = p.pid) montocr,
                   i.tipsrv,
                   operacion.pq_conciliacion_hfc.f_get_no_es_srv_principal(i.tipsrv,
                                                                           t.idproducto,
                                                                           p.flgprinc) flgprinc,
                   i.numero,
                   p.fecini,
                   p.fecfin,
                   case
                     when (select c.tiposervicioitw
                             from configuracion_itw c
                            where to_char(c.idconfigitw) = t.codigo_ext) = 1 then
                      operacion.pq_conciliacion_hfc.f_obt_ncossac(i.numero)
                     else
                      (select c.codigo_ext
                         from configuracion_itw c
                        where to_char(c.idconfigitw) = t.codigo_ext)
                   end cod_proviw,
                   (select pr.plan || '-' || pr.plan_opcional
                      from plan_redint pr
                     where pr.idplan = t.idplan) codplanj,
                   operacion.pq_sga_janus.f_get_ciclo_codinssrv(i.numero,
                                                                i.codinssrv) ciclo
              from solot      s,
                   solotpto   pto,
                   inssrv     i,
                   insprd     p,
                   tystabsrv  t
             where s.codsolot = pto.codsolot
               and pto.codinssrv = i.codinssrv
               and i.codinssrv = p.codinssrv
               and pto.pid = p.pid
               and p.codsrv = t.codsrv
               and p.codequcom is null
               and s.codsolot = ltb_solot(cur_tbsolot).codsolot;

          COMMIT;

        exception
          when others then

            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'SGA';
            lt_conci_hfc.codsolot := ltb_solot(cur_tbsolot).codsolot;
            lt_conci_hfc.co_id := 0;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);
        END;

      END LOOP;

      EXIT WHEN cur_solot%notfound;
    END LOOP;

    CLOSE cur_solot;

  END;

  PROCEDURE p_hfc_facturacion_ln IS
    ln_hilos     NUMBER;
    ln_idproceso NUMBER;
    lv_username  VARCHAR2(100);
    lv_password  VARCHAR2(100);
    lv_url       VARCHAR2(200);

    lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||'.p_hfc_facturacion_bl';

    lv_nsp_upd   VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_hfc_update_bscs_bl';

    lv_nsp_equ   VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||'.p_hfc_equipos_bscs_bl';

  BEGIN

    SELECT operacion.sq_tab_conciliacion_hfc.nextval
      INTO ln_idproceso
      FROM dual;

    -- Obtener datos iniciales
    ln_hilos    := to_number(operacion.pq_conciliacion_hfc.f_getConstante('NUMH_HFC_BSCS')); --modificar config
    lv_username := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCUSER');
    lv_password := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCPWD');
    lv_url      := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCURL');

    -- Cargar datos
    insert into /*+ append */
       operacion.tab_th_facturacion
      (idproceso, co_id, id_tarea, estado, customer_id, tmcode)
      select ln_idproceso, q.co_id, rownum, 0, q.customer_id, q.tmcode
        from (select c.co_id, c.customer_id, c.tmcode
                from contract_all@dbl_bscs_bf c
               where c.sccode = 6) q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ operacion.tab_th_facturacion b
       SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    --Ejecutamos los Hilos
    operacion.pq_conciliacion_hfc.p_ThreadRun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp,
                                              ln_idproceso,
                                              ln_hilos);

    COMMIT;

    --Ejecutamos los Hilos
    operacion.pq_conciliacion_hfc.p_ThreadRun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp_upd,
                                              ln_idproceso,
                                              ln_hilos);

    COMMIT;

    operacion.pq_conciliacion_hfc.p_hfc_upd_th_bscs_bl;
    COMMIT;

    --Ejecutamos los Hilos
    operacion.pq_conciliacion_hfc.p_ThreadRun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp_equ,
                                              ln_idproceso,
                                              ln_hilos);

    COMMIT;

  END;

  PROCEDURE p_hfc_facturacion_bl(an_idproceso NUMBER,
                                      an_idtarea   NUMBER) IS

    cursor cur_co_id is
      SELECT g.co_id
        FROM operacion.tab_th_facturacion g
       WHERE g.idproceso = an_idproceso
         AND g.id_tarea = an_idtarea;

    TYPE tb_bscs IS TABLE OF cur_co_id%rowtype INDEX BY BINARY_INTEGER;
    ltb_bscs tb_bscs;
    le_error EXCEPTION;
    ln_limit_in NUMBER := 1000;

    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_FACTURACION_BL';

    --insertar en tabla
    OPEN cur_co_id;

    LOOP
      FETCH cur_co_id BULK COLLECT
        INTO ltb_bscs limit ln_limit_in;

      FOR c_t IN 1 .. ltb_bscs.COUNT LOOP

        BEGIN

          INSERT INTO OPERACION.TAB_FACTURACION
            (IDLOTE,
             ORI_REG,
             customer_id,
             co_id,
             tmcode,
             tiposrv,
             flgprinc,
             sncode,
             servicio,
             data_v1,
             numero,
             cargo_fijo,
             date_billed,
             estsrv,
             codplanj)
            select an_idproceso,
                   'BSCS',
                   c.customer_id,
                   c.co_id,
                   c.tmcode,
                   (select h.desc_prod
                      from tim.pf_hfc_parametros@dbl_bscs_bf h
                     where h.campo = 'HFC_TIPO_SERV'
                       and h.cod_prod1 = ps.sncode) tiposrv,
                   (select h.cod_prod2
                      from tim.pf_hfc_parametros@dbl_bscs_bf h
                     where h.campo = 'HFC_TIPO_SERV'
                       and h.cod_prod1 = ps.sncode) flgprinc,
                   ps.sncode,
                   sn.des servicio,
                   (select decode(d.tipo_serv, 'CTV', d.campo02, d.campo01)
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d,
                           tim.pf_hfc_parametros@dbl_bscs_bf h
                     where h.campo = 'HFC_TIPO_SERV'
                       and h.cod_prod1 = ps.sncode
                       and d.co_id = c.co_id
                       and d.id_producto =
                           (select min(dd.id_producto)
                              from tim.pf_hfc_datos_serv@dbl_bscs_bf dd
                             where dd.co_id = d.co_id
                               and dd.tipo_serv = d.tipo_serv)
                       and h.tipo_serv = d.tipo_serv
                       and h.cod_prod2 = 1) codprov_iw,
                   tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(c.co_id) numero,
                   ps.adv_charge cargo_fijo,
                   ps.date_billed,
                   ssh.status estsrv,
                   case
                     when (select count(1)
                             from tim.pf_hfc_parametros@dbl_bscs_bf h
                            where h.campo = 'SERV_TELEFONIA'
                              and h.cod_prod1 = ps.sncode) = 1 then
                      (select h.param1 || '-' || h.param2
                         from tim.pf_hfc_parametros@dbl_bscs_bf h
                        where h.campo = 'SERV_TELEFONIA'
                          and h.cod_prod1 = ps.sncode)
                     when (select count(1)
                             from tim.pf_hfc_parametros@dbl_bscs_bf h
                            where h.campo = 'SERV_ADICIONAL'
                              and h.cod_prod2 = ps.sncode) = 1 then
                      (select to_char(h.cod_prod3)
                         from tim.pf_hfc_parametros@dbl_bscs_bf h
                        where h.campo = 'SERV_ADICIONAL'
                          and h.cod_prod2 = ps.sncode)
                     else
                      null
                   end codplanj
              from contract_all@dbl_bscs_bf        c,
                   profile_service@dbl_bscs_bf     ps,
                   pr_serv_status_hist@dbl_bscs_bf ssh,
                   mpusntab@dbl_bscs_bf            sn
             where c.co_id = ps.co_id
               and ps.co_id = ssh.co_id
               and ps.sncode = sn.sncode
               and sn.sncode = ssh.sncode
               and ps.status_histno = ssh.histno
               and c.sccode = 6
               and c.co_id = ltb_bscs(c_t).co_id;

          COMMIT;
        exception
          when others then

            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'BSCS';
            lt_conci_hfc.codsolot := 0;
            lt_conci_hfc.co_id := ltb_bscs(c_t).co_id;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);

        END;

      END LOOP;

      EXIT WHEN cur_co_id%notfound;
    END LOOP;

    CLOSE cur_co_id;

  END;

  PROCEDURE p_hfc_equipos_bscs_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

    cursor cur_co_id is
      SELECT g.co_id
        FROM operacion.tab_th_facturacion g
       WHERE g.idproceso = an_idproceso
         AND g.id_tarea = an_idtarea;

    TYPE tb_bscs IS TABLE OF cur_co_id%rowtype INDEX BY BINARY_INTEGER;
    ltb_bscs tb_bscs;
    le_error EXCEPTION;
    ln_limit_in NUMBER := 1000;

    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;
  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_EQUIPOS_BSCS_BL';

    --insertar en tabla
    OPEN cur_co_id;

    LOOP
      FETCH cur_co_id BULK COLLECT
        INTO ltb_bscs limit ln_limit_in;

      FOR c_t IN 1 .. ltb_bscs.COUNT LOOP

        BEGIN

          INSERT INTO OPERACION.TAB_EQUIPOS
            (IDLOTE,
             ORI_REG,
             CO_ID,
             TIPO_SERV,
             ID_PRODUCTO,
             ID_PRODUCTO_PADRE,
             NUMERO_SERIE,
             MAC_ADDRESS,
             MODELO,
             CODPROV_IW,
             UNIT_ADDRESS,
             RESERVA_ACT,
             INSTAL_ACT,
             ESTADO_RECURSO,
             CODSOLOT,
             NUMERO)
            select an_idproceso,
                   'BSCS',
                   int.co_id,
                   'INT' tipo_serv,
                   int.id_producto,
                   int.id_producto_padre,
                   '' numero_serie,
                   int.mac_address,
                   '' modelo,
                   (select d.campo01
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                     where d.id_producto = int.id_producto
                       and d.co_id = int.co_id) codigo_ext,
                   '' unit_address,
                   int.reserva_act,
                   int.instal_act,
                   int.estado_recurso,
                   int.sot,
                   '' numero
              from tim.pf_hfc_internet@dbl_bscs_bf int
             where int.co_id = ltb_bscs(c_t).co_id
            union
            select an_idproceso,
                   'BSCS',
                   tlf.co_id,
                   'TLF' tipo_serv,
                   tlf.id_producto,
                   tlf.id_producto_padre,
                   '' numero_serie,
                   tlf.mac_address mac,
                   tlf.mta_model_crm_id modelo,
                   (select d.campo01
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                     where d.id_producto = tlf.id_producto
                       and d.co_id = tlf.co_id) codigo_ext,
                   '' unit_address,
                   tlf.reserva_act,
                   tlf.instal_act,
                   tlf.estado_recurso,
                   tlf.sot,
                   (select decode(d.campo05, '0', null, d.campo05)
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                     where d.id_producto = tlf.id_producto
                       and d.co_id = tlf.co_id) numero
              from tim.pf_hfc_telefonia@dbl_bscs_bf tlf
             where tlf.co_id = ltb_bscs(c_t).co_id
            union
            select an_idproceso,
                   'BSCS',
                   tlf.co_id,
                   d.tipo_serv,
                   d.id_producto,
                   d.id_producto_padre,
                   '' numero_serie,
                   tlf.mac_address mac,
                   tlf.mta_model_crm_id modelo,
                   (select d.campo01
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                     where d.id_producto_padre = tlf.id_producto
                       and d.co_id = tlf.co_id
                       and rownum = 1) codigo_ext,
                   '' unit_address,
                   tlf.reserva_act,
                   tlf.instal_act,
                   tlf.estado_recurso,
                   tlf.sot,
                   decode(d.campo05, '0', null, d.campo05) numero
              from tim.pf_hfc_telefonia@dbl_bscs_bf  tlf,
                   tim.pf_hfc_datos_serv@dbl_bscs_bf d
             where tlf.co_id = d.co_id
               and tlf.id_producto = d.id_producto_padre
               and d.tipo_serv = 'TEP'
               and tlf.co_id = ltb_bscs(c_t).co_id
            union
            select an_idproceso,
                   'BSCS',
                   ctv.co_id,
                   'CTV' tipo_serv,
                   ctv.id_producto,
                   ctv.id_producto_padre,
                   ctv.serial_number numero_serie,
                   '' mac,
                   ctv.stb_type_crm_id modelo,
                   (select d.campo02
                      from tim.pf_hfc_datos_serv@dbl_bscs_bf d
                     where d.id_producto = ctv.id_producto
                       and d.co_id = ctv.co_id) codigo_ext,
                   ctv.unit_address,
                   ctv.reserva_act,
                   ctv.instal_act,
                   ctv.estado_recurso,
                   ctv.sot,
                   '' numero
              from tim.pf_hfc_cable_tv@dbl_bscs_bf ctv
             where ctv.co_id = ltb_bscs(c_t).co_id;

          COMMIT;

        exception
          when others then
            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'BSCS_EQU';
            lt_conci_hfc.codsolot := 0;
            lt_conci_hfc.co_id := ltb_bscs(c_t).co_id;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);
        END;

      END LOOP;

      EXIT WHEN cur_co_id%notfound;
    END LOOP;

    CLOSE cur_co_id;

  END;

  PROCEDURE p_hfc_equipos_sga_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

    cursor cur_solot is
      select t.codsolot
        from operacion.tab_th_instalacion t
       where t.idproceso = an_idproceso
         and t.id_tarea = an_idtarea;

    TYPE tb_sga IS TABLE OF cur_solot%rowtype INDEX BY BINARY_INTEGER;
    ltb_sga tb_sga;

    le_error    EXCEPTION;
    ln_limit_in NUMBER := 1000;

    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_EQUIPOS_SGA_BL';

    --insertar en tabla
    OPEN cur_solot;

    LOOP
      FETCH cur_solot BULK COLLECT
        INTO ltb_sga limit ln_limit_in;

      FOR c_t IN 1 .. ltb_sga.COUNT LOOP

        BEGIN

          INSERT INTO OPERACION.TAB_EQUIPOS
            (IDLOTE,
             ORI_REG,
             CO_ID,
             TIPO_SERV,
             NUMERO_SERIE,
             MAC_ADDRESS,
             CODPROV_IW,
             CODSOLOT)
            select an_idproceso,
                   'SGA' ori_reg,
                   s.cod_id,
                   t.tipo,
                   upper(equ.numserie),
                   upper(equ.mac),
                   case
                     when (select count(1)
                             from operacion.trs_interface_iw t
                            where t.codsolot = equ.codsolot) > 0 then
                      (select tt.codigo_ext
                         from operacion.trs_interface_iw tt
                        where tt.codsolot = equ.codsolot
                          and tt.tip_interfase = 'INT')
                     else
                      (select i.codigo_ext
                         from int_servicio_intraway i
                        where i.codsolot = equ.codsolot
                          and i.id_interfase = '620')
                   end codprov_iw,
                   equ.Codsolot
              from solotptoequ equ, tipequ t, solot s
             where equ.codsolot = s.codsolot
               and equ.tipequ = t.tipequ
               and equ.codsolot = ltb_sga(c_t).codsolot;

          COMMIT;

        exception
          when others then
            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'SGA_EQU';
            lt_conci_hfc.codsolot := ltb_sga(c_t).codsolot;
            lt_conci_hfc.co_id := 0;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);
        END;

      END LOOP;

      EXIT WHEN cur_solot%notfound;
    END LOOP;

    CLOSE cur_solot;

  END;

  PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                        av_password  VARCHAR2,
                        av_url       VARCHAR2,
                        av_nsp       VARCHAR2,
                        an_idproceso NUMBER,
                        an_hilos     IN NUMBER) AS

    LANGUAGE JAVA NAME 'com.creo.operacion.ProcesaGrupoHilo.procesa(java.lang.String,java.lang.String,java.lang.String,java.lang.String, long, int)';

  FUNCTION f_obt_ncossac(L_NUMERO IN VARCHAR2) RETURN VARCHAR2 IS
    L_VALNM      NUMBER;
    L_CENTRAL    NUMBER;
    L_CODEXT     VARCHAR2(60);
    L_CODUBI     INSSRV.CODUBI%TYPE;
    L_CODSRV     INSSRV.CODSRV%TYPE;
    L_CODINSSRV  INSSRV.CODINSSRV%TYPE;
    L_NUMSLC     INSSRV.NUMSLC%TYPE;
    L_CODINSSRVL INSSRV.CODINSSRV%TYPE;

  BEGIN
    BEGIN
      SELECT COUNT(1) INTO L_VALNM FROM NUMTEL WHERE NUMERO = L_NUMERO;
    EXCEPTION
      WHEN OTHERS THEN
        L_VALNM := 0;
    END;
    IF L_VALNM > 0 THEN
      BEGIN
        SELECT I.CODUBI, I.NUMSLC, I.CODINSSRV
          INTO L_CODUBI, L_NUMSLC, L_CODINSSRVL
          FROM INSSRV I
         WHERE I.NUMERO = L_NUMERO
           AND EXISTS (SELECT 'T'
                  FROM NUMTEL
                 WHERE CODINSSRV = I.CODINSSRV
                   AND NUMERO = I.NUMERO);

        SELECT I.CODINSSRV, I.CODSRV
          INTO L_CODINSSRV, L_CODSRV
          FROM INSSRV I, TYSTABSRV T
         WHERE NUMSLC = L_NUMSLC
           AND I.CODSRV = T.CODSRV
           AND I.TIPINSSRV = 3
           AND EXISTS (SELECT 'T'
                  FROM CONFIGURACION_ITW W
                 WHERE T.CODIGO_EXT = TO_CHAR(W.IDCONFIGITW)
                   AND TIPOSERVICIOITW = 1);

        SELECT COUNT(1)
          INTO L_CENTRAL
          FROM SOLOTPTO S
         WHERE EXISTS (SELECT 'T'
                  FROM TYSTABSRV
                 WHERE CODSRV = S.CODSRVNUE
                   AND IDPRODUCTO = 888)
           AND S.CODINSSRV = L_CODINSSRV;

        SELECT DECODE(L_CENTRAL, 0, N.CODIGO_EXT, N.CODEXT_CENTREX)
          INTO L_CODEXT
          FROM CONFIGURACION_ITW   C,
               CONFIGXSERVICIO_ITW S,
               NCOSXDEPARTAMENTO   N,
               CONFIGXPROCESO_ITW  P,
               TYSTABSRV           T
         WHERE C.IDCONFIGITW = S.IDCONFIGITW
           AND S.CODSRV = L_CODSRV
           AND C.IDCONFIGITW = TO_NUMBER(T.CODIGO_EXT)
           AND T.CODSRV = S.CODSRV
           AND C.IDCONFIGITW = P.IDCONFIGITW
           AND P.PROCESO = 3
           AND N.IDNCOS = C.IDNCOS
           AND TRIM(N.CODEST) IN
               (SELECT DISTINCT V.CODEST
                  FROM V_UBICACIONES V
                 WHERE V.CODUBI = L_CODUBI);

      EXCEPTION
        WHEN OTHERS THEN
          L_CODEXT := NULL;
      END;
      RETURN L_CODEXT;
    ELSE
      RETURN NULL;
    END IF;
  END;

  FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE)
    RETURN VARCHAR2 IS
    lv_valor VARCHAR2(100);
  BEGIN

    IF av_constante = 'OPTHFCPWD' THEN
      SELECT utl_raw.cast_to_varchar2(valor)
        INTO lv_valor
        FROM constante
       WHERE constante = av_constante;
    ELSE
      SELECT valor
        INTO lv_valor
        FROM constante
       WHERE constante = av_constante;
    END IF;

    RETURN lv_valor;

  END;

  function fn_divide_cadena(p_cadena in out varchar2) return varchar2 is

    v_longitud integer;
    v_valor    varchar2(100);

  begin

    select decode(instr(p_cadena, '-', 1, 1),
                  0,
                  length(p_cadena),
                  instr(p_cadena, '-', 1, 1) - 1)
      into v_longitud
      from dual;

    select substr(p_cadena, 1, v_longitud),
           substr(p_cadena, v_longitud + 2)
      into v_valor, p_cadena
      from dual;

    return v_valor;
  end;

  function f_get_es_idproducto_sisact(an_idproducto number) return varchar2 is
    lv_origen opedd.codigoc%type;
  begin

    select distinct sa.codigoc
      into lv_origen
      from soluciones sol,
           paquete_venta p,
           detalle_paquete d,
           (select o.codigoc, o.codigon
              from tipopedd tt, opedd o
             where tt.tipopedd = o.tipopedd
               and tt.abrev = 'ES_IDPRODUCTO_SISACT') sa
     where sol.idsolucion = p.idsolucion
       and p.idpaq = d.idpaq
       and sol.idsolucion = sa.codigon
       and d.idproducto = an_idproducto;

    return lv_origen;

  exception
    when others then
      return null;
  end;

  function f_get_no_es_srv_principal(av_tipsrv     varchar2,
                                     an_idproducto number,
                                     an_flprinc    number) return number

   is
    ln_cont number;
  begin
    select count(1)
      into ln_cont
      from tipopedd tt, opedd o
     where tt.tipopedd = o.tipopedd
       and tt.abrev = 'NO_ES_SRV_PRINCIPAL'
       and o.codigoc = av_tipsrv
       and (o.codigon_aux = 0 or
           (o.codigon_aux = 1 and o.codigon = an_idproducto));

    if ln_cont > 0 then
      return 0;
    else
      return an_flprinc;
    end if;

  end;

  function f_get_desc_tiposerv(av_tiposrv varchar2) return varchar2 is

    lv_desctiposrv opedd.descripcion%type;

  begin
    select o.descripcion
      into lv_desctiposrv
      from tipopedd tt, opedd o
     where tt.tipopedd = o.tipopedd
       and tt.abrev = 'CONCILIACION_TIPOSRV'
       and o.codigoc = av_tiposrv;

    return lv_desctiposrv;
  exception
    when others then
      return 'Revisar';
  end;

  PROCEDURE p_hfc_update_bscs_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

    cursor cur_co_id is
      SELECT g.co_id, g.customer_id
        FROM operacion.tab_th_facturacion g
       WHERE g.idproceso = an_idproceso
         AND g.id_tarea = an_idtarea;

    TYPE tb_bscs IS TABLE OF cur_co_id%rowtype INDEX BY BINARY_INTEGER;
    ltb_bscs tb_bscs;
    le_error EXCEPTION;
    ln_limit_in  NUMBER := 1000;
    lv_chstatus  varchar2(1);
    lv_chpending varchar2(1);
    ld_validfrom date;
    lv_ciclo     varchar2(10);
    ln_alta      number;
    ln_chseqno   number;
    lv_nrodocu   varchar2(15);

    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_UPDATE_BSCS_BL';

    --insertar en tabla
    OPEN cur_co_id;
    LOOP
      FETCH cur_co_id BULK COLLECT
        INTO ltb_bscs limit ln_limit_in;

      FOR c_t IN 1 .. ltb_bscs.COUNT LOOP

        BEGIN
          select ch.ch_status, ch.ch_pending, ch.ch_validfrom, ch.ch_seqno
            into lv_chstatus, lv_chpending, ld_validfrom, ln_chseqno
            from contract_history@dbl_bscs_bf ch
           where ch.ch_seqno = (select max(cc.ch_seqno)
                                  from contract_history@dbl_bscs_bf cc
                                 where cc.co_id = ch.co_id)
             and ch.co_id = ltb_bscs(c_t).co_id;

          select cu.billcycle, cu.passportno
            into lv_ciclo, lv_nrodocu
            from customer_all@dbl_bscs_bf cu
           where cu.customer_id = ltb_bscs(c_t).customer_id;

          if ln_chseqno = 2 and lower(lv_chstatus) = 'a' and
             lower(lv_chpending) = 'x' then
            ln_alta := 1;
          else
            ln_alta := 0;
          end if;

          update operacion.tab_th_facturacion t
             set t.ch_status  = lv_chstatus,
                 t.ch_pending = lv_chpending,
                 t.data_d1    = ld_validfrom,
                 t.ciclo      = lv_ciclo,
                 t.flg_alta   = ln_alta,
                 t.passportno = lv_nrodocu
           where t.co_id = ltb_bscs(c_t).co_id;

          COMMIT;
        exception
          when others then

            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'BSCS_UPD';
            lt_conci_hfc.codsolot := 0;
            lt_conci_hfc.co_id := ltb_bscs(c_t).co_id;
            lt_conci_hfc.customer_id := ltb_bscs(c_t).customer_id;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);

        END;

      END LOOP;

      EXIT WHEN cur_co_id%notfound;
    END LOOP;

    CLOSE cur_co_id;

  END;

  PROCEDURE p_hfc_upd_th_bscs_bl IS

    cursor cur2a is
      select x.customer_id, count(1)
        from operacion.tab_th_facturacion x
       group by x.customer_id
      having count(1) = 1;

    cursor cur3 is
      select m.customer_id, count(1)
        from operacion.tab_th_facturacion m
       group by m.customer_id
      having count(1) > 1;

    cursor cur3a(p_customer_id in operacion.tab_th_facturacion.customer_id%type) is
       select x.ch_status,
             x.ch_pending,
             x.co_id,
             x.flg_alta,
             case
               when x.ch_status='a' and x.ch_pending is null then 1
               when x.ch_status='a' and x.ch_pending is not null and x.flg_alta=0 then 2
               when x.ch_status='s' and x.ch_pending is null then 3
               when x.ch_status='s' and x.ch_pending is not null then 4
               when x.ch_status='d' and x.ch_pending is null then 5
               when x.ch_status='d' and x.ch_pending is not null then 6
               when x.ch_status='a' and x.ch_pending is not null and x.flg_alta=1 then 7
               when x.ch_status='o' and x.ch_pending is null then 8
               end orden
       from operacion.tab_th_facturacion x
       where x.customer_id=p_customer_id
      group by x.ch_status, x.ch_pending, x.co_id, x.flg_alta
      order by orden asc;

    cursor cur6 is
       select x.customer_id, l_cont1, l_cont2
         from (select a.customer_id, count(1) l_cont1
                 from operacion.tab_th_facturacion a
                group by a.customer_id) x,
              (select b.customer_id, count(1) l_cont2
                 from operacion.tab_th_facturacion b
                where b.ch_status = 'd'
                  and b.ch_pending is null
                group by b.customer_id) y
        where x.customer_id = y.customer_id
        and x.l_cont1 = y.l_cont2;

    TYPE tb_bscs IS TABLE OF cur2a%rowtype INDEX BY BINARY_INTEGER;
    ltb_bscs tb_bscs;

    TYPE tb_2 IS TABLE OF cur3%rowtype INDEX BY BINARY_INTEGER;
    ltb_2 tb_2;

    TYPE tb_3 IS TABLE OF cur6%rowtype INDEX BY BINARY_INTEGER;
    ltb_3 tb_3;

    le_error EXCEPTION;
    ln_limit_in   NUMBER := 1000;
    v_unico       number;
    v_customer_id number;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_UPDATE_BSCS_BL';

    open cur2a;
    loop
      fetch cur2a bulk collect
        into ltb_bscs limit ln_limit_in;

      for c_t in 1 .. ltb_bscs.count loop

        begin

          update operacion.tab_th_facturacion t
             set t.flg_unico = 1, t.data_v1 = to_char(ltb_bscs(c_t).customer_id)
           where t.customer_id = ltb_bscs(c_t).customer_id;

          commit;

        exception
          when others then
            rollback;
        end;

      end loop;

      exit when cur2a%notfound;
    end loop;

    close cur2a;

    open cur3;
    loop
      fetch cur3 bulk collect
        into ltb_2 limit ln_limit_in;

      for c_t in 1 .. ltb_2.count loop

        begin

          v_unico       := 0;
          v_customer_id := ltb_2(c_t).customer_id;

          for c3a in cur3a(ltb_2(c_t).customer_id) loop

            if c3a.ch_status = 'a' and v_unico = 0 and
               c3a.ch_pending is null then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 's' and v_unico = 0 and
               c3a.ch_pending is null then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 's' and v_unico = 0 then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 'a' and v_unico = 0 then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 'd' and v_unico = 0 and
               c3a.ch_pending is null then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 'd' and v_unico = 0 then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if c3a.ch_status = 'o' and v_unico = 0 then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 1, b.data_v1=to_char(v_customer_id)
               where b.co_id = c3a.co_id;
              v_unico := 1;
              commit;
            end if;

            if v_unico = 1 then
              update operacion.tab_th_facturacion b
                 set b.flg_unico = 0
               where b.customer_id = v_customer_id
                 and b.flg_unico is null;
              commit;
              exit when v_unico = 1;
            end if;

          end loop;

          commit;

        exception
          when others then
            rollback;
        end;
      end loop;
      exit when cur3%notfound;
    end loop;
    close cur3;

    open cur6;
    loop
      fetch cur6 bulk collect
        into ltb_3 limit ln_limit_in;

      for c_t in 1 .. ltb_3.count loop

        begin

          if ltb_3(c_t).l_cont1 = ltb_3(c_t).l_cont2 then
            update operacion.tab_th_facturacion b
               set b.data_n1 = 1
             where b.flg_unico=1 and b.customer_id = ltb_3(c_t).customer_id;
          end if;

          commit;

        exception
          when others then
            rollback;
        end;

      end loop;

      exit when cur6%notfound;
    end loop;

    close cur6;

  END;

  PROCEDURE p_hfc_janus_ln IS

    ln_hilos     NUMBER;
    ln_idproceso NUMBER;
    lv_username  VARCHAR2(100);
    lv_password  VARCHAR2(100);
    lv_url       VARCHAR2(200);
    l_sql        VARCHAR2(4000);
    lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit || '.p_hfc_janus_bl';
  BEGIN

    SELECT operacion.sq_payers_janus.nextval INTO ln_idproceso FROM dual;

    l_sql := 'truncate table operacion.payers_janus';
    execute immediate l_sql;

    l_sql := 'truncate table operacion.connection_accounts_janus';
    execute immediate l_sql;

    l_sql := 'truncate table operacion.payer_tariffs_janus';
    execute immediate l_sql;

    -- Obtener datos iniciales
    ln_hilos    := to_number(operacion.pq_conciliacion_hfc.f_getConstante('NUMH_HFC_JANUS')); --modificar config
    lv_username := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCUSER');
    lv_password := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCPWD');
    lv_url      := operacion.pq_conciliacion_hfc.f_getConstante('OPTHFCURL');

    -- Cargar datos
    insert into /*+ append */
    operacion.payers_janus
      (idproceso,
       id_tarea,
       estado,
       payer_id_n,
       external_payer_id_v,
       numero,
       payer_status_n,
       bill_cycle_n)
      select ln_idproceso,
             rownum,
             0,
             q.payer_id_n,
             q.external_payer_id_v,
             q.numero,
             q.status,
             q.ciclo
        from (select j.payer_id_n,
                     j.external_payer_id_v,
                     substr(j.external_payer_id_v, 5) numero,
                     j.payer_status_n status,
                     (select substr(pb.bill_cycle_n, 2, 2)
                        from janus_prod_pe.payer_bill_cycle_details@DBL_JANUS pb
                       where pb.payer_id_n = j.payer_id_n) ciclo
                from janus_prod_pe.payers@DBL_JANUS j
               where substr(j.external_payer_id_v, 1, 4) = 'IMSI') q;

    COMMIT;

    --Agrupar los hilos
    UPDATE /*+ parallel(b,4)*/ operacion.payers_janus b
       SET b.id_tarea = decode(MOD(b.id_tarea, ln_hilos),
                               0,
                               ln_hilos,
                               MOD(b.id_tarea, ln_hilos))
     WHERE b.idproceso = ln_idproceso;

    COMMIT;

    --Ejecutamos los Hilos
    operacion.pq_conciliacion_hfc.p_ThreadRun(lv_username,
                                              lv_password,
                                              lv_url,
                                              lv_nsp,
                                              ln_idproceso,
                                              ln_hilos);

    COMMIT;

  END;

  PROCEDURE p_hfc_janus_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

    cursor cur_janus is
      select j.payer_id_n, j.numero
        from operacion.payers_janus j
       where j.idproceso = an_idproceso
         and j.id_tarea = an_idtarea;

    TYPE tb_janus IS TABLE OF cur_janus%rowtype INDEX BY BINARY_INTEGER;
    ltb_janus tb_janus;
    le_error EXCEPTION;
    ln_limit_in NUMBER := 1000;

    lt_conci_hfc historico.log_conciliacion_hfc%rowtype;

  BEGIN

    -- Obtenet el limite para bulk collect
    SELECT d.codigon
      INTO ln_limit_in
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'BULKCOLLECT_LIMIT_CONCILIA_HFC' --modificar
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'P_HFC_JANUS_BL';

    --insertar en tabla
    open cur_janus;

    loop
      fetch cur_janus bulk collect
        into ltb_janus limit ln_limit_in;
      for c_tb in 1 .. ltb_janus.count loop

        begin

          insert into operacion.connection_accounts_janus
            (start_date_dt,
             account_id_n,
             payer_id_0_n,
             payer_id_3_n,
             customer_id)
            select max(ca.start_date_dt) start_date_dt,
                   ca.account_id_n,
                   ca.payer_id_0_n,
                   ca.payer_id_3_n,
                   (select x.external_payer_id_v
                      from janus_prod_pe.payers@dbl_janus x
                     where x.payer_id_n = ca.payer_id_3_n) customer_id
              from janus_prod_pe.connection_accounts@dbl_janus ca
             where ca.payer_id_0_n = ltb_janus(c_tb).payer_id_n
             group by ca.account_id_n, ca.payer_id_0_n, ca.payer_id_3_n;

          commit;

          insert into operacion.payer_tariffs_janus
            (start_date_dt,
             tariff_id_n,
             payer_id_n,
             description_v,
             tariff_type_v)
            select pt.start_date_dt,
                   pt.tariff_id_n,
                   pt.payer_id_n,
                   tm.description_v,
                   tm.tariff_type_v
              from janus_prod_pe.payer_tariffs@dbl_janus pt,
                   janus_prod_pe.tariff_master@dbl_janus tm
             where pt.payer_id_n = ltb_janus(c_tb).payer_id_n
               and pt.tariff_id_n = tm.tariff_id_n
               and pt.start_date_dt =
                   (select max(ptt.start_date_dt)
                      from janus_prod_pe.payer_tariffs@dbl_janus ptt
                     where ptt.tariff_id_n = pt.tariff_id_n
                       and ptt.payer_id_n = pt.payer_id_n)
               and pt.status_n = 1;

          commit;

        exception
          when others then
            rollback;

            lt_conci_hfc.idproceso := an_idproceso;
            lt_conci_hfc.tipo := 'JANUS';
            lt_conci_hfc.codsolot := ltb_janus(c_tb).payer_id_n;
            lt_conci_hfc.co_id := 0;
            lt_conci_hfc.customer_id := 0;
            lt_conci_hfc.iderror := sqlcode ;
            lt_conci_hfc.msgerror := substr('Error : ' || sqlerrm || '  - Linea (' ||
                               dbms_utility.format_error_backtrace || ')',
                               1,
                               4000);

            operacion.pq_conciliacion_hfc.p_insert_log_conci_hfc(lt_conci_hfc);
        end;

      end loop;

      exit when cur_janus%notfound;
    end loop;

    close cur_janus;

  END;

  procedure p_insert_log_conci_hfc(lt_conci_hfc historico.log_conciliacion_hfc%rowtype) is

    pragma autonomous_transaction;

    ln_idlog historico.log_conciliacion_hfc.idlog%type;

  begin

    select historico.sq_log_conciliacion_hfc.nextval
      into ln_idlog
      from dual;

    insert into historico.log_conciliacion_hfc
      (idlog,
       idproceso,
       tipo,
       codsolot,
       co_id,
       customer_id,
       iderror,
       msgerror)
    values
      (ln_idlog,
       lt_conci_hfc.idproceso,
       lt_conci_hfc.tipo,
       lt_conci_hfc.codsolot,
       lt_conci_hfc.co_id,
       lt_conci_hfc.customer_id,
       lt_conci_hfc.iderror,
       lt_conci_hfc.msgerror);

    commit;

  exception
    when others then
      rollback;
  end;


  procedure p_datos_clientes(v_data_n1 number, v_data_v1 varchar2, nflag number , u_datos_consulta in out sys_refcursor)
    is
      v_dynamic_select varchar2(4000);
      begin

      if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_cliente';
        v_dynamic_select := v_dynamic_select||v_data_n1||' order by 1,2 asc';

     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_cliente';
        v_dynamic_select := v_dynamic_select||''''||v_data_v1||''''||' order by 1,2 asc';

        end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

    end ;

  procedure p_datos_bscs(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is

    v_dynamic_select varchar2(4000);
      begin
       if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_bscs';
        v_dynamic_select := v_dynamic_select||v_data_n1;

     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_bscs';
        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';

        end if;
     end if;

      open u_datos_consulta for v_dynamic_select;
    end ;

  procedure p_datos_sga(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
      begin
       if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_sga';
        v_dynamic_select := v_dynamic_select||v_data_n1;

     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_sga';
        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';

        end if;
     end if;

      open u_datos_consulta for v_dynamic_select;

    end ;


  procedure p_conciliacion_consul_01(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_01';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2 then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_01';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
         end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;


  procedure p_conciliacion_consul_02(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_02';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2 then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_02';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
         end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;

  procedure p_conciliacion_consul_03(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_03';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_03';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
         end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;


  procedure p_conciliacion_consul_04(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_04';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_04';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
         end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;

  procedure p_conciliacion_consul_05(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_05';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_05';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
        end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;


  procedure p_conciliacion_consul_06(v_data_n1 number,v_data_v1 varchar2,nflag number , u_datos_consulta in out sys_refcursor)
  is
   v_dynamic_select varchar2(4000);
   begin
     if nflag  = 1 then
        select data_v1 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_06';

        v_dynamic_select := v_dynamic_select||v_data_n1;
     else if nflag  = 2  then
        select data_v2 into v_dynamic_select
        from operacion.tab_parametros p
        where p.clave='datos_concil_consul_06';

        v_dynamic_select := v_dynamic_select||''''||v_data_v1||'''';
         end if;
     end if;

        open u_datos_consulta for v_dynamic_select;

   end ;

   procedure p_carga_provision
     is
     ls_sql varchar2(4000);
   begin

      ls_sql := 'truncate table operacion.tab_provision;';
      execute immediate ls_sql;

      insert into operacion.tab_provision(ori_reg, codcli, idproducto, idventa, hub,
      nodo, macaddress, disabled, servicepackagename, idispcrm, activationcode, serialnumber,
      fechaalta, fechaactivacion, cantpcs, mensaje, fec_susp, idcablemodem, estado)
      select 'IW_CM',codcli, idproducto, idventa, hub, nodo, upper(macaddress), disabled, servicepackagename, idispcrm, activationcode, serialnumber,
      fechaalta, fechaactivacion, cantpcs, mensaje, fec_susp, idcablemodem, estado
      from intraway.int_reg_cm;
      commit;


      insert into operacion.tab_provision (
      ori_reg, codcli, idproducto, idventa, hub, nodo, macaddress, servicepackagename, idispcrm, activationcode, serialnumber, fechaalta,
      mensaje, idcablemodem, estado, data_n1, data_n2)
      select 'IW_MTA',a.codcli, a.idproducto,a.idventa, a.cmscrmid, a.cablemodemid, a.macaddress, a.profilecrmid, a.profilename, a.activationcode, a.serialnumber, a.fechaalta,
      a.mtamodelcrmid, a.mtaid, a.estado, a.idventapadre, a.idproductopadre
      from intraway.int_reg_mta a;
      commit;

      insert into operacion.tab_provision (
      ori_reg, codcli, idproducto, idventa, hub, nodo,disabled, servicepackagename, idispcrm, serialnumber, fechaalta,
      fechaactivacion,cantpcs, idcablemodem, estado, data_n1, data_n2)
      select 'IW_TLF',a.codcli, a.idproducto,a.idventa, a.cmscmrid,a.mtaid,a.disabled, a.homeexchangename, a.homeexchangecrmid , a.tn, a.fechaalta,
      a.fechaactivacion,a.endpointnumber,  a.endpointid , a.estado, a.idventapadre, a.idproductopadre
      from intraway.int_reg_TLF a;
      commit;

      insert into operacion.tab_provision (
      ori_reg, codcli, idproducto, idventa, hub, nodo, servicepackagename,
      idcablemodem, estado, data_n1, data_n2)
      select 'IW_TLF_ADIC',a.codcli, a.idproducto,a.idventa, a.callfeaturecrmid,a.endpointid, a.featurename ,
      a.epcallfeatureid , a.estado, a.idventapadre, a.idproductopadre
      from intraway.int_reg_adictlf a;
      commit;

      insert into operacion.tab_provision (
      ori_reg, codcli,idproducto,idventa,hub,nodo,macaddress,disabled,servicepackagename,idispcrm,activationcode,serialnumber,fechaalta,
      fechaactivacion,idcablemodem,estado)
      select 'IW_STB', a.codcli,a.idproducto,a.idventa,a.stbtypecrmid,a.defaultconfigidcrm,a.unitaddress,a.disabled,a.productcrmid,
      a.channelmapcrmid,a.activationcode,a.serialnumber,a.fechaalta,a.fechaactivacion,a.stbid,a.estado
      from intraway.int_reg_stb a;
      commit;

      insert into operacion.tab_provision (
      ori_reg, codcli,idproducto,idventa,servicepackagename,idcablemodem,estado,data_n1,data_n2,data_n3 )
      select 'IW_STB_ADIC', a.codcli,a.idproducto,a.idventa,a.productname,a.stbid,a.estado,a.idventapadre,a.idproductopadre,a.adicid
      from intraway.int_reg_adictv a;
      commit;

   end;

END PQ_CONCILIACION_HFC;
/

