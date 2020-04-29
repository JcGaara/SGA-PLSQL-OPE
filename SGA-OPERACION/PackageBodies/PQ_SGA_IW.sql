CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_IW IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_SGA_IW
    PROPOSITO:    Paquete de objetos necesarios para la Conexion del SGA - BSCS
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       09/08/2013  Edilberto Astulle
     2.0       06/10/2015  Marco de la Cruz                  SD-433116 - Mejorar el Flujo de Provisi?n HFC (SGA-IW)
     3.0       29/10/2015  Juan Gonzales    Joel Franco       SD-507517 - Anulaci?n de SOT y asignaci?n de n?mero telef?nico
     4.0       24/11/2015                                    SD-438726
     5.0     14/12/2015  Luis Flores               SGA-SD-560640
     6.0      8/1/2016    Carlos Ter?n              SD-606329 Corregir ciclo de facturacion despues de un cambio de plan y reg SOA
     7.0      8/2/2016    Carlos Ter?n              SD-596715 Se activa la facturaci?n en SGA (Alineaci?n)
     8.0      15/02/2016  Alfonso Mu?ante           SGA-SD-534868-1
     9.0      28/04/2016                                      SD-642508-1 Cambio de Plan Fase II
     10.0     20/07/2016  Dorian Sucasaca           SD_795618
     11.0     10/01/2017  Servicio Fallas-HITSS     INC000000648208
     12.0     19/01/2017  Servicio Fallas-HITSS              Migraci?n WIMAX a LTE
     13.0     26/01/2017  Servicio Fallas-HITSS      INC000000638618
     14.0     28/02/2017  Servicio Fallas-HITSS      INC000000697906
     15.0     20/11/2018  Steve Panduro      Tito Huerta        FTTH
  *******************************************************************************************************/
  -- ini 3.0
  procedure p_genera_sot_baja_oac is

    cursor c_s is
       select distinct t.co_id, t.customer_id,
       (select nvl(max(s.codsolot), 0)   from solot s, solotpto pto, inssrv ins
       where s.codsolot = pto.codsolot
       and pto.codinssrv = ins.codinssrv
       and ins.estinssrv in (1, 2, 3)
       and s.estsol in (12, 29)
       and s.tiptra in (select o.codigon
                          from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev = 'TIPREGCONTIWSGABSCS')
       and s.cod_id = t.co_id) sot_maxima
       from tim.pf_hfc_prov_bscs@dbl_bscs_bf t, contract_history@dbl_bscs_bf ch
       where t.co_id = ch.co_id
       and t.action_id = 9 and t.estado_prv=5 and t.fecha_rpt_eai is null
       and ch.ch_seqno = (select max(c.ch_seqno) from contract_history@dbl_bscs_bf c where c.co_id = ch.co_id)
       and ch.userlastmod in (select o.codigoc
                              from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                              and t.abrev = 'USERCOB');

  ln_coderror number;
  lv_msgerror varchar2(4000);
  ln_estadoprv number;
  ln_valbaja number;
  v_tiene_cp number;
  v_est_servicio number;

  begin

    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';

    for c in c_s loop

      v_tiene_cp := f_val_cambioplan_cod_id_old(c.co_id,c.customer_id);

      select nvl(max(ins.estinssrv), 0) into v_est_servicio from solot s, solotpto pto, inssrv ins
      where s.codsolot = pto.codsolot and pto.codinssrv = ins.codinssrv and ins.estinssrv in (1, 2,3)
      and s.estsol in (12, 29) and s.codsolot = c.sot_maxima;

      if v_est_servicio = 3 and v_tiene_cp =0 then

        update inssrv ins set ins.estinssrv = 1, ins.fecfin = null
        where ins.codinssrv in (select codinssrv from solotpto where codsolot =c.sot_maxima);

        update insprd ins set ins.estinsprd = 1, ins.fecfin = null
        where ins.codinssrv in (select codinssrv from solotpto where codsolot =c.sot_maxima);

        update tim.pf_hfc_prov_bscs@dbl_bscs_bf t set t.estado_prv = ln_estadoprv where t.co_id = c.co_id;
        operacion.pq_sga_iw.p_genera_sot_oac(c.co_id, 4, 56, ln_coderror, lv_msgerror);

      elsif v_est_servicio <> 0 then

        update tim.pf_hfc_prov_bscs@dbl_bscs_bf t set t.estado_prv = ln_estadoprv where t.co_id = c.co_id;
        operacion.pq_sga_iw.p_genera_sot_oac(c.co_id, 4, 56, ln_coderror, lv_msgerror);

      end if;
    end loop;

  end;

  procedure p_genera_sot_reconexion_oac is

    cursor c_s is
       select distinct t.co_id, t.customer_id
       from tim.pf_hfc_prov_bscs@dbl_bscs_bf t, contract_history@dbl_bscs_bf ch
       where t.co_id = ch.co_id
       and t.action_id = 3 and t.estado_prv=5 and t.fecha_rpt_eai is null
       and ch.ch_seqno = (select max(c.ch_seqno) from contract_history@dbl_bscs_bf c where c.co_id = ch.co_id)
       and ch.userlastmod in (select o.codigoc
                              from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                              and t.abrev = 'USERCOB');

  ln_coderror number;
  lv_msgerror varchar2(4000);
  ln_estadoprv number;

  begin
    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';

    for c in c_s loop

      update tim.pf_hfc_prov_bscs@dbl_bscs_bf t set t.estado_prv = ln_estadoprv
      where t.co_id = c.co_id;

      p_genera_sot_oac(c.co_id, 6, 56, ln_coderror, lv_msgerror);

    end loop;

  end;

  procedure p_genera_sot_suspension_oac is

    cursor c_s is
       select distinct t.co_id, t.customer_id
       from tim.pf_hfc_prov_bscs@dbl_bscs_bf t, contract_history@dbl_bscs_bf ch
       where t.co_id = ch.co_id
       and t.action_id = 5 and t.estado_prv=5 and t.fecha_rpt_eai is null
       and ch.ch_seqno = (select max(c.ch_seqno) from contract_history@dbl_bscs_bf c where c.co_id = ch.co_id)
       and ch.userlastmod in (select o.codigoc
                              from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                              and t.abrev = 'USERCOB');

  ln_coderror number;
  lv_msgerror varchar2(4000);
  ln_estadoprv number;

  begin

    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';

    for c in c_s loop

      update tim.pf_hfc_prov_bscs@dbl_bscs_bf t set t.estado_prv = ln_estadoprv
      where t.co_id = c.co_id;

      p_genera_sot_oac(c.co_id, 2, 56, ln_coderror, lv_msgerror);

    end loop;

  end;

  procedure p_genera_sot_corte_oac is

    cursor c_s is
       select distinct t.co_id, t.customer_id
       from tim.pf_hfc_prov_bscs@dbl_bscs_bf t, contract_history@dbl_bscs_bf ch
       where t.co_id = ch.co_id
       and t.action_id = 4 and t.estado_prv=5 and t.fecha_rpt_eai is null
       and ch.ch_seqno = (select max(c.ch_seqno) from contract_history@dbl_bscs_bf c where c.co_id = ch.co_id)
       and ch.userlastmod in (select o.codigoc
                              from tipopedd t, opedd o
                              where t.tipopedd = o.tipopedd
                              and t.abrev = 'USERCOB');

  ln_coderror number;
  lv_msgerror varchar2(4000);
  ln_estadoprv number;

  begin

    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';

    for c in c_s loop

      update tim.pf_hfc_prov_bscs@dbl_bscs_bf t set t.estado_prv = ln_estadoprv
      where t.co_id = c.co_id;

      p_genera_sot_oac(c.co_id, 6, 56 ,ln_coderror, lv_msgerror);

    end loop;

  end;

  procedure p_genera_sot_oac(av_cod_id       in solot.cod_id%type,
                             an_idtrancorte  in number,
                             an_idgrupocorte in number,
                             an_cod_rpta     out number,
                             ac_msg_rpta     out varchar2) is
     --excepciones
     le_error_plantilla_trs exception;
     le_error_plantilla_sot exception;
     le_error_sids_activos exception;
     le_error_sot exception;
     le_error_wf exception;

     --variables
     l_par_sot            ope_plantillasot%rowtype;
     lout_codsolot        solot.codsolot%type;
     lc_resultado         varchar2(10);
     lc_mensaje           varchar2(2000);
     ln_puntos            number;
     ln_idtragrucorte     number;
     n_idlog              number;
     n_tipo               number;
     n_cont_plantilla_trs number;
     n_customer_id number;
     av_codcli            solot.codcli%type;
     av_numslc            solot.numslc%type;
     v_codsolot           solot.codsolot%type;
     ln_canttickler       number; --6.0

  begin

     --inicializacion de parametros de respuesta
     n_tipo      := 0;
     an_cod_rpta := 0;
     ac_msg_rpta := null;

     --registrar transaccion enviada de bscs a sga
     p_reg_log_oac(n_tipo,
                  n_idlog,
                  av_cod_id,
                  av_codcli,
                  av_numslc,
                  an_idgrupocorte,
                  an_idtrancorte,
                  'PQ_SGA_IW.P_GENERA_SOT_OAC',
                  ac_msg_rpta,
                  lout_codsolot,
                  ln_canttickler);

     n_tipo := 1;

     p_reg_serv_cod_id_sot(av_cod_id, v_codsolot);

     --Obtener maxima SOT en base al CO_ID
     v_codsolot := f_max_sot_x_cod_id(av_cod_id);

     if v_codsolot = 0 then
        raise le_error_sids_activos;
     end if;

     select s.codcli, s.numslc, s.customer_id into av_codcli, av_numslc, n_customer_id
     from solot s where s.codsolot = v_codsolot;

     --Validar configuraciones para generaci?n de SOT
     select count(1)
       into n_cont_plantilla_trs
       from cxc_transxgrupocorte
      where idgrupocorte = an_idgrupocorte
        and idtrancorte = an_idtrancorte;

     if n_cont_plantilla_trs = 0 then
       raise le_error_plantilla_trs;
     end if;

     --Obtener configuraciones para generaci?n de SOT
     begin

       select a.idplansot,
              a.tiptra,
              a.tipsrv,
              a.motot,
              a.areasol,
              b.idtragrucorte,
              a.diasfeccom
         into l_par_sot.idplansot,
              l_par_sot.tiptra,
              l_par_sot.tipsrv,
              l_par_sot.motot,
              l_par_sot.areasol,
              ln_idtragrucorte,
              l_par_sot.diasfeccom
         from ope_plantillasot       a,
              cxc_transxgrupocorte   b,
              cxc_transaccionescorte c
        where b.idgrupocorte = an_idgrupocorte
          and b.idtrancorte = c.idtrancorte
          and c.idtrancorte = an_idtrancorte
          and a.idplansot = b.idplansot;

     exception
       when no_data_found then
         raise le_error_plantilla_sot;
     end;

     /*********************************
     Generaci?n de cabecera de la SOT
     **********************************/
     p_insert_sot_oac(av_codcli,
                      l_par_sot.tiptra,
                      l_par_sot.tipsrv,
                      1,
                      l_par_sot.motot,
                      l_par_sot.areasol,
                      null,
                      lout_codsolot);

     /****************************************
      Actualizaci?n de la fecha de compromiso
     *****************************************/
     update solot
        set feccom = sysdate + l_par_sot.diasfeccom,cod_id=av_cod_id,customer_id=n_customer_id
      where codsolot = lout_codsolot;

     /*********************************
      Generaci?n de detalle de la SOT
     **********************************/
     p_insert_solotpto_oac(n_idlog,
                           lout_codsolot,
                           v_codsolot,
                           av_codcli,
                           av_numslc,
                           lc_resultado,
                           lc_mensaje,
                           ln_puntos);

     if ln_puntos = 0 then
       raise le_error_sot;
     end if;

     --Se aprueba la SOT
     pq_solot.p_chg_estado_solot(lout_codsolot, 11);

     --Finaliza parametros de respuesta
     an_cod_rpta := c_cod_rpta_ok;
     ac_msg_rpta := 'Exito en el Proceso';

     ln_canttickler := f_val_tickler_records_oac(av_cod_id);
     --Invocar funcion actualizar codcli y numslc
     p_reg_log_oac(n_tipo,
                    n_idlog,
                    av_cod_id,
                    av_codcli,
                    av_numslc,
                    an_idgrupocorte,
                    an_idtrancorte,
                    'PQ_SGA_IW.P_GENERA_SOT_OAC',
                    ac_msg_rpta,
                    lout_codsolot,
                    ln_canttickler);
     commit;
  exception
     when le_error_plantilla_trs then
       rollback;
       an_cod_rpta := c_cod_rpta_error;
       ac_msg_rpta := 'Error en la Generacion de SOT - OAC: La transacci?n no esta configurada en el grupo de corte.';
       p_reg_log_oac(n_tipo,
                      n_idlog,
                      av_cod_id,
                      av_codcli,
                      av_numslc,
                      an_idgrupocorte,
                      an_idtrancorte,
                      'PQ_SGA_IW.P_GENERA_SOT_OAC',
                      ac_msg_rpta,
                      lout_codsolot,
                      ln_canttickler);

     when le_error_plantilla_sot then
       rollback;
       an_cod_rpta := c_cod_rpta_error;
       ac_msg_rpta := 'Error en la Generacion de SOT - OAC: No existe plantilla de SOT definida para el IDTRANCORTE: ' ||
                      to_char(an_idtrancorte);
       p_reg_log_oac(n_tipo,
                      n_idlog,
                      av_cod_id,
                      av_codcli,
                      av_numslc,
                      an_idgrupocorte,
                      an_idtrancorte,
                      'PQ_SGA_IW.P_GENERA_SOT_OAC',
                      ac_msg_rpta,
                      lout_codsolot,
                      ln_canttickler);

     when le_error_sids_activos then
       rollback;
       an_cod_rpta := c_cod_rpta_error;
       ac_msg_rpta := 'Error en la Generacion de SOT - OAC: Los Servicios asociados a la SOT tiene estado Invalido: Cancelado/No Operativo'; --4.0
       p_reg_log_oac(n_tipo,
                      n_idlog,
                      av_cod_id,
                      av_codcli,
                      av_numslc,
                      an_idgrupocorte,
                      an_idtrancorte,
                      'PQ_SGA_IW.P_GENERA_SOT_OAC',
                      ac_msg_rpta,
                      lout_codsolot,
                      ln_canttickler);
     when le_error_sot then
       rollback;
       an_cod_rpta := c_cod_rpta_error;
       ac_msg_rpta := 'Error en la Generacion de SOT - OAC: No encontraron puntos para la generacion de la SOT: ' ||
                      lc_mensaje || ' - ' || sqlerrm;
       p_reg_log_oac(n_tipo,
                      n_idlog,
                      av_cod_id,
                      av_codcli,
                      av_numslc,
                      an_idgrupocorte,
                      an_idtrancorte,
                      'PQ_SGA_IW.P_GENERA_SOT_OAC',
                      ac_msg_rpta,
                      lout_codsolot,
                      ln_canttickler);
     when others then
       rollback;
       an_cod_rpta := c_cod_rpta_error;
       ac_msg_rpta := 'Error en la Generacion de SOT - OAC: Error de BD ORA - ' ||
                      sqlerrm || ' Linea (' || dbms_utility.format_error_backtrace || ')';
       p_reg_log_oac(n_tipo,
                      n_idlog,
                      av_cod_id,
                      av_codcli,
                      av_numslc,
                      an_idgrupocorte,
                      an_idtrancorte,
                      'PQ_SGA_IW.P_GENERA_SOT_OAC',
                      ac_msg_rpta,
                      lout_codsolot,
                      ln_canttickler);
  END;

  procedure p_insert_sot_oac(v_codcli   in solot.codcli%type,
                         v_tiptra   in solot.tiptra%type,
                         v_tipsrv   in solot.tipsrv%type,
                         v_grado    in solot.grado%type,
                         v_motivo   in solot.codmotot%type,
                         v_areasol  in solot.areasol%type,
                         a_idoac in number,
                         a_codsolot out number) IS

  begin
    a_codsolot := F_GET_CLAVE_SOLOT();
    insert into solot(codsolot, codcli, estsol, tiptra, tipsrv, grado, codmotot, areasol,idoac)
    values(a_codsolot,v_codcli,10,v_tiptra,v_tipsrv,v_grado,v_motivo,v_areasol,a_idoac);
    G_CODSOLOT := a_codsolot;
  end;


  procedure p_insert_solotpto_oac(an_idlog         in collections.logtrsoac_bscs.idlog%type,
                                   an_codsolot      in solot.codsolot%type,
                                   an_codsolot_b    in solot.codsolot%type,
                                   av_codcli        in varchar2,
                                   av_numslc        in varchar2,
                                   ac_resultado     out varchar2,
                                   ac_mensaje       out varchar2,
                                   an_puntos        out number) is
    l_cont         number;
    ln_idlog       collections.logtrsoac_bscs.idlog%type;

    cursor cur_detalle_sot is
      --considera todos los servicios de la factura, incluso aquellos que no han generado cargos recurrentes
      select distinct i.codsrv      codsrvnue,
                      i.bw          bwnue,
                      i.numero,
                      i.codinssrv,
                      i.cid,
                      i.descripcion,
                      i.direccion,
                      2             tipo,
                      1             estado,
                      1             visible,
                      i.codubi,
                      1             flgmt
        from inssrv i
        inner join solotpto s
          on i.codinssrv = s.codinssrv
       where i.codcli = av_codcli
         and s.codsolot = an_codsolot_b
         and i.numslc = av_numslc;

  begin
    l_cont := 0;
    for c_det in cur_detalle_sot loop

      l_cont := l_cont + 1;

      insert into solotpto
        (codsolot,
         punto,
         codsrvnue,
         bwnue,
         codinssrv,
         cid,
         descripcion,
         direccion,
         tipo,
         estado,
         visible,
         codubi,
         flgmt)
      values
        (an_codsolot,
         l_cont,
         c_det.codsrvnue,
         c_det.bwnue,
         c_det.codinssrv,
         c_det.cid,
         c_det.descripcion,
         c_det.direccion,
         c_det.tipo,
         c_det.estado,
         c_det.visible,
         c_det.codubi,
         c_det.flgmt);

    end loop;

    ac_resultado := fnd_estado_exito;
    ac_mensaje   := '';
    an_puntos    := l_cont;

  exception
    when others then
      ac_resultado := fnd_estado_error;
      ac_mensaje   := sqlerrm;
      an_puntos    := 0;
      ln_idlog     := an_idlog;

      p_reg_log_oac(1,
                     ln_idlog,
                     null,
                     null,
                     null,
                     null,
                     null,
                     'pq_sga_iw.p_insert_solotpto_oac',
                     ac_mensaje,
                     an_codsolot,
                     0);
  end;

  procedure p_reg_log_oac(an_tipo         number,
                          an_idlog        in out collections.logtrsoac_bscs.idlog%type,
                           an_cod_id       collections.logtrsoac_bscs.cod_id%type,
                           av_codcli       collections.logtrsoac_bscs.codcli%type,
                           av_numslc       collections.logtrsoac_bscs.numslc%type,
                           an_idgrupocorte collections.logtrsoac_bscs.idgrupocorte%type,
                           an_idtrancorte  collections.logtrsoac_bscs.idtrancorte%type,
                           ac_proceso      collections.logtrsoac_bscs.proceso%type,
                           ac_texto        collections.logtrsoac_bscs.texto%type,
                           ac_codsolot     collections.logtrsoac_bscs.codsolot%type,
                           an_canttickler  collections.logtrsoac_bscs.cant_tickler%type) is  --6.0
    pragma autonomous_transaction;
  begin
    --flag insertar y otro para update
    if an_tipo = 0 then
       -- generar id
      select collections.sq_idlogtrsoac_bscs.nextval into an_idlog from dummy_coll;

      insert into collections.logtrsoac_bscs
        (idlog,cod_id,idgrupocorte, idtrancorte, proceso, texto, codsolot)
      values
        (an_idlog,
         an_cod_id,
         an_idgrupocorte,
         an_idtrancorte,
         ac_proceso,
         substr(ac_texto, 1, 4000),
         ac_codsolot);
    else
      update collections.logtrsoac_bscs
      set codcli = av_codcli, numslc = av_numslc,
  texto = substr(ac_texto, 1, 4000),
  codsolot = ac_codsolot,
        cant_tickler = an_canttickler --6.0
      where idlog = an_idlog;
    end if ;

    commit;
  end;

