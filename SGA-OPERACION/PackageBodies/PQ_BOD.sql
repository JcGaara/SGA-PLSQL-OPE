CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_BOD AS
  /******************************************************************************
     NAME:       PQ_BOD
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        09/01/2006  VICTOR HUGO      1. Created this package.
  ******************************************************************************/

  /**********************************************************************
  Inserta registros en la tabla INSSRV del portal
  **********************************************************************/

  FUNCTION f_get_bwmax_inssrv(a_codinssrv in number) return number IS
    l_bandwid tystabsrv.banwid%type;
  BEGIN

    /*       select max(ta.banwid) into l_bandwid from insprd p, tystabsrv ta, define_precio dp
    where  p.codsrv=ta.codsrv
    and    p.codinssrv = a_codinssrv
    and    ta.idproducto in (select idproductobod from bodproducto where flgfact = 1)
    and    p.codsrv =dp.codsrv
    and    dp.plazo in (select plazo_srv from vtatabslcfac where numslc in (
                        select numslc from inssrv where codinssrv = a_codinssrv));*/
    ---luis olarte
    select max(t.banwid)
      into l_bandwid
      from inssrv i, insprd p, tystabsrv t, operacion.bodproducto pb
     where i.codinssrv = a_codinssrv
       and i.codinssrv = p.codinssrv
       and p.codsrv = t.codsrv
       and t.idproducto = pb.idproductobod
       and pb.flgfact = 1;

    RETURN l_bandwid;

  END;

  /**********************************************************************
  Inserta registros en la tabla INSSRV del portal
  **********************************************************************/

  PROCEDURE p_insert_inssrv(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) IS
    l_codsolot solot.codsolot%type;

    cursor cur_srv is
    /*  select distinct ins.codinssrv, ins.codcli, ins.tipsrv,
                      (select dsctipsrv from tystipsrv where tipsrv = ins.tipsrv) dsctipsrv, ins.codsrv,
                      ins.tipinssrv, ins.numero, ins.cid, ins.descripcion, ins.direccion, ins.codubi,
                      f_get_bwmax_inssrv(ins.codinssrv) bwmax, ins.estinssrv, ins.fecini, ins.fecfin, 1 flgbod
                      from   inssrv ins, tystabsrv srv, solotpto pto
                      where  ins.codsrv = srv.codsrv
                      and    srv.idproducto in (select idproducto from bodproducto where tipsrv = ins.tipsrv)
                      and    ins.codinssrv = pto.codinssrv
                      and   pto.codsolot = l_codsolot;*/
      select i.codinssrv,
             i.codcli,
             i.tipsrv,
             (select dsctipsrv from tystipsrv where tipsrv = i.tipsrv) dsctipsrv,
             i.codsrv,
             i.tipinssrv,
             i.numero,
             i.cid,
             i.descripcion,
             i.direccion,
             i.codubi,
             f_get_bwmax_inssrv(i.codinssrv) bwmax,
             i.estinssrv,
             i.fecini,
             i.fecfin,
             1 flgbod
        from solotpto sp, inssrv i
       where sp.codsolot = l_codsolot
         and i.codinssrv = sp.codinssrv;

    cursor cur_mail is
      select distinct pto.codinssrv, vm.numcomcnt, vc.nomcnt
        from VTADETCNTSLC vc, VTAMEDCOMCNT vm, solot sot, solotpto pto
       where vc.numslc = sot.numslc
         and sot.codsolot = pto.codsolot
         and vc.codcnt = vm.codcnt
         and vm.idmedcom = '008'
         and sot.codsolot = l_codsolot;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    for cs in cur_srv loop
      begin
        insert into bod.inssrv@pewebprd.world
          (codinssrv,
           codcli,
           tipsrv,
           dsctipsrv,
           codsrv,
           tipinssrv,
           numero,
           cid,
           descripcion,
           direccion,
           codubi,
           bwmax,
           estinssrv,
           fecini,
           fecfin,
           flgbod)
        values
          (cs.codinssrv,
           cs.codcli,
           cs.tipsrv,
           cs.dsctipsrv,
           cs.codsrv,
           cs.tipinssrv,
           cs.numero,
           cs.cid,
           cs.descripcion,
           cs.direccion,
           cs.codubi,
           cs.bwmax,
           cs.estinssrv,
           cs.fecini,
           cs.fecfin,
           cs.flgbod);
      end;
    end loop;

    for cm in cur_mail loop
      begin
        insert into bod.mailxinssrv@pewebprd.world
          (codinssrv, numcomcnt, nomcnt)
        values
          (cm.codinssrv, cm.numcomcnt, cm.nomcnt);
      end;
    end loop;

  END;

  /**********************************************************************
  Inserta registros en la tabla INSPRD del portal
  **********************************************************************/

  PROCEDURE p_insert_insprd(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) IS
    l_codsolot    solot.codsolot%type;
    lm_codinssrv  inssrv.codinssrv%type;
    ll_tipsrv     inssrv.tipsrv%type;
    ln_tipo       number;
    ln_porcentaje number;
    ln_monto      number;

    cursor cur_prd is
      select po.codinssrv,
             po.pid,
             po.codsrv,
             tso.dscsrv,
             tso.banwid bw,
             tsb.banwid bwmax,
             tso.idproducto,
             pre.cossrv monto,
             po.estinsprd,
             po.fecini,
             po.fecfin,
             b.flgbod flgbod,
             b.flgfact flgfact,
             b.FLGACCESO,
             pre.cossrv montoori
        from insprd                po,
             tystabsrv             tso,
             operacion.bodproducto b,
             insprd                pb,
             tystabsrv             tsb,
             define_precio         pre
       where po.codinssrv = lm_codinssrv
         and po.codsrv = tso.codsrv
         and po.estinsprd = 1
         and pb.codsrv = tsb.codsrv
         and pb.estinsprd = 1
         and pb.codinssrv = po.codinssrv
         and tso.idproducto = b.idproducto
         and tsb.idproducto = b.idproductobod
         and po.codsrv = pre.codsrv
         and pre.plazo in (select max(plazo_srv)
                             from vtatabslcfac
                            where numslc = po.numslc);

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select max(codinssrv)
      into lm_codinssrv
      from solotpto
     where codsolot = l_codsolot;

    for cp in cur_prd loop
      begin
        insert into bod.insprd@pewebprd.world
          (codinssrv,
           pid,
           codsrv,
           dscsrv,
           bw,
           bwmax,
           idproducto,
           monto,
           estinsprd,
           fecini,
           fecfin,
           flgbod,
           flgfact,
           FLGACCESO,
           montoori)
        values
          (cp.codinssrv,
           cp.pid,
           cp.codsrv,
           cp.dscsrv,
           cp.bw,
           cp.bwmax,
           cp.idproducto,
           cp.monto,
           cp.estinsprd,
           cp.fecini,
           cp.fecfin,
           cp.flgbod,
           cp.flgfact,
           cp.FLGACCESO,
           cp.montoori);
      end;

      select nvl(max(b.porcentaje), 0),
             nvl(max(a.cantidad *
                     f_calc_porc_promocion(a.numslc, a.numpto, 0)),
                 0)
        into ln_porcentaje, ln_monto
        from insprd a, vtadetprmcom b, tystabsrv c
       where a.numslc = b.numslc
         and a.numpto = b.numpto
         and b.afectacr = 1
         and a.codsrv = c.codsrv(+)
         and a.pid = cp.pid;

      if ln_porcentaje > 0 then
        update bod.insprd@pewebprd.world
           set porcentaje = ln_porcentaje, monto = ln_monto
         where pid = cp.pid;
      end if;

    end loop;

    /*       insert into bod.insprd@pewebprd.world(codinssrv, pid, codsrv, dscsrv,  bw,bwmax,
              idproducto, monto, estinsprd, fecini, fecfin, flgbod, flgfact,FLGACCESO)
           select distinct prd1.codinssrv, prd1.pid, prd1.codsrv, srv1.dscsrv, srv1.banwid bw, srv2.banwid bwmax, srv1.idproducto,
                pre.cossrv monto, prd1.estinsprd, prd1.fecini, prd1.fecfin, bod.flgbod flgbod, bod.flgfact flgfact, bod.FLGACCESO

    */

    -- actualizar tipo para tiempos de plazo
    select tipsrv
      into ll_tipsrv
      from inssrv
     where codinssrv = lm_codinssrv;
    if ll_tipsrv = '0052' then
      update bod.inssrv@pewebprd.world
         set tipo = 1
       where codinssrv = lm_codinssrv;
    end if;
    if ll_tipsrv = '0006' then

      select (case
               when upper(dscsrv) like '%CARRI%' then
                4
               when upper(dscsrv) like '%PREM%' then
                3
               when upper(dscsrv) like '%CORP%' then
                2
               else
                2
             end)
        into ln_tipo
        from bod.insprd@pewebprd.world
       where idproducto = 527
         and codinssrv = lm_codinssrv
  and rownum = 1; --<3.0>

      update bod.inssrv@pewebprd.world
         set tipo = ln_tipo
       where codinssrv = lm_codinssrv;
    end if;

  END;

  /**********************************************************************
  Genera accesos a la aplicacion BOD  del portal
  **********************************************************************/
  PROCEDURE p_asigna_permiso(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) IS
    l_codsolot solot.codsolot%type;
    l_codcli   solot.codcli%type;

    cursor c_permiso is
      select codopc,
             l_codcli codusu,
             1 indact,
             1 indborrar,
             1 indgrabar,
             1 indprn
        from seguridad.segtabopc@pewebprd.world
       where trim(codmod) = trim('BOD'); --nombreaplicacion;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select codcli into l_codcli from solot where codsolot = l_codsolot;

    for cp in c_permiso loop
      begin
        delete from seguridad.segusuopc@pewebprd.world
         where codusu = l_codcli
           and codopc = cp.codopc;
        insert into seguridad.segusuopc@pewebprd.world
          (codopc, codusu, indact, indborrar, indgrabar, indprn)
        values
          (cp.codopc,
           cp.codusu,
           cp.indact,
           cp.indborrar,
           cp.indgrabar,
           cp.indprn);
      end;
    end loop;

  END;

  /**********************************************************************
  Crea las instancia de servicio y producto del portal
  **********************************************************************/

  PROCEDURE p_crear_instancias(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) IS
  BEGIN
    p_insert_inssrv(a_idtareawf, a_idwf, a_tarea, a_tareadef);
    p_insert_insprd(a_idtareawf, a_idwf, a_tarea, a_tareadef);
    p_asigna_permiso(a_idtareawf, a_idwf, a_tarea, a_tareadef);
    commit;
  END;

  /**********************************************************************
  Crea la sot de incidencia del portal
  **********************************************************************/

  PROCEDURE p_crear_sot_incidencia(a_codincidence in number) IS
    cursor cur_incid is
      select customersequence,
             customercode,
             service,
             servicecode,
             service2,
             serviceinstance,
             monto,
             bw
        from bod.customerxincidence@pewebprd.world
       where codincidence = a_codincidence;

    l_codsolot       solot.codsolot%type;
    l_observ         solot.observacion%type;
    l_observacion    solot.observacion%type;
    l_codcli         inssrv.codcli%type;
    l_codsrv         tystabsrv.codsrv%type;
    l_dsctipsrv      tystipsrv.dsctipsrv%type;
    l_idproducto     tystabsrv.idproducto%type;
    l_tipsrv         tystabsrv.tipsrv%type;
    l_suggesteddate  date;
    l_endbillingdate date;

    l_bw     varchar2(10);
    l_bwp    varchar2(10);
    l_dscsrv tystabsrv.dscsrv%type;

    l_tarea_upgrade   tareawf.idtareawf%type;
    l_tarea_downgrade tareawf.idtareawf%type;
    ls_titulo         varchar2(200);
    ls_texto          varchar2(2000);
    ls_contacto       varchar2(400);

  BEGIN
    l_codsolot := F_GET_CLAVE_SOLOT();

    select suggesteddate, endbillingdate
      into l_suggesteddate, l_endbillingdate
      from bod.incidence@pewebprd.world
     where codincidence = a_codincidence;

    insert into solot
      (codsolot,
       codcli,
       estsol,
       tiptra,
       areasol,
       grado,
       tiprec,
       feccom,
       fecini,
       fecfin,
       fecultest)
    values
      (l_codsolot,
       '00000000',
       10,
       367,
       41,
       3,
       'S',
       l_suggesteddate,
       l_suggesteddate,
       l_endbillingdate,
       sysdate);

    l_observ := '';
    for ci in cur_incid loop
      begin
        insert into solotpto
          (codsolot, punto, codinssrv, pid, codsrvnue, bwnue, tipo)
        values
          (l_codsolot,
           ci.customersequence,
           ci.service,
           ci.service2,
           ci.servicecode,
           ci.bw,
           2);

        l_codcli := ci.customercode;
        l_codsrv := ci.servicecode;

        select cxi.bw, bp.bw
          into l_bw, l_bwp
          from bod.customerxincidence@pewebprd.world cxi,
               bod.insprd@pewebprd.world             bp
         where cxi.codincidence = a_codincidence
           and cxi.service2 = bp.pid
           and cxi.servicecode = l_codsrv;

        select dscsrv into l_dscsrv from tystabsrv where codsrv = l_codsrv;

        l_observ := l_observ || l_dsctipsrv || chr(13) || chr(10) ||
                    l_dscsrv || ' Ancho de Banda: ' || l_bwp /*|| chr(13) || chr(10)*/
                    || ' ==> Ancho de Banda Upgrade: ' || l_bw;
      end;
    end loop;

    /* select idproducto into l_idproducto from tystabsrv where codsrv = l_codsrv;*/
    select tipsrv into l_tipsrv from tystabsrv where codsrv = l_codsrv;

    select tip.dsctipsrv
      into l_dsctipsrv
      from tystipsrv tip, tystabsrv srv
     where tip.tipsrv = srv.tipsrv
       and srv.codsrv = l_codsrv;

    l_observacion := 'Incidencia: ' || to_char(a_codincidence) || chr(13) ||
                     chr(10) || l_dsctipsrv /*|| chr(13)*/ /*|| chr(10)*/
                     || l_observ;

    select 'Contacto: '||rpad(nomcnt, 80, ' ') || ' Teléfono: '||rpad(telefono1, 50, ' ') contacto
      into ls_contacto
      from bod.incidence@pewebprd.world
     where codincidence = a_codincidence;

    l_observacion := l_observacion || chr(13) || chr(10) ||
                     ' Datos del contacto ==> ' || ls_contacto;

    update solot
       set codcli = l_codcli, observacion = l_observacion
     where codsolot = l_codsolot;

    --  if l_tipsrv = '0052' then
    pq_solot.p_asig_wf(l_codsolot, 478);
    --  else
    --   pq_solot.p_asig_wf(l_codsolot, 478);
    --  end if;

    select tareawf.idtareawf
      into l_tarea_upgrade
      from tareawf, wf
     where tareawf.idwf = wf.idwf
       and wf.codsolot = l_codsolot
       and tareawf.tareadef = 543;

    select tareawf.idtareawf
      into l_tarea_downgrade
      from tareawf, wf
     where tareawf.idwf = wf.idwf
       and wf.codsolot = l_codsolot
       and tareawf.tareadef = 544;

    update tareawf
       set feccom = l_suggesteddate
     where idtareawf = l_tarea_upgrade;

    update tareawf
       set feccom = l_endbillingdate
     where idtareawf = l_tarea_downgrade;

    update bod.incidence@pewebprd.world
       set codstatus = 2, codsolot = l_codsolot
     where codincidence = a_codincidence;

    ls_titulo := 'Se genero la Sot de BoD ' || l_codsolot;
    ls_texto  := 'Se genero la Sot de BoD ' || l_codsolot ||
                 ' para la solicitud ' || a_codincidence;
    ls_texto  := ls_texto || chr(13) || chr(10) ||
                 'select *  from bod.incidence@pewebprd.world where codincidence=' ||
                 a_codincidence;

    --envia notificacion a it de con el numero de la sot creada para BOD.
    OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                       'DL-PE-ITSoportealNegocio',--4.0
                                       ls_texto,
                                       'SGA@BoD');

  END;

  /**********************************************************************
  Envia los emails de notificación de la incidencia a clientes y consultores
  **********************************************************************/

  PROCEDURE p_enviar_notificaciones(a_codincidence in number) IS
    l_codinssrv   inssrv.codinssrv%type;
    l_nomcli      vtatabcli.nomcli%type;
    l_codect      vtatabcli.codect%type;
    l_codectmnt   vtatabcli.codectmnt%type;
    l_emailect    vtatabect.email%type;
    l_emailectmnt vtatabect.email%type;
    l_dscsrv      tystabsrv.dscsrv%type;
    l_dsctipsrv   tystipsrv.dsctipsrv%type;
    l_bw          varchar2(10);
    l_bwp         varchar2(10);
    ls_titulo     varchar2(100);
    ls_texto      varchar2(1200);

    cursor cur_mxi is
      select codinssrv, numcomcnt
        from bod.mailxinssrv@pewebprd.world
       where codinssrv = l_codinssrv;

    cursor cur_cxi is
      select customercode, servicecode
        from bod.customerxincidence@pewebprd.world
       where service = l_codinssrv
         and codincidence = a_codincidence;
  BEGIN

    select distinct service
      into l_codinssrv
      from bod.customerxincidence@pewebprd.world
     where codincidence = a_codincidence;

    ls_titulo := 'PRUEBA:  Servicio de Ancho de Banda, incidencia ' ||
                 to_char(a_codincidence);

    if l_codinssrv is not null then

      select c.nomcli, c.codect, c.codectmnt
        into l_nomcli, l_codect, l_codectmnt
        from inssrv i, vtatabcli c
       where i.codcli = c.codcli
         and i.codinssrv = l_codinssrv;

      for cxi in cur_cxi loop
        select dscsrv
          into l_dscsrv
          from tystabsrv
         where codsrv = cxi.servicecode;

        select tip.dsctipsrv
          into l_dsctipsrv
          from tystipsrv tip, tystabsrv srv
         where tip.tipsrv = srv.tipsrv
           and srv.codsrv = cxi.servicecode;

        select c.bw, p.bw
          into l_bw, l_bwp
          from bod.customerxincidence@pewebprd.world c,
               bod.insprd@pewebprd.world             p
         where c.service = l_codinssrv
           and c.service2 = p.pid
           and c.servicecode = cxi.servicecode
           and codincidence = a_codincidence;

        ls_texto := ls_texto || chr(13) || chr(10) || l_dscsrv ||
                    ' Ancho de Banda: ' || l_bwp ||
                    ' ==> Ancho de Banda Upgrade: ' || l_bw || chr(13) ||
                    chr(10);
      end loop;
      -- ls_texto :=  l_dsctipsrv || chr(13) || chr(10) || ls_texto;
      ls_texto := 'Cliente: ' || l_nomcli || chr(13) || chr(10) || chr(13) ||
                  chr(10) || l_dsctipsrv || chr(13) || chr(10) || chr(13) ||
                  chr(10) || ls_texto || chr(13) || chr(10);

      if l_codect is not null then
        select email
          into l_emailect
          from vtatabect
         where codect = l_codect;
        OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                           l_emailect,
                                           ls_texto,
                                           'SGA@BoD');
      end if;

      if l_codectmnt is not null then
        select email
          into l_emailectmnt
          from vtatabect
         where codect = l_codectmnt;
        OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                           l_emailectmnt,
                                           ls_texto,
                                           'SGA@BoD');
      end if;

      for cmi in cur_mxi loop
        OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                           cmi.numcomcnt,
                                           ls_texto,
                                           'SGA@BoD');
      end loop;

      OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                         'DL-PE-ITSoportealNegocio',--4.0
                                         ls_texto,
                                         'SGA@BoD');
      commit;
    end if;

  END;

  /**********************************************************************
  Envia los emails de notificación de la incidencia al NOC
  **********************************************************************/

  PROCEDURE p_enviar_notificaciones_noc(a_tipo   in number,
                                        a_tiempo in number) IS
    ls_titulo varchar2(100);
    ls_texto  varchar2(1200);

    cursor cur_incidence is
      select codincidence,
             suggesteddate,
             endbillingdate,
             trunc((suggesteddate - sysdate) * 1440) minutos1,
             trunc((endbillingdate - sysdate) * 1440) minutos2
        from bod.incidence@pewebprd.world
       where codstatus = 2;
  BEGIN

    ls_titulo := 'Servicio de Ancho de Banda - Incidencia por vencer';

    for ci in cur_incidence loop

      ls_texto := 'Incidencia: ' || ci.codincidence;

      if a_tipo = 1 and ci.minutos1 > 0 and ci.minutos1 < a_tiempo then
        ls_texto := ls_texto || chr(13) || chr(10) ||
                    'Fecha de Compromiso: ' || ci.suggesteddate;
        OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                           'DL-PE-ITSoportealNegocio',--4.0
                                           ls_texto,
                                           'SGA@BoD');
      end if;

      if a_tipo = 2 and ci.minutos2 > 0 and ci.minutos2 < a_tiempo then
        ls_texto := ls_texto || chr(13) || chr(10) ||
                    'Fecha de Compromiso: ' || ci.endbillingdate;
        OPEWF.PQ_SEND_MAIL_JOB.p_send_mail(ls_titulo,
                                           'DL-PE-ITSoportealNegocio',--4.0
                                           ls_texto,
                                           'SGA@BoD');
      end if;
    end loop;

  END;

  /**********************************************************************
  Crea las sot para los requerimientos activos del portal
  **********************************************************************/

