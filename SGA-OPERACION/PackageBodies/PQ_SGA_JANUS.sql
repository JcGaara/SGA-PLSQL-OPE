CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_JANUS IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_SGA_JANUS
   PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - JANUS
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       04/11/2015                    00
    2.0       14/12/2015  Luis Flores                        SGA-SD-560640
    3.0       28/04/2016                                     SD-642508-1 Cambio de Plan Fase II
    4.0       01/07/2016                                     SGA_SD-767463 Se asignan bolsas en Janus de clientes anteriores
    5.0       10/10/2016  Felipe Maguiña                     PROY 25526 -  Ciclos de Facturación
    6.0       28/11/2016  Luis Flores                        PROY-20828.SGA Mejora Provision HFC
    7.0       10/01/2017  Servicio Fallas-HITSS              INC000000648208
    8.0       31/01/2017  Servicio Fallas-HITSS              INC000000638618
    9.0       06/04/2017  Luis Guzman          Fanny Najarro PROY-20152 3Play Inalambrico
   10.0       18/03/2017  Servicio Fallas-HITSS              INC000000728320 -
   11.0       12/05/2017  Luis Guzmán          Fanny Najarro INC000000774220
   12.0       10/07/2017  Jose Varillas        Tito Huertas  PROY 27792
   13.0       07/02/2019  Abel Ojeda           Luis Flores   Provision para JANUS generado por Cambio de Plan CE
  *******************************************************************************************************/
  procedure p_insert_prov_sga_janus(an_nsecuencia number,
                                    an_accion number,
                                    an_codsolot number,
                                    an_cod_id number,
                                    an_customer_id number,
                                    av_customer_idjanus varchar2,
                                    av_numero varchar2,
                                    av_tipo varchar2,
                                    an_coderror out number,
                                    av_msgerror out varchar2)
  is
     ln_idprov number;
     pragma autonomous_transaction;
  begin

    select operacion.sq_prov_sga_janus.nextval into ln_idprov from dual;

    insert into operacion.prov_sga_janus(idprov, nsecuencia, accion, codsolot, cod_id, customer_id, customer_idjanus,
                                         numero, tipo)
    values (ln_idprov,an_nsecuencia,an_accion,an_codsolot,an_cod_id,an_customer_id,av_customer_idjanus,av_numero,av_tipo);

    an_coderror := 1;
    av_msgerror := 'OK';

    commit;

  exception
    when others then
      rollback;
      an_coderror := -1;
      av_msgerror := 'ERROR : (P_INSERT_PROV_SGA_JANUS) - '|| sqlerrm;
  end p_insert_prov_sga_janus;

  procedure p_insertxacc_prov_sga_janus(an_naccion number,
                                        an_codsolot number,
                                        an_cod_id number,
                                        an_customer_id number,
                                        av_customer_idjanus varchar2,
                                        av_numero varchar2,
                                        an_coderror out number,
                                        av_msgerror out varchar2) is
  begin

    an_coderror := 1;
    av_msgerror := 'OK';

    /*an_naccion (1:Alta, 2: Baja, 3: Baja y Alta, 4: Baja Linea y Alta)*/
    if an_naccion = 1 then
       p_insert_prov_sga_janus(1, 1, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'ALTANUMERO',an_coderror, av_msgerror);
    elsif an_naccion = 2 then
       p_insert_prov_sga_janus(1, 2, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'BAJANUMERO',an_coderror, av_msgerror);
       p_insert_prov_sga_janus(2, 2, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'BAJANUMERO',an_coderror, av_msgerror);
    elsif an_naccion = 3 then
       p_insert_prov_sga_janus(1, 2, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'BAJAALTANUMERO',an_coderror, av_msgerror);
       p_insert_prov_sga_janus(2, 2, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'BAJAALTANUMERO',an_coderror, av_msgerror);
       p_insert_prov_sga_janus(3, 1, an_codsolot, an_cod_id, an_customer_id,av_customer_idjanus,av_numero, 'BAJAALTANUMERO',an_coderror, av_msgerror);
    elsif an_naccion = 4 then
      p_insert_prov_sga_janus(1, 2, an_codsolot, an_cod_id, an_customer_id, av_customer_idjanus, av_numero,
                              'BAJAALTANUMERO', an_coderror, av_msgerror);
      p_insert_prov_sga_janus(3, 1, an_codsolot, an_cod_id, an_customer_id, av_customer_idjanus,
                              av_numero, 'BAJAALTANUMERO', an_coderror, av_msgerror);
    elsif an_naccion = 16 then
      p_insert_prov_sga_janus(1, 16, an_codsolot, an_cod_id, an_customer_id, av_customer_idjanus,
                              av_numero, 'CAMBIOPLANHFC', an_coderror, av_msgerror);
    end if;

  exception
    when others then
      an_coderror := -1;
      av_msgerror := 'ERROR : (P_INSERTXACC_PROV_SGA_JANUS) - '|| sqlerrm;
  end p_insertxacc_prov_sga_janus;

  procedure p_update_prov_sga_janus(an_idprov number,
                                    an_estado number,
                                    an_nerror number,
                                    av_merror varchar2,
                                    an_coderror out number,
                                    av_msgerror out varchar2) is
   pragma autonomous_transaction;

  begin

     update operacion.prov_sga_janus p
     set p.estado = an_estado,
         p.coderror = an_nerror,
         p.msgerror = av_merror,
         p.modusu =  user,
         p.fecmod = sysdate
     where p.idprov = an_idprov;

     an_coderror := 1;
     av_msgerror := 'OK';

     commit;

   exception
      when others then
        rollback;
        an_coderror := -1;
        av_msgerror := 'ERROR : (P_UPDATE_PROV_SGA_JANUS) - '|| sqlerrm;
  end p_update_prov_sga_janus;

 -- Consulta si el numero existe en Janus
  procedure p_cons_linea_janus(av_numero      in varchar2,
                               an_tipo        in number,
                               an_out         out number,
                               av_mensaje     out varchar2,
                               av_customer_id out varchar2,
                               an_codplan     out number,
                               av_producto    out varchar2,
                               ad_fecini      out date,
                               av_estado      out varchar2,
                               av_ciclo       out varchar2) is
    l_cont    number;
    lv_numero varchar2(20);
    error_no_janus exception;

  begin
    lv_numero := '0051' || av_numero;
    select count(1)
      into l_cont
      from janus_prod_pe.connections@DBL_JANUS c
     where c.connection_id_v = lv_numero;
    if l_cont > 0 then
      -- Consulta toda la Informacion
      if an_tipo = 1 then
         begin
          select pc.external_payer_id_v,
                 pt.tariff_id_n,
                 tm.description_v,
                 pt.start_date_dt,
                 decode(p.payer_status_n,
                        '1',
                        'Registrado',
                        '2',
                        'Activo',
                        '3',
                        'Activo s/recargas',
                        '4',
                        'Suspendido',
                        '5',
                        'Terminado',
                        '???'),
                 substr(pb.bill_cycle_n, 2, 2)
            into av_customer_id,
                 an_codplan,
                 av_producto,
                 ad_fecini,
                 av_estado,
                 av_ciclo
            from janus_prod_pe.connections@DBL_JANUS              c,
                 janus_prod_pe.connection_accounts@DBL_JANUS      ca,
                 janus_prod_pe.payer_tariffs@DBL_JANUS            pt,
                 janus_prod_pe.tariff_master@DBL_JANUS            tm,
                 janus_prod_pe.payers@DBL_JANUS                   p,
                 janus_prod_pe.payers@DBL_JANUS                   pc,
                 janus_prod_pe.payer_bill_cycle_details@DBL_JANUS pb
           where c.account_id_n = ca.account_id_n
             and c.start_date_dt =
                 (select max(start_date_dt)
                    from janus_prod_pe.connections@DBL_JANUS
                   where connection_id_v = c.connection_id_v)
             and ca.start_date_dt =
                 (select max(start_date_dt)
                    from janus_prod_pe.connection_accounts@DBL_JANUS
                   where account_id_n = ca.account_id_n)
             and ca.payer_id_0_n = p.payer_id_n
             and ca.payer_id_0_n = pt.payer_id_n
             and p.payer_id_n = pb.payer_id_n
             and pt.tariff_id_n = tm.tariff_id_n
             and pt.start_date_dt =
                 (select max(start_date_dt)
                    from janus_prod_pe.payer_tariffs@DBL_JANUS
                   where tariff_id_n = pt.tariff_id_n
                     and payer_id_n = pt.payer_id_n)
             and pt.status_n = 1
             and ca.payer_id_3_n = pc.payer_id_n
             and tm.tariff_type_v = 'B' -- Solo plan base
             and c.connection_id_v = lv_numero;
         exception
           when no_data_found then
               raise error_no_janus;
         end;
         an_out     := 1;
         av_mensaje := 'OK';
        -- Consulta solo Linea y Customer_ID
        elsif an_tipo = 2 then
         begin
          select distinct b.external_payer_id_v into av_customer_id
            from janus_prod_pe.connections@DBL_JANUS a,
                 janus_prod_pe.payers@DBL_JANUS b,
                 janus_prod_pe.connection_accounts@DBL_JANUS c
            where a.account_id_n = c.account_id_n
            and c.payer_id_3_n=b.payer_id_n
            and a.start_date_dt = (select max(start_date_dt) from janus_prod_pe.connections@DBL_JANUS  where connection_id_v = a.connection_id_v)
            and c.start_date_dt = (select max(start_date_dt) from janus_prod_pe.connection_accounts@DBL_JANUS where account_id_n = c.account_id_n)
            and a.connection_id_v =  lv_numero;
         exception
           when no_data_found then
               raise error_no_janus;
         end;
         an_out     := 1;
          av_mensaje := 'OK';
        end if;
      an_out     := 1;
      av_mensaje := 'OK';
    else
      an_out     := 0;
      av_mensaje := 'No existe Numero en Janus';
    end if;
  exception
    when error_no_janus then
      an_out     := -2;
      av_mensaje := 'Error: La linea no esta asociada a un Cliente en Janus';
    when others then
      av_mensaje := sqlcode || ' - ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
      an_out     := -1;
      av_mensaje := 'Error - ' || av_mensaje;
  end p_cons_linea_janus;

  procedure p_baja_janus(an_codsolot solot.codsolot%type, an_error out number , av_error out varchar2) is

    ln_cod_id   solot.cod_id%type;
    lv_codcli   solot.codcli%type;
    ln_customer solot.customer_id%type;
    lv_numero   inssrv.numero%type;
    ln_codinssrv inssrv.codinssrv%type;
    ln_error number;
    lv_error varchar2(4000);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    ln_tiposot           number;
    ln_contrato          number;

  begin
     ln_tiposot := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

     operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 ln_error,
                                                 lv_error);

    if ln_tiposot = 3 then
      ln_contrato := ln_cod_id;
    else
      ln_contrato := ln_codinssrv;
    end if;

    if ln_error = 1 and lv_numero is not null then

      p_cons_linea_janus(lv_numero,
                         2, -- Muestra solo Customer
                         ln_out_janus,
                         lv_mensaje_janus,
                         lv_customer_id_janus,
                         ln_codplan_janus,
                         lv_producto_janus,
                         ld_fecini_janus,
                         lv_estado_janus,
                         lv_ciclo_janus);

      if ln_out_janus = 1 then
        -- Baja
        p_insertxacc_prov_sga_janus(2, an_codsolot,ln_contrato, ln_customer,lv_customer_id_janus,lv_numero,an_error, av_error);
      elsif ln_out_janus = -2 then
        p_insertxacc_prov_sga_janus(2, an_codsolot,ln_contrato, ln_customer,lv_customer_id_janus,lv_numero,an_error, av_error);
      elsif ln_out_janus = -1 then
        an_error := -1;
        av_error := lv_mensaje_janus;
      elsif ln_out_janus = 0 then
        an_error := 5;
        av_error := 'Cerrar Tarea con estado No Interviene - No existe en Janus';
      end if;
    else
      an_error := 5;
      av_error := 'Cerrar Tarea con estado No Interviene';
    end if;
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR: P_BAJA_JANUS - ' || sqlcode || ' - ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
  end p_baja_janus;

  procedure p_libera_janusxsot(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is

  n_codsolot solot.codsolot%type;
  n_cod_id number;
  n_error number;
  error_general exception;
  v_error varchar2(200);
  an_error number;
  av_error varchar2(4000);
  ln_valida_cp number;
  n_customer_id number;
  ln_tiposot    number;
  BEGIN

    select a.codsolot, b.cod_id, b.customer_id into n_codsolot, n_cod_id, n_customer_id
    from wf a, solot b
    where a.idwf = a_idwf
    and a.codsolot = b.codsolot;

    ln_valida_cp := operacion.pq_sga_iw.f_val_cambioplan_cod_id_old(n_cod_id, n_customer_id);

    if ln_valida_cp = 1 then
      an_error := 5;
    else
      p_baja_janus(n_codsolot, an_error, av_error);
    end if;

    --Se cambia el estado de la tarea a No Interviene
    if an_error = 5 then
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                       4,
                                       8,
                                       0,
                                       sysdate,
                                       sysdate);
      operacion.pq_sga_iw.p_update_prov_hfc_bscs(a_idtareawf,
                                                 a_idwf,
                                                 A_tarea,
                                                 A_tareadef);
    end if;

  EXCEPTION
    WHEN error_general THEN
      v_error := 'Liberar JANUS';
      --p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
      raise_application_error(-20001, v_error);
    WHEN OTHERS THEN
      v_error := 'Liberar JANUS : ' || SQLERRM;
      n_error := sqlcode;
      --p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
      raise_application_error(-20001, v_error);
  End p_libera_janusxsot;

  --Insertamos en la Provision de Janus BSCS
  procedure p_insert_prov_bscs_janus(an_actionid number,
                                     an_priority number,
                                     an_customerid number,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     an_tarea number,
                                     av_trama varchar2,
                                     an_ordid      out number,
                                     an_error out number,
                                     av_msgerror out varchar2) is
    ln_ordid    number;
    pragma autonomous_transaction;

  begin

    select tim.rp_janus_ord_id.nextval@dbl_bscs_bf
    into ln_ordid
    from dual;

    insert into tim.rp_prov_bscs_janus@dbl_bscs_bf
      (ord_id, action_id, priority,customer_id,co_id, estado_prv, tarea, valores)
    values
       (ln_ordid, an_actionid, an_priority, an_customerid, an_cod_id, av_estadoprv, an_tarea, av_trama);

    commit;
    an_ordid    := ln_ordid;
    an_error := 1;
    av_msgerror := 'OK';

  exception
    when others then
      rollback;
      an_error := -1;
      av_msgerror := 'Error al Insertar en la Provision BSCS : '|| sqlerrm;

  end p_insert_prov_bscs_janus;

  --Insertamos en la Provision de Janus (SGA)
  procedure p_insert_prov_ctrl_janus(an_actionid number,
                                     an_priority number,
                                     av_customerid varchar2,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     av_trama varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2) is
     pragma autonomous_transaction;
  begin

    insert into tim.rp_prov_ctrl_janus@dbl_bscs_bf
                (action_id, priority, customer_id, co_id, estado_prv, valores)
    values(an_actionid, an_priority, av_customerid, an_cod_id, av_estadoprv, av_trama);

    commit;
    an_error := 1;
    av_msgerror := 'OK';

  exception
    when others then
      rollback;
      an_error := -1;
      av_msgerror := 'Error al Insertar en la Provision CTRL : '|| sqlerrm;

  end p_insert_prov_ctrl_janus;

  procedure p_envia_baja_numero_janus(an_tipo number,
                                      av_numero varchar2,
                                      an_co_id number,
                                      av_customer varchar2,
                                      an_error out number,
                                      av_error out varchar2) is
    lv_trama varchar2(4000);
    ln_customer number;
    an_ordid    number;--8.0
  begin

    lv_trama := 'IMSI' || trim(av_numero);

    if an_tipo = 2 then -- SGA
      p_insert_prov_ctrl_janus(2,4,av_customer,an_co_id,0,lv_trama,an_error,av_error);
    elsif an_tipo = 3 then -- BSCS
      ln_customer := to_number(av_customer);
      --p_insert_prov_bscs_janus(2,5,ln_customer,an_co_id,'2',1,lv_trama,an_error,av_error);
      p_insert_prov_bscs_janus(2,5,ln_customer,an_co_id,'2',1,lv_trama,an_ordid,an_error,av_error);--8.0
    end if;

  exception
    when others then
       an_error := -1;
       av_error := 'ERROR : ' || sqlerrm || ' (' || dbms_utility.format_error_backtrace || ')' ;
  end p_envia_baja_numero_janus;

  procedure p_envia_baja_cliente_janus(an_tipo number,
                                       an_co_id number,
                                       av_customer varchar2,
                                       an_error out number,
                                       av_error out varchar2) is
    ln_customer number;
    an_ordid number;--8.0
  begin

    if an_tipo = 2 then -- SGA
      p_insert_prov_ctrl_janus(2,4,av_customer,an_co_id,0,av_customer,an_error, av_error);
    elsif an_tipo = 3 then -- BSCS
      ln_customer := to_number(av_customer);
      --p_insert_prov_bscs_janus(2,5,ln_customer,an_co_id,'2',1,av_customer,an_error,av_error);
      p_insert_prov_bscs_janus(2,5,ln_customer,an_co_id,'2',1,av_customer,an_ordid,an_error,av_error);--8.0

    end if;

  exception
    when others then
       an_error := -1;
       av_error := 'ERROR : ' || sqlerrm || ' (' || dbms_utility.format_error_backtrace || ')' ;

  end p_envia_baja_cliente_janus;

  function f_val_prov_janus_pend(an_cod_id number) return number is

  ln_janus_act number;

  begin
     select count(1)
       into ln_janus_act
       from dual
      where exists (select 1
               from tim.rp_prov_bscs_janus@dbl_bscs_bf pj
              where pj.co_id = an_cod_id)
         or exists (select 1
               from tim.rp_prov_ctrl_janus@dbl_bscs_bf pj
              where pj.estado_prv <> 5
                and pj.co_id = an_cod_id);

     return ln_janus_act;
  end;

  procedure p_validacion_pre_janus is

    cursor c_listasot is
      select distinct o.codsolot, o.numero, o.customer_id, o.tipo, o.estado
        from operacion.prov_sga_janus o
       where o.estado = 0
         and o.nsecuencia = 1;

    cursor c_sotactu(an_codsolot number) is
      select o.codsolot, o.numero,o.customer_id,o.idprov,o.tipo,o.estado
        from operacion.prov_sga_janus o
       where o.estado = 0
         and o.codsolot = an_codsolot;

    cursor c_sotactu_ba(an_codsolot number) is
      select o.codsolot,o.numero,o.customer_id,o.idprov,o.tipo,o.estado
        from operacion.prov_sga_janus o
       where o.estado = 0
         and o.accion = 2
         and o.codsolot = an_codsolot;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    an_error             number;
    av_error             varchar2(4000);
    ln_estado            number;
    lv_error             varchar2(4000);
    ln_coderror          number;
    ln_valida            number;
    ln_valbajcli         number;

  begin
     ln_valbajcli := f_get_constante_conf('CBAJCLIJANUSVAL');

    for c_s in c_listasot loop

      ln_estado   := c_s.estado;
      lv_error    := null;
      ln_coderror := 1;
      ln_valida   := 0;

      p_cons_linea_janus(c_s.numero,
                         2,
                         ln_out_janus,
                         lv_mensaje_janus,
                         lv_customer_id_janus,
                         ln_codplan_janus,
                         lv_producto_janus,
                         ld_fecini_janus,
                         lv_estado_janus,
                         lv_ciclo_janus);

      if ln_out_janus = 1 and to_char(c_s.customer_id) != lv_customer_id_janus and c_s.tipo = 'BAJANUMERO' then

        ln_estado   := 5;
        ln_coderror := -1;
        lv_error    := 'El numero telefonico esta asociado a otro Cliente en Janus';

        if ln_valbajcli = 1 then
          ln_valida   := 0;
        else
          ln_valida   := 1;
        end if;

      elsif ln_out_janus = 0 then

        ln_estado   := 5;
        ln_coderror := -1;
        lv_error    := 'El numero telefonico ya no Existe en Janus';

        if c_s.tipo = 'BAJANUMERO' then
          if ln_valbajcli = 1 then
            ln_valida   := 0;
          else
            ln_valida   := 1;
          end if;
        elsif c_s.tipo = 'BAJAALTANUMERO' then
          ln_valida := 2;
        end if;

      elsif ln_out_janus = 1 and c_s.tipo = 'ALTANUMERO' then
        ln_estado   := 5;
        ln_coderror := -1;
        lv_error    := 'El numero telefonico ya Existe en Janus';
        ln_valida   := 1;
      end if;

      if ln_valida = 1 then
        for c in c_sotactu(c_s.codsolot) loop
          p_update_prov_sga_janus(c.idprov,ln_estado,ln_coderror, lv_error,an_error, av_error);
        end loop;
      end if;

      -- Cuando es Baja y Alta
      if ln_valida = 2 then
        for c in c_sotactu_ba(c_s.codsolot) loop
          p_update_prov_sga_janus(c.idprov,ln_estado,ln_coderror,lv_error,an_error,av_error);
        end loop;
      end if;
    end loop;

  end p_validacion_pre_janus;

  procedure p_job_alinea_janus is

   cursor c_listasot is
     select distinct o.codsolot
     from operacion.prov_sga_janus o where o.estado = 0;

   cursor c_sotpendiente(an_codsolot number) is
     select o.* from operacion.prov_sga_janus o
     where o.estado = 0
     and o.codsolot = an_codsolot
     order by o.nsecuencia asc;

   ln_tiposot number;
   an_error number;
   av_error varchar2(4000);
   ln_pendiente number;
   ln_valexist_linea  number;

  begin
    -- Validamos antes del enviamos las transacciones
    p_validacion_pre_janus;
    commit;

    for c_s in c_listasot loop

      ln_tiposot := operacion.pq_sga_iw.f_val_tipo_serv_sot(c_s.codsolot);

      for c_p in c_sotpendiente(c_s.codsolot) loop

        ln_pendiente := operacion.pq_sga_janus.f_val_prov_janus_pend(c_p.cod_id);

        if ln_pendiente = 0 then
          if c_p.nsecuencia = 1 then
            if c_p.accion = 1 then
              --Enviamos la Alta a Janus
              operacion.pq_sga_janus.p_altanumero_janus(c_s.codsolot,
                                                        an_error,
                                                        av_error);
            elsif c_p.accion = 2 then
              --Enviamos la Baja del Numero
              operacion.pq_sga_janus.p_envia_baja_numero_janus(ln_tiposot,
                                                               c_p.numero,
                                                               c_p.cod_id,
                                                               to_char(c_p.customer_id),
                                                               an_error,
                                                               av_error);
            elsif c_p.accion = 16 then
              operacion.pq_sga_janus.p_cambio_plan_janus_hfc(c_s.codsolot,
                                                             an_error,
                                                             av_error);
            end if;
          elsif c_p.nsecuencia = 2 and c_p.accion = 2 then
            -- Enviamos Baja del Cliente
            ln_valexist_linea := operacion.pq_sga_janus.f_val_exis_linea_janus(c_p.numero); -- Validamos si la linea se elimino para enviar la baja del cliente
            if ln_valexist_linea = 0 then
              operacion.pq_sga_janus.p_envia_baja_cliente_janus(ln_tiposot,
                                                                c_p.cod_id,
                                                                to_char(c_p.customer_id),
                                                                an_error,
                                                                av_error);
            end if;

          elsif c_p.nsecuencia = 3 and c_p.accion = 1 then
            -- Enviamos alta del numero
            operacion.pq_sga_janus.p_altanumero_janus(c_s.codsolot,
                                                      an_error,
                                                      av_error);
          end if;

          if an_error = 1 or an_error = -10 then
            -- Se envio correctamente
            operacion.pq_sga_janus.p_update_prov_sga_janus(c_p.idprov,
                                                           1,
                                                           an_error,
                                                           av_error,
                                                           an_error,
                                                           av_error);
          end if;

          goto salto;

        else
          -- si existe pendiente no envia nada.
          goto salto;
        end if;
      end loop;

      <<salto>>
      av_error := 1;

    end loop;
  end p_job_alinea_janus;

  procedure p_job_cierra_tarea_janus is

    cursor c_tareajanus_pend is
      select s.cod_id,
             s.codsolot,
             tw.idtareawf,
             tw.mottarchg,
             f.idwf,
             tw.tarea,
             tw.tareadef,
             xx.codigon,
             xx.codigoc tipo
        from solot s,
             wf f,
             tareawf tw,
             (select o.codigon, o.codigoc, o.abreviacion
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and t.abrev = 'TAREADEF_SRB'
                 and o.abreviacion = 'TAREA_JANUS'
                 and o.codigon_aux = 1) xx
       where s.codsolot = f.codsolot
         and f.idwf = tw.idwf
         and f.valido = 1
         and tw.tareadef = xx.codigon
         and tw.esttarea = 1;

    cursor c_tareajanus_pend_ce is
      select s.codsolot,
             tw.idtareawf,
             tw.mottarchg,
             f.idwf,
             tw.tarea,
             tw.tareadef
        from solot s, wf f, tareawf tw
       where s.codsolot = f.codsolot
         and f.idwf = tw.idwf
         and f.valido = 1
         and tw.tareadef in (select o.codigon
                               from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                                and o.abreviacion = 'BAJA_JANUS_CE'
                                and t.abrev = 'TAREADEF_SRB'
                                and o.codigon_aux = 1)
         and tw.esttarea = 1;

    cursor c_codinssrv(n_codsolot number) is
      select distinct ins.codinssrv
        from solotpto pto, inssrv ins
       where pto.codinssrv = ins.codinssrv
         and ins.tipinssrv = 3
         and pto.codsolot = n_codsolot;

    --Ini 7.0
    cursor c_bajas is
      select tw.idtareawf, s.cod_id, s.customer_id
        from solot s, wf f, tareawf tw
       where s.codsolot = f.codsolot
         and f.idwf = tw.idwf
         and f.valido = 1
         and exists (select 1
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and o.abreviacion = 'TAREACONFIW'
                 and t.abrev = 'TAREADEF_SRB'
                 and o.codigon_aux = 1
                 and o.codigon = tw.tareadef)
         and exists (select 1
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and o.abreviacion = 'TIPTRABAJ_ADM_TOT'
                 and t.abrev = 'TAREADEF_SRB'
                 and o.codigon_aux = 1
                 and o.codigon = s.tiptra)
         and tw.esttarea = 1;
    --Fin 7.0
    ln_trans_enviada number;
    ln_trans_cerrada number;
    ln_servtelefonia number;
    ln_valida        number;
    ln_tiposerv      number;
    lv_plat_origen   varchar2(50);
    --Ini 7.0
    ln_tiene_cp     number;
    ln_val_contrato number;
    --Fin 7.0
    ln_pendiente number;

  begin

    -- Cerrar Tareas Janus HFC SISACT
    for c_t in c_tareajanus_pend loop

      ln_servtelefonia := f_val_serv_tlf_sot(c_t.codsolot);

      if ln_servtelefonia = 0 then
        if c_t.tipo = 'BAJA' then
          opewf.pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                           cn_estcerrado,
                                           cn_estnointerviene,
                                           0,
                                           sysdate,
                                           sysdate);
        elsif c_t.tipo = 'CPLAN' then
          opewf.pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                           cn_estcerrado,
                                           cn_estnointerviene,
                                           0,
                                           sysdate,
                                           sysdate);
        end if;

      else

        select count(j.estado)
          into ln_trans_enviada
          from operacion.prov_sga_janus j
         where j.codsolot = c_t.codsolot
           and j.cod_id = c_t.cod_id;

        if ln_trans_enviada > 0 then
          select count(j.estado)
            into ln_trans_cerrada
            from operacion.prov_sga_janus j
           where j.codsolot = c_t.codsolot
             and j.cod_id = c_t.cod_id
             and j.estado = 0;

          if ln_trans_cerrada = 0 then
            if c_t.tipo = 'BAJA' then
              pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                         cn_estcerrado,
                                         cn_estcerrado,
                                         c_t.mottarchg,
                                         sysdate,
                                         sysdate);

              operacion.pq_sga_iw.p_update_prov_hfc_bscs(c_t.idtareawf,
                                                         c_t.idwf,
                                                         c_t.tarea,
                                                         c_t.tareadef);
            elsif c_t.tipo = 'CPLAN' then
              ln_pendiente := operacion.pq_sga_janus.f_val_prov_janus_pend(c_t.cod_id);

              if ln_pendiente = 0 then
                pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                           cn_estcerrado,
                                           cn_estcerrado,
                                           c_t.mottarchg,
                                           sysdate,
                                           sysdate);
              end if;
            end if;
          end if;
        else
          if c_t.tipo = 'BAJA' then
            p_libera_janusxsot(c_t.idtareawf,
                               c_t.idwf,
                               c_t.tarea,
                               c_t.tareadef);
          end if;
        end if;
      end if;

    end loop;

    -- Cierra Tareas HFC CE
    for c_t in c_tareajanus_pend_ce loop

      lv_plat_origen := f_get_plataforma_origen(c_t.codsolot);
      ln_tiposerv    := operacion.pq_sga_iw.f_val_tipo_serv_sot(c_t.codsolot);

      if lv_plat_origen = 'JANUS' then
        if ln_tiposerv = 1 then
          for c_in in c_codinssrv(c_t.codsolot) loop

            if f_val_prov_janus_pend(c_in.codinssrv) != 0 then
              ln_valida := ln_valida + 1;
            end if;

          end loop;

          if ln_valida = 0 then
            pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                       cn_estcerrado,
                                       cn_estcerrado,
                                       c_t.mottarchg,
                                       sysdate,
                                       sysdate);
          end if;
        end if;

        ln_valida := 0;

        if ln_tiposerv = 2 then

          select count(j.estado)
            into ln_trans_enviada
            from operacion.prov_sga_janus j
           where j.codsolot = c_t.codsolot;

          if ln_trans_enviada > 0 then

            select count(j.estado)
              into ln_trans_cerrada
              from operacion.prov_sga_janus j
             where j.codsolot = c_t.codsolot
               and j.estado = 0;

            if ln_trans_cerrada = 0 then
              pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                         cn_estcerrado,
                                         cn_estcerrado,
                                         c_t.mottarchg,
                                         sysdate,
                                         sysdate);
            end if;
          else
            p_libera_janusxsot(c_t.idtareawf,
                               c_t.idwf,
                               c_t.tarea,
                               c_t.tareadef);
          end if;
        end if;
      end if;
    end loop;
    --Ini 7.0
    for c_t in c_bajas loop
      ln_tiene_cp     := operacion.pq_sga_iw.f_val_cambioplan_cod_id_old(c_t.cod_id,
                                                                         c_t.customer_id);
      ln_val_contrato := operacion.pq_sga_iw.f_val_baja_co_id_customer_id(c_t.customer_id,
                                                                          c_t.cod_id);

      if (ln_tiene_cp = 1 and ln_val_contrato = 1) or ln_val_contrato = 1 then
        opewf.pq_wf.p_chg_status_tareawf(c_t.idtareawf,
                                         4,
                                         8,
                                         0,
                                         sysdate,
                                         sysdate);
      end if;
    end loop;
    --Fin 7.0
  end;

  procedure p_valida_linea_bscs_sga(an_codsolot in number,
                                    av_tipo     in varchar2,
                                    an_error    out number,
                                    av_error    out varchar2) is
    ln_cod_id   solot.cod_id%type;
    lv_codcli   solot.codcli%type;
    ln_customer solot.customer_id%type;
    lv_numero   inssrv.numero%type;
    ln_codinssrv inssrv.codinssrv%type;
    ln_error number;
    lv_error varchar2(4000);
    ln_tiposot number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    lv_tiposot varchar2(40);

    ln_alinea number;
    lv_mensaje varchar2(4000);
    ln_enviabajacli number;
    ln_contrato number;
    ln_codcliente   number;
    an_coderror number;
    av_msgerror varchar2(4000);
    ln_pendiente    number;
    ln_val_iw       number;
    ln_val_sotcp    number;
    ln_valor        number;
  begin

   ln_tiposot := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

   ln_enviabajacli := f_get_constante_conf('CBAJACLIJANUS');

   operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 ln_error,
                                                 lv_error);
   if ln_tiposot = 3 then
     lv_tiposot := 'BSCS';
     ln_contrato := ln_cod_id;
     ln_codcliente := ln_customer;
   elsif ln_tiposot = 2 then
     lv_tiposot := 'SGA';
     ln_contrato := ln_codinssrv;
     ln_codcliente := to_number(lv_codcli);
   end if;

   if ln_error = 1 and lv_numero is not null then
   --ini 10.0
   operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(an_codsolot,
                                                            ln_error,
                                                            lv_error);

      --fin 10.0
      if av_tipo = 'REGU' then

        ln_val_sotcp := operacion.pq_sga_bscs.f_get_is_cp_hfc(an_codsolot);

        select count(1)
          into ln_pendiente
          from operacion.prov_sga_janus p
         where p.codsolot = an_codsolot
           and p.estado = 0;

        ln_valor := f_get_constante_conf('CCPJANUSSIACU');

        if ln_pendiente = 0 then
          if ln_val_sotcp != 0 and ln_valor = 1 then
            p_insertxacc_prov_sga_janus(16,
                                        an_codsolot,
                                        ln_contrato,
                                        ln_customer,
                                        to_char(ln_customer),
                                        lv_numero,
                                        an_error,
                                        av_error);
          else
            if ln_enviabajacli = 1 then
              p_insertxacc_prov_sga_janus(3,
                                          an_codsolot,
                                          ln_contrato,
                                          ln_customer,
                                          to_char(ln_customer),
                                          lv_numero,
                                          an_error,
                                          av_error);
            else
              p_insertxacc_prov_sga_janus(4,
                                          an_codsolot,
                                          ln_contrato,
                                          ln_customer,
                                          to_char(ln_customer),
                                          lv_numero,
                                          an_error,
                                          av_error);
            end if;
          end if;
        else
          an_error := -1;
          av_error := 'La SOT ' || an_codsolot  || ' tiene programacion pendiente de envio a JANUS';
        end if;

     elsif av_tipo = 'INIFAC' then

        ln_val_iw := f_get_constante_conf('VALIDAIWJANUS');

        if ln_val_iw = 1 then
        p_valida_linea_iw_sga(lv_numero, ln_codcliente, an_coderror, av_msgerror);
        else
          an_coderror := 1;
        end if;

        if an_coderror = 1 then
            p_cons_linea_janus(lv_numero,
                               1,
                               ln_out_janus,
                               lv_mensaje_janus,
                               lv_customer_id_janus,
                               ln_codplan_janus,
                               lv_producto_janus,
                               ld_fecini_janus,
                               lv_estado_janus,
                               lv_ciclo_janus);

            if ln_out_janus = 1 then
               operacion.pq_sga_iw.p_val_datos_linea_janus(lv_tiposot,
                                                           an_codsolot,
                                                           ln_contrato,
                                                           lv_numero,
                                                           lv_customer_id_janus,
                                                           ln_codplan_janus,
                                                           lv_ciclo_janus,
                                                           ln_alinea,
                                                           lv_mensaje);
              if ln_alinea = 0 then
                an_error := 0;
                av_error := 'La informacion en JANUS/SGA/BSCS/IW no estan Alineados, por favor ejecutar Baja y Alta a Janus';
              elsif ln_alinea = 1 then
                an_error := 1;
                av_error := 'La informacion en JANUS/SGA/BSCS/IW estan Alineados';
              else
                an_error := ln_alinea;
                av_error := lv_mensaje;
              end if;
           elsif ln_out_janus = 0 then
             an_error := 0;
             av_error := 'La linea telefonica no existe en JANUS, por favor ejecutar Alta';
           else
             an_error := -1;
             av_error := lv_mensaje_janus;
           end if;
       else
         an_error := -1;
         av_error := av_msgerror;
       end if;
     end if;
   else
     an_error := 1;
     av_error := 'La SOT no tiene numero telefonico';
   end if;

 exception
   when others then
     an_error := -1;
     av_error := 'ERROR: P_VALIDA_LINEA_BSCS_SGA - ' || lv_error || '-' || sqlcode || ' - ' || sqlerrm || ' Linea (' ||
                          dbms_utility.format_error_backtrace || ')';
     p_reg_log(lv_codcli,
              ln_customer,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              ln_cod_id,
              'Regularización JANUS');
 end;

 procedure p_valida_linea_iw_sga(av_numero  in inssrv.numero%type,
                                 an_cliente in solot.customer_id%type,
                                 an_error   out number,
                                 av_error   out varchar2) is
    l_out  number;
    l_mensaje varchar2(50);
    l_clientecrm varchar2(50);
    l_idproducto number;
    l_idproductopadre number;
    l_idventa         number;
    l_idventapadre    number;
    l_endpointn       number;
    l_homeexchangename  varchar2(50);
    l_homeexchangecrmid varchar2(50);
    l_fechaActivacion   date;

    l_out1 number;
    l_mensaje1 varchar2(50);
    l_clientecrm1 varchar2(50);

 begin

   INTRAWAY.PQ_MIGRASAC.P_TRAE_NUMTELF(av_numero,l_out1,l_mensaje1,l_clientecrm1);

   IF l_out1 = 1 THEN
      if trim(l_clientecrm1) = to_char(an_cliente) then
            an_error := 1;
            av_error := 'Numero se encuentra Alineado en IC';
       else
            an_error := 0;
            av_error := 'Numero no esta asociado al Cliente '|| to_char(an_cliente) ||' en IC';
       end if;


   ELSE

   intraway.pq_consultaitw.p_int_consultatn(av_numero,l_out,l_mensaje,l_clientecrm,
                                            l_idproducto,l_idproductopadre,l_idventa,l_idventapadre,
                                            l_endpointn,l_homeexchangename,l_homeexchangecrmid,
                                            l_fechaActivacion);

   if l_out = 1 then
     if trim(l_clientecrm) = to_char(an_cliente) then
        an_error := 1;
        av_error := 'Numero se encuentra Alineado en IW';
     else
        an_error := 0;
        av_error := 'Numero no esta asociado al Cliente '|| to_char(an_cliente) ||' en IW';
     end if;
   else
     an_error := 2;
         av_error := 'Numero no existe en IW / IC';
   end if;

   END IF;
 exception
   when others then
     an_error := -1;
     av_error := 'Error : ' || sqlerrm || ' Linea (' || dbms_utility.format_error_backtrace ||')';
 end;

 function f_val_exis_linea_janus(av_numero in varchar2) return number is

   ln_cont number;
   lv_numero varchar2(20);

 begin
   lv_numero := '0051'||av_numero;

   select count(1)
      into ln_cont
      from dual
     where exists (select 1
              from janus_prod_pe.connections@DBL_JANUS c
             where c.connection_id_v = lv_numero);

   return ln_cont;

 end;

 -- Procedimiento para enviar baja a Janus SGA Masivo, SGA BSCS Masivo y SGA CE.
 procedure p_baja_janus_pre_ce_sga(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
   ln_codsolot      number;
   ln_error         number;
   lv_error         varchar2(4000);
   ln_servtelefonia number;
   lv_plat_origen varchar2(100);
   ln_tiposerv    number;
 begin

   select a.codsolot
     into ln_codsolot
     from wf a, solot b
    where a.idwf = a_idwf
      and a.codsolot = b.codsolot;

   ln_servtelefonia := f_val_serv_tlf_sot(ln_codsolot);
   ln_tiposerv      := operacion.pq_sga_iw.f_val_tipo_serv_sot(ln_codsolot);

   if ln_servtelefonia = 0 then
     opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                      cn_estcerrado,
                                      cn_estnointerviene,
                                      0,
                                      sysdate,
                                      sysdate);

   else

     lv_plat_origen := f_get_plataforma_origen(ln_codsolot);

     if lv_plat_origen = 'JANUS' then

       if ln_tiposerv = 1 then

         p_bajalinea_janus_ce(ln_codsolot, null, ln_error, lv_error);

       elsif ln_tiposerv = 3 or ln_tiposerv = 2 then

         p_libera_janusxsot(a_idtareawf, a_idwf, a_tarea, a_tareadef);

       end if;

     elsif lv_plat_origen = 'TELLIN' or lv_plat_origen = 'ABIERTA' then

       operacion.pq_int_telefonia.set_globals(a_idtareawf,
                                              a_idwf,
                                              a_tarea,
                                              a_tareadef);

       operacion.pq_int_telefonia.crear_int_telefonia();
       operacion.pq_int_telefonia.g_operacion := 'BAJA';
       operacion.pq_int_telefonia.g_origen    := lv_plat_origen;
       operacion.pq_int_telefonia.g_destino   := lv_plat_origen;

       if lv_plat_origen = 'TELLIN' then
         operacion.pq_tellin_baja.baja();
       elsif lv_plat_origen = 'ABIERTA' then
         operacion.pq_abierta.baja();
       end if;

       operacion.pq_int_telefonia.update_int_telefonia();

     else
       opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,
                                        cn_estcerrado,
                                        cn_estnointerviene,
                                        0,
                                        sysdate,
                                        sysdate);
     end if;

   end if;

 exception
   when others then
     lv_error := 'JANUS: p_baja_janus_pre_ce_sga - ' || SQLERRM ||
                 ' Linea (' || dbms_utility.format_error_backtrace || ')';
     raise_application_error(-20001, lv_error);
 end;

 function f_get_plataforma_origen(an_codsolot solot.codsolot%type) return varchar2 is
 begin
   if f_val_es_tlf_janus(an_codsolot) > 0 then
     return 'JANUS';
   elsif f_val_es_tlf_tellin(an_codsolot) > 0 then
     return 'TELLIN';
   elsif f_val_es_tlf_abierta(an_codsolot) > 0 then
     return 'ABIERTA';
   else
     RETURN 'NINGUNO';
   end if;
 end;

 function f_val_es_tlf_janus(an_codsolot solot.codsolot%type) return number is

   l_count number;

 begin
   select count(*)
     into l_count
     from tystabsrv t, solotpto s
    where s.codsolot = an_codsolot
      and s.codsrvnue = t.codsrv
      and t.idproducto in (select pp.idproducto
                             from plan_redint p, planxproducto pp
                            where p.idplan = pp.idplan
                              and p.idplan = t.idplan
                              and p.idplataforma = 6) --JANUS
      and t.flag_lc = 1;

   return l_count;
 end;

 function f_val_es_tlf_tellin(an_codsolot solot.codsolot%type)
   return number is
   l_count number;

 begin

   select count(*)
     into l_count
     from tystabsrv t, solotpto s
    where s.codsolot = an_codsolot
      and s.codsrvnue = t.codsrv
      and t.idproducto in (select pp.idproducto
                             from plan_redint p, planxproducto pp
                            where p.idplan = pp.idplan
                              and p.idplan = t.idplan
                              and p.idplataforma = 3) --TELLIN
      and t.flag_lc = 1;

   return l_count;
 end;

 function f_val_es_tlf_abierta(an_codsolot solot.codsolot%type)
   return number is
   l_count number;

 begin
   select count(*)
     into l_count
     from solotpto s, tystabsrv ty
    where s.codsolot = an_codsolot
      and s.codsrvnue = ty.codsrv
      and ty.tipsrv = '0004'
      and (ty.flag_lc is null or ty.flag_lc = 0);

   return l_count;
 end;

 procedure p_bajalinea_janus_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2) is

  lv_trama varchar2(3000);

  cursor c_linea is
     SELECT e.codsolot, f.pid, ins.numero, f.codinssrv
        FROM tystabsrv b,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.codsrv NOT IN
             (SELECT d.codigoc
                FROM tipopedd c, opedd d
               WHERE c.abrev = 'CFAXSERVER'
                 AND c.tipopedd = d.tipopedd
                 AND d.abreviacion = 'CFAXSERVER_SRV')
         AND e.codinssrv = ins.codinssrv
         and (ins.numero = av_numero or nvl(av_numero,'X')='X')
         and e.codsolot = an_codsolot
       ORDER BY f.pid DESC;

  ln_cantlinea number;
  ln_enviadas number;
  error_general_log   exception;

  begin
    ln_enviadas := 0;

    ln_cantlinea := f_obt_cant_linea_ce(an_codsolot);

    for c_lin in c_linea loop

      ln_enviadas := ln_enviadas + 1;

      lv_trama :=  operacion.pq_janus_ce_baja.armar_trama(c_lin.numero,c_lin.codinssrv, ln_cantlinea - ln_enviadas);

      tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp@dbl_bscs_bf(1000, 2, lv_trama, an_error, av_error);

      if an_error != 0 then
        av_error := 'ERROR al enviar la baja del numero ' || c_lin.numero || ' CE de Janus : ' || av_error;
        raise error_general_log;
      end if;
    end loop;

    an_error := 1;
    av_error := 'Exito al enviar la provision de baja a Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');

  exception
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la baja del numero CE de Janus : ' ||
                  to_char(sqlerrm);
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_error,
              av_error,
              0,
              'JANUS-Baja Numero SGACE');

  end p_bajalinea_janus_ce;

  function f_obt_cant_linea_ce(an_codsolot number) return number is

    ln_cantlinea number;

  begin
    -- Cantidad de Lineas telefonicas de la SOT
    SELECT count(e.codsolot) into ln_cantlinea
        FROM tystabsrv b,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.codsrv NOT IN
             (SELECT d.codigoc
                FROM tipopedd c, opedd d
               WHERE c.abrev = 'CFAXSERVER'
                 AND c.tipopedd = d.tipopedd
                 AND d.abreviacion = 'CFAXSERVER_SRV')
         AND e.codinssrv = ins.codinssrv
         and e.codsolot = an_codsolot
       ORDER BY f.pid DESC;

   return ln_cantlinea;

  end;

  --Funcion que valida si la SOT tiene el servicio de telefonia asociado
  function f_val_serv_tlf_sot(an_codsolot number) return number is
    ln_validar number;
  begin
    select count(distinct pto.codsolot)
      into ln_validar
      from solotpto pto, tystabsrv ser, producto p
     where pto.codsrvnue = ser.codsrv
       and ser.idproducto = p.idproducto
       and p.idproducto in
           (select o.codigon
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA'
               and o.codigoc = 'TLF')
       and pto.codsolot = an_codsolot;

    if ln_validar > 0 then
      return 1; -- Tiene telefonia
    else
      return 0; -- No tiene telefonia
    end if;

  end;

  --Procedimiento de alta de numero en Janus
  procedure p_altanumero_janus(an_codsolot number,
                               an_error    out integer,
                               av_error    out varchar2) is
    ln_tiposerv      number;
    ln_servtelefonia number;
  begin

    ln_servtelefonia := f_val_serv_tlf_sot(an_codsolot);

    if ln_servtelefonia = 1 then

      ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

      if ln_tiposerv = 1 then
        -- HFC CE
        p_altanumero_janus_sga_ce(an_codsolot, null, an_error, av_error);
      elsif ln_tiposerv = 2 then
        -- HFC SGA
        p_altanumero_janus_sga(an_codsolot, an_error, av_error);
      elsif ln_tiposerv = 3 then
        -- HFC SISACT
        p_altanumero_janus_bscs(an_codsolot, an_error, av_error);
      end if;
    else
      an_error := -1;
      av_error := 'La SOT no tiene el servicio de telefonia';
    end if;

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                  to_char(sqlerrm);
  end p_altanumero_janus;

  procedure p_altanumero_janus_sga_ce(an_codsolot number,
                                      av_numero   varchar2,
                                      an_error    out integer,
                                      av_error    out varchar2) is

    lv_trama             varchar2(3000);
    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    error_serv_pend   exception;
    error_general     exception;
    error_general_log exception;
    error_ok          exception;

    cursor c_linea is
      select e.numslc, e.codinssrv, trim(e.numero) numero, b.pid
        from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
       where a.pid = b.pid
         and e.tipinssrv = 3
         and b.codsrv = c.codsrv
         and e.codinssrv = b.codinssrv
         and a.codsolot = g.codsolot
         and b.flgprinc = 1
         and g.codsolot = an_codsolot
         and (trim(e.numero) = av_numero or nvl(av_numero, 'X') = 'X')
         and e.cid is not null;
  begin

    if f_get_plataforma_origen(an_codsolot) = 'JANUS' then

      for c_lin in c_linea loop

        if operacion.pq_sga_iw.f_val_prov_janus_pend(c_lin.codinssrv) = 0 then

           p_cons_linea_janus(c_lin.numero,
                             2,
                             ln_out_janus,
                             lv_mensaje_janus,
                             lv_customer_id_janus,
                             ln_codplan_janus,
                             lv_producto_janus,
                             ld_fecini_janus,
                             lv_estado_janus,
                             lv_ciclo_janus);

          if ln_out_janus = 0 then

            begin
              lv_trama := f_retorna_trama_alta_ce(an_codsolot,
                                                  c_lin.numslc,
                                                  c_lin.codinssrv,
                                                  c_lin.numero);

              tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl_corp@dbl_bscs_bf(1000,
                                                                         1,
                                                                         lv_trama,
                                                                         an_error,
                                                                         av_error);
              if an_error != 0 then
                av_error := 'ERROR al enviar la provision del numero ' ||
                            c_lin.numero || ' a Janus : ' || av_error;
                raise error_general_log;
              end if;

            exception
              when others then
                av_error := 'ERROR al enviar la provision del numero a Janus : ' ||
                            sqlerrm;
                raise error_general_log;
            end;

            an_error := 1;
            av_error := 'Se envio la provision correctamente a Janus';

          end if;
        else
          av_error := 'Existen pendientes en la provision de Janus CE';
          raise error_general;
        end if;
      end loop;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_ok;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGACE');
  exception
    when error_ok then
      an_error := -10; -- Para Control en el JOB
    when error_general then
      an_error := -1;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                0,
                'JANUS-Alta Numero SGACE');
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                0,
                'JANUS-Alta Numero SGACE');
    when others then
      an_error := -1;
      av_error := 'Error : ' || sqlerrm;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_Error,
                av_error,
                0,
                'JANUS-Alta Numero SGACE');

  end p_altanumero_janus_sga_ce;

  function f_retorna_trama_alta_ce(an_codsolot number,
                                   av_numslc   varchar2,
                                   an_codinssrv number,
                                   av_numero    varchar2)
    return varchar2 is

    lv_trama   varchar2(4000);
    lv_codcli  varchar2(8);
    lv_numslc varchar2(10);
    ln_planbase  number;
    ln_planopcion  number;
    lv_tipdide  varchar2(3);
    lv_ntdide  varchar2(15);
    lv_apellidos  varchar2(80);
    lv_nomcli  varchar2(100);
    lv_ruc  varchar2(15);
    lv_razon  varchar2(200);
    lv_tlf1  varchar2(50);
    lv_tlf2  varchar2(50);
    an_error  number;
    av_error  varchar2(4000);

    av_dirsuc  varchar2(1000);
    av_referencia  varchar2(340);
    av_nomdst  varchar2(40);
    av_nompvc  varchar2(40);
    av_nomest  varchar2(40);

  begin

    p_retorna_datos_cliente_ce(an_codsolot,lv_codcli,lv_numslc,ln_planbase, ln_planopcion,lv_tipdide,lv_ntdide,
                               lv_apellidos,lv_nomcli,lv_ruc,lv_razon,lv_tlf1,lv_tlf2,an_error,av_error);

    p_retorna_datos_sucursal_ce(av_numslc,av_dirsuc,av_referencia,av_nomdst,av_nompvc,av_nomest,an_error,av_error);

    lv_trama := pq_janus_ce.get_conf('P_COD_CUENTA') || lv_numslc || '|';
    lv_trama := lv_trama || pq_janus_ce.get_conf('P_HCCD') || lv_codcli || '|';
    lv_trama := lv_trama || lv_ruc || '|';
    lv_trama := lv_trama || lv_nomcli || '|';
    lv_trama := lv_trama || lv_apellidos || '|';
    lv_trama := lv_trama || lv_tipdide || '|';
    lv_trama := lv_trama || lv_ntdide || '|';
    lv_trama := lv_trama || lv_razon || '|';
    lv_trama := lv_trama || lv_tlf1 || '|';
    lv_trama := lv_trama || lv_tlf2 || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.get_nomemail(lv_codcli) || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.trim_dato('DIRSUC', av_dirsuc) || '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.trim_dato('REFERENCIA', av_referencia) || '|';
    lv_trama := lv_trama || av_nomdst || '|';
    lv_trama := lv_trama || av_nompvc || '|';
    lv_trama := lv_trama || av_nomest || '|';
    lv_trama := lv_trama || an_codinssrv || '|';
    lv_trama := lv_trama || av_numero || '|';
    lv_trama := lv_trama || pq_janus_ce.get_conf('P_IMSI') || av_numero|| '|';
    lv_trama := lv_trama || operacion.pq_janus_ce_alta.get_ciclo() || '|';
    lv_trama := lv_trama || ln_planbase || '|';
    lv_trama := lv_trama || ln_planopcion;

    return lv_trama;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.Trama CE: ' ||
                              sqlerrm);
  end;

  procedure p_retorna_datos_cliente_ce(an_codsolot number,
                                       av_codcli out varchar2,
                                       av_numslc out varchar2,
                                       an_planbase out number,
                                       an_planopcion out number,
                                       av_tipdide out varchar2,
                                       av_ntdide out varchar2,
                                       av_apellidos out varchar2,
                                       av_nomcli out varchar2,
                                       av_ruc out varchar2,
                                       av_razon out varchar2,
                                       av_tlf1 out varchar2,
                                       av_tlf2 out varchar2,
                                       an_error out number,
                                       av_error out varchar2)  is

  begin

    SELECT distinct
           e.codcli,
           e.numslc,
           h.plan,
           h.plan_opcional,
           v.tipdide,
           v.ntdide,
           REPLACE(v.apepatcli, '|', ' ') || ' ' ||
           REPLACE(v.apematcli, '|', ' ') apellidos,
           REPLACE(v.nomclires, '|', ' '),
           DECODE(v.tipdide, '001', v.ntdide, NULL) AS ruc,
           REPLACE(v.nomcli, '|', ' ') AS razon,
           v.telefono1,
           v.telefono2
           into av_codcli, av_numslc, an_planbase, an_planopcion, av_tipdide,
           av_ntdide, av_apellidos, av_nomcli,
           av_ruc, av_razon,  av_tlf1, av_tlf2
      FROM solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           vtatabcli v,
           plan_redint h
     WHERE a.pid = b.pid
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot
       and g.codcli   = v.codcli
       and g.codsolot =  an_codsolot;

       an_error := 1;
       av_error := 'OK';

  exception
    when others then
      an_error := -1;
      av_error := 'ERROR : Consulta Datos Cliente  CE - ' || sqlerrm;
  end p_retorna_datos_cliente_ce;

  procedure p_retorna_datos_sucursal_ce(av_numslc varchar2,
                                       av_dirsuc out varchar2,
                                       av_referencia out varchar2,
                                       av_nomdst out varchar2,
                                       av_nompvc out varchar2,
                                       av_nomest out varchar2,
                                       an_error out number,
                                       av_error out varchar2) is

  BEGIN
    SELECT DISTINCT REPLACE(vsuc.dirsuc, '|', ' ') dirsuc,
           REPLACE(vsuc.referencia, '|', ' ') referencia,
           vu.nomdst,
           vu.nompvc,
           vu.nomest
      INTO av_dirsuc, av_referencia, av_nomdst, av_nompvc, av_nomest
      FROM vtasuccli vsuc,
           (SELECT DISTINCT codsuc
              FROM vtadetptoenl vdet
             WHERE vdet.numslc = av_numslc
            ) vv,
           v_ubicaciones vu
     WHERE vsuc.codsuc = vv.codsuc
       AND vsuc.ubisuc = vu.codubi(+);

       an_error := 1;
       av_error := 'OK';
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR : Consulta Datos Cliente  CE - ' || sqlerrm;
  end p_retorna_datos_sucursal_ce;

  procedure p_altanumero_janus_sga(an_codsolot number,
                                   an_error    out integer,
                                   av_error    out varchar2) is
    vs_hcon      varchar2(1) := 9;
    vs_hccd      varchar2(4) := 'HCCD';
    lv_trama      varchar2(4000);
    v_msgerr     varchar2(1000);
    v_respuesta  varchar2(1000);
    lv_ciclo     varchar2(10);
    ln_contciclo number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    error_general     exception;
    error_general_log exception;
    error_ok          exception;

    cursor c_lineaxsot is
      select distinct ins.codinssrv,
                      trim(ins.numero) numero,
                      r.plan plan_actual_SGA,
                      r.plan_opcional plan_opc_actual_SGA,
                      ins.codcli,
                      decode(v.tipdide, '001', v.ntdide, null) ruc,
                      intraway.f_retorna_nomcli_itw(v.nomclires) nombre_clires,
                      intraway.f_retorna_nomcli_itw(v.nomclires) || ' ' ||
                      intraway.f_retorna_nomcli_itw(v.apepatcli) apenom_cliente,
                      v.tipdide,
                      v.ntdide,
                      intraway.f_retorna_nomcli_itw(v.nomcli) razon,
                      trim(v.telefono1) telef_1,
                      trim(v.telefono2) telef_2,
                      trim(v.mail) mail,
                      intraway.f_retorna_nomcli_itw(substr(v.dircli, 1, 200)) direc_cliente,
                      intraway.f_retorna_nomcli_itw(substr(v.referencia,
                                                           1,
                                                           200)) refere_cliente,
                      (select u.nomdst
                         from v_ubicaciones u
                        where u.codubi = ins.codubi) nomdst,
                      (select u.nompvc
                         from v_ubicaciones u
                        where u.codubi = ins.codubi) nompvc,
                      (select u.nomest
                         from v_ubicaciones u
                        where u.codubi = ins.codubi) nomest
        from solot       s,
             solotpto    pto,
             inssrv      ins,
             tystabsrv   tt,
             plan_redint r,
             vtatabcli   v
       where s.codsolot = pto.codsolot
         and tt.codsrv = ins.codsrv
         and tt.idplan = r.idplan
         and pto.codinssrv = ins.codinssrv
         and v.codcli = ins.codcli
         and ins.tipinssrv = 3
         and ins.estinssrv = 1
         and s.codsolot = an_codsolot;

  begin

    if f_get_plataforma_origen(an_codsolot) = 'JANUS' then

      for bb in c_lineaxsot loop

        ln_contciclo := f_get_constante_conf('CCICLO_JANUS');

        if ln_contciclo = 1 then
          lv_ciclo := f_get_ciclo_codinssrv(bb.numero, bb.codinssrv);
        else
          lv_ciclo := '01';
        end if;

        if operacion.pq_sga_iw.f_val_prov_janus_pend(bb.codinssrv) = 0 then

          p_cons_linea_janus(bb.numero,
                             2,
                             ln_out_janus,
                             lv_mensaje_janus,
                             lv_customer_id_janus,
                             ln_codplan_janus,
                             lv_producto_janus,
                             ld_fecini_janus,
                             lv_estado_janus,
                             lv_ciclo_janus);

          if ln_out_janus = 0 then
            lv_trama := vs_hcon || bb.codcli || '|' || vs_hccd || bb.codcli || '|' ||
                       bb.ruc || '|' || bb.nombre_clires || '|' ||
                       bb.apenom_cliente || '|' || bb.tipdide || '|' ||
                       bb.ntdide || '|' || bb.razon || '|' || bb.telef_1 || '|' ||
                       bb.telef_2 || '|' || bb.mail || '|' ||
                       bb.direc_cliente || '|' || bb.refere_cliente || '|' ||
                       bb.nomdst || '|' || bb.nompvc || '|' || bb.nomest || '|' ||
                       bb.codinssrv || '|' || bb.numero || '|' || 'IMSI' ||
                       bb.numero || '|' || lv_ciclo || '|' || bb.plan_actual_SGA || '|' ||
                       bb.plan_opc_actual_SGA;
            begin

              tim.pp001_pkg_prov_janus.SP_REG_PROV_CTRL@dbl_bscs_bf(12,
                                                                    1,
                                                                    lv_trama,
                                                                    v_respuesta,
                                                                    v_msgerr);

              if v_respuesta != 0 then
                av_error := 'Provision Janus : ' || v_msgerr;
                raise error_general_log;
              end if;

            exception
              when others then
                av_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                            sqlerrm;
                raise error_general_log;
            end;

          elsif ln_out_janus = -2 then

            av_error := 'La linea telefonica ya existe en JANUS pero no se encuentra asociada a un cliente; por favor derivar el caso con el area de RED para que proceda a eliminar correctamente la linea telefonica de JANUS';
            raise error_general;

          elsif ln_out_janus = 1 then

            av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
            raise error_ok;

          else
            av_error := 'Error Janus : ' || lv_mensaje_janus;
            raise error_general_log;
          end if;
        else
          av_error := 'Existen pendientes en la provision de Janus';
          raise error_general;
        end if;
      end loop;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_ok;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              0,
              'JANUS-Alta Numero SGA');

  exception
    when error_ok then
      an_error := -10; -- Para Control en el JOB
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_error,
                av_error,
                0,
                'JANUS-Alta Numero SGA');

    when error_general then
      an_error := -1;
    when others then
      an_error := -1;
      av_error := 'Error : ' || sqlerrm;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_error,
                av_error,
                0,
                'JANUS-Alta Numero SGA');

  end p_altanumero_janus_sga;

  function f_get_ciclo_codinssrv(l_numero    numtel.numero%type,
                                 l_codinssrv insprd.codinssrv%type)
    return varchar2 is

    l_cicfac   number;
    l_maxsec   number;
    l_ciclo    varchar2(100);
    l_cons     number;
    l_desciclo ciclo.descripcion%type;

  begin

    l_cons := 0;

    begin
      select distinct cicfac
        into l_cicfac
        from instxproducto
       where pid in (select pid
                       from insprd
                      where codinssrv = l_codinssrv
                        and flgprinc = 1)
         and nomabr = l_numero;

      l_cons := 1;

    exception
      when others then
        l_cons := 0;
    end;

    if l_cons > 0 then
      begin
        select max(seccicfac)
          into l_maxsec
          from fechaxciclo
         where cicfac = l_cicfac;

        select to_char(fecini, 'dd')
          into l_ciclo
          from fechaxciclo
         where seccicfac = l_maxsec
           and cicfac = l_cicfac;

        select descripcion
          into l_desciclo
          from ciclo
         where cicfac = l_cicfac;

        return l_ciclo;

      exception
        when others then
          l_ciclo := -1;
      end;
    else
      l_ciclo := 0;
    end if;

    return l_ciclo;

  end;

  procedure p_altanumero_janus_bscs(an_codsolot number,
                                    an_error    out integer,
                                    av_error    out varchar2) is
    ln_cod_id     number;
    ln_customer   number;
    v_customer_id number;
    v_tmcode      number;
    v_sncode      number;
    error_general     exception;
    error_general_log exception;
    error_ok          exception;
    ln_existe_csc  number;
    lv_numero      varchar2(20);
    an_error_contr number;
    av_error_contr varchar2(1000);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    lv_codcli    varchar2(8);
    ln_codinssrv number;
    ln_tn_bscs   varchar2(20);
    ln_error     number;
    lv_error     varchar2(4000);

    ln_valor  number;
    ln_tiptra number;

    cursor c_request(an_codid number) is
      select request
        from mdsrrtab@DBL_BSCS_BF
       where co_id = an_codid
         and request_update is null
         and status not in (9, 7)
         and action_id in (1);

  begin
    if f_get_plataforma_origen(an_codsolot) = 'JANUS' then

      an_error_contr := 0;

      operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                   lv_numero,
                                                   lv_codcli,
                                                   ln_cod_id,
                                                   ln_customer,
                                                   ln_codinssrv,
                                                   an_error,
                                                   av_error);

      if an_error = 1 then

        ln_valor := f_get_constante_conf('REGCONTR_SERCAB');

        select count(1)
          into ln_tiptra
          from solot s
         where s.codsolot = an_codsolot
           and exists (select 1
                  from tipopedd t, opedd o
                 where t.tipopedd = o.tipopedd
                   and t.abrev = 'CONFSERVADICIONAL'
                   and o.abreviacion = 'TIPTRA_CSC_CP'
                   and o.codigon = s.tiptra);

        if ln_valor = 2 and ln_tiptra = 1 then
          for c_r in c_request(ln_cod_id) loop
            contract.finish_request@dbl_bscs_bf(c_r.request);
            update mdsrrtab@dbl_bscs_bf
               set status = 7
             where request = c_r.request;
            commit;
          end loop;
        end if;

        -- Alineamos los numeros en el caso
        ln_tn_bscs := tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(ln_cod_id);

        operacion.pq_hfc_alineacion.p_regulariza_numero(ln_cod_id,
                                                        lv_numero,
                                                        ln_tn_bscs,
                                                        2,
                                                        ln_error,
                                                        lv_error);

        begin

          select ca.customer_id, ca.tmcode, ps.sncode
            into v_customer_id, v_tmcode, v_sncode
            from contract_all@dbl_bscs_bf          ca,
                 profile_service@dbl_bscs_bf       ps,
                 tim.pf_hfc_parametros@dbl_bscs_bf hf
           where ca.co_id = ln_cod_id
             and ca.co_id = ps.co_id
             and ps.sncode = hf.cod_prod1
             and HF.CAMPO = 'SERV_TELEFONIA';

        exception
          when too_many_rows then
            av_error := 'ERROR: El contrato tiene asociado mas de un Plan de Telefonia, por favor realizar una nueva venta por Regularización ' ||
                        sqlcode || ' ' || sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';
            raise error_general_log;
        end;

        ln_existe_csc := operacion.pq_sga_bscs.f_val_existe_contract_sercad(ln_cod_id);

        --Insertamos en la Contr_servicas si no existe
        if ln_existe_csc = 0 then
          begin
            operacion.pq_sga_bscs.p_reg_contr_services_cap(ln_cod_id,
                                                           lv_numero,
                                                           an_error_contr,
                                                           av_error_contr);
            commit;
          exception
            when others then
              av_error := 'Error al Registrar en la contr_services_cap : ' ||
                          sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
              raise error_general_log;
          end;
        end if;

        if an_error_contr = 1 or ln_existe_csc > 0 then

          if operacion.pq_sga_iw.f_val_prov_janus_pend(ln_cod_id) = 0 then

            p_cons_linea_janus(lv_numero,
                               2,
                               ln_out_janus,
                               lv_mensaje_janus,
                               lv_customer_id_janus,
                               ln_codplan_janus,
                               lv_producto_janus,
                               ld_fecini_janus,
                               lv_estado_janus,
                               lv_ciclo_janus);

            if ln_out_janus = 0 then
              begin
                tim.pp001_pkg_prov_janus.sp_prov_nro_hfc@dbl_bscs_bf(ln_cod_id,
                                                                     v_customer_id,
                                                                     v_tmcode,
                                                                     v_sncode,
                                                                     'A',
                                                                     an_error,
                                                                     av_error);
              exception
                when others then
                  av_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                              sqlcode || ' ' || sqlerrm || ' (' ||
                              dbms_utility.format_error_backtrace || ')';
                  raise error_general_log;
              end;

            elsif ln_out_janus = 1 then

              av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
              raise error_ok;

            elsif ln_out_janus = -2 then

              av_error := 'La linea telefonica ya existe en JANUS pero no se encuentra asociada a un cliente; por favor derivar el caso con el area de RED para que proceda a eliminar correctamente la linea telefonica de JANUS';
              raise error_general;

            else
              av_error := 'Error Janus : ' || lv_mensaje_janus;
              raise error_general;
            end if;
          else
            av_error := 'Existen pendientes en la provision de Janus';
            raise error_general;
          end if;
        else
          av_error := 'El numero telefonico no esta Asociado al contrato';
          raise error_general;
        end if;
      end if;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_ok;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';

    p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              ln_cod_id,
              'JANUS-Alta Numero BSCS');
  exception
    when error_ok then
      an_error := -10; -- Para control en el JOB
    when error_general_log then
      an_error := -1;
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_error,
                av_error,
                ln_cod_id,
                'JANUS-Alta Numero BSCS');

    when error_general then
      an_error := -1;

    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                  sqlcode || ' ' || sqlerrm || ' (' ||
                  dbms_utility.format_error_backtrace || ')';
      p_reg_log(null,
                null,
                NULL,
                an_codsolot,
                null,
                an_error,
                av_error,
                ln_cod_id,
                'JANUS-Alta Numero BSCS');

  end p_altanumero_janus_bscs;

  function f_get_constante_conf(av_constante char) return number is
    ln_valor number;

  begin
    select to_number(c.valor)
      into ln_valor
      from constante c
     where c.constante = av_constante;

    return ln_valor;

  exception
    when others then
      return - 10;
  end;

  procedure p_ejecuta_transaccion_janus(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number) is

     ln_codsolot  solot.codsolot%type;
     ln_cod_id    solot.cod_id%type;
     lv_codcli    solot.codcli%type;
     ln_customer  solot.customer_id%type;
     ln_error     number;
     lv_error     varchar2(4000);

     error_general exception;

   begin

     select a.codsolot, b.codcli, b.customer_id, b.cod_id
       into ln_codsolot, lv_codcli, ln_customer, ln_cod_id
       from wf a, solot b
      where a.idwf = a_idwf
        and a.codsolot = b.codsolot
        and a.valido = 1;

     p_valida_linea_bscs_sga(ln_codsolot, 'INIFAC', ln_error, lv_error);

     if ln_error = 0 then

       p_valida_linea_bscs_sga(ln_codsolot, 'REGU', ln_error, lv_error);

       if ln_error <> 1 then
         raise error_general;
       end if;

     else
       raise error_general;
     end if;

     ln_error := 1;
     lv_error := 'Proceso Ejecutado Exitoso';

     p_reg_log(lv_codcli,
               ln_customer,
               NULL,
               ln_codsolot,
               null,
               ln_Error,
               lv_error,
               ln_cod_id,
               'Transaccion JANUS');
   exception
     when error_general then
       ln_error := -1;
       p_reg_log(lv_codcli,
                 ln_customer,
                 NULL,
                 ln_codsolot,
                 null,
                 ln_error,
                 lv_error,
                 ln_cod_id,
                 'Transaccion JANUS');
     when others then
       ln_error := -1;
       lv_error := 'ERROR al enviar la provision del numero de Janus : ' ||
                   sqlcode || ' ' || sqlerrm || ' (' ||
                   dbms_utility.format_error_backtrace || ')';
       p_reg_log(lv_codcli,
                 ln_customer,
                 NULL,
                 ln_codsolot,
                 null,
                 ln_error,
                 lv_error,
                 ln_cod_id,
                 'Transaccion JANUS');
  end;
  procedure p_baja_linea_janus_lte(an_codsolot number,
                                   an_error    out number,
                                   av_error    out varchar2) is
    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    ln_cod_id    number;
    lv_codcli    varchar2(8);
    ln_customer  number;
    ln_codinssrv number;
    lv_numero    inssrv.numero%type;
    ln_ordid     number;
    ln_ordid_ant number;
    lv_trama     varchar2(1000);
    error_general exception;
    lv_resul varchar2(4000);
    ln_alinea     number;
    lv_mensaje    varchar2(4000);
  begin

    an_error := 1;
    av_error := 'OK';

  OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
              'p_baja_linea_janus_lte', --proceso
              'Inicio', --mensaje
              'Dar Baja Número', --tarea
              ln_cod_id,
              lv_resul); --ASL

    operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                 lv_numero,
                                                 lv_codcli,
                                                 ln_cod_id,
                                                 ln_customer,
                                                 ln_codinssrv,
                                                 an_error,
                                                 av_error);



    if an_error = 1 and lv_numero is not null then

      if f_val_prov_janus_pend(ln_cod_id) = 0 then

        p_cons_linea_janus(lv_numero,
                           1,
                           ln_out_janus,
                           lv_mensaje_janus,
                           lv_customer_id_janus,
                           ln_codplan_janus,
                           lv_producto_janus,
                           ld_fecini_janus,
                           lv_estado_janus,
                           lv_ciclo_janus);

        if ln_out_janus = -1 then
          av_error := 'Error Janus : ' || lv_mensaje_janus;
          raise error_general;
        end if;--ASL

        if ln_out_janus = 1 then
          -- Agregar la validacion

          operacion.pq_sga_iw.p_val_datos_linea_janus('LTE',
                                  an_codsolot,
                                  ln_cod_id,
                                  lv_numero,
                                  lv_customer_id_janus,
                                  ln_codplan_janus,
                                  lv_ciclo_janus,
                                  ln_alinea,
                                  lv_mensaje);
          if ln_alinea = 0 then

          lv_trama := f_get_external_janus_numero(lv_numero);

          if lv_trama = '00' then
              av_error := 'Error Janus : ' || av_error;
              raise error_general;--ASL
           end if;
          if lv_trama != '00' then
            p_insert_prov_bscs_janus(2,
                                     5,
                                     ln_customer,
                                     ln_cod_id,
                                     '2',
                                     1,
                                     lv_trama,
                                     ln_ordid_ant,
                                     an_error,
                                     av_error);

        if an_error = -1 then
          av_error := 'Error Janus : ' || av_error;
          raise error_general;
        end if;--ASL

            lv_trama := to_char(ln_customer);

            p_insert_prov_bscs_janus(2,
                                     5,
                                     ln_customer,
                                     ln_cod_id,
                                     '2',
                                     1,
                                     lv_trama,
                                     ln_ordid,
                                     an_error,
                                     av_error);

         if an_error = -1 then
          av_error := 'Error Janus : ' || av_error;
          raise error_general;
        end if;--ASL

            update tim.rp_prov_bscs_janus@dbl_bscs_bf p
               set p.ord_id_ant = ln_ordid_ant
             where p.ord_id = ln_ordid;
            end if;

          elsif ln_alinea = 1 then
            an_error := -1;
            av_error := 'La informacion en JANUS y BSCS estan Alineados';
          else
            an_error := -1;
            av_error := 'ERROR : ' || lv_mensaje;
          end if;

        elsif ln_out_janus = -2 then
          lv_trama := f_get_external_janus_numero(lv_numero);
           if lv_trama = '00' then
              av_error := 'Error Janus : ' || av_error;
              raise error_general;--ASL
           end if;
          if lv_trama != '00' then
            p_insert_prov_bscs_janus(2,
                                     5,
                                     ln_customer,
                                     ln_cod_id,
                                     '2',
                                     1,
                                     lv_trama,
                                     ln_ordid,
                                     an_error,
                                     av_error);

         if an_error = -1 then
          av_error := 'Error Janus : ' || av_error;
          raise error_general;
        end if;--ASL

          end if;
        else
          av_error := 'Error Janus : ' || lv_mensaje_janus;
          raise error_general;
        end if;
      else
        av_error := 'Existen pendientes en la provision de Janus';
        raise error_general;
      end if;
    else
      av_error := 'La SOT no tiene el servicio de Telefonia para enviar a Janus';
      raise error_general;
    end if;

    -- Colocar LOG de Exito
        OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                                  'p_baja_linea_janus_lte', --proceso
                                                  'Fin con ÿXITO', --mensaje
                                                  'Dar Baja Número', --tarea
                                                  ln_cod_id,
                                                  lv_resul);
    --
  exception
    when error_general then
      an_error := -1;
      av_error :=  'ERROR en la Baja de Linea Telefonica en JANUS-LTE : '|| av_error ||sqlcode || ' ' || sqlerrm || ' (' ||dbms_utility.format_error_backtrace || ')';

      operacion.pq_3play_inalambrico.p_log_3playi(an_codsolot, --solot
                                                  'p_baja_linea_janus_lte', --proceso
                                                  av_error, --mensaje
                                                  'Dar Baja Número', --tarea
                                                  ln_cod_id,
                                                  lv_resul);
    when others then
          av_error := 'ERROR en la Baja de Linea Telefonica en JANUS-LTE : ' || av_error ||
                  sqlcode || ' ' || sqlerrm || ' (' ||
                  dbms_utility.format_error_backtrace || ')';

          operacion.pq_3play_inalambrico.p_log_3playi(an_codsolot, --solot
                                                  'p_baja_linea_janus_lte', --proceso
                                                  av_error, --mensaje
                                                  'Dar Baja Número', --tarea
                                                  ln_cod_id,
                                                  lv_resul);
  end;

  procedure p_alta_numero_janus_lte(an_codsolot number,
                                    an_error    out number,
                                    av_error    out varchar2) is
    ln_cod_id   number;
    ln_customer number;
    error_general     exception;
    error_general_log exception;
    error_ok          exception;
    lv_numero            varchar2(20);
    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);

    lv_codcli    varchar2(8);
    ln_codinssrv number;
    ln_tmcode    number;
    ln_smcode    number;
    ln_resp      number;
    lv_mensaje   varchar2(4000);
    lv_resul     varchar2(4000);
    ln_cod_resp  number;  --11.00
    ln_val_wimax_lte number; --11.00
  begin

         OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                                'p_alta_numero_janus_lte', --proceso
                                                'Inicio', --mensaje
                                                'Dar Alta Numero', --tarea
                                                ln_cod_resp, --11.00
                                                lv_resul); --ASL

       if f_get_plataforma_origen(an_codsolot) = 'JANUS' then



      operacion.pq_sga_iw.p_cons_numtelefonico_sot(an_codsolot,
                                                   lv_numero,
                                                   lv_codcli,
                                                   ln_cod_id,
                                                   ln_customer,
                                                   ln_codinssrv,
                                                   an_error,
                                                   av_error);
     --ini 9.0
     select mac
       into lv_numero
       from solotptoequ
      where codsolot=an_codsolot
        and tipequ in(select a.codigon
                        from opedd a, tipopedd b
                       where a.tipopedd = b.tipopedd
                         and b.abrev = 'TIPEQU_LTE_TLF'
                         and a.codigoc = '3');
     --fin 9.0

      if an_error = 1 or lv_numero is not null then
        if f_val_prov_janus_pend_alta(ln_cod_id) = 0 then

          p_cons_linea_janus(lv_numero,
                             2,
                             ln_out_janus,
                             lv_mensaje_janus,
                             lv_customer_id_janus,
                             ln_codplan_janus,
                             lv_producto_janus,
                             ld_fecini_janus,
                             lv_estado_janus,
                             lv_ciclo_janus);

          if ln_out_janus = 0 then

              --ini 11.0
              ln_val_wimax_lte := operacion.pq_sga_wimax_lte.f_val_cli_wimax(lv_codcli);

              if ln_val_wimax_lte = 0 then
                OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, 'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact', 'INICIO',
                                                            'Alta Janus LTE', ln_cod_resp, lv_resul);
                --Cambio de ciclo de facturacion
                operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(an_codsolot,
                                                                      ln_resp,
                                                                      lv_mensaje);
                OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, 'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact', lv_mensaje,
                                                            'Alta Janus LTE', ln_cod_resp, lv_resul);

                if ln_resp = -99 then
                  av_error := lv_mensaje;
                  raise error_general;
                end if;
              end if;
              --fin 11.0

              ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
              ln_smcode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

              -- Mapees el mensaje de error
              operacion.pq_3play_inalambrico.p_provision_janus(ln_cod_id,
                                                               ln_customer,
                                                               ln_tmcode,
                                                               ln_smcode,
                                                               'A',
                                                               ln_resp,
                                                               lv_mensaje);
              if ln_resp <> 0 then
                av_error := lv_mensaje; --11.0
                raise error_general;
              end if;

          elsif ln_out_janus = 1 then

            av_error := 'La linea telefonica ya se encuentra provisionada en Janus';
            raise error_ok;

          elsif ln_out_janus = -2 then

            av_error := 'La linea telefonica ya existe en JANUS pero no se encuentra asociada a un cliente; por favor derivar el caso con el area de RED para que proceda a eliminar correctamente la linea telefonica de JANUS';
            raise error_general;

          else
            av_error := lv_mensaje_janus; --11.0
            raise error_general;
          end if;
        else
          av_error := 'Existen pendientes en la provision de Janus';
          raise error_general;
        end if;
      end if;
    else
      av_error := 'La SOT tiene asociado un servicio de telefonia (Linea Abierta), estas no se Provisionan a JANUS';
      raise error_general;
    end if;

    an_error := 1;
    av_error := 'Exito al enviar la provision del numero de Janus';
    -- Colocar LOG

    OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                                'p_alta_numero_janus_lte', --proceso
                                                av_error, --mensaje
                                                'Dar Alta Numero', --tarea
                                                ln_cod_resp, --11.00
                                                lv_resul);
  exception
    when error_ok then
      an_error := -4;
      av_error := 'Información: ' || av_error ;

      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                      'p_alta_numero_janus_lte', --proceso
                                      av_error, --mensaje
                                      'Dar Alta Numero', --tarea
                                      ln_cod_resp, --11.00
                                      lv_resul);
      --LOG
    when error_general_log then
      an_error := -3;
      av_error := 'ERROR al enviar la provision del numero de Janus : ' || av_error ||
      sqlcode || ' ' || sqlerrm || ' (' ||
      dbms_utility.format_error_backtrace || ')';

      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                      'p_alta_numero_janus_lte', --proceso
                                      av_error, --mensaje
                                      'Dar Alta Numero', --tarea
                                      ln_cod_resp, --11.00
                                      lv_resul);
      --LOG
    when error_general then
      an_error := -2;
        av_error := 'ERROR al enviar la provision del numero de Janus : ' || av_error ||
                 ' (' || dbms_utility.format_error_backtrace || ')'; --11.0

    OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                            'p_alta_numero_janus_lte', --proceso
                                            av_error, --mensaje
                                            'Dar Alta Numero', --tarea
                                            ln_cod_resp, --11.00
                                            lv_resul);
      --LOG
    when others then
      an_error := -1;
      av_error := 'ERROR al enviar la provision del numero de Janus : ' || av_error ||
                  sqlcode || ' ' || sqlerrm || ' (' ||
                  dbms_utility.format_error_backtrace || ')';

          OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                                  'p_alta_numero_janus_lte', --proceso
                                                  av_error, --mensaje
                                                  'Dar Alta Numero', --tarea
                                                  ln_cod_resp, --11.00
                                                  lv_resul);
      --LOG
  end;

  function f_get_external_janus_numero(av_numero varchar2) return varchar2 is

    lv_imsijanus   varchar2(100);
    lv_numerojanus varchar2(20);

  begin

    lv_numerojanus := '0051' || av_numero;

    select l.external_payer_id_v
      into lv_imsijanus
      from janus_prod_pe.connections@DBL_JANUS         c,
           janus_prod_pe.connection_accounts@DBL_JANUS d,
           janus_prod_pe.payers@DBL_JANUS              l
     where c.account_id_n = d.account_id_n
       and d.payer_id_0_n = l.payer_id_n
       and c.connection_id_v = lv_numerojanus;

    return lv_imsijanus;

  exception
    when others then
      lv_imsijanus := '00';
      return lv_imsijanus;
  end;

  procedure p_reg_log(ac_codcli      operacion.solot.codcli%type,
                      an_customer_id number,
                      an_idtrs       number,
                      an_codsolot    number,
                      an_idinterface number,
                      an_error       number,
                      av_texto       varchar2,
                      an_cod_id      number default 0,
                      av_proceso     varchar default '') is
    pragma autonomous_transaction;
  begin
    insert into operacion.log_trs_interface_iw
      (codcli,
       idtrs,
       codsolot,
       idinterface,
       error,
       texto,
       customer_id,
       cod_id,
       proceso)
    values
      (ac_codcli,
       an_idtrs,
       an_codsolot,
       an_idinterface,
       an_error,
       av_texto,
       an_customer_id,
       an_cod_id,
       av_proceso);
    commit;
  end p_reg_log;

  procedure p_relanza_co_id_bscs_lte(an_codsolot number,
                                an_error    out number,
                                av_error    out varchar2) is

    n_cod_id    number;
    ln_resp     NUMERIC := 0;
    lv_mensaje  VARCHAR2(3000);
    ln_resp1    NUMERIC := 0;
    lv_mensaje1 VARCHAR2(3000);
    lv_idtrs    varchar2(30);
    ln_cod1     number;
    lv_ch_status varchar2(1);
    lv_resul    varchar2(4000);
    error_general     exception;
    lv_codcli        solot.codcli%type;
    ln_val_wimax_lte number;
    p_cod       number;
    p_mensaje   varchar2(4000);
    ln_tmcode         NUMBER;
    ln_smcode         NUMBER;
    ln_cod_id         NUMBER;
    ln_custumer_id    NUMBER;
      
  begin

    SELECT a.cod_id
      INTO n_cod_id
      FROM operacion.solot a
     WHERE a.codsolot = an_codsolot
       and a.cod_id is not null;
         
    an_error := 1;
    av_error := 'OK';

        operacion.pq_3play_inalambrico.p_log_3playi(an_codsolot, --solot
                                                'p_relanza_co_id_bscs_lte', --proceso
                                                'Inicio', --mensaje
                                                'Relanzamiento LTE', --tarea
                                                ln_cod1,
                                                lv_resul);


     select  f_val_status_contrato_Bscs(n_cod_id) into lv_ch_status  from dual;


     if lower(lv_ch_status) = 'o' then
       webservice.pq_datos_webservice.actualizar_contrato(n_cod_id,
                                                          '2', -- Estado: Activo
                                                          '1', -- Razon: Activacion
                                                          lv_idtrs, -- Id. de Transaccion a devolver
                                                          ln_resp,
                                                          lv_mensaje);

       if ln_resp = -1 then
         av_error := 'Error BSCS-LTE : ' || lv_mensaje;
         raise error_general;
       end if;
     end if;
      commit;

      operacion.pq_3play_inalambrico.p_reg_cbscs_lte(an_codsolot,
                                                     lv_idtrs,
                                                     ln_resp1,
                                                     lv_mensaje1);

      IF ln_resp1 <> 0 THEN
        av_error := 'Error BSCS-LTE : ' || lv_mensaje1;
        raise error_general;
      END IF;




            -- Colocar LOG de Exito
        OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot, --solot
                                                  'p_relanza_co_id_bscs_lte', --proceso
                                                  'Fin con ÿXITO', --mensaje
                                                  'Relanzamiento LTE', --tarea
                                                  ln_cod1,
                                                  lv_resul);
    commit;
    
    -- inc000002095333
      if tim.pp021_venta_lte.f_estado_co_id@dbl_bscs_bf(n_cod_id) = 'ax' then
        
       --ini 15.0      
         select s.codcli
            into lv_codcli
            from solot s
           where s.codsolot = an_codsolot;
           
         ln_val_wimax_lte := operacion.pq_sga_wimax_lte.f_val_cli_wimax(lv_codcli);
         
         select s.cod_id,
               s.customer_id
          into ln_cod_id, ln_custumer_id
          from solotptoequ se,
               solot s,
               solotpto sp,
               inssrv i,
               tipequ t,
               almtabmat a,
               (select a.codigon tipequ, codigoc grupo
                  from opedd a, tipopedd b
                 where a.tipopedd = b.tipopedd
                   and b.abrev = 'TIPEQU_LTE_TLF') equ_conax
         where se.codsolot = s.codsolot
           and s.codsolot = sp.codsolot
           and se.punto = sp.punto
           and sp.codinssrv = i.codinssrv
           and t.tipequ = se.tipequ
           and a.codmat = t.codtipequ
           and se.codsolot = an_codsolot
           and t.tipequ = equ_conax.tipequ
           and equ_conax.grupo = '3';
         
         ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
         ln_smcode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

            if ln_val_wimax_lte = 0 then
              OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           'INICIO',
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);
              --Cambio de ciclo de facturacion
              operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact(an_codsolot,
                                                                    p_cod,
                                                                    p_mensaje);
              OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

            end if;

            --si nuestra error en cambio de ciclo: error -99
            if p_cod = -99 and ln_val_wimax_lte = 0 then
              OPERACION.PQ_3PLAY_INALAMBRICO.sgasu_serv_x_cliente(an_codsolot,
                                   'JN',
                                   p_mensaje,
                                   'ERRO',
                                   ln_cod1,
                                   lv_resul);
            else
              --fin 15.0
              OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot,
                           'p_provision_janus',
                           'INICIO',
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

              OPERACION.PQ_3PLAY_INALAMBRICO.p_provision_janus(ln_cod_id,
                                ln_custumer_id,
                                ln_tmcode,
                                ln_smcode,
                                'A',
                                p_cod,
                                p_mensaje);

              OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot,
                           'p_provision_janus',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);

              if p_cod = 0 then
                OPERACION.PQ_3PLAY_INALAMBRICO.sgasu_serv_x_cliente(an_codsolot,
                                     'JN',
                                     null,
                                     'EPLA',
                                     ln_cod1,
                                     lv_resul);
              else
                OPERACION.PQ_3PLAY_INALAMBRICO.sgasu_serv_x_cliente(an_codsolot,
                                     'JN',
                                     p_mensaje,
                                     'ERRO',
                                     ln_cod1,
                                     lv_resul);
              end if;
            end if; --15.00      
      else
        p_mensaje := 'No se realizó Cambio de Ciclo, estado CO_ID incorrecto';
        OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(an_codsolot,
                           'operacion.pkg_cambio_ciclo_fact.sgasu_camb_ciclo_fact',
                           p_mensaje,
                           'Validación de Servicios Inalámbricos pre',
                           ln_cod1,
                           lv_resul);
      end if;
      -- fin inc000002095333
   
  EXCEPTION
    when error_general then
      an_error := -1;
      av_error := 'ERROR en el relanzamiento BSCS-LTE : ' ||sqlcode || ' ' || sqlerrm || ' (' ||dbms_utility.format_error_backtrace || ')';
      operacion.pq_3play_inalambrico.p_log_3playi(an_codsolot, --solot
                                                  'p_relanza_co_id_bscs_lte', --proceso
                                                  av_error, --mensaje
                                                  'Relanzamiento LTE', --tarea
                                                  ln_cod1,
                                                  lv_resul);
  END;

   procedure p_cont_reproceso(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2) is
   CURSOR CUR_TAREAS IS
     select SENTENCIA from OPERACION.OPE_CONFIG_ACCION_JANUS
     WHERE TIP_SVR = 'hfc_sisact'
     AND ESTADO = 'A';
   l_sql VARCHAR2(4000);

  BEGIN
      FOR CUR_TR IN CUR_TAREAS LOOP

          l_sql := CUR_TR.SENTENCIA;

          l_sql := l_sql || ' and p.co_id = ' || an_cod_id;

          EXECUTE IMMEDIATE l_sql;

      END LOOP;


    an_error := 0;
    av_error := 'ÿxito en el proceso';
    p_reg_log(null,
              null,
              NULL,
              null,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Reproceso JANUS');
  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Ocurrio un error al reprocesar JANUS';
      p_reg_log(null,
                null,
                NULL,
                null,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Reproceso JANUS');
  END p_cont_reproceso;


  procedure p_cont_reproceso_ce(an_cod_id number,
                             an_error  out integer,
                             av_error  out varchar2) is


   CURSOR CUR_TAREAS IS
     select SENTENCIA from OPERACION.OPE_CONFIG_ACCION_JANUS
     WHERE TIP_SVR = 'hfc_ce'
     AND ESTADO = 'A';
   l_sql VARCHAR2(4000);

  BEGIN
      FOR CUR_TR IN CUR_TAREAS LOOP

          l_sql := CUR_TR.SENTENCIA;

          l_sql := l_sql || ' and p.co_id = ' || an_cod_id;

          EXECUTE IMMEDIATE l_sql;



      END LOOP;

    an_error := 0;
    av_error := 'ÿxito en el proceso';

    p_reg_log(null,
              null,
              NULL,
              null,
              null,
              an_Error,
              av_error,
              an_cod_id,
              'Reproceso JANUS');

  EXCEPTION
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Ocurrio un error al reprocesar JANUS';
      p_reg_log(null,
                null,
                NULL,
                null,
                null,
                an_Error,
                av_error,
                an_cod_id,
                'Reproceso JANUS');
  END p_cont_reproceso_ce;

   procedure p_reproceso_janusxsot(an_codsolot number,
                                 an_error    out number,
                                 av_error    out varchar2) is
   ln_tiposerv number;
   ln_codid    number;

   cursor c_detalle is
     select e.codinssrv
       from solotpto a, insprd b, tystabsrv c, inssrv e, solot g
      where a.pid = b.pid
        and e.tipinssrv = 3
        and b.codsrv = c.codsrv
        and e.codinssrv = b.codinssrv
        and a.codsolot = g.codsolot
        and b.flgprinc = 1
        and g.codsolot = an_codsolot
        and e.cid is not null;
 begin

   ln_tiposerv := operacion.pq_sga_iw.f_val_tipo_serv_sot(an_codsolot);

   if ln_tiposerv = 1 or ln_tiposerv = 2 then

     for c_d in c_detalle loop
       p_cont_reproceso_ce(c_d.codinssrv, an_error, av_error);
     end loop;

   elsif ln_tiposerv = 3 or ln_tiposerv = 5 then

     select s.cod_id
       into ln_codid
       from solot s
      where s.codsolot = an_codsolot;

     p_cont_reproceso(ln_codid, an_error, av_error);

   end if;

   an_error := 1;
   av_error := 'ÿxito en el proceso';

 exception
   when others then
     an_error := -1;
     av_error := 'Error en el Reproceso de la Provision Janus : ' || sqlerrm ;
 end;

 function f_val_status_contrato_Bscs(an_co_id number) return varchar2 is

    lv_ch_status varchar2(1);
  begin

     select c.ch_status
     into lv_ch_status
     from contract_history@Dbl_Bscs_Bf c
     where c.co_id = an_co_id
           and c.ch_seqno = (select max(cc.ch_seqno) from contract_history@Dbl_Bscs_Bf cc
                            where cc.co_id = c.co_id);

     return lv_ch_status;
 end;

 --ini 9.0
  function f_val_prov_janus_pend_alta(an_cod_id number) return number is

  ln_janus_act number;

  begin
     select count(1)
       into ln_janus_act
       from dual
      where exists (select 1
                     from tim.rp_prov_bscs_janus@dbl_bscs_bf pj
                    where pj.co_id = an_cod_id
                      and pj.estado_prv <> 5)
         or exists (select 1
                     from tim.rp_prov_ctrl_janus@dbl_bscs_bf pj
                    where pj.estado_prv <> 5
                      and pj.co_id = an_cod_id);

     return ln_janus_act;
  end;
 --fin 9.0

 --ini 11.0
 procedure p_cons_existe_linea_janus(av_numero      in varchar2,
                                     an_error       out number,
                                     av_mensaje     out varchar2) is

 lv_numero varchar2(20);
 lv_imsi varchar2(50);
 ln_count number;

 begin

    lv_numero := '0051' || av_numero;

    SELECT COUNT(*)
      INTO ln_count
      FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS              C,
           JANUS_PROD_PE.CONNECTION_ACCOUNTS@DBL_JANUS      CA,
           JANUS_PROD_PE.PAYER_TARIFFS@DBL_JANUS            PT,
           JANUS_PROD_PE.TARIFF_MASTER@DBL_JANUS            TM,
           JANUS_PROD_PE.PAYERS@DBL_JANUS                   P,
           JANUS_PROD_PE.PAYERS@DBL_JANUS                   PC,
           JANUS_PROD_PE.PAYER_BILL_CYCLE_DETAILS@DBL_JANUS PB
     WHERE C.ACCOUNT_ID_N = CA.ACCOUNT_ID_N
       AND C.START_DATE_DT =   (SELECT MAX(START_DATE_DT)
                                  FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS
                                 WHERE CONNECTION_ID_V = C.CONNECTION_ID_V)
       AND CA.START_DATE_DT =  (SELECT MAX(START_DATE_DT)
                                  FROM JANUS_PROD_PE.CONNECTION_ACCOUNTS@DBL_JANUS
                                 WHERE ACCOUNT_ID_N = CA.ACCOUNT_ID_N)
       AND CA.PAYER_ID_0_N = P.PAYER_ID_N
       AND CA.PAYER_ID_0_N = PT.PAYER_ID_N
       AND P.PAYER_ID_N = PB.PAYER_ID_N
       AND PT.TARIFF_ID_N = TM.TARIFF_ID_N
       AND PT.START_DATE_DT =  (SELECT MAX(START_DATE_DT)
                                  FROM JANUS_PROD_PE.PAYER_TARIFFS@DBL_JANUS
                                 WHERE TARIFF_ID_N = PT.TARIFF_ID_N
                                   AND PAYER_ID_N = PT.PAYER_ID_N)
       AND PT.STATUS_N = 1
       AND CA.PAYER_ID_3_N = PC.PAYER_ID_N
       AND TM.TARIFF_TYPE_V = 'B' -- Solo plan base
       AND C.CONNECTION_ID_V = lv_numero;

    if ln_count = 0 then

      select TIM.TFUN009_OBTIENE_DATOS_MSISDN@DBL_BSCS_BF(av_numero,3)
        into lv_imsi
        from dual;

      SELECT count(*)
        INTO ln_count
        FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS         C,
             JANUS_PROD_PE.CONNECTION_ACCOUNTS@DBL_JANUS CA,
             JANUS_PROD_PE.PAYERS@DBL_JANUS              P
       WHERE C.ACCOUNT_ID_N = CA.ACCOUNT_ID_N
         AND C.START_DATE_DT =
             (SELECT MAX(S.START_DATE_DT)
                FROM JANUS_PROD_PE.CONNECTIONS@DBL_JANUS S
               WHERE S.CONNECTION_ID_V = C.CONNECTION_ID_V)
         AND CA.PAYER_ID_0_N = P.PAYER_ID_N
         AND P.EXTERNAL_PAYER_ID_V = lv_imsi;

       if ln_count = 0 then
         an_error := 0;
         av_mensaje := 'La linea no existe en JANUS' ;
       else
         an_error := 1;
         av_mensaje := 'La linea existe en JANUS' ;
       end if;
    else
       an_error := 1;
       av_mensaje := 'La linea existe en JANUS' ;
    end if;

 exception
   when others then
     an_error := -1;
     av_mensaje := 'Error en el Reproceso de la Provision Janus : ' || sqlerrm ;
 end;
 --fin 11.0

 --ini 12.0
 procedure p_cambio_plan_janus_hfc(an_codsolot operacion.solot.codsolot%type,
                                   an_error    out number,
                                   av_error    out varchar2) is

   ln_cod_id           solot.cod_id%type;
   ln_cod_id_old       solot.cod_id_old%type;
   ln_customer_id      solot.customer_id%type;
   lv_codcli           solot.codcli%type;
   ln_max_codsolot_old solot.codsolot%type;
   ln_idinterface      operacion.log_trs_interface_iw.idinterface%type := 820;
   ln_error            number;
   lv_error            varchar2(4000);
   ln_flg_tlf_new      number;
   ln_flg_tlf_old      number;
   error_general exception;
   lv_valores    varchar2(4000);
   ln_sncode_old number;
   ln_sncode_new number;
   ln_valor      number;
   ln_existe_csc number;
   lv_numero     inssrv.numero%type;
   --LFLORES
   lv_tipo_producto   varchar2(20);
   ln_tmcode          NUMBER;
   ln_sncode          NUMBER;
   lv_tarfif_prov_old varchar2(200);
   lv_tarfif_prov_new varchar2(200);
   --LFLORES
 begin

   ln_valor := f_get_constante_conf('CCPJANUSSIACU');

   if ln_valor = 0 then
     return;
   end if;

   select s.cod_id,
          s.cod_id_old,
          s.customer_id,
          operacion.pq_sga_iw.f_max_sot_x_cod_id(s.cod_id_old),
          f_val_serv_tlf_sot(s.codsolot),
          (select distinct ins.numero
             from solotpto pto, inssrv ins
            where pto.codinssrv = ins.codinssrv
              and ins.tipinssrv = 3
              and pto.codsolot = s.codsolot),
          decode(operacion.pq_sga_iw.f_val_tipo_serv_sot(s.codsolot),
                 1,
                 'HFCCE',
                 2,
                 'HFCSGA',
                 3,
                 'HFC',
                 4,
                 'WIMAX',
                 5,
                 'LTE',
                 'OTROS') -- LFLORES
     into ln_cod_id,
          ln_cod_id_old,
          ln_customer_id,
          ln_max_codsolot_old,
          ln_flg_tlf_new,
          lv_numero,
          lv_tipo_producto -- LFLORES
     from solot s
    where s.codsolot = an_codsolot;

   if lv_numero is null then
     av_error := 'El numero telefonico asociado a la SOT : ' || an_codsolot ||
                 ' esta en NULO';
     raise error_general;
   end if;

   IF lv_tipo_producto = 'HFC' then
     -- LFLORES

   ln_existe_csc := operacion.pq_sga_bscs.f_val_existe_contract_sercad(ln_cod_id);

   if ln_existe_csc = 0 then
     begin
       operacion.pq_sga_bscs.p_reg_contr_services_cap(ln_cod_id,
                                                      lv_numero,
                                                      AN_ERROR,
                                                      AV_ERROR);
       commit;
     exception
       when others then
         av_error := 'Error al Registrar en la contr_services_cap : ' ||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';
         raise error_general;
     end;
   end if;

   if operacion.pq_sga_bscs.f_val_existe_contract_sercad(ln_cod_id) = 0 then
     av_error := 'La contrato (CO_ID) ' || ln_cod_id ||
                 ' no tiene asociado la linea telefonica en BSCS';
     raise error_general;
   end if;

   end if; -- LFLORES

   ln_flg_tlf_old := f_val_serv_tlf_sot(ln_max_codsolot_old);

   if ln_flg_tlf_new = ln_flg_tlf_old and ln_flg_tlf_new != 0 then

     begin
       IF lv_tipo_producto = 'HFC' then
       select ps.sncode
         into ln_sncode_new
         from profile_service@dbl_bscs_bf       ps,
              contract_all@dbl_bscs_bf          ca,
              tim.pf_hfc_parametros@dbl_bscs_bf plj
        where ps.co_id = ca.co_id
          and ca.sccode = 6
          and ps.sncode = plj.cod_prod1
          and plj.campo = 'SERV_TELEFONIA'
          and ca.co_id = ln_cod_id;
       elsif lv_tipo_producto = 'LTE' then
         select ps.sncode, plj.param1 || '|' || plj.param2
           into ln_sncode_new, lv_tarfif_prov_new
           from profile_service@dbl_bscs_bf       ps,
                contract_all@dbl_bscs_bf          ca,
                tim.pf_hfc_parametros@dbl_bscs_bf plj
          where ps.co_id = ca.co_id
            and ca.tmcode in (SELECT x.valor1
                                FROM tim.tim_parametros@dbl_bscs_bf x
                               WHERE x.campo = 'PLAN_LTE')
            and ps.sncode = plj.cod_prod1
            and plj.campo = 'SERV_TELEFONIA_LTE'
            and ca.co_id = ln_cod_id;
       end if;
     exception
       when others then
         an_error := -1;
         av_error := 'ERRROR: Error al obtener el SNCODE de TLF de BSCS para el CO_ID ' ||
                     ln_cod_id || SQLERRM || ' Linea (' ||
                     dbms_utility.format_error_backtrace || ')';
         raise error_general;
     end;

     begin
       IF lv_tipo_producto = 'HFC' then
 /*     TERAN
  select ps.sncode
         into ln_sncode_old
         from profile_service@dbl_bscs_bf       ps,
              contract_all@dbl_bscs_bf          ca,
                tim.pf_hfc_parametros@dbl_bscs_bf plj
        where ps.co_id = ca.co_id
          and ca.sccode = 6
          and ps.sncode = plj.cod_prod1
          and plj.campo = 'SERV_TELEFONIA'
          and ca.co_id = ln_cod_id_old;
*/

        select ps.sncode
          into ln_sncode_old
        from profile_service@dbl_bscs_bf       ps,
             contract_all@dbl_bscs_bf          ca,
             tim.pf_hfc_parametros@dbl_bscs_bf plj,
             pr_serv_status_hist@dbl_bscs_bf   sh
        where ps.co_id = ca.co_id
         and ca.sccode = 6
         and sh.co_id = ps.co_id
         and sh.profile_id = ps.profile_id
         and ps.sncode = sh.sncode
         and ps.status_histno = sh.histno
         and sh.status IN ('A', 'S')
         and ps.sncode = plj.cod_prod1
         and plj.campo = 'SERV_TELEFONIA'
         and ca.co_id = ln_cod_id_old;

       elsif lv_tipo_producto = 'LTE' then

         select ps.sncode, plj.param1 || '|' || plj.param2
           into ln_sncode_new, lv_tarfif_prov_old
           from profile_service@dbl_bscs_bf       ps,
                contract_all@dbl_bscs_bf          ca,
                tim.pf_hfc_parametros@dbl_bscs_bf plj
          where ps.co_id = ca.co_id
            and ca.tmcode in (SELECT x.valor1
                                FROM tim.tim_parametros@dbl_bscs_bf x
                               WHERE x.campo = 'PLAN_LTE')
            and ps.sncode = plj.cod_prod1
            and plj.campo = 'SERV_TELEFONIA_LTE'
            and ca.co_id = ln_cod_id_old;
       end if;
     exception
       when others then
         av_error := 'ERRROR: Error al obtener el SNCODE de TLF de BSCS para el CO_ID ' ||
                     ln_cod_id_old || SQLERRM || ' Linea (' ||
                     dbms_utility.format_error_backtrace || ')';
         raise error_general;
     end;

     if lv_tipo_producto = 'LTE' then
       lv_valores := lv_tarfif_prov_new || '|' || lv_tarfif_prov_old;
     else
       lv_valores := null;
     end if;

     /* Realizamos la provsion a JANUS*/
     tim.pp004_siac_lte.siacsi_prov_janus_cp@dbl_bscs_bf(ln_cod_id,
                                                         ln_customer_id,
                                                         lv_tipo_producto,
                                                         ln_sncode_new,
                                                         ln_sncode_old,
                                                         lv_valores,
                                                         ln_error,
                                                         lv_error);

     IF ln_error <> 0 THEN
       an_error := ln_error;
       av_error := lv_error;
       raise error_general;
     END IF;

   elsif ln_flg_tlf_new != 0 and ln_flg_tlf_old = 0 and
         lv_tipo_producto = 'HFC' then
     p_insertxacc_prov_sga_janus(1,
                                 an_codsolot,
                                 ln_cod_id,
                                 ln_customer_id,
                                 to_char(ln_customer_id),
                                 null,
                                 an_error,
                                 av_error);
     if an_error != 1 then
       raise error_general;
     end if;

   elsif ln_flg_tlf_new != 0 and ln_flg_tlf_old = 0 and
         lv_tipo_producto = 'LTE' then

     ln_tmcode := tim.pp021_venta_lte.f_get_plan@dbl_bscs_bf(ln_cod_id);
     ln_sncode := tim.pp021_venta_lte.f_get_serv_tel@dbl_bscs_bf(ln_cod_id);

     operacion.pq_3play_inalambrico.p_provision_janus(ln_cod_id,
                                                      ln_customer_id,
                                                      ln_tmcode,
                                                      ln_sncode,
                                                      'A',
                                                      ln_error,
                                                      lv_error);
     IF ln_error <> 0 THEN
       an_error := ln_error;
       av_error := lv_error;
       raise error_general;
     END IF;

   end if;

   an_error := 1;
   av_error := 'Exito al enviar la provision de Cambio de Plan JANUS';

   p_reg_log(lv_codcli,
             ln_customer_id,
             NULL,
             an_codsolot,
             ln_idinterface,
             an_Error,
             av_error,
             ln_cod_id,
             'Cambio de Plan JANUS');

 exception
   when error_general then
     an_error := -1;
     p_reg_log(lv_codcli,
               ln_customer_id,
               NULL,
               an_codsolot,
               ln_idinterface,
               an_Error,
               av_error,
               ln_cod_id,
               'Cambio de Plan JANUS');
   when others then
     an_error := -99;
     av_error := 'ERROR : P_CAMBIO_PLAN_JANUS_HFC ' || sqlerrm ||
                 ' Linea (' || dbms_utility.format_error_backtrace || ')';
     p_reg_log(lv_codcli,
               ln_customer_id,
               NULL,
               an_codsolot,
               ln_idinterface,
               an_Error,
               av_error,
               ln_cod_id,
               'Cambio de Plan JANUS');
 end;

  procedure p_eje_tarea_cambio_plan(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) is
    ln_codsolot solot.codsolot%type;
    error_general exception;
    ln_cod_id      solot.cod_id%type;
    ln_customer_id solot.customer_id%type;
    lv_codcli      solot.codcli%type;
    ln_idinterface operacion.log_trs_interface_iw.idinterface%type := 820;
    ln_error       number;
    lv_error       varchar2(4000);

  BEGIN

    select a.codsolot, b.codcli, b.customer_id, b.cod_id
      into ln_codsolot, lv_codcli, ln_customer_id, ln_cod_id
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot;

    operacion.pq_sga_janus.p_valida_linea_bscs_sga(ln_codsolot,
                                                   'INIFAC',
                                                   ln_error,
                                                   lv_error);

    if ln_error = 0 then
       operacion.pq_sga_janus.p_valida_linea_bscs_sga(ln_codsolot,
                                                     'REGU',
                                                     ln_error,
                                                     lv_error);
    elsif ln_error = 1 then
      -- Cerrar la Tarea en No Interviene
      OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a_idtareawf,
                                       4,
                                       cn_estnointerviene,
                                       0,
                                       SYSDATE,
                                       SYSDATE);

      INSERT INTO tareawfseg
              (idtareawf, observacion)
            VALUES
              (a_idtareawf,
               'SOT : ' || to_char(ln_codsolot) ||
               ' - COD_ID : ' ||to_char(ln_cod_id) ||
               ' - Janus : '|| lv_error);
    end if;
    --operacion.pq_sga_janus.p_cambio_plan_janus_hfc(ln_codsolot,ln_error,lv_error);
    if ln_error < 0 then
      raise error_general;
    end if;

  exception
    when error_general then
      lv_error := 'ERROR : P_EJE_TAREA_CAMBIO_PLAN - ' || lv_error ||
                 ' Linea (' || dbms_utility.format_error_backtrace || ')';
      p_reg_log(lv_codcli,
                ln_customer_id,
                NULL,
                ln_codsolot,
                ln_idinterface,
                ln_error,
                lv_error,
                ln_cod_id,
                'TAREA-Cambio de Plan JANUS-HFC');

      raise_application_error(-20001, lv_error);

    when others then
      lv_error := 'ERROR : P_EJE_TAREA_CAMBIO_PLAN - ' || SQLERRM ||
                 ' Linea (' || dbms_utility.format_error_backtrace || ')';
      ln_error := sqlcode;
      p_reg_log(lv_codcli,
                ln_customer_id,
                NULL,
                ln_codsolot,
                ln_idinterface,
                ln_error,
                lv_error,
                ln_cod_id,
                'TAREA-Cambio de Plan JANUS-HFC');
      raise_application_error(-20001, lv_error);
  End;
  --fin 12.0

  procedure sp_prov_adic_janus(p_co_id       in integer,
                               p_customer_id in integer,
                               p_tmcode      in integer,
                               p_sncode      in integer,
                               p_accion      in varchar2,
                               p_resultado   out integer,
                               p_msgerr      out varchar2,
                               p_ordid       out number) is

    V_REG      INTEGER;
    ln_ordid   number;

    CURSOR CUR_LINEAS IS
      SELECT CSC.CO_ID,
             DN.DN_NUM,
             'IMSI' || DN.DN_NUM IMSI,
             DN.DN_NUM NRO_CORTO
        FROM CONTR_SERVICES_CAP@DBL_BSCS_BF CSC,
             DIRECTORY_NUMBER@DBL_BSCS_BF   DN
       WHERE CSC.CO_ID = P_CO_ID
         AND CSC.DN_ID = DN.DN_ID
         AND CSC.CS_DEACTIV_DATE IS NULL;

    CURSOR CUR_PROD_COMP(PC_CO_ID INTEGER) IS
      SELECT PS.CO_ID,
             P.COD_PROD1 ACTION_ID,
             PS.SNCODE,
             SPH.SPCODE,
             P.COD_PROD3 TARIFF_ID
        FROM PROFILE_SERVICE@DBL_BSCS_BF       PS,
             PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
             PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH,
             TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P
       WHERE PS.CO_ID = PC_CO_ID
         AND PS.CO_ID = SSH.CO_ID
         AND PS.SNCODE = SSH.SNCODE
         AND PS.SNCODE = P_SNCODE
         AND PS.STATUS_HISTNO = SSH.HISTNO
         AND SSH.STATUS IN ('O', 'A')
         AND P.CAMPO = 'SERV_ADICIONAL'
         AND P.COD_PROD2 = PS.SNCODE
         AND PS.CO_ID = SPH.CO_ID
         AND PS.SNCODE = SPH.SNCODE
         AND PS.SPCODE_HISTNO = SPH.HISTNO;

  BEGIN

    P_RESULTADO := 0;
    P_MSGERR    := 'PROCESO SATISFACTORIO';

    -- VALIDAMOS DATOS INGRESADOS
    IF P_CO_ID IS NULL OR P_CUSTOMER_ID IS NULL OR P_TMCODE IS NULL OR
       P_SNCODE IS NULL OR P_ACCION IS NULL THEN
      P_RESULTADO := -1;
      P_MSGERR    := 'DATOS INVALIDOS';
      RETURN;
    END IF;

    ln_ordid := null;

    --VALIDAMOS QUE SERVICIO ESTE ASOCIADO A PLAN
    SELECT COUNT(1)
      INTO V_REG
      FROM MPULKTMB@DBL_BSCS_BF TMB
     WHERE TMB.TMCODE = P_TMCODE
       AND TMB.SNCODE = P_SNCODE
       AND TMB.VSCODE = (SELECT MAX(V.VSCODE)
                           FROM RATEPLAN_VERSION@DBL_BSCS_BF V
                          WHERE V.TMCODE = TMB.TMCODE
                            AND V.VSDATE <= SYSDATE
                            AND V.STATUS = 'P');

    IF V_REG = 0 THEN
      P_RESULTADO := -2;
      P_MSGERR    := 'PRODUCTOS TELEFONIA NO ASOCIADO A PLAN TARIFARIO';
      RETURN;
    END IF;

    -- REGISTRAMOS DATOS PARA PROVISION.
    IF P_ACCION = 'A' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            select tim.rp_janus_ord_id.nextval@dbl_bscs_bf
              into ln_ordid
              from dual;

            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ORD_ID,
               ACTION_ID,
               PRIORITY,
               CUSTOMER_ID,
               CO_ID,
               SNCODE,
               SPCODE,
               STATUS,
               FECHA_INSERT,
               ESTADO_PRV,
               VALORES)
            VALUES
              (ln_ordid,
               501,
               5,
               P_CUSTOMER_ID,
               CC.CO_ID,
               CC.SNCODE,
               CC.SPCODE,
               'A',
               SYSDATE,
               '0',
               TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);

            P_ordid := ln_ordid;
          END IF;
        END LOOP;
      END LOOP;

    ELSIF P_ACCION = 'D' THEN
      FOR TL IN CUR_LINEAS LOOP
        FOR CC IN CUR_PROD_COMP(TL.CO_ID) LOOP
          IF CC.ACTION_ID = 501 THEN
            -- PROVISION DEL SERVICIO ADICIONAL
            select tim.rp_janus_ord_id.nextval@dbl_bscs_bf
              into ln_ordid
              from dual;
            INSERT INTO TIM.RP_PROV_BSCS_JANUS@DBL_BSCS_BF
              (ORD_ID,
               ACTION_ID,
               PRIORITY,
               CUSTOMER_ID,
               CO_ID,
               SNCODE,
               SPCODE,
               STATUS,
               FECHA_INSERT,
               ESTADO_PRV,
               VALORES)
            VALUES
              (ln_ordid,
               501,
               5,
               P_CUSTOMER_ID,
               CC.CO_ID,
               CC.SNCODE,
               CC.SPCODE,
               'D',
               SYSDATE,
               '0',
               TL.DN_NUM || '|' || CC.TARIFF_ID || '|' || 100);

            P_ordid := ln_ordid;
          END IF;
        END LOOP;
      END LOOP;
    ELSE
      P_RESULTADO := -3;
      P_MSGERR    := 'TIPO DE ACCION NO SOPORTADA';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_RESULTADO := -99;
      P_MSGERR    := 'ERROR ' || TO_CHAR(SQLCODE) || ' : ' || SQLERRM;
  END SP_PROV_ADIC_JANUS;

  PROCEDURE SGASI_BAJA_JANUS_TLFCLI(AV_NUMERO   IN INSSRV.NUMERO%TYPE,
                                    AN_CUSTOMER IN SOLOT.CUSTOMER_ID%TYPE,
                                    AN_COD_ID   IN SOLOT.COD_ID%TYPE,
                                    AN_ERROR    OUT NUMBER,
                                    AV_ERROR    OUT VARCHAR2) IS
    lv_trama varchar2(1000);
    error_general exception;
    ln_ordid     number;
    ln_ordid_ant number;
    lv_resul     varchar2(4000);
    ln_cod_id    solot.cod_id%type;
  BEGIN
    an_error := 1;
    av_error := 'Exito';
    ln_cod_id := an_cod_id;

    lv_trama := f_get_external_janus_numero(av_numero);

    if lv_trama = '00' then
      av_error := 'Error Janus : ' || av_error;
      raise error_general; --ASL
    end if;

    if lv_trama != '00' then
      p_insert_prov_bscs_janus(2,
                               5,
                               an_customer,
                               ln_cod_id,
                               '2',
                               1,
                               lv_trama,
                               ln_ordid_ant,
                               an_error,
                               av_error);

      if an_error = -1 then
        av_error := 'Error Janus : ' || av_error;
        raise error_general;
      end if; --ASL

      lv_trama := to_char(an_customer);

      p_insert_prov_bscs_janus(2,
                               5,
                               an_customer,
                               ln_cod_id,
                               '2',
                               1,
                               lv_trama,
                               ln_ordid,
                               an_error,
                               av_error);

      if an_error = -1 then
        av_error := 'Error Janus : ' || av_error;
        raise error_general;
      end if; --ASL

      update tim.rp_prov_bscs_janus@dbl_bscs_bf p
         set p.ord_id_ant = ln_ordid_ant
       where p.ord_id = ln_ordid;
    end if;

    OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(ln_cod_id,
                                                'SGASI_BAJA_JANUS_TLFCLI',
                                                av_error,
                                                'Baja Janus',
                                                ln_cod_id,
                                                lv_resul);
  exception
    when error_general then
      an_error := -1;
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(ln_cod_id,
                                                'SGASI_BAJA_JANUS_TLFCLI',
                                                av_error,
                                                'Baja Janus',
                                                ln_cod_id,
                                                lv_resul);
    when others then
      an_error := -1;
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(ln_cod_id,
                                                'SGASI_BAJA_JANUS_TLFCLI',
                                                av_error,
                                                'Baja Janus',
                                                ln_cod_id,
                                                lv_resul);
  END;