procedure p_genera_xml_baja(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_salida number;
v_salida varchar2(300);
v_msg varchar2(4000);
BEGIN
  select a.codsolot, b.cod_id into n_codsolot, n_cod_id
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot;

  INTRAWAY.PQ_PROVISION_ITW.P_INT_EJECBAJA(n_codsolot,n_salida, v_salida, 0 );

  if n_salida = 1 then
    INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO(n_codsolot,4, v_salida,v_msg);
  end if;

EXCEPTION
  WHEN error_general THEN
    v_error := 'Generar XML';
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Generar XML : ' || SQLERRM;
    n_error := sqlcode;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;

procedure p_genera_xml_scr(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_salida number;
v_salida varchar2(300);
n_tiptra number;
n_proceso number;

BEGIN
  select a.codsolot, b.cod_id, b.tiptra into n_codsolot, n_cod_id, n_tiptra
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot;

  select to_number(codigoc) into n_proceso from opedd o, tipopedd t
  where o.tipopedd = t.tipopedd and t.tipopedd = 1418 and codigon = n_tiptra;

  intraway.pq_provision_itw.P_INT_EJECSCR(n_codsolot,n_proceso,n_salida, v_salida, 0);

EXCEPTION
  WHEN error_general THEN
    v_error := 'Generar XML Susp/Rec/Corte';
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Generar XML Susp/Rec/Corte: ' || SQLERRM;
    n_error := sqlcode;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;

procedure p_envio_xml_baja(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_salida number := 4;
v_salida varchar2(300);
v_msg varchar2(300);
BEGIN
  select a.codsolot, b.cod_id into n_codsolot, n_cod_id
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot;

  INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO(n_codsolot,n_salida, v_salida,v_msg);
EXCEPTION
  WHEN error_general THEN
    v_error := 'Envio XML';
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Envio XML : ' || SQLERRM;
    n_error := sqlcode;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;


procedure p_envio_xml_scr(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_salida number := 4;
v_salida varchar2(300);
v_msg varchar2(300);
BEGIN
  select a.codsolot, b.cod_id into n_codsolot, n_cod_id
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot;

  intraway.pq_ejecuta_masivo.p_carga_info_int_envio(n_codsolot);

EXCEPTION
  WHEN error_general THEN
    v_error := 'Envio XML Susp/Rec/Corte';
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Envio XML Susp/Rec/Corte: ' || SQLERRM;
    n_error := sqlcode;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;

PROCEDURE p_genera_sot_baja IS
d_fecinibajasiac date;
cursor c_s is  --6.00
select a.CO_ID, a.CUSTOMER_ID, a.servd_fechaprog, a.SERVD_FECHA_REG,a.SERVC_ESTADO,
a.TIPO_SERV,a.CO_SER,a.TIPO_REG,a.servi_cod,a.servc_codigo_interaccion,
to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 1, 4000)) xml1,
case
when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 4000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 8000 then
   to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 4001,  8000))
end xml2,
case
when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 8000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 12000 then
   to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 8001,  12000))
end xml3
from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
where servi_cod=18 and SERVC_ESTADO=1
and a.SERVD_FECHAPROG >= d_fecinibajasiac
and a.SERVD_FECHAPROG <= trunc (sysdate);  --6.0

n_codsolot number;
n_res_cod number;
v_res_desc varchar2(400);
n_idseq number;
n_customer_id number;
n_tiptra number;
v_observacion solot.observacion%type;
v_franjahoraria varchar2(400);
n_codigoMotivo solot.codmotot%type;
v_codigoPlano agendamiento.idplano%type;
v_usuarioAsesor usuarioope.usuario%type;
n_estado number;
v_xml  varchar2(32767);
lv_xml  varchar2(32767); --3.0
an_coderror number;
av_msgerror varchar2(4000);
exception_general exception;
exception_tiptra exception; --<10.0>
ln_codsolot number;
ln_flag     number;
BEGIN
  select to_date(valor,'dd/mm/yyyy') into d_fecinibajasiac from constante where constante='DATEBAJASIACINI';
  for c in c_s loop   --6.0
    begin

      select to_number(c.valor) into ln_flag
      from constante c where c.constante = 'REGUREQUESTCOID';
      if ln_flag = 1 then
        operacion.pq_sga_bscs.p_libera_request_co_id(c.co_id,an_coderror,av_msgerror);
      end if;

      lv_xml:=c.xml1||nvl(c.xml2,'')||nvl(c.xml3,'');
      v_xml := f_retorna_xml_recorta(lv_xml);

      if f_val_trs_susp(c.co_id,c.servi_cod,c.servd_fechaprog) = 1 then --Transaccion Valida

        n_customer_id:=WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'codigoCliente');

            p_reg_serv_cod_id_sot(c.co_id, ln_codsolot);

            p_insert_ope_sol_siac(c.co_id, c.customer_id, v_xml, c.servd_fecha_reg, c.tipo_serv,
                                  c.co_ser, c.servi_cod, c.tipo_reg, c.servc_codigo_interaccion,
                                  0, c.servd_fechaprog, n_idseq, an_coderror, av_msgerror);

            if an_coderror = -1 then
              raise exception_general;
            end if;

            -- ini 10.0
            begin
               n_tiptra:=WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'tipTra');
            exception
              when others then
                av_msgerror := 'Transaccion Anulada: tipo de trabajo incorrecto, por favor volver a ingresar programacion de baja';
                an_coderror := -1;
                raise exception_tiptra;
            end;
            -- fin 10.0

            v_observacion:=to_char(substr(WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'observaciones'), 1, 4000));
            v_franjahoraria:=WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'franjaHoraria');
            n_codigoMotivo:=WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'codigoMotivo');

            -- ini 10.0
            if n_tiptra = 448 then
               select to_number(c.valor) into n_tiptra
               from constante c where c.constante = 'TIPTRABAJSIAC';
            end if;

            if n_codigoMotivo = 0 or nvl(n_codigoMotivo, 0) = 0 or n_codigoMotivo = -1 then
              begin


                select distinct o.codigon into n_codigoMotivo
                from tipopedd t, opedd o
                where t.tipopedd = o.tipopedd
                and t.abrev = 'TIPTRABAJASIACMOTOT'
                and o.codigon_aux = n_tiptra
                and o.codigoc = 'SB';


              exception
                when others then
                   av_msgerror := 'ERROR: Tipo ';
                   an_coderror := -1;
                   raise exception_general;
              end;
            end if;
            -- fin 10.0

            begin
             select distinct d1.idplano into v_codigoPlano from solot a1,solotpto b1,inssrv c1, vtasuccli d1
             where a1.codsolot=b1.codsolot and b1.codinssrv=c1.codinssrv and c1.codsuc=d1.codsuc
             and a1.cod_id=c.co_id  and b1.idplano is not null   and rownum=1;

            exception
              when no_data_found then
                v_codigoPlano := '';
            end;

            --Ini 11.0
            /*if n_tiptra = 448 then
              n_tiptra := 728;
            end if;*/
            --Fin 11.0
            -- Valida si tipo de trabajo lo envia incorrecto el SIAC
            if n_tiptra = -1 or nvl(n_tiptra, 0) = 0 then
              begin

                select distinct o.codigon_aux into n_tiptra
                from tipopedd t, opedd o
                where t.tipopedd = o.tipopedd
                and t.abrev = 'TIPTRABAJASIACMOTOT'
                and o.codigon = n_codigoMotivo;

              exception
                when others then
                  select distinct o.codigon_aux into n_tiptra
                  from tipopedd t, opedd o
                  where t.tipopedd = o.tipopedd
                  and t.abrev = 'TIPTRABAJASIACMOTOT'
                  and o.abreviacion = 'BAJAADM'
                  and o.codigon = n_codigoMotivo;
              end;
            end if;

            v_usuarioAsesor:=WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'usuarioAsesor');

            p_genera_sot_bscs(n_customer_id,c.co_id,n_tiptra,sysdate,
            v_franjahoraria,n_codigoMotivo,v_observacion,v_codigoPlano,v_usuarioAsesor,n_codsolot,n_res_cod,v_res_desc);

            if n_res_cod=1 then
              n_estado:=2;
            end if;

            if n_res_cod=-1 or n_res_cod=0 then--Error
              n_estado:=4;
            end if;

            p_update_ope_sol_siac(n_idseq,n_codsolot,n_customer_id,n_estado,n_res_cod,v_res_desc,an_coderror,av_msgerror);

            --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija(n_estado, v_res_desc, n_res_cod, c.co_id, c.servi_cod,
                                             c.servd_fecha_reg, an_coderror, av_msgerror);
      else
        --Se anula la transaccion
        p_update_postt_serv_fija(5, 'Duplicidad de Contrato de Desactivaci?n.',-1, c.co_id,c.servi_cod,
                                         c.servd_fecha_reg,an_coderror, av_msgerror);
      end if;

    exception
      when exception_general then
          p_update_postt_serv_fija(4, av_msgerror, an_coderror,c.co_id, c.servi_cod, c.servd_fecha_reg,
                                      an_coderror, av_msgerror);
      -- ini 10.0
      when exception_tiptra then
        p_update_postt_serv_fija(5, av_msgerror, an_coderror,c.co_id, c.servi_cod, c.servd_fecha_reg,
                                      an_coderror, av_msgerror);
      -- fin 10.0
      when others then
        p_update_postt_serv_fija(4,
                                 av_msgerror,
                                 an_coderror,
                                 c.co_id,
                                 c.servi_cod,
                                 c.servd_fecha_reg,
                                 an_coderror,
                                 av_msgerror);
    end;
  end loop;  --6.0
END;


procedure p_genera_sot_bscs(as_customer_id in varchar2,
                           ad_cod_id      in sales.sot_sisact.cod_id%type,
                           an_tiptra      in number,
                           ad_fecprog     in date,
                           as_franja      in varchar2,
                           an_codmotot    in motot.codmotot%type,
                           as_observacion in solot.observacion%type,
                           as_plano       in vtatabgeoref.idplano%type,
                           as_usuarioreg  in solot.codusu%type,
                           o_codsolot     out number,
                           o_res_cod      out number,
                           o_res_desc     out varchar2) is

  ln_wf           number;
  as_fecpro       varchar2(20);
  ad_fechaagenda  date;
  an_codsolot     solot.codsolot%type;
  as_numslc       solot.numslc%type;
  as_codcli       vtatabcli.codcli%type;
  as_codcuadrilla cuadrillaxcontrata.codcuadrilla%type;
  an_codcon       cuadrillaxcontrata.codcon%type;
  ln_wfdef        wfdef.wfdef%type;
  error_no_valor exception;
  error_no_cli exception;
  error_no_sot exception;
  error_no_cuad exception;
  error_no_gensot exception;
  error_no_usuario exception;--3.0
  error_no_wf exception;
  error_cod      number;
  error_desc     varchar2(100);
  ls_codusu  varchar2(30);--3.0
  ll_contusu number;--3.0
  ls_codubi     inssrv.codubi%type; -- 7.0
  ls_direccion  inssrv.direccion%type; --7.0

  begin
    o_res_cod  := 1;
    o_res_desc := 'exito';
    error_cod :=0;
    error_desc:='exito';
    if as_customer_id is null then
      raise error_no_valor;
    end if;

    if ad_cod_id is null then
      raise error_no_valor;
    end if;
    if an_tiptra is null then
      raise error_no_valor;
    end if;
    if ad_fecprog is null then
      raise error_no_valor;
    end if;
    if an_codmotot is null then
      raise error_no_valor;
    end if;
    if as_usuarioreg is null then
      raise error_no_valor;
    end if;

    --1. identificamos el codcli cliente del sga:
--ini 3.0
    begin
      select distinct s.codcli into as_codcli
      from sales.cliente_sisact s
      where trim(s.customer_id) = as_customer_id
      and s.estado = 1;
    exception
      when no_data_found then
         select distinct s.codcli into as_codcli
         from solot s where s.customer_id = as_customer_id;

         insert into sales.cliente_sisact(customer_id, codcli)
         values (as_customer_id, as_codcli);

      when too_many_rows then
        select distinct s.codcli into as_codcli
        from solot s where s.customer_id = as_customer_id;
    end;
--fin 3.0
    if as_codcli is null then
      raise error_no_cli;
    end if;

    an_codsolot := f_max_sot_x_cod_id(ad_cod_id);

    if an_codsolot = 0 then
      raise error_no_sot;
    end if;

    select numslc into as_numslc from solot where codsolot=an_codsolot;

    begin  -- Ini 7.0
      select distinct (codubi), direccion
        into ls_codubi, ls_direccion
        from inssrv
      where numslc = as_numslc;
    exception
      when too_many_rows then
        update inssrv i
        set i.direccion = (select ins.direccion from inssrv ins where ins.numslc = as_numslc
                           and rownum = 1)
        where i.numslc = as_numslc;
    end;  -- Fin 7.0

    if error_cod =0 then

      select to_char(ad_fecprog, 'dd/mm/yyyy') into as_fecpro from dual;

      begin
        select to_date(as_fecpro || as_franja, 'dd/mm/yyyy hh24:mi')
        into ad_fechaagenda
        from dual;
      exception
        when others then
          select to_date(as_fecpro || '13:00', 'dd/mm/yyyy hh24:mi')
          into ad_fechaagenda
          from dual;
      end;
-- ini 3.0
      begin
        select distinct s.usureg  -- 7.0
          into ls_codusu
          from sales.sot_sisact s  -- 7.0
         where s.numslc = as_numslc -- 7.0
         and s.cod_id = ad_cod_id;  --7.0

      exception
        when no_data_found then
          begin
            select distinct s.usureg   -- 7.0
              into ls_codusu
              from sales.sot_siac s, solot l
             where s.codsolot = l.codsolot
               and l.numslc = as_numslc
               and s.cod_id = ad_cod_id; -- 7.0
          exception
            when no_data_found then
              ls_codusu := sales.pq_postventa_unificada.get_usureg_sot(as_codcli);
          end;
      end;

      select count(1)
        into ll_contusu
        from usuarioope
       where trim(usuarioope.usuario) = trim(ls_codusu);

      if ll_contusu = 0 then

        begin
          select distinct s.codusu into ls_codusu
          from solot s, tiptrabajo t
          where s.tiptra = t.tiptra
          and t.tiptrs = 1
          and s.numslc = as_numslc;

          update sales.sot_sisact s
            set s.usureg = ls_codusu
          where s.numslc = as_numslc
          and s.codsolot = an_codsolot;

          update sales.sot_siac s
             set s.usureg = ls_codusu
          where s.codsolot = an_codsolot;

       exception
         when others then
            raise error_no_usuario;
       end;

      end if;
-- fin 3.0
      sales.pq_postventa_unificada.p_gen_sot_siac(as_numslc,
                   as_codcli,
                   an_tiptra,
                   an_codmotot,
                   an_codcon,
                   as_codcuadrilla,
                   ad_fechaagenda,
                   as_observacion,
                   as_plano,
                   null,
                   o_codsolot);

      if o_codsolot is null then
        raise error_no_gensot;
      end if;
      --Actualizar usuario solicitante
      update solot set codusu = as_usuarioreg, customer_id=as_customer_id,cod_id=ad_cod_id  where codsolot = o_codsolot;--4.0
      update agendamiento set fecagenda = ad_fechaagenda
      where codsolot = o_codsolot;

   else
      o_res_cod  := error_cod;
      o_res_desc := error_desc;
   end if;

  exception
    when error_no_valor then
      o_res_cod  := 0;
      o_res_desc := 'no se ha ingresado todos los par?metros.';
    when error_no_cli then
      o_res_cod  := 0;
      o_res_desc := 'no se ha encontrado el cliente asociado.';
    when error_no_sot then
      o_res_cod  := 0;
      o_res_desc := 'Los servicios asociados a la SOT de Alta tienen estado Invalido: Cancelado/No Operativo';
    when error_no_cuad then
      o_res_cod  := 0;
      o_res_desc := 'no se ha encontrado la cuadrilla asociada.';
    when error_no_gensot then
      o_res_cod  := 0;
      o_res_desc := 'no se ha generado la sot.';
-- ini 3.0
    when error_no_usuario then
      o_res_cod  := 0;
      o_res_desc := 'no se actualizado correctamente el usuario';
-- fin 3.0
    when error_no_wf then
      o_res_cod  := 0;
      o_res_desc := 'no se encuentra definido un wf.';
    when others then
      o_res_cod  := -1;
      o_res_desc := 'error: ' || sqlcode || ' ' || sqlerrm || ' (' ||--3.0
                          dbms_utility.format_error_backtrace || ')';--3.0

  end p_genera_sot_bscs;

procedure p_envia_ws_desactiva_baja(an_codsolot number,
                                    an_coderror out number,
                                    av_msgerror out varchar2)
IS
v_abrev varchar2(50);
v_error varchar2(400);
n_error number;
n_co_id number;
n_estado number;
ln_idseq number;
err EXCEPTION;
 cursor c_sol is
    select b.co_id, b.fecha_reg, b.servi_cod, b.idseq
    from operacion.ope_sol_siac b where b.codsolot = an_codsolot;
Begin
  an_coderror := 1;
  av_msgerror := 'OK';

  for r_s in c_sol loop
    ln_idseq := r_s.idseq;

    WEBSERVICE.PQ_WS_SGA_IW.p_desactivarContrato(an_codsolot, r_s.co_id, n_error,v_error);--3.0

    if n_error<0 then
       n_estado:=4;
       an_coderror := n_error;
       av_msgerror := v_error;
    else
      n_estado:=3;
      v_error := 'Exito';
    end if;

    p_update_postt_serv_fija(n_estado, v_error, n_error, r_s.CO_ID, r_s.servi_cod ,
                                       r_s.fecha_reg, an_coderror, av_msgerror);

    p_update_ope_sol_siac(ln_idseq, an_codsolot, null, n_estado, n_error, v_error,
                          an_coderror,av_msgerror);

  end loop;
exception
  when others then
    an_coderror := -1;
    v_error:='Envia WS desactiva ' ||'-'||sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';

    p_update_ope_sol_siac(ln_idseq, an_codsolot, null, 4, n_error, v_error,
                          an_coderror,av_msgerror);

    p_reg_log('Envia WS desactiva.',sqlcode,v_error,null,null,null,null,null);
END;

procedure p_valida_contrato(n_cod_id number,
                            an_codsolot number,
                            av_tipo varchar2,
                            an_coderror out number,
                            av_msgerror out varchar2)  is

n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_val_request_c number;
n_val_request_m number;
n_request number;
n_idseq number;

-- ini 3.0
cursor c_request(an_codid number) is
    select request
    from mdsrrtab@DBL_BSCS_BF where co_id = an_codid and request_update is null
    and status not in (9, 7);
  -- fin 3.0
BEGIN
  an_coderror := 1;
  av_msgerror := 'OK';

  if an_codsolot is not null then
    select s.idseq into n_idseq from operacion.ope_sol_siac s where s.co_id = n_cod_id
    and s.codsolot = an_codsolot;
  end if;

  -- av_tipo: d:baja, a:reconexion, s:suspension
  if av_tipo = 'd' then
      -- Request pendiente
      select count(request) into n_val_request_m
      from mdsrrtab@DBL_BSCS_BF where co_id = n_cod_id and request_update is null and status not in (9, 7);

      select count(request) into n_val_request_c
      from contract_history@DBL_BSCS_BF where co_id = n_cod_id and upper(ch_pending) = 'X';

      if n_val_request_m > 0 then
      -- ini 3.0
        for c_r in c_request(n_cod_id) loop
          contract.Cancel_Request@DBL_BSCS_BF(c_r.request);
          update mdsrrtab@DBL_BSCS_BF  set status=9 where request=c_r.request;
          commit;
         end loop;
      -- fin 3.0
      end if;

      if n_val_request_c > 0 then
        update contract_history@DBL_BSCS_BF set ch_pending=null where co_id=n_cod_id
        and ch_pending is not null;
        --commit;
      end if;
   end if;
EXCEPTION
  WHEN OTHERS THEN
    an_coderror := -1;
    av_msgerror := 'Error Validar Contrato BSCS : ' || SQLERRM;
    n_error := sqlcode;

    p_update_ope_sol_siac(n_idseq,null,null,2,an_coderror,av_msgerror,an_coderror,av_msgerror);


    p_reg_log(null, null, NULL, n_cod_id, null, n_error, av_msgerror, n_cod_id);

    raise_application_error(-20001, v_error);
End;

procedure p_desactiva_contrato(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
v_usuario varchar2(100);
n_reason number;
n_motivo_action number;
n_tipmotot number;
n_val_contrato_act number;
an_tiptra number;--3.0
an_coderror number;
av_msgerror varchar2(4000);
n_idseq number;

BEGIN

  select a.codsolot, b.cod_id, b.tiptra--3.0
  into n_codsolot, n_cod_id,an_tiptra--3.0
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot
  and a.valido = 1;

  select s.idseq into n_idseq from operacion.ope_sol_siac s where s.codsolot = n_codsolot;

  p_valida_contrato(n_cod_id, n_codsolot,  'd', an_coderror, av_msgerror);

  if an_coderror = 1 then

    select a.codigon into n_reason from opedd a, tipopedd b
    where a.tipopedd=b.tipopedd and b.abrev='SGAREASONTIPMOTOT'
    and a.codigon_aux = an_tiptra
    and a.codigoc=1;

    select a.abreviacion into v_usuario from opedd a, tipopedd b
    where a.tipopedd=b.tipopedd and b.abrev='SGAREASONTIPMOTOT' and a.codigoc=2;

    n_val_contrato_act := f_val_status_contrato(n_cod_id);  --6.0

    if n_val_contrato_act in (1, 2) then --Desactivamos el contrato
      tim.tim111_pkg_acciones_sga.sp_contr_desactiva@dbl_bscs_bf(n_cod_id,n_reason,v_usuario,n_motivo_action);
      if n_motivo_action < 0 then
        n_error:=n_motivo_action;
        v_error := 'Error al desactivar Contrato BSCS';
        RAISE error_general;
      end if;
    end if;
  else
    v_error := av_msgerror;
    raise error_general;
  end if;

EXCEPTION
  WHEN error_general THEN
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error,n_cod_id);
    p_update_ope_sol_siac(n_idseq,null,null,2,n_error,v_error,an_coderror,av_msgerror);

    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Error desactivar Contrato BSCS : ' || SQLERRM;
    n_error := sqlcode;

    p_update_ope_sol_siac(n_idseq,null,null,2,n_error,v_error,an_coderror,av_msgerror);

    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;