PROCEDURE p_genera_sots_job IS

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.PQ_BOD.P_GENERA_SOTS_JOB';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='228';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------


  cursor cur_incid is
    select codincidence, suggesteddate
      from bod.incidence@pewebprd.world
     where codstatus = 1
       and sysdate <= suggesteddate;

  l_horaminima number;
BEGIN
  begin
    for ci in cur_incid loop
      begin

        select min(a.horaminima) / 24
          into l_horaminima
          from bod.incidence@pewebprd.world          i,
               bod.customerxincidence@pewebprd.world c,
               bod.inssrv@pewebprd.world             srv,
               bod.antelacion@pewebprd.world         a
         where i.codincidence = ci.codincidence
           and c.codincidence = i.codincidence
           and srv.codinssrv = c.service
           and srv.tipo = a.codantelacion;

        /*   select distinct ant.horaminima into l_horaminima
        from   bod.segmentoantelacion@pewebprd.world ant, bod.customerxincidence@pewebprd.world cus, vtatabcli cli
        where  cus.customercode = cli.codcli and cli.codsegmark = ant.codsegmark
        and    cus.codincidence = ci.codincidence;*/

        if sysdate > ci.suggesteddate - l_horaminima then
          p_crear_sot_incidencia(ci.codincidence);
        end if;
      end;
    end loop;
  exception
    when others then
      rollback;
      OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('Error en Job BoD',
                                         'DL-PE-ITSoportealNegocio@claro.com.pe,dl-pe-dba@claro.com.pe',--4.0
                                         'Error al ejecutar Job BoD ' ||
                                         sqlerrm || ' ',
                                         'SGA@BoD');
  end;