/****************************************************************
  '* Nombre SP : SGASI_BAJALTA_JANUS_CE
  '* Propósito : Proceso de baja, alta y/o cambio de plan Ce en Janus
  '*             para cambio de plan anterior.
  '* Input :     <a_idtareawf>     - Id tarea wf
  '* Input :     <a_idwf>          - Id wf
  '* Input :     <a_tarea>         - Tarea
  '* Input :     <a_tareadef>      - Tarea def
  '* Creado por : Abel Ojeda
  '* Fec Creación : 06/02/2018
  '****************************************************************/
  PROCEDURE sgasi_bajalta_janus_ce(a_idtareawf IN NUMBER,
                                   a_idwf      IN NUMBER,
                                   a_tarea     IN NUMBER,
                                   a_tareadef  IN NUMBER) IS

    v_idplan          sales.tystabsrv.idplan%TYPE;
    v_idproducto      sales.tystabsrv.idproducto%TYPE;
    v_codsolot        operacion.solot.codsolot%TYPE;
    v_numslc          operacion.solot.numslc%TYPE;
    v_idplan_old      sales.tystabsrv.idplan%TYPE;
    v_idproducto_old  sales.tystabsrv.idproducto%TYPE;
    v_codsolot_old    operacion.solot.codsolot%TYPE;
    v_numslc_old      operacion.solot.numslc%TYPE;
    v_plan            telefonia.plan_redint.plan%TYPE;
    v_plan_old        telefonia.plan_redint.plan%TYPE;
    v_msj             varchar2(4000);
    v_cod             number;
    v_cod_log         number;
    v_msj_log         varchar2(4000);
    ex_error          exception;

  BEGIN

   v_msj := '';
   v_cod := 0;
   v_plan := 0;
   v_plan_old := 0;

   select codsolot
   into v_codsolot
   from opewf.wf
   where idwf = a_idwf
   and valido = 1;

   Begin
     select numslc
     into v_numslc
     from operacion.solot
     where codsolot = v_codsolot
     and estsol = 17;
   Exception
    When no_data_found Then
      v_msj := 'No existe numero de proyecto con la sot buscada';
      v_cod := -1;
      raise ex_error;
    When too_many_rows Then
      v_msj := 'Se encontraron muchas filas';
      v_cod := -2;
      raise ex_error;
    When Others Then
     v_msj := SQLERRM || ' - Linea ('||dbms_utility.format_error_backtrace ||')';
     v_cod := -99;
     raise ex_error;
   End;

   Begin
     select distinct t.idplan, t.idproducto
     into v_idplan, v_idproducto
     from sales.tystabsrv t
     inner join inssrv i on t.codsrv = i.codsrv
     inner join solotpto pto on i.codinssrv = pto.codinssrv
     where pto.codsolot = v_codsolot and t.tipsrv = cv_telefonia
     and t.idplan is not null;
   Exception
    When too_many_rows Then
     select distinct x.idplan, x.idproducto
     into v_idplan, v_idproducto
     from (
       select distinct t.idplan, t.idproducto
       from sales.tystabsrv t
       inner join inssrv i on t.codsrv = i.codsrv
       inner join solotpto pto on i.codinssrv = pto.codinssrv
       where pto.codsolot = v_codsolot and t.tipsrv = cv_telefonia
       and t.idplan is not null
       order by t.idplan desc ) x
     where rownum = 1;
    When Others Then
      v_idplan := 0;
   End;

   Begin
      select prorv_numslc_ori
      into v_numslc_old
      from operacion.sgat_postv_proyecto_origen
      where prorv_numslc_new = v_numslc;
   Exception
    When no_data_found Then
      v_msj := 'No existe numero de proyecto origen registrado';
      v_cod := -1;
      raise ex_error;
    When too_many_rows Then
      select x.prorv_numslc_ori
      into v_numslc_old
      from (select prorv_numslc_ori
            from operacion.sgat_postv_proyecto_origen
            where prorv_numslc_new = v_numslc
            order by to_number(prorv_numslc_new) desc) x
      where rownum = 1;
    When Others Then
      v_msj := SQLERRM || ' - Linea ('||dbms_utility.format_error_backtrace ||')';
      v_cod := -99;
      raise ex_error;
   End;

   select codsolot
   into v_codsolot_old
   from operacion.solot
   where numslc = v_numslc_old
   and estsol in (12,29);

   Begin
     select distinct t.idplan, t.idproducto
     into v_idplan_old, v_idproducto_old
     from sales.tystabsrv t
     inner join inssrv i on t.codsrv = i.codsrv
     inner join solotpto pto on i.codinssrv = pto.codinssrv
     where pto.codsolot = v_codsolot_old and t.tipsrv = cv_telefonia
     and t.idplan is not null;
   Exception
    When too_many_rows Then
     select distinct x.idplan, x.idproducto
     into v_idplan_old, v_idproducto_old
     from (
       select distinct t.idplan, t.idproducto
       from sales.tystabsrv t
       inner join inssrv i on t.codsrv = i.codsrv
       inner join solotpto pto on i.codinssrv = pto.codinssrv
       where pto.codsolot = v_codsolot_old and t.tipsrv = cv_telefonia
       and t.idplan is not null
       order by t.idplan desc ) x
     where rownum = 1;
    When Others Then
      v_idplan_old := 0;
   End;

   --Tenía Telefonía y ahora no (Baja Janus)
   If v_idplan = 0 and v_idplan_old > 0 Then
     OPERACION.PQ_SGA_JANUS.p_bajalinea_janus_ce(v_codsolot_old,null,v_cod,v_msj);
     if v_cod < 0 then
      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot_old, 'sgasi_bajalta_janus_ce',
                                                  v_msj || ' - Codigo : ' || v_cod,
                                                  'OPERACION.PQ_SGA_JANUS.p_bajalinea_janus_ce',
                                                  v_cod_log, v_msj_log);
     end if;

   End If;

   --No tenía Telefonía y ahora si (Alta Janus)
   If v_idplan > 0 and v_idplan_old = 0 Then
     OPERACION.PQ_SGA_JANUS.p_altanumero_janus_sga_ce(v_codsolot,null,v_cod,v_msj);
     if v_cod < 0 then
      operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot, 'sgasi_bajalta_janus_ce',
                                                  v_msj || ' - Codigo : ' || v_cod,
                                                  'OPERACION.PQ_SGA_JANUS.p_altanumero_janus_sga_ce',
                                                  v_cod_log, v_msj_log);
     end if;

   End If;

   --Si existe datos de telefonía nuevo entonces encontrar el nuevo plan
   If v_idplan > 0 Then
     Begin
       select p.plan
       into v_plan
       from telefonia.plan_redint p, telefonia.planxproducto pp
       where p.idplan = pp.idplan
       and p.idplan = v_idplan
       and p.idplataforma = 6
       and pp.idproducto = v_idproducto;
     Exception
       When Others Then
        v_plan := 0;
     End;
   End If;

   --Si existe datos de telefonía anterior entonces encontrar el plan anterior
   If v_idplan_old > 0 Then
      Begin
       select p.plan
       into v_plan_old
       from telefonia.plan_redint p, telefonia.planxproducto pp
       where p.idplan = pp.idplan
       and p.idplan = v_idplan_old
       and p.idplataforma = 6
       and pp.idproducto = v_idproducto_old;
      Exception
       When Others Then
        v_plan_old := 0;
      End;
   End If;

   if v_plan > 0 and v_plan_old > 0 then
      --Baja Janus
       OPERACION.PQ_SGA_JANUS.p_bajalinea_janus_ce(v_codsolot_old,null,v_cod,v_msj);
       if v_cod < 0 then
         operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot_old, 'sgasi_bajalta_janus_ce',
                                                     v_msj || ' - Codigo : ' || v_cod,
                                                     'OPERACION.PQ_SGA_JANUS.p_bajalinea_janus_ce',
                                                     v_cod_log, v_msj_log);
       end if;
       --Alta Janus
       OPERACION.PQ_SGA_JANUS.p_altanumero_janus_sga_ce(v_codsolot,null,v_cod,v_msj);
       if v_cod < 0 then
         operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot, 'sgasi_bajalta_janus_ce',
                                                     v_msj || ' - Codigo : ' || v_cod,
                                                     'OPERACION.PQ_SGA_JANUS.p_altanumero_janus_sga_ce',
                                                     v_cod_log, v_msj_log);
       end if;
   end if;

  EXCEPTION
   WHEN ex_error THEN
    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot, 'sgasi_bajalta_janus_ce',
                                                v_msj || ' - Codigo : ' || v_cod,
                                                'OPERACION.PKG_ACTIVACION_SERVICIOS.sgasi_bajalta_janus_ce',
                                                v_cod_log, v_msj_log);
   WHEN OTHERS THEN
    operacion.pq_3play_inalambrico.p_log_3playi(v_codsolot, 'sgasi_bajalta_janus_ce',
                                                SQLERRM || ' - Linea ('||dbms_utility.format_error_backtrace ||')',
                                                'OPERACION.PKG_ACTIVACION_SERVICIOS.sgasi_bajalta_janus_ce',
                                                v_cod_log, v_msj_log);
  END sgasi_bajalta_janus_ce;

END PQ_SGA_JANUS;
/