procedure p_desactiva_bscs_hfc(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
n_codsolot solot.codsolot%type;
n_cod_id number;
n_error number;
error_general EXCEPTION;
v_error varchar2(200);
n_val_contrato_act number;
n_val_contrato_desact number;
n_valida_request number;
BEGIN
  select a.codsolot, b.cod_id into n_codsolot, n_cod_id
  from wf a, solot b
  where a.idwf = a_idwf
  and a.codsolot = b.codsolot
  and a.valido = 1;

  select count(1) into n_val_contrato_act
  from contract_history@DBL_BSCS_BF c
  where c.ch_seqno = (select max(b.ch_seqno) from contract_history@DBL_BSCS_BF b where b.co_id = c.co_id)
  and c.co_id=n_cod_id and upper(c.ch_status) in ('A','S') and c.ch_pending is null;

  select count(1) into n_val_contrato_desact
  from contract_history@DBL_BSCS_BF c
  where c.ch_seqno = (select max(b.ch_seqno) from contract_history@DBL_BSCS_BF b where b.co_id = c.co_id)
  and c.co_id=n_cod_id and upper(c.ch_status)='D' and c.ch_pending is null;

  if n_val_contrato_act>0 then--Desactivamos el contrato 3.0
    select count(1) into n_valida_request
    from tim.pf_hfc_prov_bscs@DBL_BSCS_BF p
    where p.co_id =n_cod_id and p.estado_prv <> '5' ;
    if n_valida_request>0 then--3.0
      update  tim.pf_hfc_prov_bscs@DBL_BSCS_BF set  estado_prv=9
      where co_id= n_cod_id;
      commit;
      insert into tim.pf_hfc_prov_bscs_hist@DBL_BSCS_BF
      select * from tim.pf_hfc_prov_bscs@DBL_BSCS_BF where co_id=n_cod_id;
      delete from  tim.pf_hfc_prov_bscs@DBL_BSCS_BF where co_id= n_cod_id and  estado_prv=9;
    end if;
    tim.tim111_pkg_acciones_sga.SP_CONTR_DES_PROV_IW@DBL_BSCS_BF(n_cod_id, n_error, v_error) ;
    if n_error<0 then
      raise error_general;
    end if;
    update tim.pf_hfc_prov_bscs@DBL_BSCS_BF  set estado_prv=5,fecha_rpt_eai=sysdate
    where co_id=n_cod_id and action_id=9 and to_char(fecha_insert,'yyyymmdd') = to_char(sysdate,'yyyymmdd');

  end if;
  if n_val_contrato_desact=1 then--El contrato esta desactivo
    --Se tiene que cerrar la tarea como NO INTERVIENE
    null;
  end if;

EXCEPTION
  WHEN error_general THEN
    v_error := 'Error al desactivar Servicios HFC en BSCS:' || v_error;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error,n_cod_id);
    raise_application_error(-20001, v_error);
  WHEN OTHERS THEN
    v_error := 'Error al desactivar Servicios HFC en BSCS: ' || SQLERRM;
    n_error := sqlcode;
    p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
    raise_application_error(-20001, v_error);
End;