--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

END;

  /**********************************************************************
  Genera accesos a la aplicacion RAT  del portal
  **********************************************************************/
  PROCEDURE p_asigna_permiso_RAT(a_idtareawf in number,
                                 a_idwf      in number,
                                 a_tarea     in number,
                                 a_tareadef  in number) IS
    l_codsolot solot.codsolot%type;
    l_codcli   solot.codcli%type;

    cursor c_permiso is
      select codopc,
             l_codcli codusu,
             1 indact,
             1 indborrar,
             1 indgrabar,
             1 indprn
        from seguridad.segtabopc@pewebprd.world
       where trim(codmod) = trim('TRAFICORTA'); --nombreaplicacion;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;
    select codcli into l_codcli from solot where codsolot = l_codsolot;

    for cp in c_permiso loop
      begin
        delete from seguridad.segusuopc@pewebprd.world
         where codusu = l_codcli
           and codopc = cp.codopc;
        insert into seguridad.segusuopc@pewebprd.world
          (codopc, codusu, indact, indborrar, indgrabar, indprn)
        values
          (cp.codopc,
           cp.codusu,
           cp.indact,
           cp.indborrar,
           cp.indgrabar,
           cp.indprn);
      end;
    end loop;

  END;

  /**********************************************************************
  Habilita el url para un reporte avanzado de trafico
  **********************************************************************/

  PROCEDURE p_configuraURLTVRAT(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) IS
    l_codsolot solot.codsolot%type;
    l_nxt      number;

    cursor c_cid is
      select distinct a.cid
        from solotpto sp, inssrv i, acceso a
       where sp.codsolot = l_codsolot
         and sp.codinssrv = i.codinssrv
         and a.codinssrv = i.codinssrv;

    cursor c_url(l_cid acceso.cid%type) is
    /*  select se.codequipo codequipo,
                             V_SERVIDOR.ABREVIACION||V_CADURL.ABREVIACION||V_DIRECTORIO.ABREVIACION||V_TIPEQU.ABREVIACION||'%2F'||lower(er.descripcion)||'%2Fcid'||ci.cid||';view=Trafico' url
                             from
                             servxtrafixequipo se,
                             equipored er,
                             cidxide ci,
                             puertoxequipo pe,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 182) V_CADURL
                             where
                             ci.cid = l_cid and
                             ci.ide = pe.ide and
                             se.codequipo = pe.codequipo and
                             se.codequipo = er.codequipo and
                             se.tiporep = 1 and
                             se.servidor = V_SERVIDOR.CODIGON and
                             se.directorio = V_DIRECTORIO.CODIGON and
                             se.tipequrep = V_TIPEQU.CODIGON; */
    /*       select se.codequipo codequipo,
                             V_SERVIDOR.ABREVIACION||V_CADURL.ABREVIACION||V_DIRECTORIO.ABREVIACION||V_TIPEQU.ABREVIACION||'%2F'||lower(se.equipored)||'%2Fcid'||ci.cid||';view=TraficoCoS' url
                             from
                             servxtrafixequipo se,
                             servxtrafixequipo se1,
                             equipored er,
                             cidxide ci,
                             puertoxequipo pe,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
                             (SELECT CODIGON,ABREVIACION FROM OPEDD WHERE TIPOPEDD = 182) V_CADURL
                             where
                             ci.cid = l_cid and
                             ci.ide = pe.ide and
                             se1.codequipo = pe.codequipo and
                             se1.codequiporpv =  se.codequipo and
                             se.codequipo = er.codequipo and
                             se.tiporep = 1 and
                             se.servidor = V_SERVIDOR.CODIGON and
                             se.directorio = V_DIRECTORIO.CODIGON and
                             se.tipequrep = V_TIPEQU.CODIGON;*/
      select se.codequipo codequipo,
             idproducto,
             decode(idproducto, 708, 0, 709, 1, 710, 2, 711, 3) tipoacc,
             decode(idproducto,
                    708,
                    'ACCESO',
                    709,
                    'COS1',
                    710,
                    'COS2',
                    711,
                    'COS3',
                    'TV') tipoaccdesc,
             'http://' || V_SERVIDOR.ABREVIACION || V_CADURL.ABREVIACION ||
             V_DIRECTORIO.ABREVIACION || V_TIPEQU.ABREVIACION || '%2F' ||
             lower(se.equipored) || '%2Fcid' || ci.cid ||
             decode(idproducto,
                    708,
                    ';view=TraficoCoS',
                    709,
                    ';view=TraficoCoS1',
                    710,
                    ';view=TraficoCoS2',
                    711,
                    ';view=TraficoCoS3') url
        from servxtrafixequipo se,
             servxtrafixequipo se1,
             equipored er,
             cidxide ci,
             puertoxequipo pe,
             inssrv iso,
             insprd ip,
             tystabsrv ts,
             (SELECT CODIGON, ABREVIACION FROM OPEDD WHERE TIPOPEDD = 179) V_SERVIDOR,
             (SELECT CODIGON, ABREVIACION FROM OPEDD WHERE TIPOPEDD = 180) V_DIRECTORIO,
             (SELECT CODIGON, ABREVIACION FROM OPEDD WHERE TIPOPEDD = 181) V_TIPEQU,
             (SELECT CODIGON, ABREVIACION
                FROM OPEDD
               WHERE TIPOPEDD = 182
                 and CODIGON = 1) V_CADURL
       where ci.cid = l_cid
         and iso.cid = ci.cid
         and iso.codinssrv = ip.codinssrv
         and ip.codsrv = ts.codsrv
         and ts.idproducto in (708, 709, 710, 711)
         and ci.ide = pe.ide
         and se1.codequipo = pe.codequipo
         and se1.codequiporpv = se.codequipo
         and se.codequipo = er.codequipo
         and se.tiporep = 1
         and se.servidor = V_SERVIDOR.CODIGON
         and se.directorio = V_DIRECTORIO.CODIGON
         and se.tipequrep = V_TIPEQU.CODIGON;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;
    -- l_codsolot := 113787;

    for r_cid in c_cid loop
      begin

        for r_url in c_url(r_cid.cid) loop
          begin
            select OPERACION.SQ_ACCESO_DETALLE_URL.NEXTVAL
              into l_nxt
              from DUMMY_OPE;

            insert into acceso_detalle_url
              (url_id, cid, url_type_code, url_description, url_text)
            values
              (l_nxt,
               r_cid.cid,
               r_url.tipoacc,
               r_url.tipoaccdesc,
               r_url.url);

          end;
        end loop;

      end;
    end loop;

    update solotpto
       set fecinisrv = trunc(sysdate)
     where codsolot = l_codsolot;

    pq_solot.p_crear_trssolot(0, l_codsolot, null, null, null, null);

    UPDATE TRSSOLOT
       SET ESTTRS = 2, FECTRS = trunc(sysdate)
     WHERE Codsolot = l_codsolot;

    update insprd
       set estinsprd = 1, fecini = trunc(sysdate)
     where pid in
           (select distinct pid from solotpto where codsolot = l_codsolot);

  END;

  --<req id='87455'>
  PROCEDURE p_exporta_precios is
  begin

     delete bod.bodprecio@pewebprd.world;

    --INTERNET DEDICADO CARRIER CLASS
    INSERT INTO bod.bodprecio@pewebprd.world
    (TIPSRV, IDPRODUCTO, BANWID, MONEDA_ID, COSTO, TIPO)
    SELECT DISTINCT TS.TIPSRV, TS.IDPRODUCTO, TS.BANWID, 2, PRE.COSSRV, 4
    FROM TYSTABSRV TS, DEFINE_PRECIO PRE
    WHERE TS.TIPSRV = '0006'
    AND UPPER(TS.DSCSRV) LIKE '%CARRIE%'
    AND PRE.CODSRV =TS.CODSRV
    AND PRE.PLAZO = 10
    AND TS.IDCATEGORIA = 3
    AND TS.ESTADO = 1;

    --INTERNET DEDICADO PREMIUM
    INSERT INTO bod.bodprecio@pewebprd.world
    (TIPSRV, IDPRODUCTO, BANWID, MONEDA_ID, COSTO, TIPO)
    SELECT DISTINCT TS.TIPSRV, TS.IDPRODUCTO, TS.BANWID, 2, PRE.COSSRV, 3
    FROM TYSTABSRV TS, DEFINE_PRECIO PRE
    WHERE TS.TIPSRV = '0006'
    AND UPPER(TS.DSCSRV) LIKE '%PREM%'
    AND PRE.CODSRV =TS.CODSRV
    AND PRE.PLAZO = 10
    AND TS.IDCATEGORIA = 3
    AND TS.ESTADO = 1;

    --INTERNET DEDICADO CORPORATIVO
    INSERT INTO bod.bodprecio@pewebprd.world
    (TIPSRV, IDPRODUCTO, BANWID, MONEDA_ID, COSTO, TIPO)
    SELECT DISTINCT TS.TIPSRV, TS.IDPRODUCTO, TS.BANWID, 2, PRE.COSSRV, 2
    FROM TYSTABSRV TS, DEFINE_PRECIO PRE
    WHERE TS.TIPSRV = '0006'
    AND UPPER(TS.DSCSRV) LIKE '%CORP%'
    AND PRE.CODSRV =TS.CODSRV
    AND PRE.PLAZO = 10
    AND TS.IDCATEGORIA = 3
    AND TS.ESTADO = 1;

    --ACCESOS
     INSERT INTO bod.bodprecio@pewebprd.world
    (TIPSRV, IDPRODUCTO, BANWID, MONEDA_ID, COSTO, TIPO)
    SELECT DISTINCT TS.TIPSRV, TS.IDPRODUCTO, TS.BANWID, 2, PRE.COSSRV, 1
    FROM TYSTABSRV TS, DEFINE_PRECIO PRE
    WHERE TS.TIPSRV = '0006'
    AND PRE.CODSRV =TS.CODSRV
    AND PRE.PLAZO = 10
    AND TS.IDPRODUCTO = 520
    AND TS.IDCATEGORIA = 3
    AND TS.DSCSRV LIKE '%Acceso a la Red %'
    AND TS.ESTADO = 1;

    --RPV
    INSERT INTO bod.bodprecio@pewebprd.world
    (TIPSRV, IDPRODUCTO, BANWID, MONEDA_ID, COSTO, TIPO)
    SELECT DISTINCT TS.TIPSRV, TS.IDPRODUCTO, TS.BANWID, 2, PRE.COSSRV, 1
    FROM TYSTABSRV TS, DEFINE_PRECIO PRE
    WHERE TS.TIPSRV = '0052'
    AND PRE.CODSRV =TS.CODSRV
    AND PRE.PLAZO = 10
    AND TS.IDCATEGORIA = 3
    AND TS.ESTADO = 1
    AND TS.IDPRODUCTO IN (708,709,710,711);

    commit;

 end p_exporta_precios;
 --</req>

END PQ_BOD;
/