procedure p_reg_log(ac_codcli      OPERACION.SOLOT.CODCLI%type,
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
    insert into OPERACION.LOG_TRS_INTERFACE_IW
      (CODCLI,
       IDTRS,
       CODSOLOT,
       IDINTERFACE,
       ERROR,
       TEXTO,
       CUSTOMER_ID,
       COD_ID,
       PROCESO)
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
  end;

  function f_val_sotbaja_hfc(an_codsolot number) return number is
    ln_count number;
   begin
     select count(1) into ln_count
     from solot s, tiptrabajo t
     where s.tiptra = t.tiptra
     and t.tiptrs = 5
     and s.codsolot = an_codsolot;

     return ln_count;

   end;
  -- ini 3.0
   function f_val_sotrechazada_hfc(an_codsolot number) return number is
    ln_count number;
   begin

     select count(1) into ln_count
         from solot s, estsol es
         where es.tipestsol = 7
         and s.estsol = es.estsol
         and s.codsolot = an_codsolot
         and s.tiptra in (select o.codigon
                      from tipopedd t, opedd o
                      where t.tipopedd = o.tipopedd
                      and t.abrev ='TIP_TRABAJO');

     return ln_count;
  end;
 -- fin 3.0

 -- Ini 6.0
   function f_obtener_ciclo_bscs( an_cod_id number ) return varchar2 is -- 12.0
      ln_billcycle number;
   begin
      select ca.billcycle
             INTO ln_billcycle
           from customer_all@Dbl_Bscs_Bf ca,
                contract_all@Dbl_Bscs_Bf cc
           where cc.customer_id = ca.customer_id
           and cc.co_id = an_cod_id;
      return   ln_billcycle;
   end;
  -- Fin 6.0

  procedure p_ejecutar_baja_janus(an_codsolot number, an_error out number , av_error out varchar2) is

    ln_cod_id   number;
    lv_codcli   varchar2(8);
    ln_customer number;
    lv_trama    varchar2(20);
    lv_numero   varchar2(8);

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    ln_codinssrv number;

    ln_valida_envio number;
    ln_tipo_serv_sot number;
    ln_alinea number;
    lv_mensaje varchar2(4000);
    ln_error number;
    lv_error varchar2(4000);

    ln_contrechazada number;--3.0
    lv_codclijanus varchar2(10);--3.0
    an_ordid      number;--13.0

  begin

     ln_tipo_serv_sot := f_val_tipo_serv_sot(an_codsolot);--3.0

     p_cons_numtelefonico_sot(an_codsolot,
                             lv_numero,
                             lv_codcli,
                             ln_cod_id,
                             ln_customer,
                             ln_codinssrv,
                             ln_error,
                             lv_error);

    if ln_error = 1 and lv_numero is not null then

      operacion.pq_sga_janus.p_cons_linea_janus(lv_numero,
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

         ln_valida_envio := f_valida_prov_numero(lv_customer_id_janus);
         ln_contrechazada := f_val_sotrechazada_hfc(an_codsolot);--3.0

         -- ln_tipo_serv_sot(2: SGA Puro, 3: HFC SISACT)
         -- ln_valida_envio (1: BSCS, 2:SGA )
         if ln_tipo_serv_sot = 2 and ln_valida_envio = 1 and f_val_sotbaja_hfc(an_codsolot) = 0 and ln_contrechazada = 0 then -- Enviar la Baja por BSCS 3.0

            if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then -- Validamos si hay provision encolados 3.0

              lv_trama := 'IMSI' || trim(lv_numero);
        --ini 3.0
              ln_customer := to_number(lv_customer_id_janus);
              --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_codinssrv,'2',1,lv_trama,ln_error,lv_error);
              operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_codinssrv,'2',1,lv_trama,an_ordid,ln_error,lv_error);

              operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
              'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);
        --fin 3.0

              an_error := 1;
              av_error := 'Exito al enviar la baja a Janus';
            else
              an_error := -1;
              av_error := 'Existen pendientes en la provision de Janus';--3.0
            end if;

         elsif ln_tipo_serv_sot = 3 and ln_valida_envio = 2 and f_val_sotbaja_hfc(an_codsolot) = 0 and ln_contrechazada = 0 then -- Enviar Baja por SGA 3.0

            if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then--3.0

              lv_trama := 'IMSI' || trim(lv_numero);

              operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus,ln_cod_id,0,lv_trama,--3.0
                                                              ln_error,lv_error);
        --ini 3.0
              ln_customer := to_number(lv_customer_id_janus);

              operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,
              'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);
        --fin 3.0
              an_error := 1;
              av_error := 'Exito al enviar la baja a Janus';

            else
              an_error := -1;
              av_error := 'Existen pendientes en la provision de Janus';--3.0
            end if;

         elsif ln_tipo_serv_sot = 2 and ln_valida_envio = 2 and f_val_sotbaja_hfc(an_codsolot) = 0 and ln_contrechazada = 0 then -- Enviar Baja por SGA 3.0

            p_val_datos_linea_janus('SGA',
                                    an_codsolot,
                                    ln_codinssrv,
                                    lv_numero,
                                    lv_customer_id_janus,
                                    ln_codplan_janus,
                                    lv_ciclo_janus,
                                    ln_alinea,
                                    lv_mensaje);
            if ln_alinea = 0 then
              if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then

                 lv_trama := 'IMSI' || trim(lv_numero);

                 operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus,ln_codinssrv,0,lv_trama,
                                                                 ln_error,lv_error);
        -- ini 3.0
                 ln_customer := to_number(lv_customer_id_janus);

                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);
        -- fin 3.0
                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';
              else
                an_error := -1;
                av_error := 'Existen pendientes en la provision de Janus';--3.0
              end if;
           else
             an_error := -1;
            av_error := 'La informacion en JANUS y SGA estan Alineados';
           end if;

         elsif ln_tipo_serv_sot = 3 and ln_valida_envio = 1 and f_val_sotbaja_hfc(an_codsolot) = 0 and ln_contrechazada = 0 then--3.0

             p_val_datos_linea_janus('BSCS',
                                    an_codsolot,
                                    ln_cod_id,
                                    lv_numero,
                                    lv_customer_id_janus,
                                    ln_codplan_janus,
                                    lv_ciclo_janus,
                                    ln_alinea,
                                    lv_mensaje);
             if ln_alinea = 0 then
               if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then

                 lv_trama := 'IMSI' || trim(lv_numero);

                 --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,ln_error,lv_error); --3.0
                 operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_ordid,ln_error,lv_error); --13.0

        -- ini 3.0
                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);
        -- fin 3.0
                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';

               else
                  an_error := -1;
                  av_error := 'Existen pendientes en la provision de Janus';--3.0
                end if;

             elsif ln_alinea = 1 then
               an_error := -1;
               av_error := 'La informacion en JANUS y BSCS estan Alineados';
             else
               an_error := -1;
               av_error := 'ERROR : ' ||lv_mensaje;
             end if;
    --ini 3.0
         elsif ln_tipo_serv_sot = 2 and ln_valida_envio = 2 and f_val_sotbaja_hfc(an_codsolot)= 1 and ln_contrechazada = 0 then

             lv_codclijanus := '9'||lv_codcli;

             if lv_codclijanus = lv_customer_id_janus then -- SOT de Baja y mismo cliente

               if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then
        --fin 3.0
                 lv_trama := 'IMSI' || trim(lv_numero);

                 operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus ,ln_codinssrv,0,lv_trama,
                                                                 ln_error,lv_error);
        -- ini 3.0
                 ln_customer := to_number(lv_customer_id_janus);

                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';

              else
                an_error := -1;
                av_error := 'Existen pendientes en la provision de Janus';
              end if;
            else
               an_error := 1;
               av_error := 'Sot Baja: El numero telefonico esta asociado a otro cliente en Janus';
            end if;

         elsif ln_tipo_serv_sot = 3 and ln_valida_envio = 1 and f_val_sotbaja_hfc(an_codsolot)= 1 and ln_contrechazada = 0 then

            if ln_customer = to_number(lv_customer_id_janus) then -- SOT de Baja y mismo cliente
               if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then

                 lv_trama := 'IMSI' || trim(lv_numero);

                 --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,ln_error,lv_error);
                  operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_ordid,ln_error,lv_error);--13.0


                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';

              else
                an_error := -1;
                av_error := 'Existen pendientes en la provision de Janus';
              end if;
           else
             an_error := 1;
             av_error := 'Sot Baja: El numero telefonico esta asociado a otro cliente en Janus';
           end if;

         -- Enviar la Baja a Janus cuando se cambio de estado la SOT de rechazado a Anulado -- Proyecto Anulacion de SOT
         elsif ln_tipo_serv_sot = 2 and ln_valida_envio = 2 and  ln_contrechazada = 1 and f_val_sotbaja_hfc(an_codsolot)= 0 then

            lv_codclijanus := '9'||lv_codcli;

            if lv_codclijanus = lv_customer_id_janus then -- Anulacion de SOT y mismo cliente

              if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then
                 lv_trama := 'IMSI' || trim(lv_numero);

                 operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus ,ln_codinssrv,0,lv_trama,
                                       ln_error,lv_error);

                 ln_customer := to_number(lv_customer_id_janus);

                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';
              else
                an_error := -1;
                av_error := 'Existen pendientes en la provision de Janus';
              end if;
           else
             an_error := 1;
             av_error := 'Anulacion: El numero telefonico esta asociado a otro cliente en Janus';
           end if;
         elsif ln_tipo_serv_sot = 3 and ln_valida_envio = 1 and  ln_contrechazada = 1 and f_val_sotbaja_hfc(an_codsolot)= 0 then

            if ln_customer = to_number(lv_customer_id_janus) then -- Anulacion de SOT y mismo cliente
              if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then

                   lv_trama := 'IMSI' || trim(lv_numero);

                   --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,ln_error,lv_error);
                   operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_ordid,ln_error,lv_error);--13.0

                   operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,
                   'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);
          -- fin 3.0
                   an_error := 1;
                   av_error := 'Exito al enviar la baja a Janus';
           -- ini 3.0
                else
                  an_error := -1;
                  av_error := 'Existen pendientes en la provision de Janus';
                end if;
           else
             an_error := 1;
             av_error := 'Anulacion: El numero telefonico esta asociado a otro cliente en Janus';
           end if;

         -- solo en el caso no encuentra por donde fue enviada la provision de alta
         elsif ln_valida_envio = 9 then
           if ln_tipo_serv_sot = 3 then
             if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then

                 lv_trama := 'IMSI' || trim(lv_numero);

                 --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,
                 --                                                ln_error,lv_error);

                 operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_ordid,
                                                                 ln_error,lv_error);--13.0
                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';

             else
                  an_error := -1;
                  av_error := 'Existen pendientes en la provision de Janus';
             end if;

           elsif ln_tipo_serv_sot = 2 then
              if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then

                 lv_trama := 'IMSI' || trim(lv_numero);

                 operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus,ln_codinssrv,0,lv_trama,
                                                                 ln_error,lv_error);

                 ln_customer := to_number(lv_customer_id_janus);

                 operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
                 'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

                 an_error := 1;
                 av_error := 'Exito al enviar la baja a Janus';
              else
                an_error := -1;
                av_error := 'Existen pendientes en la provision de Janus';
              end if;
           end if;
         end if;

      -- En el caso Exista el Numero en Janus y devuelva no-data-found
      elsif ln_out_janus = -2 then

         if ln_tipo_serv_sot = 3 then

            if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_cod_id) = 0 then
      -- fin 3.0
              lv_trama := 'IMSI' || trim(lv_numero);

              --operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,ln_error,lv_error);
              operacion.PQ_SGA_JANUS.p_insert_prov_bscs_janus(2,5,ln_customer,ln_cod_id,'2',1,lv_trama,an_ordid,ln_error,lv_error);


              operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_cod_id, ln_customer,--3.0
               'BAJALINEAJANUS',ln_customer,lv_numero,an_error,av_error);--3.0

              an_error := 1;
              av_error := 'Exito al enviar la baja a Janus';
        -- ini 3.0
            else
              an_error := -1;
              av_error := 'Existen pendientes en la provision de Janus';
            end if;

         elsif ln_tipo_serv_sot = 2  then

            if operacion.pq_sga_janus.f_val_prov_janus_pend(ln_codinssrv) = 0 then

              lv_trama := 'IMSI' || trim(lv_numero);
              lv_customer_id_janus := 'P'||lv_codcli;

              operacion.pq_sga_janus.p_insert_prov_ctrl_janus(2, 4, lv_customer_id_janus,ln_codinssrv,0,lv_trama,
                                       ln_error,lv_error);

              operacion.pq_cont_regularizacion.p_insert_janus_solot_seg(an_codsolot, ln_codinssrv, ln_customer,
               'BAJALINEAJANUS',lv_customer_id_janus,lv_numero,an_error,av_error);

              an_error := 1;
              av_error := 'Exito al enviar la baja a Janus';

            else
              an_error := -1;
              av_error := 'Existen pendientes en la provision de Janus';
            end if;
         end if;
    -- fin 3.0
      elsif ln_out_janus = -1 then
        an_error := -1;
        av_error := lv_mensaje_janus;
      end if;
    end if;
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR: p_ejecutar_baja_janus - ' || sqlcode || ' - ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';--3.0
  end;

  procedure p_cons_numtelefonico_sot(an_codsolot in number,
                                     av_numero out varchar2,
                                     av_codcli out varchar2,
                                     an_cod_id out number,
                                     an_customerid out number,
                                     an_codinssrv out number,
                                     an_error out number,
                                     av_error out varchar2) is
  begin
      select distinct s.cod_id, s.customer_id, ins.numero, s.codcli, ins.codinssrv
        into an_cod_id, an_customerid, av_numero, av_codcli, an_codinssrv
        from solot s, solotpto pto, inssrv ins
       where s.codsolot = pto.codsolot
         and pto.codinssrv = ins.codinssrv
         and ins.tipinssrv = 3
         and s.codsolot = an_codsolot;

         an_error := 1;
         av_error := 'OK';
    exception
      when no_data_found then
        av_numero := null;
        an_error  := -1;
        av_error  := 'Error';
  end;

  -- Consulta si el numero existe en Janus
  procedure p_cons_linea_janus(av_numero      in varchar2,
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
    error_no_janus exception;--3.0
  begin
    lv_numero := '0051' || av_numero;
    select count(1)  --6.0
      into l_cont
      from janus_prod_pe.connections@DBL_JANUS c
     where c.connection_id_v = lv_numero;
    if l_cont > 0 then
      begin--3.0
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
  -- ini 3.0
           exception
             when no_data_found then
                 raise error_no_janus;
           end;
  -- fin 3.0
      an_out     := 1;
      av_mensaje := 'OK';
    else
      an_out     := 0;
      av_mensaje := 'No existe Numero en Janus';
    end if;
  exception
   -- ini 3.0
    when error_no_janus then
      an_out     := -2;
      av_mensaje := 'Error: La linea no esta asociada a un Cliente en Janus';
    when others then
      av_mensaje := sqlcode || ' - ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
 -- fin 3.0
      an_out     := -1;
      av_mensaje := 'Error - ' || av_mensaje;
  end;

-- Funcion que evalua si es una HFC MASIVO (SGA), HFC MASIVO SISACT, HFC CE
  function f_val_tipo_serv_sot(an_codsolot number) return number is
    ln_tipo_serv number;

  begin
    select distinct xx.codigon_aux
    into ln_tipo_serv
    from solotpto pto,
         tystabsrv ser,
         producto p,
         (select o.codigon, o.codigon_aux
            from tipopedd t, opedd o
           where t.tipopedd = o.tipopedd
             and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx
   where pto.codsrvnue = ser.codsrv
     and ser.idproducto = p.idproducto
     and p.idproducto = xx.codigon
     and pto.codsolot = an_codsolot;

     return ln_tipo_serv;
  exception
   when others then
    return 0;
  end;

  function f_valida_prov_numero(av_customerid varchar2) return number is

  ln_action_id number;

  begin

        select count(r.action_id)
        into ln_action_id
        from tim.rp_prov_bscs_janus_hist@dbl_bscs_bf r
        where r.customer_id = to_number(av_customerid)
        and r.ord_id = (select max(rr.ord_id) from tim.rp_prov_bscs_janus_hist@dbl_bscs_bf rr
                               where rr.customer_id = r.customer_id
                               and rr.action_id in (1)
                               and rr.estado_prv = 5);

        if ln_action_id > 0 then
          return 1; -- Alta por BSCS
        end if;

        select count(r.action_id)
        into ln_action_id
        from tim.rp_prov_ctrl_janus@dbl_bscs_bf r
        where r.customer_id = av_customerid
        and r.ord_id = (select max(rr.ord_id) from tim.rp_prov_ctrl_janus@dbl_bscs_bf rr
                               where rr.customer_id = r.customer_id
                               and rr.action_id in (1)
                               and rr.estado_prv = 5);

        if ln_action_id > 0 then
          return 2; -- Alta por SGA
        end if;

        return 9;
  exception
    when others then
        select count(r.action_id)
        into ln_action_id
        from tim.rp_prov_ctrl_janus@dbl_bscs_bf r
        where r.customer_id = av_customerid
        and r.ord_id = (select max(rr.ord_id) from tim.rp_prov_ctrl_janus@dbl_bscs_bf rr
                               where rr.customer_id = r.customer_id
                               and rr.action_id in (1)
                               and rr.estado_prv = 5);

        if ln_action_id > 0 then
          return 2; -- Alta por SGA
        end if;

        return 9;
  end;

--Insertamos en la Provision de Janus BSCS
  procedure p_insert_prov_bscs_janus(an_actionid number,
                                     an_priority number,
                                     an_customerid number,
                                     an_cod_id number,
                                     av_estadoprv varchar2,
                                     an_tarea number,
                                     av_trama varchar2,
                                     an_error out number,
                                     av_msgerror out varchar2) is
    ln_ordid    number;

    pragma autonomous_transaction;

  begin

    select tim.rp_janus_ord_id.nextval@dbl_bscs_bf
    into ln_ordid
    from dual;

    insert into tim.rp_prov_bscs_janus@dbl_bscs_bf
      (ord_id,
       action_id,
       priority,
       customer_id,
       co_id,
       estado_prv,
       tarea,
       valores)
    values
      (ln_ordid, an_actionid, an_priority, an_customerid, an_cod_id, av_estadoprv, an_tarea, av_trama);

    an_error := 1;
    av_msgerror := 'OK';

    commit;

  exception
    when others then
      rollback;
      an_error := -1;
      av_msgerror := 'Error al Insertar en la Provision : '|| sqlerrm;

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

    an_error := 1;
    av_msgerror := 'OK';

    commit;

  exception
    when others then
      rollback;
      an_error := -1;
      av_msgerror := 'Error al Insertar en la Provision : '|| sqlerrm;

  end p_insert_prov_ctrl_janus;

  -- procedimiento que valida si esta alineado en Janus y BSCS
 procedure p_val_datos_linea_janus(av_tipo          in varchar2,
                                   an_codsolot      in number,
                                   an_cod_id        in number,
                                   av_numero        in varchar2,
                                   av_customerjanus in varchar2,
                                   an_codplanjanus  in number,
                                   av_ciclojanus    in varchar2,
                                   an_valida        out number,
                                   av_mensaje       out varchar2) is

   ln_customer_id_bscs number;
   lv_numero_bscs      varchar2(70);
   lv_codplan_bscs     varchar2(10);
   lv_ciclo_bscsc      varchar2(2);

   lv_codclisga  varchar2(8);
   lv_numerosga  varchar2(10);
   ln_codplansga number;
   lv_ciclosga   varchar2(10);
   ln_codinssrv  number;

   lv_tramabscs  varchar2(4000);
   lv_tramajanus varchar2(4000);
   lv_tramasga   varchar2(4000);

   ln_contciclo number;
   error_datos exception; --7.0
 begin

   if av_tipo = 'BSCS' then

     begin
       -- Consulta la informacion en BSCS
       select distinct p.customer_id,
                       tim.tfun051_get_dnnum_from_coid@DBL_BSCS_BF(p.co_id) tn,
                       serv.codplan,
                       cu.billcycle
         into ln_customer_id_bscs,
              lv_numero_bscs,
              lv_codplan_bscs,
              lv_ciclo_bscsc
         from CONTRACT_all@DBL_BSCS_BF p,
              CUSTOMER_ALL@DBL_BSCS_BF cu,
              (select ssh.co_id,
                      plj.param1 codplan,
                      rp.des desc_plan,
                      OPERACION.PQ_CONT_REGULARIZACION.f_val_tipo_servicio_bscs(ssh.sncode) Tipo_Servicio
                 from pr_serv_status_hist@DBL_BSCS_BF   ssh,
                      profile_service@dbl_bscs_bf       ps,
                      mpusntab@DBL_BSCS_BF              sn,
                      contract_all@DBL_BSCS_BF          ca,
                      rateplan@DBL_BSCS_BF              rp,
                      tim.pf_hfc_parametros@DBL_BSCS_BF plj
                where ssh.sncode = sn.sncode
                  and ssh.status in ('A', 'O', 'S')
                  and ps.status_histno = ssh.histno
                  and ssh.sncode = ps.sncode
                  and ssh.co_id = ps.co_id
                  and ssh.co_id = ca.co_id
                  and ca.co_id = an_cod_id
                  and ca.tmcode = rp.tmcode
                  and ssh.sncode = plj.cod_prod1
                  and plj.campo = 'SERV_TELEFONIA'
                  and sn.sncode not in
                      (select o.codigon
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'SNCODENOHFC_BSCS')) serv
        where p.sccode = 6
          and p.co_id = serv.co_id
          and cu.customer_id = p.customer_id
          and serv.Tipo_Servicio = 'TLF'
          and p.co_id = an_cod_id;

     exception
       when others then
         av_mensaje := 'No informacion en BSCS' || sqlcode || ' - ' ||
                       sqlerrm; --3.0
         raise error_datos; --7.0
     end;

     lv_tramabscs := to_char(ln_customer_id_bscs) || lv_numero_bscs ||
                     lv_codplan_bscs || lv_ciclo_bscsc;

     -- Consulta la Informacion en Janus
     lv_tramajanus := trim(av_customerjanus) || trim(av_numero) ||
                      to_char(an_codplanjanus) || trim(av_ciclojanus);

     if lv_tramabscs != lv_tramajanus then
       an_valida := 0; -- Desalineado
     else
       an_valida := 1; -- Alineado
     end if;

   elsif av_tipo = 'SGA' then
     begin
       select distinct ins.numero, r.plan, '9' || ins.codcli, ins.codinssrv
         into lv_numerosga, ln_codplansga, lv_codclisga, ln_codinssrv
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
     exception
       when others then
         av_mensaje := 'No informacion en SGA' || sqlcode || ' - ' ||
                       sqlerrm; --3.0
         raise error_datos;
     end;
     select to_number(c.valor)
       into ln_contciclo
       from constante c
      where c.constante = 'CCICLO_JANUS';

     if ln_contciclo = 1 then
       lv_ciclosga := operacion.pq_sga_janus.f_get_ciclo_codinssrv(lv_numerosga,
                                                                   ln_codinssrv); --12.0
     else
       lv_ciclosga := '01';
     end if;

     lv_tramasga := trim(lv_codclisga) || trim(lv_numerosga) ||
                    to_char(ln_codplansga) || trim(lv_ciclosga);

     lv_tramajanus := trim(av_customerjanus) || trim(av_numero) ||
                      to_char(an_codplanjanus) || trim(av_ciclojanus);

     if lv_tramasga != lv_tramajanus then
       an_valida := 0; -- Desalineado
     else
       an_valida := 1; -- Alineado
     end if;

   elsif av_tipo = 'LTE' then
     --13.0
     begin
       -- Consulta la informacion en BSCS
       SELECT CA.CUSTOMER_ID,
              DN.DN_NUM,
              CA.BILLCYCLE CICLOFACT,
              (SELECT HD.PARAM1
                 FROM TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF HD
                WHERE HD.CAMPO = 'SERV_TELEFONIA_LTE'
                  AND HD.COD_PROD1 =
                      tim.pp021_venta_lte.f_get_serv_tel@DBL_BSCS_BF(cc.co_id))
         into ln_customer_id_bscs,
              lv_numero_bscs,
              lv_ciclo_bscsc,
              lv_codplan_bscs
         from contr_services_cap@dbl_bscs_bf csc,
              directory_number@dbl_bscs_bf   dn,
              customer_all@dbl_bscs_bf       ca,
              contract_all@dbl_bscs_bf       cc
        where csc.co_id = an_cod_id
          and csc.dn_id = dn.dn_id
          and cc.co_id = csc.co_id
          and cc.customer_id = ca.customer_id
          and csc.seqno = (select max(seqno)
                             from contr_services_cap@dbl_bscs_bf
                            where co_id = csc.co_id);
     exception
       when others then
         av_mensaje := 'No informacion en BSCS-LTE' || sqlcode || ' - ' ||
                       sqlerrm; --3.0
         raise error_datos; --7.0
     end;

     lv_tramabscs := to_char(ln_customer_id_bscs) || lv_numero_bscs ||
                     lv_codplan_bscs || lv_ciclo_bscsc;

     -- Consulta la Informacion en Janus
     lv_tramajanus := trim(av_customerjanus) || trim(av_numero) ||
                      to_char(an_codplanjanus) || trim(av_ciclojanus);

     if lv_tramabscs != lv_tramajanus then
       an_valida := 0; -- Desalineado
     else
       an_valida := 1; -- Alineado
     end if;
   end if;

 exception
   when error_datos then
     an_valida := -1;
   when others then
     an_valida  := -1;
     av_mensaje := 'ERROR al validar el numero  : ' || sqlcode || ' - ' ||
                   sqlerrm || ' (' || dbms_utility.format_error_backtrace || ')'; --3.0

 end p_val_datos_linea_janus;

  function f_val_prov_janus_pend(an_cod_id number) return number is
            ln_janus_act number;
      begin
            select count(1)
                  into ln_janus_act
                  from dual
            where exists (select 1 from tim.rp_prov_bscs_janus@dbl_bscs_bf pj
                            where pj.co_id = an_cod_id)
         or exists (select 1 from tim.rp_prov_ctrl_janus@dbl_bscs_bf pj
                            where pj.estado_prv <> 5--3.0
                                and pj.co_id = an_cod_id) ;

            return ln_janus_act;
      end;

  function f_obtiene_valores_scr(p_abreviacion opedd.abreviacion%type)
    return varchar2 is
    l_codigoc     opedd.codigoc%type;
    l_codigon     opedd.codigon%type;
    l_retorno     varchar2(100);

  begin
    select codigoc, codigon
      into l_codigoc, l_codigon
      from tipopedd c, opedd d
     where c.abrev = 'suspension'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_abreviacion;

    if p_abreviacion in ('tiptra_sp', 'tiptra_rx', 'codigomotivo') then
      l_retorno := to_char(l_codigon);
     else
      l_retorno := l_codigoc;
    end if;

    return l_retorno;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_datos_suspension(p_abreviacion => ' ||
                              p_abreviacion || ') ' || sqlerrm);
  end;

  function f_retorna_xml_recorta(av_xml clob) return varchar2
  is
   ln_xml varchar2(32767);
   ln_totalxml number;
   ln_inicioobsr number;
   ln_finobsr number;
   ln_restante number;
   v_observacion varchar2(32767);

  begin

    ln_xml := av_xml;

    ln_totalxml := length(ln_xml);

    if ln_totalxml > 4000 then

      ln_inicioobsr := instr(ln_xml,'<observaciones>',1,1)+15;
      ln_finobsr := instr(ln_xml,'</observaciones>',1,1);
      ln_restante := ln_totalxml - ln_finobsr;
      v_observacion := substr(substr(ln_xml, ln_inicioobsr, (ln_finobsr-ln_inicioobsr)),1, (4000 - (ln_restante + ln_inicioobsr)) ) ;

      ln_xml := substr(ln_xml, 1, ln_inicioobsr -1) || v_observacion || substr(ln_xml, ln_finobsr, ln_totalxml);

    end if;

    return ln_xml;
  -- fin 3.0
  end;
  -- ini 3.0
  procedure p_cambio_ciclo_bscs(an_codsolot number,
                                an_cod_idold number,
                                an_error out number,
                                av_error out varchar2)
  is

    ln_cod_id_new number;
    lv_ciclo varchar2(2);
    lv_flag varchar2(10);
    ln_reason number;
    ln_usuario varchar2(100);
    ln_tiptra number;
    lv_tipo varchar2(30);
    ln_existeco_id number;
    ln_status_con number;
    error_cambio_ciclo exception;

  begin

   lv_flag := null;

   select s.cod_id, s.tiptra into ln_cod_id_new, ln_tiptra
   from solot s where s.codsolot = an_codsolot;

   begin

     select o.abreviacion into lv_tipo
       from tipopedd t, opedd o
     where t.tipopedd = o.tipopedd
      and t.abrev = 'TIPTRABCAMBIOCICLO'
      and o.codigon = ln_tiptra;

   exception
    when others then
      av_error:= 'Tipo de trabajo no esta configurado para Cambio de ciclo BSCS';
      raise error_cambio_ciclo;
   end;

   if lv_tipo = 'ALTA' then

       select count(1) into ln_existeco_id
       from contract_all@Dbl_Bscs_Bf cc
       where cc.co_id = an_cod_idold
       and cc.sccode = 6;

       if ln_existeco_id > 0 then

           select distinct ca.billcycle into lv_ciclo
           from customer_all@Dbl_Bscs_Bf ca,
                contract_all@Dbl_Bscs_Bf cc
           where cc.customer_id = ca.customer_id
           and cc.co_id = an_cod_idold;

           if f_val_status_contrato(ln_cod_id_new) = 0 then
             lv_flag := '1';
           end if;

           if lv_flag is not null then
              TIM.TIM111_PKG_ACCIONES_SGA.SP_UPDATE_BILLCYCLE_HFC@Dbl_Bscs_Bf(ln_cod_id_new,
                                                                           null,
                                                                           lv_ciclo,
                                                                           lv_flag,
                                                                           null,
                                                                           null,
                                                                           an_error,
                                                                           av_error);
              if an_error = 0 then
                an_error := 1;
                av_error := 'Exito al realizar cambio de ciclo BSCS';
              else
                raise error_cambio_ciclo;
              end if;
           end if;
       else
          av_error := 'No existe Contrato Antiguo en BSCS';
          raise error_cambio_ciclo;
       end if;

   elsif lv_tipo = 'MIGRA' then

      -- Para el caso de Migracion el parametro an_cod_idold es la codsolot de la baja administrativa
      begin
        select distinct ip.cicfac into lv_ciclo
        from solotpto pto, insprd pp, instxproducto ip
        where pto.codinssrv = pp.codinssrv
        and pp.pid = ip.pid
        and pto.codsolot = an_cod_idold;
      exception
        when others then
          av_error:= 'Error en obtener el ciclo de facturacion de los servicios en SGA';
          raise error_cambio_ciclo;
       end;

       select count(1) into ln_existeco_id
       from contract_all@Dbl_Bscs_Bf cc
       where cc.co_id = ln_cod_id_new
       and cc.sccode = 6;

       if ln_existeco_id > 0 then

           if f_val_status_contrato(ln_cod_id_new) = 0 then
             lv_flag := '1';
           end if;

           if lv_flag is not null then
              TIM.TIM111_PKG_ACCIONES_SGA.SP_UPDATE_BILLCYCLE_HFC@Dbl_Bscs_Bf(ln_cod_id_new,
                                                                           null,
                                                                           lv_ciclo,
                                                                           lv_flag,
                                                                           null,
                                                                           null,
                                                                           an_error,
                                                                           av_error);
              if an_error = 0 then
                an_error := 1;
                av_error := 'Exito al realizar cambio de ciclo BSCS';
              else
                raise error_cambio_ciclo;
              end if;
           end if;
      else
          av_error := 'No existe Contrato en BSCS';
          raise error_cambio_ciclo;
      end if;
   end if;

   p_reg_log(null,
           null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            an_cod_idold,
            'Cambio de Ciclo BSCS');

  exception
    when error_cambio_ciclo then
      an_Error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_idold,
              'Cambio de Ciclo BSCS');
    when others then
      an_Error := -1;
      av_error := 'Error: ' || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
  end;

  function f_val_trs_susp(an_cod_id number,an_servi_cod number, ad_servd_fecha_reg date)
  return number is
  ln_trs number;
  ln_trs_pend number;
  ld_servd_fecha_reg date;
  ln_valido number;

  cursor c_evaluaprog is
     select servc_estado
     from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
     where servi_cod = an_servi_cod and SERVC_ESTADO in (1,2,4)
     and to_char(servd_fechaprog, 'DDMMYYYY') = to_char(ad_servd_fecha_reg ,'DDMMYYYY')
     and co_id= an_cod_id;

  ln_estuno number;
  ln_estdos number;
  ln_estcuatro number;

  begin

    ln_estuno := 0;
    ln_estdos := 0;
    ln_estcuatro := 0;

    select count(1) into ln_trs--Conteo de transacciones pendientes, en proceso y con error
    from USRACT.postt_servicioprog_fija@DBL_TIMEAI a
    where servi_cod=an_servi_cod and SERVC_ESTADO in (1,2,4)
    and to_char(servd_fechaprog, 'DDMMYYYY') = to_char(ad_servd_fecha_reg ,'DDMMYYYY')
    and co_id= an_cod_id;   --6.0

    if ln_trs > 1 then--Existe mas de un registro que se debe procesar

    for c in c_evaluaprog loop

        if c.servc_estado = 1 then
          ln_estuno := ln_estuno + 1;
        elsif c.servc_estado = 2 then
          ln_estdos := ln_estdos + 1;
        elsif c.servc_estado = 4 then
          ln_estcuatro := ln_estcuatro + 1;
        end if;

    end loop;

      if ln_estcuatro >= 1 then
        return 0;
      elsif ln_estdos >= 1 then
        return 0;
      elsif ln_estuno > 1 then
        return 0;
      end if;

    end if;

    if ln_trs = 1 then--No existe duplicidad de registro
      return 1;
    end if;

    return 0;  --6.0
  end;

  function f_val_factura_contrato(an_co_id number) return number is
    ln_valida  number;
    ln_factura number;

  begin

    select count(distinct ps.co_id)
      into ln_valida
      from profile_service@Dbl_Bscs_Bf ps, contract_history@Dbl_Bscs_Bf c
     where ps.co_id = c.co_id
       and c.ch_seqno = (select max(cc.ch_seqno)
                           from contract_history@Dbl_Bscs_Bf cc
                          where cc.co_id = c.co_id)
       and ps.co_id = an_co_id
       and upper(c.ch_status) = 'A'
       and ps.date_billed is null;

    if ln_valida = 0 then
      ln_factura := 1; -- Activo y Facturanado;
    elsif ln_valida > 0 then
      ln_factura := 0; -- Activo y sin facturar
    end if;

    return ln_factura;

  end;

  function f_val_status_contrato(an_co_id number) return number is

    lv_ch_status varchar2(1);
    lv_ch_pending varchar2(1);
    ln_return number;
  begin

     select c.ch_status, c.ch_pending
     into lv_ch_status, lv_ch_pending
     from contract_history@Dbl_Bscs_Bf c
     where c.co_id = an_co_id
           and c.ch_seqno = (select max(cc.ch_seqno) from contract_history@Dbl_Bscs_Bf cc
                            where cc.co_id = c.co_id);

     if lower(lv_ch_status) = 'o' or (lower(lv_ch_status) = 'a' and lower(lv_ch_pending) = 'x') then
       ln_return := 0; -- Onhold y Activo con pendiente
     elsif lower(lv_ch_status) = 'a' and lv_ch_pending is null then
       ln_return := 1; -- Activo y sin pendiente
     elsif lower(lv_ch_status) = 's' and lv_ch_pending is null then
       ln_return := 2; -- Suspendido y sin pendiente
     elsif lower(lv_ch_status) = 's' and lower(lv_ch_pending) = 'x' then
       ln_return := 3; -- Suspendido y con pendiente
     elsif lower(lv_ch_status) = 'd' and lv_ch_pending is null then
       ln_return := 4; -- Contrato Desactivo y sin pendiente
     elsif lower(lv_ch_status) = 'd' and lower(lv_ch_pending) = 'x' then
       ln_return := 5; -- Contrato Desactivo y con pendiente
     end if;  --6.0

     return ln_return;
  end;

  function f_val_nofact_act_contr(an_co_id number) return varchar2
  is

  ln_est_contrato number;
  ln_factura_contr number;

  begin
    ln_est_contrato := f_val_status_contrato(an_co_id);
    ln_factura_contr := f_val_factura_contrato(an_co_id);

    if ln_est_contrato = 1 and ln_factura_contr = 0 then -- Contrato Activo y sin facturar
      return '3';
    elsif ln_est_contrato = 1 and ln_factura_contr = 1 then -- Contrato Activo y facturando
      return '4';
    elsif ln_est_contrato = 0 then -- Contrato en OnHold, Activo con pending
      return '1';
    end if;

    return '0';
  end;

  procedure p_cambio_newciclo_bscs(an_codsolot number,
                                   an_cod_idold number,
                                   av_newciclo varchar2,
                                   an_error out number,
                                   av_error out varchar2)
  is

    ln_cod_id_new number;
    lv_flag varchar2(10);
    ln_tiptra number;
    lv_tipo varchar2(30);
    ln_existeco_id number;
    error_cambio_ciclo exception;

  begin

   lv_flag := null;

   select s.cod_id, s.tiptra into ln_cod_id_new, ln_tiptra
   from solot s where s.codsolot = an_codsolot;

   select count(1) into ln_existeco_id
   from contract_all@Dbl_Bscs_Bf cc
   where cc.co_id = ln_cod_id_new
   -- INI 12.0
   and (cc.sccode = 6 or (cc.sccode = 1 and cc.tmcode in
   (select x.valor1 from tim.tim_parametros@Dbl_Bscs_Bf x where x.campo = 'PLAN_LTE'))); -- LFLORES Agregar condicion que funcion para HFC y LTE
   -- FIN 12.0
   if ln_existeco_id > 0 then

       lv_flag := f_val_nofact_act_contr(ln_cod_id_new);

       if lv_flag != '0' then

          TIM.TIM111_PKG_ACCIONES_SGA.SP_UPDATE_BILLCYCLE_HFC@Dbl_Bscs_Bf(ln_cod_id_new,
                                                                          null,
                                                                          av_newciclo,
                                                                          lv_flag,
                                                                          null,
                                                                          null,
                                                                          an_error,
                                                                          av_error);
          if an_error = 0 then
            an_error := 1;
            av_error := 'Exito al realizar cambio de ciclo BSCS';
          else
            raise error_cambio_ciclo;
          end if;
       end if;
   else
      av_error := 'No existe Contrato en BSCS (HFC o LTE)';  -- 12.0
      raise error_cambio_ciclo;
   end if;

   p_reg_log(null,
            null,
            NULL,
            an_codsolot,
            null,
            an_Error,
            av_error,
            an_cod_idold,
            'Cambio de Ciclo BSCS');

  exception
    when error_cambio_ciclo then
      an_Error := -1;
      p_reg_log(null,
              null,
              NULL,
              an_codsolot,
              null,
              an_Error,
              av_error,
              an_cod_idold,
              'Cambio de Ciclo BSCS');
    when others then
      an_Error := -1;
      av_error := 'Error: ' || sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
  end p_cambio_newciclo_bscs;
  -- fin 3.0
procedure p_genera_sot_suspension is
    d_fecinisuspsiac date;

    cursor c_s is  --6.0
    select a.co_id, a.customer_id, a.servd_fechaprog, a.servi_cod, a.servv_cod_error,
    a.servd_fecha_reg,a.servc_estado,a.tipo_serv,a.co_ser,a.tipo_reg, a.servc_codigo_interaccion,
    to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 1, 4000)) xml1,
    case
    when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 4000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 8000 then
    to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 4001,  8000))
    end xml2,
    case
    when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 8000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 12000 then
    to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 8001,  12000))
    end xml3
    from usract.postt_servicioprog_fija@dbl_timeai a
    where a.servi_cod = 3
    and a.servc_estado = 1
    and a.servd_fechaprog >= d_fecinisuspsiac
    and a.servd_fechaprog <= trunc(sysdate);

    n_codsolot      number;
    n_res_cod       number;
    v_res_desc      varchar2(400);
    n_idseq         number;
    n_customer_id   number;
    n_tiptra        number;
    v_observacion   solot.observacion%type;
    v_franjahoraria varchar2(400);
    n_codigomotivo  solot.codmotot%type;
    v_codigoplano   agendamiento.idplano%type;
    v_usuarioasesor usuarioope.usuario%type;
    n_estado        number;
    n_nro_dias      number;
    n_fideliza      number;
    v_fecha_susp    varchar2(200);
    p_estado        number;
    p_customer_id   number;
    p_dn_num        varchar2(63);
    p_email         varchar2(200);
    v_xml  varchar2(32767);
    lv_xml varchar2(32767);
    v_usuario        varchar2(400);  --6.0
    an_coderror number;
    av_msgerror varchar2(4000);
    exception_general exception;
    ln_cont_bloq number;  --6.0
    v_tickler_code varchar2(400);  --6.0
    p_tickler_desc varchar2(2000);  --6.0
    ln_flag        number;
  begin

    select to_date(valor, 'dd/mm/yyyy') into d_fecinisuspsiac from constante where constante = 'DATESUSSIACINI';

    for c in c_s loop  --6.0
      begin
          select to_number(c.valor) into ln_flag
            from constante c where c.constante = 'REGUREQUESTCOSX'; -- <10.0>
          -- from constante c where c.constante = 'REGUREQUESTCOID'; -- <10.0>
          if ln_flag = 1 then
            operacion.pq_sga_bscs.p_libera_request_co_id(c.co_id,an_coderror,av_msgerror);
          end if;

          lv_xml :=c.xml1||nvl(c.xml2,'')||nvl(c.xml3,'');
          v_xml := f_retorna_xml_recorta(lv_xml);

          if f_val_trs_susp(c.co_id,c.servi_cod,c.servd_fechaprog) = 1 then --Transaccion Valida

              n_nro_dias   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'nroDias');
              n_fideliza   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'fideliza');
              v_fecha_susp := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'fechaSuspension');
              v_usuario    := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'usuarioSistema');

              select count(1) into ln_cont_bloq from constante c
              where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
              if ln_cont_bloq = 0 then
                 v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'ticklerCode');
              else
                select c.valor into v_tickler_code from constante c
                where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
              end if;

              p_insert_ope_sol_siac(c.co_id, c.customer_id, v_xml, c.servd_fecha_reg, c.tipo_serv,
                                  c.co_ser, c.servi_cod, c.tipo_reg, c.servc_codigo_interaccion,
                                  n_fideliza, c.servd_fechaprog, n_idseq, an_coderror, av_msgerror);

              if an_coderror = -1 then
                raise exception_general;
              end if;

              p_tickler_desc := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'desTickler');

              --Regulariza los request
              p_regulariza_reques_pend(c.co_id,an_coderror,av_msgerror);
              --Valida Suspension
              operacion.pq_sga_iw.sp_valida_suspension(c.co_id,n_nro_dias,n_fideliza,v_fecha_susp,v_usuario,v_tickler_code,
                                                       p_tickler_desc,p_estado,p_customer_id,p_dn_num,p_email); --6.0


              if p_estado < 0 then
                if p_estado = -2 then
                  n_estado   := 5;
                  v_res_desc := 'Contrato se encuentra Desactivo';
                elsif p_estado = -10 then
                  n_estado   := 5;
                  v_res_desc := 'Contrato se encuentra Suspendido';
                elsif p_estado = -11 then --Ini 6.0
                  n_estado   := 5;
                  v_res_desc := 'Contrato se encuentra Suspendido con Bloqueo por Cobranza'; -- Fin 6.0
                else
                  n_estado   := 4;
                  v_res_desc := 'No cumple requisitos para generar Suspension';
                end if;
              else

                n_customer_id   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'codCliente');
                n_tiptra        := operacion.pq_sga_iw.f_obtiene_valores_scr('tiptra_sp');
                v_observacion   := null;
                v_franjahoraria := operacion.pq_sga_iw.f_obtiene_valores_scr('franjaHoraria');
                n_codigomotivo  := operacion.pq_sga_iw.f_obtiene_valores_scr('codigomotivo');

                begin
                  select distinct d1.idplano into v_codigoPlano from solot a1, solotpto b1, inssrv c1, vtasuccli d1
                   where a1.codsolot = b1.codsolot and b1.codinssrv = c1.codinssrv and c1.codsuc = d1.codsuc
                     and a1.cod_id = c.co_id and b1.idplano is not null and rownum = 1;
                exception
                  when no_data_found then
                    v_codigoPlano := '';
                end;

                v_usuarioAsesor := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'usuarioApp');

                p_genera_sot_bscs(n_customer_id,
                                  c.co_id,
                                  n_tiptra,
                                  sysdate,
                                  v_franjahoraria,
                                  n_codigoMotivo,
                                  v_observacion,
                                  v_codigoPlano,
                                  v_usuarioAsesor,
                                  n_codsolot,
                                  n_res_cod,
                                  v_res_desc);

                if n_res_cod = 1 then
                  n_estado := 2;
                end if;
                if n_res_cod = -1 or  n_res_cod = 0 then
                  --error
                  n_estado := 4;
                end if;
              end if;

            p_update_ope_sol_siac(n_idseq,n_codsolot,n_customer_id,n_estado,n_res_cod, v_res_desc,an_coderror,av_msgerror);
              --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija(n_estado, v_res_desc, p_estado, c.co_id, c.servi_cod,
                                             c.servd_fecha_reg, an_coderror, av_msgerror);
          else
            --Se anula la transaccion
            p_update_postt_serv_fija(5, 'Duplicidad de Contrato de Suspension.',-1, c.co_id,c.servi_cod,
                                             c.servd_fecha_reg,an_coderror, av_msgerror);
          end if;
      exception
        when exception_general then
            p_update_postt_serv_fija(4, av_msgerror, an_coderror,c.co_id, c.servi_cod, c.servd_fecha_reg,
                                        an_coderror, av_msgerror);
      end;
    end loop; --6.0

  end;

procedure p_genera_corte_suspension(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number)  is

    v_tickler_code   varchar2(400);
    v_desc_tickler   varchar2(400);
    v_usuario        varchar2(400);
    p_resultado      number;
    p_msgerr         varchar2(400);
    n_idseq         number;
    v_err varchar2(2000);
    n_cod_id number;
    n_codsolot number;
    an_coderror number;
    av_msgerror varchar2(4000);
    ln_cont_bloq number;
    ln_status_contrato number;
    ln_val_bloqueo number;

    cursor c_a is
    select co_id, customer_id, xmlclob xml_siac, fecha_reg, idseq
    from operacion.ope_sol_siac where codsolot=n_codsolot;

  begin
       begin
        select codsolot into n_codsolot from wf where idwf=a_idwf and valido = 1;

        for c in c_a loop
          n_cod_id:=c.co_id;
          n_idseq := c.idseq;
          --Realiza corte de Internet, Cable, Telefonia
          select count(1) into ln_cont_bloq from constante c
          where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';

          if ln_cont_bloq = 0 then
             v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'ticklerCode');
          else
            select c.valor into v_tickler_code from constante c
            where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
          end if;

          v_desc_tickler := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'desTickler');
          v_usuario      := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'usuarioSistema');

          -- Valida si el contrato  --6.0
          ln_status_contrato := f_val_status_contrato(n_cod_id);
          ln_val_bloqueo := f_val_ticklerrecord_siac_open(n_cod_id,v_tickler_code);

          --Contrato activo
          if ln_status_contrato in (0,1) and ln_val_bloqueo != 3 then

             tim.pp021_venta_hfc.sp_corte@dbl_bscs_bf(n_cod_id,v_tickler_code,v_desc_tickler,v_usuario,p_resultado,p_msgerr);

            update tim.pf_hfc_prov_bscs@dbl_bscs_bf  set estado_prv=5,fecha_rpt_eai=sysdate
            where co_id=n_cod_id and action_id=5  and to_char(fecha_insert,'yyyymmdd') = to_char(sysdate,'yyyymmdd');

            if p_resultado < 0 then
              p_update_ope_sol_siac(n_idseq,n_codsolot,null,4,p_resultado, p_msgerr, an_coderror,av_msgerror);
            end if;
          end if;
        end loop;
      exception
        when others then
          rollback;

          v_err:=$$plsql_unit ||'. Error al procesar el SP: p_genera_corte_suspension' || sqlerrm;

          p_update_ope_sol_siac(n_idseq,null,null,4,-1,v_err,an_coderror,av_msgerror);

          p_reg_log(null, null,NULL, n_codsolot, null, null, v_err,n_cod_id);

          raise_application_error(-20000,v_err);
      end;
      commit;
  end;

procedure sp_valida_suspension( p_co_id        IN  INTEGER,
                     p_nro_dias     IN  INTEGER,
                     p_fideliza     IN  INTEGER,
                     p_fec_susp     IN  VARCHAR2,
                     p_username     IN  VARCHAR2,  --6.0
                     p_tickler_code in  varchar2,  --6.0
                     p_tickler_desc in varchar2,  --6.0
                     p_estado       OUT INTEGER,
                     p_customer_id  OUT INTEGER,
                     p_dn_num       OUT VARCHAR2,
                     p_email        OUT VARCHAR2 )
 IS
   ERR_CONTRATO_NO_VALIDO       CONSTANT NUMBER := -1;
   ERR_CONTRATO_INACTIVO        CONSTANT NUMBER := -2;
   ERR_CONTRATO_BLOQ            CONSTANT NUMBER := -3;
   ERR_SUSPENSION_EXCESO        CONSTANT NUMBER := -5;
   ERR_NRODIAS_INVALID          CONSTANT NUMBER := -6;
   ERR_FEC_SUSP_INVALID         CONSTANT NUMBER := -7;
   ERR_OTROS                    CONSTANT NUMBER := -9;
   SUSPENSION_VALIDA            CONSTANT NUMBER := 1;
   VAL_NO_FIDELIZA_MINIMO_D     CONSTANT NUMBER := 15;
   VAL_NO_FIDELIZA_MAXIMO_D     CONSTANT NUMBER := 62;
   VAL_FIDELIZA_MINIMO_D        CONSTANT NUMBER := 1;
   VAL_FIDELIZA_MAXIMO_D        CONSTANT NUMBER := 152;
   ERR_CONTRATO_SUSPENDIDO      CONSTANT NUMBER := -10;  --6.0
   ERR_CONTRATO_SUSPENDIDO_COB  CONSTANT NUMBER := -11; --6.0
   v_estado                     VARCHAR2(1);
   v_tickler                    NUMBER;
   v_existe_bloqueo             INTEGER;
   v_fec_min                    DATE;
   v_dias_susp                  INTEGER;
   v_fideliza                   INTEGER;
   v_min_dias                   INTEGER;
   v_max_dias                   INTEGER;
   v_numero                     VARCHAR2(20);
   ln_status_co_id              number;  --6.0
   an_coderror                  number;  --6.0
   ln_existe_bloqueo            number;  --6.0

 BEGIN
    p_estado := 0;
    v_fideliza := p_fideliza;

    IF p_fideliza IS NULL THEN
       v_fideliza := 0;
    END IF;

    v_min_dias := VAL_NO_FIDELIZA_MINIMO_D;
    v_max_dias := VAL_NO_FIDELIZA_MAXIMO_D;

    IF v_fideliza = 1 THEN
       v_min_dias := VAL_FIDELIZA_MINIMO_D;
       v_max_dias := VAL_FIDELIZA_MAXIMO_D;
    END IF;

    IF p_co_id IS NULL THEN
       p_estado := ERR_CONTRATO_NO_VALIDO;
    END IF;

    IF p_nro_dias IS NULL OR p_nro_dias <= 0 OR p_nro_dias > v_max_dias OR p_nro_dias < v_min_dias THEN
       p_estado := ERR_NRODIAS_INVALID;
    END IF;

    IF p_fec_susp IS NULL THEN
       p_estado := ERR_FEC_SUSP_INVALID;
    END IF;

    -- Verificando CONTRATO
    ln_status_co_id := f_val_status_contrato(p_co_id);

    if ln_status_co_id = 2 then -- Contrato Suspendido
       ln_existe_bloqueo := f_val_ticklerrecord_siac_open(p_co_id, p_tickler_code);

       if ln_existe_bloqueo = 3 then -- 6.0
         p_create_tickler_code_bscs(p_co_id, p_tickler_code, p_tickler_desc, p_username, an_coderror);
         commit;
         p_estado := ERR_CONTRATO_SUSPENDIDO_COB;
       elsif ln_existe_bloqueo in (1,2) then -- 6.0
         p_estado := ERR_CONTRATO_SUSPENDIDO;
       end if;
    elsif ln_status_co_id = 4 then -- Contrato Inactivo
       p_estado := ERR_CONTRATO_INACTIVO;
    end if;

    IF p_estado = 0 THEN
       BEGIN

       v_numero:= tim.tfun051_get_dnnum_from_coid@dbl_bscs_bf(p_co_id);

       IF v_numero = -1 THEN

          SELECT co.customer_id, null dn_num, substr(nvl(cc.ccemail, 'CORREO NO REGISTRADO'), 1, 100)
            INTO p_customer_id, p_dn_num, p_email
            FROM SYSADM.contract_all@DBL_BSCS_BF co, SYSADM.ccontact_all@DBL_BSCS_BF cc
           WHERE co.co_id = p_co_id
             AND cc.customer_id = co.customer_id
             AND cc.ccbill = 'X';

        ELSE

          SELECT co.customer_id, dn.dn_num, substr(nvl(cc.ccemail, 'CORREO NO REGISTRADO'), 1, 100)
            INTO p_customer_id, p_dn_num, p_email
            FROM SYSADM.contract_all@DBL_BSCS_BF co, SYSADM.ccontact_all@DBL_BSCS_BF cc,
                 SYSADM.curr_contr_services_cap@DBL_BSCS_BF csc, SYSADM.directory_number@DBL_BSCS_BF dn
           WHERE co.co_id = p_co_id
             AND cc.customer_id = co.customer_id
             AND cc.ccbill = 'X'
             AND csc.co_id = co.co_id
             AND csc.main_dirnum = 'X'
             AND csc.cs_deactiv_date IS NULL
             AND csc.dn_id = dn.dn_id;

        END IF;

       EXCEPTION
         WHEN no_data_found THEN
              p_customer_id := 0; p_dn_num := ''; p_email := '';
              p_estado := ERR_CONTRATO_NO_VALIDO;
       END;
    END IF;

    -- Verificando BLOQUEO x FRAUDE
    IF p_estado = 0 THEN
       BEGIN
         SELECT ssh.status, ssh.request_id
           INTO v_estado, v_tickler
           FROM sysadm.profile_service@dbl_bscs_bf ps, sysadm.pr_serv_status_hist@dbl_bscs_bf ssh
          WHERE ps.co_id = p_co_id
            AND ps.sncode = 9
            AND ps.co_id = ssh.co_id
            AND ps.sncode = ssh.sncode
            AND ps.Profile_Id = ssh.profile_id
            AND ps.status_histno = ssh.histno;

         IF v_estado = 'A' THEN
            SELECT COUNT(*) INTO   v_existe_bloqueo
              FROM SYSADM.tickler_records@dbl_bscs_bf tr
             WHERE tr.co_id = p_co_id
               AND tr.tickler_code IN ('BLOQ_FRA', 'BLOQ_COB', 'BLOQ_ROB')
               AND tr.tickler_status = 'OPEN';
         END IF;
       EXCEPTION
         WHEN no_data_found THEN
              v_estado := 'D';
       END;

       IF v_estado = 'A' AND v_existe_bloqueo > 0 THEN
          p_estado := ERR_CONTRATO_BLOQ;
       END IF;
    END IF;

    -- Verificando Suspension acumulada en el ultimo a?o
    IF p_estado = 0 THEN
       BEGIN
         SELECT NVL(CH1.CH_VALIDFROM,TRUNC(SYSDATE))
         INTO v_fec_min
         FROM sysadm.contract_history@dbl_bscs_bf ch1
         WHERE ch1.co_id = p_co_id
               AND ch1.ch_seqno = (SELECT nvl(MAX(ch_seqno),0)
                                   FROM SYSADM.contract_history@dbl_bscs_bf
                                   WHERE co_id = ch1.co_id AND ch_status = 's'
                                         AND ch_validfrom >= trunc(SYSDATE,'YYYY')
                                 );
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              v_fec_min := SYSDATE;
       END;

       SELECT nvl(SUM(trunc(nvl(ch2.ch_validfrom, SYSDATE)) - trunc(ch1.ch_validfrom)),0) dias
         INTO v_dias_susp
         FROM sysadm.contract_history@dbl_bscs_bf ch1, SYSADM.contract_history@dbl_bscs_bf ch2
        WHERE ch2.ch_status IN ('a', 'd')
          AND ch2.ch_seqno = (SELECT MIN(ch_seqno)
                              FROM sysadm.contract_history@dbl_bscs_bf
                              WHERE co_id = ch2.co_id
                                 AND ch_seqno > ch1.ch_seqno)
          AND ch2.ch_validfrom >= v_fec_min
          AND ch1.co_id = ch2.co_id
          AND ch1.ch_status = 's'
          AND ch1.co_id = p_co_id
          AND ch1.ch_validfrom >= v_fec_min ;

       IF v_dias_susp + p_nro_dias > v_max_dias THEN
          p_estado := ERR_SUSPENSION_EXCESO;
       END IF;
    END IF;

    IF p_estado = 0 THEN
       p_estado := SUSPENSION_VALIDA;
    END IF;

 EXCEPTION
   WHEN OTHERS THEN
        p_estado := ERR_OTROS;
 END;

procedure p_actualiza_contrato_sp(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is

    n_codsolot number;

    cursor c_a is
      select co_id, customer_id, xmlclob xml_siac, fecha_reg, servi_cod, idseq
      from operacion.ope_sol_siac where codsolot=n_codsolot;

    v_tickler_code   varchar2(400);
    v_desc_tickler   varchar2(400);
    v_usuario        varchar2(400);
    n_reason         number;
    p_request_id     number;
    n_idseq         number;
    n_customer_id   number;
    v_codocc       varchar2(30);
    v_FecVig       varchar2(20);
    v_NumCuo       varchar2(10);
    n_monto_occ    number;
    p_Result       number;
    v_err varchar2(2000);
    an_coderror number;
    av_msgerror varchar2(4000);
    ln_cont_bloq number;

    begin
        begin

          select codsolot into n_codsolot from wf where idwf=a_idwf and valido =1;

          for c in c_a loop
            n_idseq := c.idseq;

            --Actualiza Contrato
            select count(1) into ln_cont_bloq from constante c
            where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';

            if ln_cont_bloq = 0 then
               v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'ticklerCode');
            else
              select c.valor into v_tickler_code from constante c
              where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
            end if;

            --v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'ticklerCode');
            v_desc_tickler := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'desTickler');
            n_reason       := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'reason');
            v_usuario      := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'usuarioSistema');

            operacion.pq_sga_iw.sp_contract_suspension(c.co_id,v_tickler_code,v_desc_tickler, n_reason,
                                            v_usuario,p_request_id);
            if p_request_id > 0 then--exito
              --Actualiza Programacion a estado En Ejecucion
              p_update_postt_serv_fija(3, 'Exito', 1, c.co_id, c.servi_cod, c.fecha_reg, an_coderror, av_msgerror);

              p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id,3,p_request_id,'Exito', an_coderror,av_msgerror);

            else
              --Actualiza Programacion a estado En Ejecucion
              p_update_postt_serv_fija(4, 'Error', -1, c.co_id, c.servi_cod,c.fecha_reg, an_coderror, av_msgerror);

              p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id,4,p_request_id,'Error', an_coderror,av_msgerror);

            end if;

          end loop;
        exception
          when others then
            rollback;
            v_err:=$$plsql_unit ||'. Error al procesar el SP: p_actualiza_contrato_suspension' || sqlerrm;

            p_update_ope_sol_siac(n_idseq,n_codsolot,null,4,p_request_id,v_err,an_coderror,av_msgerror);

            p_reg_log(null, null,NULL, n_codsolot, null, null, v_err,null);
            raise_application_error(-20000,v_err);
        end;
        commit;
    end;

procedure sp_contract_suspension( p_co_id        IN  NUMBER,
                                   p_tickler_code IN  VARCHAR2,
                                   p_tickler_des  IN  VARCHAR2,
                                   p_reason       IN  NUMBER,
                                   p_username     IN  VARCHAR2,
                                   p_request_id   OUT NUMBER )
 IS
   v_gmd_status      number;
   v_cnt             number;
   v_switch_id       varchar2(7);
   v_gmd_market_id   varchar2(3);
   v_customer_id     number;
   v_sccode          number;
   v_plcode          number;
   v_request_date    date;
   v_ch_status       varchar2(1);
   v_tickler_number  number;
   v_cnt_user        number;
   v_pending_request number;
   v_cnt_t           number;
   v_cnt_control     number;
   v_cnt_tn          number;
   v_cnt_c           NUMBER;
   v_short_desc      varchar2(20);
   p_tickler_number  number;
   C_INVALID_REASON     CONSTANT NUMBER(2) := -1;    -- Motivo de acci?n incorrecto
   C_INVALID_STATUS     CONSTANT NUMBER(2) := -2;    -- El estado actual o propuesto del contrato no permite ejecutar la acci?n
   C_INVALID_USER       CONSTANT NUMBER(2) := -3;    -- Usuario inv?lido
   C_PENDING_REQUEST    CONSTANT NUMBER(2) := -4;    -- Tiene request pendiente
   C_INVALID_CONTRACT   CONSTANT NUMBER(2) := -5;    -- Id de contrato inv?lido
   C_EXCEPTION_OTHERS   CONSTANT NUMBER(2) := -6;    -- Ocurri? otra excepci?n
   C_TICKLER_ALIGNMENT_SHORT_DES  CONSTANT VARCHAR2(20) := 'ALINEACION PKG111';
   ln_valtickler_cob number;  --6.0
   an_coderror       number;  --6.0

 BEGIN
   -- Valida el motivo de suspensi?n
   SELECT COUNT(rs_id) INTO v_cnt FROM reasonstatus_all@dbl_bscs_bf WHERE rs_status = 's' AND rs_id = p_reason;
   IF v_cnt = 0 THEN
      p_request_id := C_INVALID_REASON;
      RETURN;
   END IF;

   -- Valida el usuario
   SELECT COUNT(username) INTO v_cnt_user FROM users@dbl_bscs_bf WHERE username = p_username;
   IF v_cnt_user <= 0 THEN
      p_request_id := C_INVALID_USER;
      RETURN;
   END IF;

   -- Verifica que el contrato exista y que est? activo
   BEGIN
     SELECT ch_status INTO v_ch_status FROM curr_co_status@dbl_bscs_bf ch WHERE co_id = p_co_id;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          p_request_id := C_INVALID_CONTRACT;
          RETURN;
   END;

   -- Valida si cuenta con Bloqueo por Cobranzas(solo insertamos el tickler)  --6.0
   ln_valtickler_cob := f_val_ticklerrecord_siac_open(p_co_id, p_tickler_code);

   if v_ch_status = 's' and ln_valtickler_cob = 3 then

     p_create_tickler_code_bscs(p_co_id, p_tickler_code, p_tickler_des, p_username, an_coderror);

     p_request_id := C_INVALID_STATUS;
     RETURN;
   end if;

   IF v_ch_status <> 'a' THEN
      p_request_id := C_INVALID_STATUS;
      RETURN;
   END IF;

   -- Validar requests pendientes
   SELECT COUNT(request) INTO v_pending_request FROM contract_history@dbl_bscs_bf WHERE co_id = p_co_id AND ch_pending = 'X';
   IF v_pending_request = 0 THEN
      SELECT COUNT(request) INTO v_pending_request FROM mdsrrtab@dbl_bscs_bf WHERE co_id = p_co_id AND request_update IS NULL
      AND status NOT IN (9, 7);
   END IF;

   IF v_pending_request > 0 THEN
      p_request_id := C_PENDING_REQUEST;
      RETURN;
   END IF;

   -- Si tiene tickler abierto por el mismo motivo lo cierra
    SELECT COUNT(tickler_number) INTO v_cnt_t FROM tickler_records@dbl_bscs_bf
  WHERE co_id = p_co_id AND tickler_code = p_tickler_code
       AND tickler_status = 'OPEN';

   IF v_cnt_t > 0 THEN

      UPDATE tickler_records@dbl_bscs_bf
       SET tickler_status = 'CLOSED',
           short_description = decode(1, 1, C_TICKLER_ALIGNMENT_SHORT_DES, short_description),
           modified_by = p_username, closed_by = p_username,
           closed_date = SYSDATE, modified_date = SYSDATE
     WHERE co_id = p_co_id
       AND tickler_code = p_tickler_code
       AND tickler_status = 'OPEN';
       COMMIT;

   END IF;

   -- Ejecuta la suspensi?n
   SELECT hl.switch_id INTO v_switch_id FROM curr_co_device@dbl_bscs_bf cd, mpdhltab@dbl_bscs_bf hl
    WHERE cd.co_id = p_co_id AND cd.hlcode = hl.hlcode;

   SELECT gmd.gmd_market_id, co.customer_id, co.sccode, co.plcode, decode(gmd.bypass_ind, 'Y', 15, 2)
     INTO v_gmd_market_id, v_customer_id, v_sccode, v_plcode, v_gmd_status
     FROM gmd_mpdsctab@dbl_bscs_bf gmd, contract_all@dbl_bscs_bf co
    WHERE co.co_id = p_co_id AND co.sccode = gmd.sccode;

   -- Create request
   sysadm.nextfree.getvalue@dbl_bscs_bf('MAX_REQUEST', p_request_id);
   v_request_date := SYSDATE;

   INSERT INTO gmd_request_base@dbl_bscs_bf VALUES(p_request_id, v_request_date);

   INSERT INTO mdsrrtab@dbl_bscs_bf
          ( request, action_id, data_1, data_2, data_3, status, error_code, ts,
            insert_date, plcode, userid, customer_id, co_id, worker_pid, priority, action_date,
            sccode, gmd_market_id, switch_id )
        VALUES
          ( p_request_id, 4, NULL, NULL, NULL, v_gmd_status, 0, v_request_date,
            v_request_date, v_plcode, p_username, v_customer_id, p_co_id, 0, 8, v_request_date,
            v_sccode, v_gmd_market_id, v_switch_id );

   -- Create response
   INSERT INTO gmd_response@dbl_bscs_bf ( response_seqno, request, response_result, retry_ind, effective_date)
        VALUES ( 1, p_request_id, 'SUCCESS', 'N', v_request_date);

   -- Change services
   sysadm.contract.changestateservices@dbl_bscs_bf(p_co_id, p_request_id, 's', v_request_date, 5);

   -- Change contract
   UPDATE contract_all@dbl_bscs_bf SET co_timm_modified = 'X' WHERE co_id = p_co_id;
   sysadm.contract.changestatecontract@dbl_bscs_bf(p_co_id, p_request_id, 's', v_request_date, p_reason, p_username);

   -- Si el contrato es plan Control insertar registro para la interfaz prepago/IN
   SELECT COUNT(sncode) INTO v_cnt_control FROM profile_service@dbl_bscs_bf WHERE co_id = p_co_id AND sncode = 73;

   IF v_cnt_control > 0 THEN
      INSERT INTO tim.tim_prepaid_contract_request@dbl_bscs_bf ( co_id, username, status, recharge, insert_date)
           VALUES ( p_co_id, p_username, 's', 'N', SYSDATE);
   END IF;

   -- Abre tickler de suspensi?n
    -- Obtiene la cantidad de ticklers abiertos
    SELECT COUNT(co_id), nvl(MAX(tickler_number), 0)
    INTO v_cnt_tn , p_tickler_number
    FROM tickler_records@dbl_bscs_bf  WHERE co_id = p_co_id
    AND tickler_code = p_tickler_code AND tickler_status = 'OPEN';

    IF v_cnt_tn = 0 THEN
       SELECT customer_id INTO v_customer_id FROM contract_all@dbl_bscs_bf WHERE co_id = p_co_id;
       SELECT short_desc INTO v_short_desc FROM tickler_code_def@dbl_bscs_bf WHERE tickler_Code = p_tickler_code;

       sysadm.NextFree.GetValue@dbl_bscs_bf('MAX_TICKLER_NUMBER', p_tickler_number);

       INSERT INTO tickler_records@dbl_bscs_bf
               ( customer_id, co_id, tickler_number, tickler_code,
                 tickler_status, priority, follow_up_date, created_by,
                 created_date, short_description, long_description, rec_version)
            VALUES
               ( v_customer_id, p_co_id, p_tickler_number, p_tickler_code,
                 'OPEN', 1, SYSDATE, p_username, SYSDATE, v_short_desc,
                 decode(p_tickler_des, NULL, v_short_desc, p_tickler_des), 1);
       COMMIT;
    END IF;
 EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        p_request_id := C_EXCEPTION_OTHERS;
 END;

procedure p_genera_sot_reconexion is
    d_fecinirecsiac date;
    cursor c_s is
      select a.co_id, a.customer_id, a.servd_fechaprog, a.servi_cod, a.servv_cod_error,
      a.servd_fecha_reg,a.servc_estado, a.tipo_serv,a.co_ser,a.servc_codigo_interaccion, a.tipo_reg,
      to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 1, 4000)) xml1,
      case
      when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 4000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 8000 then
      to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 4001,  8000))
      end xml2,
      case
      when length(a.SERVV_XMLENTRADA@DBL_TIMEAI) > 8000 and length(a.SERVV_XMLENTRADA@DBL_TIMEAI) <= 12000 then
      to_char(substr(a.SERVV_XMLENTRADA@DBL_TIMEAI, 8001,  12000))
      end xml3
      from usract.postt_servicioprog_fija@dbl_timeai a
      where servi_cod=4 and servc_estado=1
      and a.servd_fechaprog >= d_fecinirecsiac
      and a.servd_fechaprog <= trunc (sysdate);

    n_codsolot      number;
    n_res_cod       number;
    v_res_desc      varchar2(400);
    n_idseq         number;
    n_customer_id   number;
    n_tiptra        number;
    v_observacion   solot.observacion%type;
    v_franjahoraria varchar2(400);
    n_codigomotivo  solot.codmotot%type;
    v_codigoplano   agendamiento.idplano%type;
    v_usuarioasesor usuarioope.usuario%type;
    n_estado        number;
    p_estado        number;
    p_customer_id   number;
    p_dn_num        varchar2(63);
    p_email         varchar2(200);
    p_fec_fin       varchar2(15);
    v_xml  varchar2(32767);
    lv_xml  varchar2(32767);
    an_coderror number;
    av_msgerror varchar2(4000);
    exception_general exception;
    v_username       varchar2(400);  --6.0
    ln_cont_bloq number;    --6.0
    v_tickler_code varchar2(400);  --6.0
    ln_flag        number;
  begin

    select to_date(valor,'dd/mm/yyyy') into d_fecinirecsiac from constante where constante='DATERECSIACINI';

    operacion.pq_sga_bscs.p_alinea_reconexion_bscs;  --7.0

   for c in c_s loop
      begin
          select to_number(c.valor) into ln_flag
            from constante c where c.constante = 'REGUREQUESTCORX'; --<10.0>
          -- from constante c where c.constante = 'REGUREQUESTCOID'; --<10.0>
          if ln_flag = 1 then
            operacion.pq_sga_bscs.p_libera_request_co_id(c.co_id,an_coderror,av_msgerror);
          end if;

          lv_xml :=c.xml1 || nvl(c.xml2,'')||nvl(c.xml3,'');
          v_xml := f_retorna_xml_recorta(lv_xml);

          if f_val_trs_susp(c.co_id,c.servi_cod,c.servd_fechaprog) = 1 then --Transaccion Valida

           p_insert_ope_sol_siac(c.co_id, c.customer_id, v_xml, c.servd_fecha_reg, c.tipo_serv,
                                 c.co_ser, c.servi_cod, c.tipo_reg,c.servc_codigo_interaccion, 0, c.servd_fechaprog,
                                 n_idseq, an_coderror, av_msgerror);

            if an_coderror = -1 then
              raise exception_general;
            end if;
           --Valida Reconexion  --Ini 6.0
           v_username     := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(v_xml,'usuarioSistema');
           select count(1) into ln_cont_bloq from constante c
            where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
            if ln_cont_bloq = 0 then
               v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'ticklerCode');
            else
              select c.valor into v_tickler_code from constante c
              where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
            end if;

            operacion.pq_sga_iw.sp_valida_reactivacion(c.co_id,v_username,v_tickler_code,p_estado);  -- Fin 6.0


            if p_estado < 0 then
              if p_estado = -1 then  --6.0
                n_estado   := 5;  --6.0
                v_res_desc := 'Contrato se encuentra Desactivo';
              elsif p_estado = -3 then
                n_estado   := 5;
                v_res_desc := 'Contrato se encuentra Activo';
              elsif p_estado = -4 then
                n_estado   := 3;
                v_res_desc := 'Contrato cuenta con Bloqueo por Cobranza y esta Suspendido';
              elsif p_estado = -5 then
                n_estado   := 4;
                v_res_desc := 'SOT de suspension no se encuentra Cerrada';
              else
                n_estado   := 5;
                v_res_desc := 'No cumple requisitos para generar Reconexion';
              end if;
            else

              n_customer_id   := webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'codCliente');
              n_tiptra        := f_obtiene_valores_scr('tiptra_rx');
              v_observacion   := null;
              v_franjahoraria := f_obtiene_valores_scr('franjaHoraria');
              n_codigomotivo  := f_obtiene_valores_scr('codigomotivo');

              begin
                select distinct d1.idplano into v_codigoPlano from solot a1,solotpto b1,inssrv c1, vtasuccli d1
                  where a1.codsolot=b1.codsolot and b1.codinssrv=c1.codinssrv and c1.codsuc=d1.codsuc
                and a1.cod_id=c.co_id  and b1.idplano is not null   and rownum=1;
              exception
                  when no_data_found then
                   v_codigoPlano := '';
              end;

              v_usuarioAsesor:=webservice.pq_ws_sga_iw.f_get_atributo(v_xml,'usuarioApp');

              p_genera_sot_bscs(n_customer_id,c.co_id,n_tiptra,sysdate,v_franjahoraria,n_codigoMotivo,v_observacion,
              v_codigoPlano,v_usuarioAsesor,n_codsolot,n_res_cod,v_res_desc);

              if n_res_cod=1 then
                n_estado:=2;
              end if;
              if n_res_cod=-1 or  n_res_cod = 0 then--error
                  n_estado:=4;
              end if;
          end if;

           p_update_ope_sol_siac(n_idseq,n_codsolot,n_customer_id,n_estado,n_res_cod,v_res_desc,an_coderror,av_msgerror);

           --Actualiza Programacion a estado En Ejecucion
           p_update_postt_serv_fija(n_estado, v_res_desc, p_estado, c.co_id, c.servi_cod,
                                             c.servd_fecha_reg, an_coderror, av_msgerror);
        else
          --Se anula la transaccion
          p_update_postt_serv_fija(5, 'Duplicidad de Contrato de Reconexion.',-1, c.co_id,c.servi_cod,
                                           c.servd_fecha_reg,an_coderror, av_msgerror);
        end if;

     exception
        when exception_general then
            p_update_postt_serv_fija(4, av_msgerror, an_coderror,c.co_id, c.servi_cod, c.servd_fecha_reg,
                                        an_coderror, av_msgerror);
      end;
    end loop;  --6.0
  end;

procedure p_genera_reconexion(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number)  is

    v_tickler_code   varchar2(400);
    v_usuario        varchar2(400);
    p_resultado      number;
    p_msgerr         varchar2(400);
    n_idseq          number;
    n_codsolot       number;
    n_cod_id         number;
    v_err             varchar2(400);
    an_coderror number;
    av_msgerror varchar2(4000);
    ln_cont_bloq number;
    cursor c_s is
      select co_id, customer_id, xmlclob xml_siac, fecha_reg, idseq, servi_cod
      from operacion.ope_sol_siac
      where codsolot=n_codsolot;

  begin
    begin
       select codsolot into n_codsolot from wf where idwf=a_idwf and valido =1;
       for c in c_s loop
          n_cod_id:=c.co_id;
          n_idseq := c.idseq;
          --Realiza corte de Internet, Cable, Telefonia
          select count(1) into ln_cont_bloq from constante c
          where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';

          if ln_cont_bloq = 0 then
             v_tickler_code := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'ticklerCode');
          else
            select c.valor into v_tickler_code from constante c
            where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
          end if;

          v_usuario      := webservice.pq_ws_sga_iw.f_get_atributo(c.xml_siac,'usuarioSistema');

          tim.pp021_venta_hfc.sp_reconexion@dbl_bscs_bf(n_cod_id,v_tickler_code,v_usuario,p_resultado,p_msgerr);

          update tim.pf_hfc_prov_bscs@dbl_bscs_bf  set estado_prv=5, fecha_rpt_eai=sysdate
          where co_id=n_cod_id and action_id= 3  and to_char(fecha_insert,'yyyymmdd') = to_char(sysdate,'yyyymmdd');

          if p_resultado < 0 then
             p_update_ope_sol_siac(n_idseq,n_codsolot, c.customer_id,4,p_resultado, p_msgerr, an_coderror,av_msgerror);
          end if;
        end loop;

     exception
        when others then
          rollback;
          v_err:=$$plsql_unit ||'. Error al procesar el SP: p_genera_corte_suspension' || sqlerrm;

          p_update_ope_sol_siac(n_idseq,null,null,4,-1,v_err,an_coderror,av_msgerror);

          p_reg_log(null, null,NULL, n_codsolot, null, null, v_err,n_cod_id);

          raise_application_error(-20000,v_err);
     end;

     commit;
  end;

procedure sp_valida_reactivacion(  p_co_id        IN  INTEGER,
                                   p_username     IN  VARCHAR2,
                                   p_tickler_code IN  VARCHAR2,
                                   p_estado       OUT INTEGER)
 IS
   ERR_CO_ID_DESACTIVO         CONSTANT NUMBER := -1;  --6.0
   ERR_TICKLER_CODE            CONSTANT NUMBER := -2;  --6.0
   ERR_CO_ID_ACTIVO            CONSTANT NUMBER := -3;  --6.0
   ERR_TICKLER_CODE_COB        CONSTANT NUMBER := -4;  --6.0
   ERR_SOT_SUSP                CONSTANT NUMBER := -5;  --6.0

   v_cnt                       number;
   ln_existe_bloqueo           number;
   ln_status_co_id             number;
   an_coderror                 number;
   ln_val_sotsusp              number;
 BEGIN

    p_estado := 0;

    -- Valida que exista el tickler
    SELECT COUNT(co_id) INTO v_cnt
    FROM tickler_records@dbl_bscs_bf
    WHERE co_id = p_co_id
    AND tickler_code = p_tickler_code
    AND tickler_status = 'OPEN';

    -- Validamos estado del contrato  -- Ini 6.0
    ln_status_co_id := f_val_status_contrato(p_co_id);

    ln_existe_bloqueo := f_val_ticklerrecord_siac_open(p_co_id, p_tickler_code);

    if ln_status_co_id = 1 then -- Activo
      p_estado := ERR_CO_ID_ACTIVO;

      if v_cnt > 0 then
         p_cierre_tickler_code_bscs(p_co_id,p_username,p_tickler_code,an_coderror);
         COMMIT;
      end if;

    elsif ln_status_co_id = 2 then -- Suspendido

      if v_cnt = 0 then
        p_estado := ERR_TICKLER_CODE;
      end if;

      if p_estado = 0 then
        ln_val_sotsusp := f_val_ult_sot_susp_co_id(p_co_id);

        if ln_val_sotsusp = 0 then
          p_estado := ERR_SOT_SUSP;
        end if;

        if p_estado = 0 then
          if ln_existe_bloqueo = 2 then

             p_cierre_tickler_code_bscs(p_co_id,p_username,p_tickler_code,an_coderror);
             COMMIT;
             p_estado := ERR_TICKLER_CODE_COB;

          end if;
        end if;
       end if;
    elsif ln_status_co_id = 4 then -- Desactivo
       p_estado := ERR_CO_ID_DESACTIVO;
    end if;  -- Fin 6.0

    IF p_estado = 0 THEN
       p_estado := 1;
    END IF;

  EXCEPTION
     WHEN OTHERS THEN
          p_estado := -99;
 END;

 function f_val_ult_sot_susp_co_id(an_cod_id number) return number is

 ln_maxcodsolot_susp number;
 ln_valida number;

 begin

   select nvl(max(s.codsolot), 0) into ln_maxcodsolot_susp
   from solot s, tiptrabajo t
    where s.tiptra = t.tiptra
    and t.tiptrs = 3
    and s.cod_id = an_cod_id;

   if ln_maxcodsolot_susp = 0 then
     return 1;
   end if;

   select count(1) into ln_valida
   from solot s
   where s.codsolot = ln_maxcodsolot_susp
   and s.estsol <> 12;

   if ln_valida = 0 then
     return 1;
   end if;

   return 0;
 end;

procedure p_cierre_tickler_code_bscs(an_co_id number,
                                      av_username varchar2,
                                      av_tickler_code varchar2,
                                      an_coderror out number)
 is
    C_TICKLER_ALIGNMENT_SHORT_DES CONSTANT VARCHAR2(20) := 'ALINEACION PKG111';
 begin

    UPDATE tickler_records@dbl_bscs_bf
       SET tickler_status = 'CLOSED',
           short_description = decode(0, 1, C_TICKLER_ALIGNMENT_SHORT_DES, short_description),
           modified_by = av_username, closed_by = av_username,
           closed_date = SYSDATE, modified_date = SYSDATE
     WHERE co_id = an_co_id
       AND tickler_code = av_tickler_code
       AND tickler_status = 'OPEN';

    an_coderror := 1;

 end p_cierre_tickler_code_bscs;

 procedure p_create_tickler_code_bscs(p_co_id number,
                                      p_tickler_code varchar2,
                                      p_tickler_des varchar2,
                                      p_username varchar2,
                                      an_coderror out number)
 is
  p_tickler_number number;
  v_customer_id number;
  v_short_desc varchar2(2000);
  v_cnt_tn number;
 begin

    SELECT COUNT(co_id), nvl(MAX(tickler_number), 0)
    INTO v_cnt_tn , p_tickler_number
    FROM tickler_records@dbl_bscs_bf
    WHERE co_id = p_co_id
    AND tickler_code = p_tickler_code AND tickler_status = 'OPEN';

    IF v_cnt_tn = 0 THEN
     SELECT customer_id INTO v_customer_id
     FROM contract_all@dbl_bscs_bf WHERE co_id = p_co_id;

     SELECT short_desc INTO v_short_desc
     FROM tickler_code_def@dbl_bscs_bf WHERE tickler_Code = p_tickler_code;

     sysadm.NextFree.GetValue@dbl_bscs_bf('MAX_TICKLER_NUMBER', p_tickler_number);

     INSERT INTO tickler_records@dbl_bscs_bf
             ( customer_id, co_id, tickler_number, tickler_code,
               tickler_status, priority, follow_up_date, created_by,
               created_date, short_description, long_description, rec_version)
          VALUES
             ( v_customer_id, p_co_id, p_tickler_number, p_tickler_code,
               'OPEN', 1, SYSDATE, p_username, SYSDATE, v_short_desc,
               decode(p_tickler_des, NULL, v_short_desc, p_tickler_des), 1);


   END IF;

   an_coderror := 1;

 end p_create_tickler_code_bscs;

procedure p_actualiza_contrato_rx(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is
    n_codsolot number;

    cursor c_s is
      select co_id, customer_id, xmlclob xml_siac, fecha_reg, servi_cod, idseq, codinteracion
      from operacion.ope_sol_siac where codsolot=n_codsolot;

    v_tickler_code   varchar2(400);
    v_username       varchar2(400);
    n_reason         number;
    p_request_id     number;
    n_idseq          number;
    v_err            varchar2(2000);
    ln_monto_occ      number(8,2);
    v_resultado      number;
    an_coderror number;
    av_msgerror varchar2(4000);
    lv_monto_occ      varchar2(400);

    ln_fideliza number;
    ln_valtrans number;
    ln_cont_bloq number;

  begin

    select codsolot into n_codsolot from wf where idwf=a_idwf and valido =1;

    for c in c_s loop
      n_idseq := c.idseq;
      --Actualiza Contrato
      select count(1) into ln_cont_bloq from constante c
      where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';

      if ln_cont_bloq = 0 then
         v_tickler_code := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(c.xml_siac,'ticklerCode');
      else
        select c.valor into v_tickler_code from constante c
        where c.constante = 'PAR_SUSP_APC' and c.tipo = 'A';
      end if;

      --v_tickler_code := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(c.xml_siac,'ticklerCode');
      v_username     := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(c.xml_siac,'usuarioSistema');
      lv_monto_occ   := WEBSERVICE.PQ_WS_SGA_IW.f_get_atributo(c.xml_siac,'montoOcc');

      begin -- 7.0
      ln_monto_occ   := to_number(trim(replace(lv_monto_occ,'.',',')));
      exception
        when others then
         ln_monto_occ   := to_number(trim(replace(lv_monto_occ,',','.')));
      end; -- 7.0

      operacion.pq_sga_iw.sp_contract_reactivation(c.co_id, v_tickler_code, v_username, p_request_id);

      if p_request_id > 0 then--exito

        begin
          select s.flgfideliza into ln_fideliza
          from operacion.ope_sol_siac s where s.co_id = c.co_id
          and s.servi_cod = 3 and s.codinteracion  = c.codinteracion;
        exception
          when others then
            ln_fideliza := 1;
        end;

        ln_valtrans := 0;

        if ln_fideliza = 0 then
          -- Crea OCC
          tim.pp005_siac_trx.sp_insert_occ@dbl_bscs_bf(c.customer_id,'2800',to_char(sysdate, 'YYYYMMDD'),'1',ln_monto_occ,'Reconexi?n por suspensi?n',v_resultado);
          ln_valtrans := 1;
          if v_resultado < 0 then
             p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id,4,v_resultado,'Error en el registro de OCC', an_coderror,av_msgerror);
          else
            --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija(3, 'Exito', 1, c.co_id, c.servi_cod, c.fecha_reg, an_coderror, av_msgerror);

            p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id, 3,p_request_id,'Exito', an_coderror,av_msgerror);
          end if;
        end if;

        if ln_valtrans = 0 then
          --Actualiza Programacion a estado En Ejecucion
            p_update_postt_serv_fija(3, 'Exito', 1, c.co_id, c.servi_cod, c.fecha_reg, an_coderror, av_msgerror);

            p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id, 3,p_request_id,'Exito', an_coderror,av_msgerror);
        end if;

      else
        --Actualiza Programacion a estado En Ejecucion
        p_update_postt_serv_fija(4, 'Error', -1, c.co_id, c.servi_cod, c.fecha_reg, an_coderror, av_msgerror);

        p_update_ope_sol_siac(n_idseq,n_codsolot,c.customer_id,4,p_request_id,'Error',an_coderror,av_msgerror);
      end if;
    end loop;

  exception
    when others then
      v_err:=$$plsql_unit ||'. Error al procesar el SP: p_actualiza_contrato_reconexion' || sqlerrm;

      p_update_ope_sol_siac(n_idseq,n_codsolot, null,4,p_request_id,v_err,an_coderror,av_msgerror);

      p_reg_log(null, null,NULL, n_codsolot, null, null, v_err,null);
      raise_application_error(-20000,v_err);
  end;

  procedure sp_contract_reactivation(p_co_id        IN  NUMBER,
                                     p_tickler_code IN  VARCHAR2,
                                     p_username     IN  VARCHAR2,
                                     p_request_id   OUT NUMBER )
 IS
   v_reason          number;
   v_gmd_status      number;
   v_cnt             number;
   v_switch_id       varchar2(7);
   v_gmd_market_id   varchar2(3);
   v_customer_id     number;
   v_sccode          number;
   v_plcode          number;
   v_request_date    date;
   v_ch_status       varchar2(1);
   v_cnt_user        number;
   v_cnt_susp        number;
   v_pending_request number;
   v_cnt_control     number;

   C_OK                 CONSTANT NUMBER(2) := 1;     -- Accion sobre la bolsa ejecutada satisfactoriamente
   C_INVALID_REASON     CONSTANT NUMBER(2) := -1;    -- Motivo de acci?n incorrecto
   C_INVALID_STATUS     CONSTANT NUMBER(2) := -2;    -- El estado actual o propuesto del contrato no permite ejecutar la acci?n
   C_INVALID_USER       CONSTANT NUMBER(2) := -3;    -- Usuario inv?lido
   C_PENDING_REQUEST    CONSTANT NUMBER(2) := -4;    -- Tiene request pendiente
   C_INVALID_CONTRACT   CONSTANT NUMBER(2) := -5;    -- Id de contrato inv?lido
   C_EXCEPTION_OTHERS   CONSTANT NUMBER(2) := -6;    -- Ocurri? otra excepci?n
   C_INVALID_TICKLER    CONSTANT NUMBER(2) := -7;    -- El tickler es incorrecto o no est? en el estado requerido para ejecutar la acci?n
   C_TICKLER_ALIGNMENT_SHORT_DES  CONSTANT VARCHAR2(20) := 'ALINEACION PKG111';

 BEGIN

    p_request_id := C_OK;

    -- Valida que exista el tickler
    SELECT COUNT(co_id) INTO v_cnt
    FROM tickler_records@dbl_bscs_bf WHERE co_id = p_co_id AND tickler_code = p_tickler_code
    AND tickler_status = 'OPEN';

    IF v_cnt = 0 THEN
       p_request_id := C_INVALID_TICKLER;
    END IF;

    if p_request_id = C_OK then
      -- Valida el usuario
      SELECT COUNT(username) INTO v_cnt_user FROM users@dbl_bscs_bf WHERE username = p_username;
      IF v_cnt_user <= 0 THEN
         p_request_id := C_INVALID_USER;
      END IF;
    end if;

    if p_request_id = C_OK then
      -- Verifica que el contrato exista y que est? suspendido
      BEGIN
        SELECT ch_status INTO v_ch_status FROM curr_co_status@dbl_bscs_bf ch WHERE co_id = p_co_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             p_request_id := C_INVALID_CONTRACT;
      END;

      IF v_ch_status <> 's' THEN
         p_request_id := C_INVALID_STATUS;
      END IF;
    end if;

    if p_request_id = C_OK then
      -- Verifica si no hay otras suspensiones abiertas
      SELECT COUNT(tickler_number) INTO v_cnt_susp
      FROM tickler_records@dbl_bscs_bf WHERE co_id = p_co_id AND tickler_code <> p_tickler_code
      AND (tickler_code LIKE 'SUSP%' or tickler_code LIKE 'BLOQ%') AND tickler_status = 'OPEN';

      -- Reactiva s?lo si no tiene otras suspensiones
      IF v_cnt_susp = 0 THEN
         -- Validar requests pendientes
         SELECT COUNT(request) INTO v_pending_request FROM contract_history@dbl_bscs_bf WHERE co_id = p_co_id AND ch_pending = 'X';
         IF v_pending_request = 0 THEN
            SELECT COUNT(request) INTO v_pending_request FROM mdsrrtab@dbl_bscs_bf WHERE co_id = p_co_id AND request_update IS NULL
            AND status NOT IN (9, 7);
         END IF;

         IF v_pending_request > 0 THEN
            p_request_id := C_OK;

            -- Deberemos ingresar los datos del bloqueo en una tabla temporal
            select customer_id into v_customer_id from contract_all@dbl_bscs_bf where co_id = p_co_id;

            -- insertamos el contrato con request pendiente
            insert into tim.pp_gvn_incomplete@dbl_bscs_bf (customer_id_resp, co_id, entry_date, action, tickler_code, username, reason, status)
            values (v_customer_id, p_co_id, sysdate, 'R', p_tickler_code, p_username, 0, 'P');

            commit;
            RETURN;
         END IF;

         -- Ejecuta la reactivaci?n
         SELECT hl.switch_id INTO v_switch_id
         FROM curr_co_device@dbl_bscs_bf cd, mpdhltab@dbl_bscs_bf hl
          WHERE cd.co_id = p_co_id AND cd.hlcode = hl.hlcode;

         SELECT gmd.gmd_market_id, co.customer_id, co.sccode, co.plcode, decode(gmd.bypass_ind, 'Y', 15, 2)
           INTO v_gmd_market_id, v_customer_id, v_sccode, v_plcode, v_gmd_status
           FROM gmd_mpdsctab@dbl_bscs_bf gmd, contract_all@dbl_bscs_bf co
          WHERE co.co_id = p_co_id AND co.sccode = gmd.sccode;

         SELECT ch_reason INTO v_reason FROM contract_history@dbl_bscs_bf
          WHERE co_id = p_co_id
          AND ch_seqno = (SELECT max(ch_seqno) FROM contract_history@dbl_bscs_bf WHERE co_id = p_co_id AND ch_status = 'a');

         -- Create request
         sysadm.nextfree.getvalue@dbl_bscs_bf('MAX_REQUEST', p_request_id);
         v_request_date := SYSDATE;

         INSERT INTO gmd_request_base@dbl_bscs_bf VALUES(p_request_id, v_request_date);

         INSERT INTO mdsrrtab@dbl_bscs_bf
                ( request, action_id, status, error_code, ts, insert_date, plcode, userid,
                  customer_id, co_id, worker_pid, priority, action_date, sccode, gmd_market_id, switch_id )
              VALUES
                ( p_request_id, 3, v_gmd_status, 0, v_request_date, v_request_date, v_plcode, p_username,
                  v_customer_id, p_co_id, 0, 8, v_request_date, v_sccode, v_gmd_market_id, v_switch_id );

         -- Create response
         INSERT INTO gmd_response@dbl_bscs_bf ( response_seqno, request, response_result, retry_ind, effective_date)
              VALUES ( 1, p_request_id, 'SUCCESS', 'N', v_request_date);

         -- Change services
         sysadm.contract.changestateservices@dbl_bscs_bf(p_co_id, p_request_id, 'a', v_request_date, 1);

         -- Change contract
         UPDATE contract_all@dbl_bscs_bf SET co_timm_modified = 'X' WHERE co_id = p_co_id;
         sysadm.contract.changestatecontract@dbl_bscs_bf(p_co_id, p_request_id, 'a', v_request_date, v_reason, p_username);

         -- Si el contrato es plan Control insertar registro para la interfaz prepago/IN
         SELECT COUNT(sncode) INTO v_cnt_control FROM profile_service@dbl_bscs_bf WHERE co_id = p_co_id AND sncode = 73;
         IF v_cnt_control > 0 THEN
            INSERT INTO tim.tim_prepaid_contract_request@dbl_bscs_bf ( co_id, username, status, recharge, insert_date)
                 VALUES ( p_co_id, p_username, 'a', 'N', SYSDATE);
         END IF;
      END IF;
    end if;

    --Cierra tickler de suspensi?n
    UPDATE tickler_records@dbl_bscs_bf
       SET tickler_status = 'CLOSED',
           short_description = decode(0, 1, C_TICKLER_ALIGNMENT_SHORT_DES, short_description),
           modified_by = p_username, closed_by = p_username,
           closed_date = SYSDATE, modified_date = SYSDATE
     WHERE co_id = p_co_id
       AND tickler_code = p_tickler_code
       AND tickler_status = 'OPEN';

    COMMIT;

 EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        p_request_id := C_EXCEPTION_OTHERS;
 END;

procedure p_insert_ope_sol_siac(an_cod_id number,
                                av_customer_id varchar2,
                                av_xml varchar2,
                                ad_fecha_reg date,
                                av_tipo_serv varchar2,
                                av_co_ser varchar2,
                                an_servi_cod number,
                                av_tipo_reg varchar2,
                                av_codinteracion varchar2,
                                an_fideliza number,
                                ad_fecha_prog date,
                                an_idseq out number,
                                an_coderror out number,
                                av_msgerror out varchar2) is

  ln_idseq number;
  ln_count number;
  pragma autonomous_transaction;
begin

  select count(1) into ln_count from OPERACION.OPE_SOL_SIAC s
  where s.co_id = an_cod_id and s.fecha_prog = ad_fecha_prog
  and s.servi_cod = an_servi_cod;

  if ln_count > 0 then
    delete from operacion.ope_sol_siac s where s.co_id = an_cod_id
    and s.fecha_prog = ad_fecha_prog and s.servi_cod = an_servi_cod;
  end if;

  select operacion.sq_ope_sol_siac.nextval into ln_idseq from dual;

  insert into operacion.ope_sol_siac(idseq,co_id,cuenta,xmlclob,fecha_reg,tipo_serv,co_ser,tipo_reg,servi_cod,
  codinteracion, flgfideliza, fecha_prog)
  values(ln_idseq,an_cod_id,av_customer_id,av_xml,ad_fecha_reg,av_tipo_serv,av_co_ser,av_tipo_reg,an_servi_cod,
  av_codinteracion, an_fideliza, ad_fecha_prog);

  an_idseq := ln_idseq;
  an_coderror := 1;
  av_msgerror := 'OK';
  commit;

exception
  when others then
    rollback;
    an_coderror := -1;
    av_msgerror := 'ERROR INSERT: '|| sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
end;

procedure p_update_ope_sol_siac(an_idseq number,
                                an_codsolot number,
                                an_customer_id number,
                                an_estado number,
                                an_coderror_rpta number,
                                av_coderror_rpta varchar2,
                                an_coderror out number,
                                av_msgerror out varchar2) is
 pragma autonomous_transaction;
begin

  update operacion.ope_sol_siac s
  set s.codsolot = decode(s.codsolot, null, an_codsolot, s.codsolot),
      s.customer_id = decode(s.customer_id, null, an_customer_id, s.customer_id),
      s.estado = an_estado,
      s.error = an_coderror_rpta,
      s.mensaje = av_coderror_rpta,
      s.fecmod = sysdate,
      s.usumod = user
  where s.idseq = an_idseq;

  an_coderror := 1;
  av_msgerror := 'OK';
  commit;

exception
  when others then
    rollback;
    an_coderror := -1;
    av_msgerror := 'ERROR UPDATE : '|| sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
end;

procedure p_update_postt_serv_fija(an_servc_estado number,
                                   av_servv_men_error varchar2,
                                   an_servv_cod_error number,
                                   an_co_id number,
                                   an_servi_cod number,
                                   ad_servd_fecha_reg date,
                                   an_coderror out number,
                                   av_msgerror out varchar2) is
begin

  update usract.postt_servicioprog_fija@dbl_timeai t
     set t.servc_estado = an_servc_estado,
         t.servv_men_error = av_servv_men_error,
         t.servv_cod_error = an_servv_cod_error,
         t.servd_fecha_ejec = sysdate
  where t.co_id = an_co_id
    and t.servi_cod = an_servi_cod
    and t.servd_fecha_reg = ad_servd_fecha_reg;  --6.0

  an_coderror := 1;
  av_msgerror := 'OK';

exception
  when others then
    an_coderror := -1;
    av_msgerror := 'ERROR UPDATE : '|| sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';
end;

  procedure p_regulariza_reques_pend(an_cod_id number,
                                     an_coderror out number,
                                     av_msgerror out varchar2) is


    cursor c_contrato is

      select distinct md.co_id,ssh.status
           from mdsrrtab@dbl_bscs_bf md,
                pr_serv_status_hist@dbl_bscs_bf ssh
          where md.co_id = an_cod_id
            and ssh.co_id = md.co_id
            and ssh.request_id = md.request;
  begin
    an_coderror := 1;
    av_msgerror := 'OK';

    for c in c_contrato loop
       if upper(c.status) = 'A' then
         update mdsrrtab@dbl_bscs_bf set status = 15 where co_id = c.co_id;
       end if;
    end loop;

  exception
    when others then
      an_coderror := -1;
      av_msgerror := 'ERROR : '|| sqlcode || ' ' || sqlerrm || ' (' ||
                          dbms_utility.format_error_backtrace || ')';

  end p_regulariza_reques_pend;

  function f_valida_envio_res_act_iw(an_codsolot number) return number is

  ln_cont number;
  begin

    select count(1) into ln_cont
    from solot s, estsol es
    where s.estsol = es.estsol
    and s.codsolot = an_codsolot
    and es.tipestsol in (5, 7);

    return ln_cont;
  end;

  function f_max_sot_x_cod_id(an_cod_id number) return number is

    ln_codsolot number;

  begin

    select nvl(max(s.codsolot), 0)
      into ln_codsolot
      from solot s, solotpto pto, inssrv ins
     where s.codsolot = pto.codsolot
       and pto.codinssrv = ins.codinssrv
       and ins.estinssrv in (1, 2,3)
       and exists (select 1
                    from tipopedd t, opedd o
                    where t.tipopedd = o.tipopedd
                    and t.abrev = 'CONFSERVADICIONAL'
                    and o.abreviacion = 'ESTSOL_MAXALTA'
                    and o.codigon = s.estsol)
       and exists (select 1
                          from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev = 'TIPREGCONTIWSGABSCS'
                           and o.codigon = s.tiptra)
       and s.cod_id = an_cod_id;

    return ln_codsolot;

  exception
    when others then
      return 0;
  end;

  procedure p_update_prov_hfc_bscs(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
  n_cod_id number;
  an_tiptra number;
  an_tiptrs number;
  ln_estadoprv number;
  an_action_id number;
  n_codsolot number;
  v_error varchar2(500);
  n_error varchar2(500);
  ln_tiptra_susp_ftth operacion.tiptrabajo.tiptra%type; --15.0
  BEGIN

    select b.cod_id, b.tiptra, t.tiptrs, b.codsolot
    into  n_cod_id, an_tiptra, an_tiptrs, n_codsolot
    from wf a, solot b, tiptrabajo t
    where a.idwf = a_idwf
    and a.codsolot = b.codsolot
    and b.tiptra = t.tiptra
    and a.valido = 1;

-- ini 15.0
select codigon
      into ln_tiptra_susp_ftth
      from opedd o, tipopedd t
     where o.tipopedd = t.tipopedd
       and t.tipopedd = 1418
       and o.descripcion = 'FTTH/SIAC - SUSPENSION DEL SERVICIO'; 
-- fin 15.0

    IF an_tiptrs = 5 then -- Baja
      an_action_id := 9;
    elsif an_tiptrs = 4 then -- Reconexion
      an_action_id := 3;
    elsif an_tiptrs = 3 and (an_tiptra = 731 or an_tiptra = ln_tiptra_susp_ftth) then  --Suspension -- 15.0
      an_action_id := 5;
    elsif an_tiptrs = 3 and an_tiptra = 733 then --Corte
      an_action_id := 4;
    end if;

    select to_number(c.valor) into ln_estadoprv
    from constante c where c.constante = 'ESTPRV_BSCS';


    UPDATE tim.pf_hfc_prov_bscs@DBL_BSCS_BF
       SET ESTADO_PRV    = 5,
           FECHA_RPT_EAI = Sysdate,
           ERRCODE       = 0,
           ERRMSG        = 'Operation Success'
     where co_id = n_cod_id
       and action_id = an_action_id
       and estado_prv = ln_estadoprv;

  EXCEPTION
    WHEN OTHERS THEN
      v_error := 'Error en actualizar provision HFC BSCS : ' || SQLERRM;
      n_error := sqlcode;
      p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
      raise_application_error(-20001, v_error);
  End;

  function f_val_baja_co_id_customer_id(an_customer_id number, an_cod_id number) return number
  is
  ln_est_cont number;
  ln_maxsot   number;
  ln_contcontrato number;

  cursor c_contrato is
    select distinct c.co_id, c.customer_id
    from contract_all@DBL_BSCS_BF c
    where c.customer_id = an_customer_id
    and c.sccode = 6 --11.0
    and c.co_id != an_cod_id;

  ln_return number;
  ln_contar number;

  begin

     select count(distinct c.co_id) into ln_contcontrato
     from contract_all@DBL_BSCS_BF c
     where c.customer_id = an_customer_id
     and c.sccode = 6 --11.0
     and c.co_id != an_cod_id;

     if ln_contcontrato > 0 then
     --Contrato Desactivo y el customer tiene otro contrato
       for c in c_contrato loop
        ln_est_cont := f_val_status_contrato(c.co_id);

        select count(o.codigon) into ln_contar
            from tipopedd t, opedd o
           where t.tipopedd = o.tipopedd
             and t.abrev = 'TAREADEF_SRB'
             and o.codigoc = 'CONTRATOBSCS'
             and o.abreviacion = 'STATUS_FIN'
             and o.codigon = ln_est_cont;

        if ln_contar = 0 /*ln_est_cont not in (4, 5)*/ then  --6.0
          return 1; -- Customer_ID tiene un contrato activo, onhold y no se puede enviar baja a Intraway
        else
          ln_return := ln_return + 1;  --6.0
        end if;
       end loop;
      -- Todos los contratos restantes estan desactivados
      if ln_return = ln_contcontrato then  --6.0
        return 0;  --6.0
      end if;
    elsif ln_contcontrato = 0 then  --6.0
       return 0;  --6.0
      end if;

    -- Permite generar SOT por que todos los contratos del customer esta de baja
    return 0;
  end;

  procedure p_reg_serv_cod_id_sot(an_cod_id in number, an_codsolot out number) is

  cursor c_sot(an_cod number) is
    select distinct s.codsolot, s.tiptra
    from solot s, tiptrabajo t,(
           select nvl(max(s.codsolot), 0) codsolot,s.cod_id, s.codcli, ins.codinssrv
                from solot s, solotpto pto, inssrv ins
               where s.codsolot = pto.codsolot
                 and pto.codinssrv = ins.codinssrv
                 and s.estsol in (12, 29)
                 and s.tiptra in (select o.codigon
                                    from tipopedd t, opedd o
                                   where t.tipopedd = o.tipopedd
                                     and t.abrev = 'TIPREGCONTIWSGABSCS')
                 and s.cod_id in (an_cod)
          group by s.cod_id, s.codcli, ins.codinssrv) xx,
          solotpto pto
    where s.tiptra = t.tiptra
    and t.tiptrs in (5)
    and pto.codinssrv = xx.codinssrv
    and pto.codsolot = s.codsolot
    and xx.codcli = s.codcli;

  begin

    an_codsolot := f_max_sot_x_cod_id(an_cod_id);

    if an_codsolot = 0 then
      for cc in c_sot(an_cod_id) loop
        if cc.tiptra = 448 or cc.tiptra = 408 then

          update inssrv i set i.estinssrv = 1, i.fecfin = null
          where i.codinssrv in (select pto.codinssrv from solotpto pto where pto.codsolot = cc.codsolot);

          update insprd ins set ins.estinsprd = 1, ins.fecfin = null
          where ins.codinssrv in (select pto.codinssrv from solotpto pto where pto.codsolot = cc.codsolot);
        end if;
      end loop;
    end if;
  end p_reg_serv_cod_id_sot;

  procedure p_act_desact_srv_auto_rx(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
    v_estado varchar2(10);
    n_cod_id number;
    n_codsolot number;
    ln_valida_bloqueo number;  --6.0
    p_tickler_code varchar2(10);
    ln_tiptrs number;
    ln_status_contrato number;
    ln_ejecuta number;

  begin

    select s.codsolot, s.cod_id, t.tiptrs into n_codsolot, n_cod_id, ln_tiptrs  --6.0
    from wf w, solot s, tiptrabajo t
    where w.idwf = a_idwf
    and s.codsolot = w.codsolot
    and s.tiptra = t.tiptra
    and valido =1;

    select c.valor into p_tickler_code
    from constante c where c.constante = 'TICKLERCODEAPC';

    ln_valida_bloqueo := f_val_ticklerrecord_siac_open(n_cod_id, p_tickler_code);  --6.0
    ln_status_contrato := f_val_status_contrato(n_cod_id);  --6.0

    -- Reconexion  --Ini 6.0
    if ln_tiptrs = 4 then
       if ln_status_contrato in (2,3) and ln_valida_bloqueo in (1,0) then
         ln_ejecuta := 1;
       else
         ln_ejecuta := 0;
       end if;
    elsif ln_tiptrs = 3 then -- Suspension
       if ln_status_contrato in (0, 1) and ln_valida_bloqueo in (1,0) then
         ln_ejecuta := 1;
       else
         ln_ejecuta := 0;
       end if;
    end if;  -- Fin 6.0

    update operacion.ope_sol_siac o set o.cant_tickler = ln_valida_bloqueo
    where o.co_id = n_cod_id and o.codsolot = n_codsolot;

    if ln_ejecuta = 1 then
      operacion.p_wf_pos_actsrv(a_idtareawf,a_idwf,a_tarea,a_tareadef);
      operacion.pq_conf_iw.p_act_desact_srv_auto(a_idtareawf,a_idwf,a_tarea,a_tareadef);
    end if;

  end p_act_desact_srv_auto_rx;

  function f_val_ticklerrecord_siac_open(an_co_id number, p_tickler_code varchar2)
    return number is
    ln_exis_bloqueo_boc number;
    ln_exis_bloqueo_apc number;
    ln_valida number;
  begin

    ln_valida := 0;

    SELECT COUNT(tickler_number)
      INTO ln_exis_bloqueo_boc
      FROM tickler_records@dbl_bscs_bf
     WHERE co_id = an_co_id
       AND tickler_code <> p_tickler_code
       AND (tickler_code LIKE 'SUSP%' or tickler_code LIKE 'BLOQ%')
       AND tickler_status = 'OPEN';

    SELECT COUNT(tickler_number)
      INTO ln_exis_bloqueo_apc
      FROM SYSADM.tickler_records@dbl_bscs_bf tr
     WHERE tr.co_id = an_co_id
       AND tr.tickler_code = p_tickler_code
       AND tr.tickler_status = 'OPEN';

    if ln_exis_bloqueo_apc > 0 and ln_exis_bloqueo_boc > 0 then
      --Cuenta con ambos bloqueos abiertos
      ln_valida := 2;
    elsif ln_exis_bloqueo_apc = 0 and ln_exis_bloqueo_boc > 0 then
      --Cuenta con solo Bloqueo por Cobranzas
      ln_valida := 3;
    elsif ln_exis_bloqueo_apc > 0 and ln_exis_bloqueo_boc = 0 then
      --Cuenta con solo Bloqueo a solicitud del cliente
      ln_valida := 1;
    end if;

    return ln_valida;
  end;

  procedure p_gen_envia_xml_src_iw(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is
    n_cod_id number;
    n_codsolot number;
    ln_valida_bloqueo number;  --6.0
    p_tickler_code varchar2(10);
    n_proceso number;
    n_salida number;
    v_salida varchar2(4000);
    n_error number;
    v_error varchar2(4000);
    n_tiptra number;
    ln_cont number;
    ln_status_contrato number;  --6.0
    ln_tiptrs number;    --6.0
    ln_ejecuta number;    --6.0
  begin

    select s.codsolot, s.cod_id, s.tiptra, t.tiptrs
    into n_codsolot, n_cod_id, n_tiptra, ln_tiptrs
    from wf w, solot s, tiptrabajo t
    where w.idwf = a_idwf
    and s.codsolot = w.codsolot
    and t.tiptra = s.tiptra
    and w.valido =1;  --6.0

    ln_status_contrato := f_val_status_contrato(n_cod_id);

    select count(1) into ln_cont
    from operacion.ope_sol_siac o
    where o.codsolot = n_codsolot
      and o.co_id = n_cod_id;

    if ln_cont > 0 then
      select distinct o.cant_tickler into ln_valida_bloqueo
      from operacion.ope_sol_siac o
      where o.codsolot = n_codsolot
        and o.co_id = n_cod_id;
    else
      select count(1) into ln_cont
      from collections.logtrsoac_bscs o
      where o.cod_id = n_cod_id
      and o.codsolot = n_codsolot;

      if ln_cont > 0 then
        select distinct o.cant_tickler into ln_valida_bloqueo
        from collections.logtrsoac_bscs o
        where o.cod_id = n_cod_id
        and o.codsolot = n_codsolot;
      else
        ln_valida_bloqueo := 1;
      end if;
    end if;

    -- Reconexion
    if ln_tiptrs = 4 then
       --Contrato Activo y con un solo Tickler
       if ln_status_contrato in (0, 1) and ln_valida_bloqueo != 2 then
         ln_ejecuta := 1;
    else
         ln_ejecuta := 0;
       end if;
    elsif ln_tiptrs = 3 then -- Suspension
       -- Contrato Suspendido y con un solo Tickler
       if ln_status_contrato in (2, 3) and ln_valida_bloqueo != 2 then
         ln_ejecuta := 1;
       else
         ln_ejecuta := 0;
       end if;
    end if;

    if ln_ejecuta = 0 then
      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,4,8,0,sysdate,sysdate);
    else
      select to_number(codigoc) into n_proceso from opedd o, tipopedd t
      where o.tipopedd = t.tipopedd and t.tipopedd = 1418 and codigon = n_tiptra;

      intraway.pq_provision_itw.p_int_ejecscr(n_codsolot,n_proceso,n_salida, v_salida, 0);

      --XML Ok
      if n_salida = 1 then
        intraway.pq_ejecuta_masivo.p_carga_info_int_envio(n_codsolot);
      end if;

    end if;
  exception
    when others then
      v_error := 'Generar XML Susp/Rec/Corte: ' || SQLERRM;
      n_error := sqlcode;
      p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
      raise_application_error(-20001, v_error);
  end p_gen_envia_xml_src_iw;

  function f_val_tickler_records_oac(an_co_id number) return number is

    ln_exis_bloqueo_boc number;
    ln_exis_bloqueo_apc number;
    ln_valida number;
    p_tickler_code varchar2(10);
  begin

    ln_valida := 0;
    select c.valor into p_tickler_code
    from constante c where c.constante = 'TICKLERCODEAPC';

    SELECT COUNT(tickler_number)
      INTO ln_exis_bloqueo_boc
      FROM tickler_records@dbl_bscs_bf
     WHERE co_id = an_co_id
       AND tickler_code <> p_tickler_code
       AND (tickler_code LIKE 'SUSP%' or tickler_code LIKE 'BLOQ%')
       and trunc(modified_date) = trunc(sysdate)
       AND tickler_status = 'CLOSED';

    SELECT COUNT(tickler_number)
      INTO ln_exis_bloqueo_apc
      FROM SYSADM.tickler_records@dbl_bscs_bf tr
     WHERE tr.co_id = an_co_id
       AND tr.tickler_code = p_tickler_code
       AND tr.tickler_status = 'OPEN';

    if ln_exis_bloqueo_apc > 0 and ln_exis_bloqueo_boc > 0 then  --6.0
      --Cuenta con ambos bloqueos abiertos
      ln_valida := 2;
    elsif ln_exis_bloqueo_apc = 0 and ln_exis_bloqueo_boc > 0 then
      --Cuenta con solo Bloqueo por Cobranzas
      ln_valida := 1;
    elsif ln_exis_bloqueo_apc > 0 and ln_exis_bloqueo_boc = 0 then
      --Cuenta con solo Bloqueo a solicitud del cliente
      ln_valida := 3;
    end if;

    return ln_valida;
  end;

  procedure p_gen_envia_xml_baja(a_idtareawf in number,
                                 a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    n_cod_id number;
    n_codsolot number;
    --ln_valida number;
    --p_tickler_code varchar2(10);
    --n_proceso number;
    n_salida number;
    v_salida varchar2(4000);
    n_error number;
    v_error varchar2(4000);
    n_tiptra number;
    lb_tiene_cp number;
    n_customer_id number;
    v_msg varchar2(4000);
    ln_val_contrato number;  --6.0
    --ln_idtareawf number; --7.0
    --ln_mottarchg number; --7.0

  begin

    select s.codsolot, s.cod_id, s.tiptra, s.customer_id
    into n_codsolot, n_cod_id, n_tiptra, n_customer_id
    from wf w, solot s
    where w.idwf = a_idwf
    and s.codsolot = w.codsolot
    and w.valido =1;

    lb_tiene_cp := f_val_cambioplan_cod_id_old(n_cod_id,n_customer_id);
    ln_val_contrato := f_val_baja_co_id_customer_id(n_customer_id, n_cod_id);  --6.0

    if (lb_tiene_cp = 1 and ln_val_contrato = 1) or ln_val_contrato = 1 then

      opewf.pq_wf.p_chg_status_tareawf(a_idtareawf,4,8,0,sysdate,sysdate);

      --Ini 11.0
      /*select tw.idtareawf, tw.mottarchg   -- Ini 7.0
        into ln_idtareawf, ln_mottarchg
        from wf f, tareawf tw
        where f.idwf = tw.idwf
        and f.valido = 1
        and tw.tareadef in (select o.codigon from tipopedd t, opedd o
                            where t.tipopedd = o.tipopedd
                            and o.abreviacion = 'TAREACONFIW'
                            and t.abrev = 'TAREADEF_SRB'
                            and o.codigon_aux = 1)
        and tw.esttarea = 1
        and f.idwf = a_idwf;  -- Fin 7.0

        opewf.pq_wf.p_chg_status_tareawf(ln_idtareawf,4,8,0,sysdate,sysdate);*/
      --Fin 11.0
    else
      INTRAWAY.PQ_PROVISION_ITW.P_INT_EJECBAJA(n_codsolot,n_salida, v_salida, 0 );
      --XML Ok
      if n_salida = 1 then
        INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO(n_codsolot,4, v_salida,v_msg);
      end if;
    end if;

  exception
    when others then
      v_error := 'Generar XML Baja: ' || SQLERRM;
      n_error := sqlcode;
      p_reg_log(null, null, NULL, n_codsolot, null, n_error, v_error);
      raise_application_error(-20001, v_error);
  end p_gen_envia_xml_baja;

  function f_val_cambioplan_cod_id_old(an_cod_old number, an_customer_id number) return number is

    ln_tiene_cp number;
  begin
      select count(1) into ln_tiene_cp from solot s
      where s.tiptra in (select distinct o.codigon from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                          and t.abrev = 'PAR_VAL_OAC_BSR'
                          and o.codigoc = 'CPOAC'
                          and o.codigon_aux = 1)
      and s.estsol in (select distinct o.codigon from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                          and t.abrev = 'PAR_VAL_OAC_BSR'
                          and o.codigoc = 'ESTSOL'
                          and o.codigon_aux = 1)
      and s.cod_id_old = an_cod_old
      and s.customer_id = an_customer_id;

      if ln_tiene_cp > 0 then
         return 1;
      else
        return 0;
      end if;
  end;

  --Ini 6.0
  procedure p_actualiza_ciclo_bscs(an_codsolot_alta number,
                                an_cod_id number,
                                an_codsolot_baja number,
                                an_error out number,
                                av_error out varchar2)
  is
    ln_billcycle varchar2(6); --12.0
    --ln_cod_id number;  --12.0
    ln_cicfac number;
    lv_cicfac varchar2(2);
    error_ciclo_sga exception;

  begin
    -- obtener el ciclo de la instalaci?n en BSCS
    ln_billcycle := f_obtener_ciclo_bscs(an_cod_id);

    an_error := 1;

    if ln_billcycle is not null then
      begin -- INI 12.0
      -- obtener ciclo de facturacion de la SOT de baja
      select operacion.pq_sga_janus.f_get_ciclo_codinssrv(ins.numero, ins.codinssrv)
             into  ln_cicfac
             from solot s, solotpto pto, inssrv ins
             where s.codsolot = pto.codsolot
             and  pto.codinssrv = ins.codinssrv
             and s.codsolot = an_codsolot_baja
             and s.estsol = 17
             and rownum = 1;
      exception
        when others then
        raise error_ciclo_sga;
      end;
      -- FIN 12.0
       if ln_billcycle = ln_cicfac then
         return;
       end if;

       -- si los ciclos de facturaci?n son diferentes, se actualiza el lado de BSCS
       -- Verificar el status del contrato
       if f_val_status_contrato(an_cod_id) = 0 then
          lv_cicfac:= lpad(cast(ln_cicfac as varchar2), 2, '0');
          p_cambio_newciclo_bscs(an_codsolot_alta,
                                an_cod_id,
                                lv_cicfac,
                                an_error,
                                av_error );
          if an_error = -1 then
            av_error :='Ocurrio un error al actualizar el ciclo de facturaci?n!!!';
          end if;
       end if;
     end if;
  -- INI 12.0
  exception
     when error_ciclo_sga then
      an_error := -1;
      av_error :='Error al obtener el ciclo de facturaci?n en el SGA';
  end;
  -- FIN 12.0
  -- Fin 6.0

  --Ini 14.0
  Function f_obt_cli_idprod (p_idproducto IN producto.idproducto%TYPE) return number is

  ln_tipo_serv number;
  ln_cli_idprod number;

  begin
    select distinct xx.codigon_aux
      into ln_tipo_serv
      from tystabsrv ser,
           producto p,
           (select o.codigon, o.codigon_aux
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx
     where ser.idproducto = p.idproducto
       and p.idproducto = xx.codigon
       and p.idproducto = p_idproducto;

  If ln_tipo_serv = 1 then
    ln_cli_idprod := 1;
  Else
    ln_cli_idprod := 0;
  End If;

  return ln_cli_idprod;
  exception
   when others then
    return 0;
  End;

  Function f_obt_idplano (p_codsuc IN marketing.vtasuccli.codsuc%TYPE) return number is

  lv_idplano varchar2(10);
  ln_idplano number;

  Begin

    select vs.idplano
      into lv_idplano
      from vtasuccli vs
     where vs.codsuc = p_codsuc;

    If  lv_idplano is not null or lv_idplano <> '' then
      ln_idplano := 1;
    Else
      ln_idplano := 0;
    End If;

  return ln_idplano;
  exception
   when others then
    return 0;
  End;
  --Fin 14.0
   FUNCTION F_RETORNA_SELECT_STATUS(P_LV_CH_STATUS VARCHAR2, P_LV_CH_PENDING VARCHAR2) RETURN NUMBER IS
    V_CODIGON    VARCHAR2(1);
  BEGIN
  IF P_LV_CH_PENDING IS NOT NULL THEN
SELECT CODIGON
  INTO V_CODIGON
  FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD OD
 WHERE O.TIPOPEDD = OD.TIPOPEDD
   AND OD.ABREV = 'VAL_STATUS_CONTRAT'
   AND lower(CODIGOC) = lower(P_LV_CH_STATUS)
   AND lower(ABREVIACION) = lower(P_LV_CH_PENDING);
  ELSE
    SELECT CODIGON
  INTO V_CODIGON
  FROM OPERACION.OPEDD O, OPERACION.TIPOPEDD OD
 WHERE O.TIPOPEDD = OD.TIPOPEDD
   AND OD.ABREV = 'VAL_STATUS_CONTRAT'
   AND lower(CODIGOC) = lower(P_LV_CH_STATUS)
   AND ABREVIACION IS NULL;
  END IF;
   RETURN V_CODIGON;
  EXCEPTION
   WHEN OTHERS THEN
    RETURN 100;
  END;
END PQ_SGA_IW;
/
