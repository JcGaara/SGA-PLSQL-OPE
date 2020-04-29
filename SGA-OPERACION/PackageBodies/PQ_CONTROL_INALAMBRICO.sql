CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONTROL_INALAMBRICO IS
  /******************************************************************************
     NAME:       PQ_INALAMBRICO
     PURPOSE:

     REVISIONS:
     Ver        Date        Author           Solicitado por  Description
     ---------  ----------  ---------------  --------------  ------------------------------------

      1        24/03/2010  Antonio Lagos                     REQ 119998, DTH + CDMA
      2        21/04/2010  Antonio Lagos     Juan Gallegos   REQ 119999, DTH + CDMA, cortes
      3.0      05/06/2010  Vicky Sánchez     Juan Gallegoso  Promociones DTH:
      4.0      06/07/2010  Joseph Asencios   Jose Ramos M.   REQ 141063: Optimización del cursor de cortes
      5.0      25/06/2010  Joseph Asencios   Miguel Londoña  REQ 142338: Extorno de recarga dth en tiendas telmex
      6.0      19/10/2010  Joseph Asencios   José Ramos      REQ 146378: Se modificó el proc. p_crea_sot para que actualice el flg_recarga
                                                             cuando se genera una SOT de recarga/reconexión
      7.0      06/10/2010                                    REQ.139588 Cambio de Marca
      8.0      27/10/2010  Alexander Yong    José Ramos      REQ-146383: Se modificó el procedimiento p_job_genera_corte, se aumentaron validaciones
                                                             para que a los registros que tengan sots de reconexión no se les genere sots de corte
      9.0      29/09/2010  Miguel Aroñe                      REQ 142941: Recargas Claro

      10.0      12/11/2010  Antonio Lagos     José Ramos     REQ.147952. se realiza validacion de que no se haya realizado recarga en INT
      11.0      30/11/2010  Alfonso Pérez     José Ramos     REQ 150061: Recargas no transferidas
      12.0      26/01/2011  Antonio Lagos     Edilberto A.   REQ 154951: Se agrega control de error en corte DTH
      13.0      28/03/2011  Alex Alamo        Edilberto A.   Req 153934, se crea el procedimiento para generacion de solicitudes de corte y reconexion de DTH recargable
      14.0      08/04/2011  Antonio Lagos     Edilberto A.   Mejoras cortes y reconexiones,control de errores
      15.0      07/04/2011  Ronal Corilloclla Melvin B.      Proyecto Suma de Cargo
                                                             1 - p_job_migra_cuponpago() - Modificado - Insertamos en cuponpago_dth los campos idvigencia y monto_ori
      16.0      07/04/2011  Luis Patiño                      Proyecto Suma de Cargo
      17.0      04/07/2011  Antonio Lagos     Juan Gallegos  REQ 160118.Reparar la caida del JOB 28703 (Suma de Cargo)
      18.0      12/08/2011  Alex Alamo        Edilberto A.   REQ 159269: Problemas en el Extorno de recargas virtuales TV SAT
      19.0      18/07/2012  Hector Huaman                    SD-117369 Corregir envio de bouquets 
      20.0      09/05/2013  Edson Caqui       Jimmy Cruzatte REQ. NC en OAC
 *********************************************************************/

  --procedure p_crea_sot_pago(a_numregistro varchar2,a_idcupon number) is --2.0
  procedure p_crea_sot(a_numregistro varchar2,
                       a_idcupon     number,
                       a_idctrlcorte number) is
    --2.0

    cursor cur_detalle is
      select b.codinssrv,
             c.codsrv,
             c.bw,
             c.cid,
             c.descripcion,
             c.direccion,
             c.codubi,
             c.codpostal
      --from recargaxinssrv b, inssrv c --2.0
        from ope_srv_recarga_det b, inssrv c --2.0
       where b.codinssrv = c.codinssrv
         and b.numregistro = a_numregistro;

    lr_solot    solot%rowtype;
    lr_solotpto solotpto%rowtype;
    ln_codsolot solot.codsolot%type;
    ln_punto    solotpto.punto%type;
    ls_tipsrv   tystipsrv.tipsrv%type;
    ls_codcli   vtatabcli.codcli%type;
    ln_tiptra   tiptrabajo.tiptra%type;
    ls_solucion soluciones.idsolucion%type;
    --<2.0
    --ln_num number;
    ln_num_reco number;
    ln_tiptrs   number; --tipo de transaccion
    ls_area_sol constante.valor%type;
    --2.0>
    --ini 5.0
    ln_cupon_extorno      number; -- Extorno de recarga
    ln_cupon_extorno_reco number; --Extorno de recarga y reconexión

    --fin 5.0
    --ini 13.0
    ln_wfdef number; --definicion de wf que se asignará a la SOT
    --ini 13.0
    -- ln_finpromocion number;
    ln_count number;
    --ini 13.0
    lc_abrev operacion.tipopedd.abrev%type; --16.0
  begin

    --ini 5.0
    ln_cupon_extorno      := 0;
    ln_cupon_extorno_reco := 0;
    --select a.codcli,b.tipsrv, idsolucion into ls_codcli,ls_tipsrv, ls_solucion
    select a.codcli, c.tipsrv, b.idsolucion
      into ls_codcli, ls_tipsrv, ls_solucion
    --from recargaproyectocliente a, vtatabslcfac b --2.0
    --from ope_srv_recarga_cab a, vtatabslcfac b --2.0
      from ope_srv_recarga_cab a, vtatabslcfac b, soluciones c
    --fin 5.0
     where numregistro = a_numregistro
          --ini 5.0
       and b.idsolucion = c.idsolucion
          --fin 5.0
       and a.numslc = b.numslc;
    --ini 5.0
    --si cupon tiene dato y no tiene marcado un corte proviene de una recarga
    if a_idcupon is not null and a_idctrlcorte is null then
      --si cupon tiene datos proviene de una recarga
      --if a_idcupon is not null  then --2.0
      --fin 5.0
      --se cuenta si hay reconexiones pendientes
      --select count(1) into ln_num --2.0
      select count(1)
        into ln_num_reco --2.0
      --from recargaproyectocliente a, cuponpago_dth_web b, reconexiondth_web c --2.0
        from ope_srv_recarga_cab a,
             cuponpago_dth_web   b,
             reconexiondth_web   c --2.0
       where a.numregistro = b.numregistro
         and b.idcupon = c.idcupon
         and b.idcupon = a_idcupon --2.0
         and c.flgtransferir = 1;
      --<2.0
      if ln_num_reco > 0 then
        ln_tiptrs := 4; --reconexion
      else
        --ini 5.0
        --Verifica si el cupón esta marcado para cortar la recarga por extorno de pago
        select count(1)
          into ln_cupon_extorno
          from cuponpago_dth_web
         where idcupon = a_idcupon
           and estado = 9;

        if ln_cupon_extorno > 0 then
          ln_tiptrs := 3; --suspension(extorno de recarga)
        else
          --fin 5.0
          --se coloca en null cuando no ejecuta ninguna transaccion,solo recarga
          ln_tiptrs := null;
          --ini 5.0
        end if;
        --fin 5.0
      end if;
    else
      if a_idctrlcorte is not null then
        ln_tiptrs := 3; --suspension
        --ini 13.0
        --fin 13.0
        --ini 5.0
        select count(1)
          into ln_cupon_extorno_reco
          from operacion.control_corte_dth a
         where a.idctrlcorte = a_idctrlcorte
           and a.motivo = 'CORTE POR EXTORNO';
        --fin 5.0
      end if;
    end if;
    --2.0>

    --si hay reconexion pendientes se genera workflow que contiene
    --actualizacion de vigencia en recargaproyectocliente, recarga en CDMA y reconexion de CDMA.
    --if ln_num > 0 then --2.0
    if nvl(ln_tiptrs, 0) = 4 then
      --2.0
      --ini 13.0
      --select codigon into ln_tiptra
      select codigon, codigon_aux
        into ln_tiptra, ln_wfdef
      --fin 13.0
        from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev = 'RECOTIPTRA'
         and codigoc = to_char(ls_solucion);
      --else --2.0
    elsif nvl(ln_tiptrs, 0) = 0 then
      --2.0
      --tipo de trabajo que hace actualizacion de vigencia recarga y recarga CDMA
      --ini 13.0
      --select codigon into ln_tiptra
      select codigon, codigon_aux
        into ln_tiptra, ln_wfdef
      --fin 13.0
        from opedd a, tipopedd b
       where a.tipopedd = b.tipopedd
         and b.abrev = 'RECARGATIPTRA'
         and codigoc = to_char(ls_solucion);
      --<2.0
    elsif nvl(ln_tiptrs, 0) = 3 then
      --ini 5.0
      if ln_cupon_extorno > 0 or ln_cupon_extorno_reco > 0 then
        --ini 13.0
        --select codigon into ln_tiptra
        select codigon, codigon_aux
          into ln_tiptra, ln_wfdef
        --fin 13.0
          from opedd a, tipopedd b
         where a.tipopedd = b.tipopedd
           and b.abrev = 'EXTORNOTIPTRA'
           and codigoc = to_char(ls_solucion);
      else
        --fin 5.0

        --<ini 16.0
        select decode(trim(tipo), 'SUSPENSION', 'SUSPTIPTRA', 'CORTETIPTRA')
          into lc_abrev
          from operacion.control_corte_dth
         where idctrlcorte = a_idctrlcorte;
        --fin 16.0>

        --tipo de trabajo que realiza el corte de servicio
        --ini 13.0
        --select codigon into ln_tiptra
        select codigon, codigon_aux
          into ln_tiptra, ln_wfdef
        --fin 13.0
          from opedd a, tipopedd b
         where a.tipopedd = b.tipopedd
              --and b.abrev = 'CORTETIPTRA' --16.0
           and trim(b.abrev) = lc_abrev --16.0
           and codigoc = to_char(ls_solucion);
        --ini 5.0
      end if;
      --fin 5.0
      --2.0>
    end if;

    lr_solot.tiptra := ln_tiptra;
    --lr_solot.codmotot := a_motot;
    lr_solot.feccom := trunc(sysdate);
    lr_solot.estsol := 10; --generada
    lr_solot.tipsrv := ls_tipsrv;
    lr_solot.codcli := ls_codcli;
    --<2.0
    --lr_solot.areasol := 325;--operaciones inalambrico
    select to_number(valor)
      into ls_area_sol
      from constante
     where constante = 'AREASOLBUNDLE';
    lr_solot.areasol := ls_area_sol; --area solicitante
    --2.0>
    --lr_solot.arearesp := ;
    --lr_solot.usuarioresp := ;
    --se crea a cabecera de la SOT
    pq_solot.p_insert_solot(lr_solot, ln_codsolot);

    if ln_codsolot is not null then

      --ini 5.0
      if a_idcupon is not null and a_idctrlcorte is null then
        /*--si la sot fue generada de un cupon entonces se c
        if a_idcupon is not null then --2.0*/
        --Si el cupón proviene por un extorno de recarga
        if ln_cupon_extorno > 0 then
          update cuponpago_dth a
             set codsolot_extorno = ln_codsolot
           where idcupon = a_idcupon;
        else
          --fin 5.0
          update cuponpago_dth
             set codsolot = ln_codsolot
           where idcupon = a_idcupon;
          --ini 5.0
        end if;
        --fin 5.0
        --<2.0
      else
        if a_idctrlcorte is not null then
          --ini 5.0 Si el corte proviene de un extorno de recarga y reconexión
          if ln_cupon_extorno_reco > 0 then
            update cuponpago_dth a
               set codsolot_extorno = ln_codsolot
             where idcupon = a_idcupon;
          end if;
          --fin 5.0
          update operacion.control_corte_dth
             set codsolot = ln_codsolot
           where idctrlcorte = a_idctrlcorte;
        end if;
      end if;
      --2.0>
    end if;

    for c_det in cur_detalle loop
      lr_solotpto.codsolot := ln_codsolot;
      --lr_solotpto.tiptrs := 4; --reconexion --2.0
      lr_solotpto.tiptrs      := ln_tiptrs; --2.0
      lr_solotpto.codsrvnue   := c_det.codsrv;
      lr_solotpto.bwnue       := c_det.bw;
      lr_solotpto.codinssrv   := c_det.codinssrv;
      lr_solotpto.cid         := c_det.cid;
      lr_solotpto.descripcion := c_det.descripcion;
      lr_solotpto.direccion   := c_det.direccion;
      lr_solotpto.tipo        := 2;
      lr_solotpto.estado      := 1;
      lr_solotpto.visible     := 1;
      lr_solotpto.codubi      := c_det.codubi;
      --lr_solotpto.pid := c_pid.pid;
      lr_solotpto.codpostal := c_det.codpostal;

      pq_solot.p_insert_solotpto(lr_solotpto, ln_punto);
    end loop;

    --ini 13.0
    pq_solot.p_asig_wf(ln_codsolot, ln_wfdef);

    /* --se aprueba la SOT
    pq_solot.p_aprobar_solot(ln_codsolot,c_estsol_aprobado);

     --Se graba el cambio de estado a "Aprobado".
     insert into SOLOTCHGEST (codsolot,tipo, estado, fecha, observacion)
     values (ln_codsolot,1,c_estsol_aprobado,sysdate,'Aprobacion automatica.');

     --se ejecuta la SOT
     pq_solot.p_ejecutar_solot(ln_codsolot,c_estsol_ejecucion);
     --fin 13.0 *\

     --ini 6.0
     if nvl(ln_tiptrs,0) = 4 or nvl(ln_tiptrs,0) = 0 then
        update ope_srv_recarga_cab
           set flg_recarga = 1
         where numregistro = a_numregistro
           and flg_recarga = 0;
     end if;
     --fin 6.0

     --<2.0
     --se da por transferida la reconexion
     /*update reconexiondth_web
     set flgtransferir = 2
     where idcupon = a_idcupon;*/
    --2.0>
  end;

  --<2.0
  procedure p_job_verifica is
    -- Job que controla las verificaciones de DTH en pesgaprd, para ejecutar cada 5 minutos
  begin
    p_job_verifica_reconexion;
    p_job_verifica_corte;
  end;

  -- Job que controla las recargas de saldo en pesgaprd, para ejecutar cada 5 minutos
  procedure p_job_migra_cuponpago is

    ll_reconec number;
    --ini 5.0
    ln_nro_sot_rec         number;
    ln_nro_sot_corte       number;
    ln_nro_sot_ext_recarga number;
    ln_estado              number;
    ln_flgtransferir       number;
    --fin 5.0
    --INI 19.0
    V_RESULTADO NUMBER;
    V_MENSAJE   VARCHAR2(3000);
    --FIN 19.0    
    cursor c_cuponpago is
      select a.*
        from cuponpago_dth_web a, ope_srv_recarga_cab b
       where a.numregistro = b.numregistro
         and a.flgtransferir = 1
      --ini 5.0
       order by a.idcupon
      --fin 5.0
      ;

    --INI 20.0
    /*--<2.0
    --ini 5.0
    cursor c_rec_pendientes_pago(a_numregistro varchar2, ppid number) is

      select distinct f.idfac, f.sersut, f.numsut
        from cxctabfac f, bilfac b, cr c, instxproducto i
       where f.idfac = b.idfaccxc
         and b.idbilfac = c.idbilfac
         and c.idinstprod = i.idinstprod
            --and i.pid in (select pid from recargaxinssrv where numregistro = a_numregistro)
         and i.pid in (select pid
                         from ope_srv_recarga_det
                        where numregistro = a_numregistro)
         and f.estfac not in ('01', '05', '06')
       order by 3 desc;
    --ini 5.0
    --2.0>*/
    --FIN 20.0
    
  begin

    for r_cuponpago in c_cuponpago loop
      begin

        --ini 5.0
        select count(1)
          into ln_nro_sot_rec
          from cuponpago_dth a, solot b, estsol c -- ini 11.0
         where a.numregistro = r_cuponpago.numregistro
           and a.codsolot = b.codsolot
              --ini 11.0
           and b.estsol = c.estsol
           and c.tipestsol not in
               (select codigon
                  from opedd
                 where tipopedd in (select tipopedd
                                      from tipopedd
                                     where abrev = 'ESTSOLOT')) --fin 11.0
           and a.idcupon <> r_cuponpago.idcupon;

        select count(1)
          into ln_nro_sot_corte
          from operacion.control_corte_dth a, solot b, estsol c --ini 11.0
         where a.numregistro = r_cuponpago.numregistro
           and a.codsolot = b.codsolot
              --ini 11.0
           and b.estsol = c.estsol
           and c.tipestsol not in
               (select codigon
                  from opedd
                 where tipopedd in (select tipopedd
                                      from tipopedd
                                     where abrev = 'ESTSOLOT')); --fin 11.0

        select count(1)
          into ln_nro_sot_ext_recarga
          from cuponpago_dth a, solot b, estsol c --ini 11.0
         where a.numregistro = r_cuponpago.numregistro
           and a.estado = 9
           and a.codsolot_extorno = b.codsolot
              --ini 11.0
           and b.estsol = c.estsol
           and c.tipestsol not in
               (select codigon
                  from opedd
                 where tipopedd in (select tipopedd
                                      from tipopedd
                                     where abrev = 'ESTSOLOT')) --fin 11.0
           and a.idcupon <> r_cuponpago.idcupon;

        select flgtransferir, estado
          into ln_flgtransferir, ln_estado
          from cuponpago_dth_web
         where idcupon = r_cuponpago.idcupon;

        if ln_flgtransferir = 1 then
          if ln_estado = 1 then
            if ln_nro_sot_rec = 0 and ln_nro_sot_corte = 0 and
               ln_nro_sot_ext_recarga = 0 then
              --fin 5.0
              --15.0 Suma de Cargos: 1 - Insertamos en cuponpago_dth los campos idvigencia y monto_ori
              --1. Transferir el pago a PESGAPRD
              insert into cuponpago_dth
                (idcupon,
                 codcli,
                 cantidad,
                 monto,
                 estado,
                 feccargo,
                 desde,
                 hasta,
                 numregistro,
                 pid,
                 idinstprod,
                 idlote,
                 iddet,
                 contrato,
                 idcuponpagoweb,
                 nroconfir,
                 idterminal,
                 agenterecarga,
                 idpaq,
                 cid,
                 flgliquidacion,
                 numser,
                 numsut,
                 idbilfac,
                 codigo_recarga, --ini 5.0
                 idrecarga, --fin 5.0
                 idvigencia, --<15.0>
                 monto_ori -->15.0>
                 )
              values
                (r_cuponpago.idcupon,
                 r_cuponpago.codcli,
                 r_cuponpago.cantidad,
                 r_cuponpago.monto,
                 r_cuponpago.estado,
                 r_cuponpago.feccargo,
                 r_cuponpago.desde,
                 r_cuponpago.hasta,
                 r_cuponpago.numregistro,
                 r_cuponpago.pid,
                 r_cuponpago.idinstprod,
                 r_cuponpago.idlote,
                 r_cuponpago.iddet,
                 r_cuponpago.contrato,
                 r_cuponpago.idcupon,
                 r_cuponpago.refnumber,
                 trim(r_cuponpago.idterminal), --9.0
                 r_cuponpago.agenterecarga,
                 r_cuponpago.idpaq,
                 r_cuponpago.cid,
                 0,
                 r_cuponpago.numser,
                 r_cuponpago.numsut,
                 r_cuponpago.idbilfac,
                 r_cuponpago.codigo_recarga, --ini 5.0
                 r_cuponpago.idrecarga, --fin 5.0
                 r_cuponpago.idvigencia, --<15.0>
                 r_cuponpago.monto_ori --<15.0>
                 );

              --ini 18.0
              /*update cuponpago_dth_web
                 set flgtransferir = 2
               where idcupon = r_cuponpago.idcupon;*/
              --fin 18.0

              -- Se verifica si se ha generado reconexion
              select count(1)
                into ll_reconec
                from reconexiondth_web
               where idcupon = r_cuponpago.idcupon;
              if ll_reconec = 0 then
                update operacion.bouquetxreginsdth
                   set flg_transferir = 1
                 where numregistro = r_cuponpago.numregistro
                   and tipo = 0
                   and estado = 0;
              end if;
              --2. Anular los documentos en estado generado para que no se emitan
              update bilfac
                 set estfac = '06'
               where estfac = '01'
                 and idbilfac in
                     (select distinct idbilfac
                        from cr, instxproducto i
                       where cr.idinstprod = i.idinstprod
                         and i.pid in
                             (select pid
                                from ope_srv_recarga_det
                               where numregistro = r_cuponpago.numregistro));

              --3. Generar N/C por los documentos pendientes de pago
              --INI 20.0
              /*--<2.0
              --ini 5.0
              for r_rec_pend_pago in c_rec_pendientes_pago(r_cuponpago.numregistro,
                                                           r_cuponpago.pid) loop
                COLLECTIONS.PQ_NOTACREDITO_AUTOMATICA.P_NCRECARGA_DTH(r_rec_pend_pago.idfac,
                                                                      r_rec_pend_pago.sersut,
                                                                      r_cuponpago.refnumber,
                                                                      r_cuponpago.feccargo);
              end loop;
              --fin 5.0
              --2.0>*/
              BEGIN
                COLLECTIONS.PQ_CXC_NOTACREDITO.P_NC_MAIN(0, --TIPO
                                                         2, --SUBTIPO
                                                         NULL, --INCIDENCIA
                                                         NULL, --SOLOT
                                                         R_CUPONPAGO.NUMREGISTRO, --OTRO
                                                         NULL, --SERIE
                                                         V_RESULTADO,
                                                         V_MENSAJE);
              END;
              --FIN 20.0
              
              --ini 9.0
              if r_cuponpago.flgejecutado = 0 then
                pq_control_inalambrico.p_crea_sot(r_cuponpago.numregistro,
                                                  r_cuponpago.idcupon,
                                                  null);
              end if;
              --fin 9.0
              --ini 5.0
              -- Ini 18.0
              update cuponpago_dth_web
                 set flgtransferir = 2
               where idcupon = r_cuponpago.idcupon;
              -- Fin 18.0
            end if;
          else
            if ln_nro_sot_rec = 0 and ln_nro_sot_corte = 0 and
               ln_nro_sot_ext_recarga = 0 then
              --ini 18.0
              /*update cuponpago_dth_web
                 set flgtransferir = 2
               where idcupon = r_cuponpago.idcupon;

              update cuponpago_dth
                 set estado = 9
               where idcupon = r_cuponpago.idcupon;*/
              --fin 18.0
              --ini 9.0
              if r_cuponpago.flgejecutado = 0 then
                pq_control_inalambrico.p_crea_sot(r_cuponpago.numregistro,
                                                  r_cuponpago.idcupon,
                                                  null);
              end if;
              -- Ini 18.0
              update cuponpago_dth_web
                 set flgtransferir = 2
               where idcupon = r_cuponpago.idcupon;

              update cuponpago_dth
                 set estado = 9
               where idcupon = r_cuponpago.idcupon;
              -- Fin 18.0
            end if; --fin 9.0
          end if;
        end if;
        --fin 5.0
        commit;
      end;
    end loop;

  end;

  procedure p_job_verifica_reconexion is

    ls_resultado           varchar2(20);
    ls_mensaje             varchar2(1000);
    ls_estado              operacion.reginsdth.estado%TYPE;
    ls_tipesttar           esttarea.tipesttar%TYPE;
    lv_observacion         varchar2(4000);
    ln_codsolot            solot.codsolot%type;
    ls_esttarea            tareawf.esttarea%type;
    l_canfileenv_con_error number;
    -- registros con solicitud de reconexion en sistema recarga
    cursor c_regverif is
      select a.numregistro, b.codinssrv, b.pid, b.ulttareawf
        from ope_srv_recarga_cab a, ope_srv_recarga_det b
       where a.numregistro = b.numregistro
         and b.estado = '14'
         and a.flg_recarga = 1
         and b.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');
  begin
    for r_regverif in c_regverif loop
      ls_resultado := '';
      ls_mensaje   := '';

      begin
        select esttarea
          into ls_esttarea
          from tareawf
         where idtareawf = r_regverif.ulttareawf;

        --solo verifica si no esta marcado con estado error
        if (ls_esttarea <> cn_esttarea_error) then
          operacion.pq_dth.p_proc_recu_filesxcli(r_regverif.numregistro,
                                                 4,
                                                 ls_resultado,
                                                 ls_mensaje);

          select estado
            into ls_estado
            from ope_srv_recarga_det
           where numregistro = r_regverif.numregistro
             and tipsrv =
                 (select valor from constante where constante = 'FAM_CABLE');

          if ls_resultado = 'OK' and ls_estado = '17' then
            --se cierra la tarea de reconexion
            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_cerrado;

            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                             ls_tipesttar,
                                             cn_esttarea_cerrado,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
            --se ingresa comentario en la tarea
            lv_observacion := 'Verificado en Conax.';
            insert into tareawfseg
              (idtareawf, observacion)
            values
              (r_regverif.ulttareawf, lv_observacion);
          else
            --se averigua si ha habido error en los archivos enviados
            select count(1)
              into l_canfileenv_con_error
              from operacion.reg_archivos_enviados
             where estado = 3 --error
               and numregins = r_regverif.numregistro
               and fecenv is not null;

            if l_canfileenv_con_error > 0 then
              --se cambia a estado con errores
              SELECT tipesttar
                INTO ls_tipesttar
                FROM esttarea
               WHERE esttarea = cn_esttarea_error;

              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                               ls_tipesttar,
                                               cn_esttarea_error,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
              begin
                select b.codsolot
                  into ln_codsolot
                  from tareawf a, wf b
                 where a.idtareawf = r_regverif.ulttareawf
                   and a.idwf = b.idwf;

                --se ingresa comentario en la tarea
                insert into tareawfseg
                  (idtareawf, observacion)
                values
                  (r_regverif.ulttareawf, ls_mensaje);

              exception
                when others then
                  ln_codsolot := null;
              end;

              p_envia_correo_c_attach('Reconexion BUNDLE',
                                      'DL-PE-ITSoportealNegocio@claro.com.pe', --7.0
                                      'No se completó la verificación de la reconexion del servicio DTH, SOT: ' ||
                                      to_char(ln_codsolot) ||
                                      ', NumRegistro: ' ||
                                      r_regverif.numregistro || ', PID: ' ||
                                      r_regverif.pid || ', mensaje: ' ||
                                      ls_mensaje,
                                      null,
                                      'SGA'); --7.0

              lv_observacion := 'Se verifico en conax con errores.';
            else
              lv_observacion := 'No hubo resultado de verificación.';
            end if;

            --se ingresa comentario en la tarea
            insert into tareawfseg
              (idtareawf, observacion)
            values
              (r_regverif.ulttareawf, lv_observacion);
          end if;
          commit;
        end if;
      end;
    end loop;
  end p_job_verifica_reconexion;

  procedure p_job_genera_corte(ld_feccorte date) is
    cursor c_regcorte(an_dias_gracia number) is --16 .0 se agrego an_dias_gracia
      select a.*
        from ope_srv_recarga_cab a,
             --ini 4.0
             vtatabslcfac v
      --fin 4.0
       where a.flg_recarga = 1
            --and trunc(a.feccorte) <= trunc(ld_feccorte) 16.0 se comenta
            --and a.estado in ('02') --activo 16.0 se comenta
            --ini 4.0
            --< ini 16.0
         and a.estado = '03' --media suspendido
         and (((select trunc(b.fecfin)
                  from operacion.control_corte_dth aa, solot b
                 where aa.idctrlcorte =
                       (select max(idctrlcorte)
                          from operacion.control_corte_dth
                         where numregistro = a.numregistro
                           and tipo = 'SUSPENSION'
                           and estcorte = 3)
                   and aa.codsolot = b.codsolot) + an_dias_gracia) <=
             trunc(ld_feccorte))
         and a.numslc = v.numslc
         and exists (select 1
                      from ope_srv_recarga_cab aa
                      where ((select max(idctrlcorte)
                             from operacion.control_corte_dth
                             where numregistro = a.numregistro
                             and estcorte = 3) = (select max(idctrlcorte)
                                                   from operacion.control_corte_dth
                                                   where numregistro = a.numregistro
                                                   and tipo = 'SUSPENSION'
                                                   and estcorte = 3))
                     and aa.numregistro = a.numregistro)
            --fin 16.0>
         and a.numslc = v.numslc
         and exists (select 1
                from opedd o, tipopedd b
               where o.tipopedd = b.tipopedd
                 and b.abrev = 'CORTETIPTRA'
                    --ini 13.0
                 and o.codigon is not null
                 and o.codigon_aux is not null
                    --fin 13.0
                 and o.codigoc = to_char(v.idsolucion));
    --fin 4.0

    ln_idctrlcorte number;
    --ini 5.0
    ln_num_cortes_pendientes number;
    --fin 5.0
    --Ini 8.0
    ln_fecha_menor      number;
    ln_sots_no_cerradas number;
    --Fin 8.0
    --ini 10.0
    ln_recargas_no_procesadas number;
    --fin 10.0
    --ini 12.0
    --ln_proceso_prom number;--13.0
    ln_proceso_sot number;
    --fin 12.0
    --<ini 16.0
    ln_dias_gracias         number;
    ln_idctrlcorte_max_susp control_corte_dth.idctrlcorte%type;
    ln_idctrlcorte_max      control_corte_dth.idctrlcorte%type;
    ld_fecini_solot         solot.fecusu%type;
    ld_fecfin_solot         solot.fecusu%type;
    --fin 16.0>
  begin

    --<ini 16.0
    begin
      select b.codigon
        into ln_dias_gracias
        from operacion.tipopedd a, operacion.opedd b
       where a.abrev = 'DTHRECARDIAS'
         and a.tipopedd = b.tipopedd
         and b.abreviacion = 'CORTE';
    exception
      when no_data_found then
        ln_dias_gracias := 0;
    end;
    --fin 16.0>

    for r_regcorte in c_regcorte(ln_dias_gracias) loop
      --Ini 8.0
      select count(1)
        into ln_fecha_menor
        from ope_srv_recarga_cab a
       where trunc(a.feccorte) <= trunc(ld_feccorte)
         and a.numregistro = r_regcorte.numregistro;

      --<ini 16.0

      select trunc(b.fecusu), trunc(b.fecfin)
        into ld_fecini_solot, ld_fecfin_solot
        from operacion.control_corte_dth a, solot b
       where a.idctrlcorte = (select max(idctrlcorte)
                                from operacion.control_corte_dth
                               where numregistro = r_regcorte.numregistro
                                 and tipo = 'SUSPENSION'
                                 and estcorte = 3)
         and a.codsolot = b.codsolot;

      select count(1)
        into ln_sots_no_cerradas
        from cuponpago_dth a, solot s
       where a.numregistro = r_regcorte.numregistro
         and a.codsolot = s.codsolot
         and s.estsol <> c_estsol_cerrado
         and ((trunc(s.fecusu) >= ld_fecini_solot) and
             (trunc(s.fecusu) <= trunc(ld_feccorte)));

      select count(1)
        into ln_recargas_no_procesadas
        from cuponpago_dth_web
       where numregistro = r_regcorte.numregistro
         and flgtransferir in (0, 1)
         and ((trunc(fecreg) >= ld_fecini_solot) and
             (trunc(fecreg) <= trunc(ld_feccorte)));

      --fin 16.0>
      --<ini 16.0 se comenta
      /*
      select count(1)
        into ln_sots_no_cerradas
        from cuponpago_dth a, solot s
       where a.numregistro = r_regcorte.numregistro
         and a.codsolot = s.codsolot
         and s.estsol <> c_estsol_cerrado
         and trunc(s.fecusu) = trunc(ld_feccorte);

      --ini 10.0
      select count(1)
      into ln_recargas_no_procesadas
      from cuponpago_dth_web
      where numregistro = r_regcorte.numregistro
      and flgtransferir in (0,1)
      and trunc(fecreg) = trunc(ld_feccorte);*/
      --fin 16.0>

      --If ln_fecha_menor>0 and ln_sots_no_cerradas=0 then
      if (ld_fecfin_solot + ln_dias_gracias <= trunc(ld_feccorte)) then
        --16.0
        if ln_fecha_menor > 0 and ln_sots_no_cerradas = 0 and
           ln_recargas_no_procesadas = 0 then
          --fin 10.0
          --Fin 8.0
          --ini 5.0
          select count(1)
            into ln_num_cortes_pendientes
            from operacion.control_corte_dth
           where numregistro = r_regcorte.numregistro
                --ini 10.0
             and codsolot is not null --se considera lo que se genero en el nuevo proceso
                --fin 10.0
             and estcorte in (1, 2); --generado, enviado

          if ln_num_cortes_pendientes = 0 then
            --ini 12.0
            /*update reginsdth_web
            set estado = '03',
            estinsprd = 2
            where numregistro = r_regcorte.numregistro;  */
            --fin 5.0
            --fin 12.0
            select sq_ctrlcortedth.nextval
              into ln_idctrlcorte
              from dummy_ope;
            insert into operacion.control_corte_dth
              (idctrlcorte,
               numregistro,
               feccorteprg,
               feccortereal,
               estcorte,
               motivo,
               tipo)
            values
              (ln_idctrlcorte,
               r_regcorte.numregistro,
               r_regcorte.feccorte,
               sysdate,
               1,
               'FIN DE VIGENCIA',
               'CORTE');
            --ini 12.0
            commit; --se graba
            --fin 12.0
            begin
              p_crea_sot(r_regcorte.numregistro, null, ln_idctrlcorte);
              --ini 12.0
              ln_proceso_sot := 1;
              --fin 12.0
            exception
              when others then
                rollback;
                -- Se anula el envio del corte
                --ini 12.0
                ln_proceso_sot := 0;
                --update control_corte_dth
                update operacion.control_corte_dth
                --fin 12.0
                   set estcorte = 9,
                       mensaje  = 'Error en generación de corte,al crear SOT'
                 where idctrlcorte = ln_idctrlcorte;
            end;
            --ini 3.0 Genera Corte Bouquets promocionales
            --ini 12.0
            if ln_proceso_sot = 1 then
              --ini 13.0
              /*begin
              --fin 12.0
                  pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(null,r_regcorte.numregistro);
              --ini 12.0
                  ln_proceso_prom := 1;
                exception
                  when others then
                   rollback;
                   -- Se anula el envio del corte
                   update operacion.control_corte_dth
                     set estcorte = 9,
                         mensaje  = 'Error al cortar bouquets promocionales'
                   where idctrlcorte = ln_idctrlcorte;
                   ln_proceso_prom := 0;
                end;

                if ln_proceso_prom = 1 then*/
              --fin 13.0
              begin
                update reginsdth_web
                   set estado = '03', estinsprd = 2
                 where numregistro = r_regcorte.numregistro;

              exception
                when others then
                  rollback;
                  update operacion.control_corte_dth
                     set estcorte = 9,
                         mensaje  = 'Error al actualizar en INT'
                   where idctrlcorte = ln_idctrlcorte;
              end;
              --ini 13.0
              --end if;
              --fin 13.0
            end if;
            --fin 12.0
            --fin 3.0
            commit;
            --ini 5.0
          end if;
          --fin 5.0
        end if;
      end if; --16.0
    end loop;
    --ini 13.0
    --se generan los cortes para los bouquets promocionales
    billcolper.pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(sysdate,
                                                                      null);
    --p_job_verifica_corte; --cuando se termina generacion de cortes se realiza la verificacion
    --fin 13.0
  end;

  procedure p_job_verifica_corte is

    ls_resultado           varchar2(20);
    ls_mensaje             varchar2(1000);
    ls_estado              operacion.reginsdth.estado%TYPE;
    ls_tipesttar           esttarea.tipesttar%TYPE;
    lv_observacion         varchar2(4000);
    ln_codsolot            solot.codsolot%type;
    ls_esttarea            tareawf.esttarea%type;
    l_canfileenv_con_error number;

    -- registros con solicitud de corte en sistema recarga
    cursor c_regverif is
    --se buscan los servicios DTH para verificarlos
      select a.numregistro, b.codinssrv, b.pid, b.estado, b.ulttareawf
        from ope_srv_recarga_cab a, ope_srv_recarga_det b
       where a.numregistro = b.numregistro
         and b.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE')
         and b.estado = '13'
         and a.flg_recarga = 1;

  begin
    for r_regverif in c_regverif loop
      ls_resultado := '';
      ls_mensaje   := '';

      begin
        select esttarea
          into ls_esttarea
          from tareawf
         where idtareawf = r_regverif.ulttareawf;

        --solo verifica si no esta marcado con estado error
        if (ls_esttarea <> cn_esttarea_error) then
          operacion.pq_dth.p_proc_recu_filesxcli(r_regverif.numregistro,
                                                 3,
                                                 ls_resultado,
                                                 ls_mensaje);

          select estado
            into ls_estado
            from ope_srv_recarga_det
           where numregistro = r_regverif.numregistro
             and pid = r_regverif.pid;

          if ls_resultado = 'OK' and ls_estado = '16' then
            --cierra tarea de suspension
            SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_cerrado;

            OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                             ls_tipesttar,
                                             cn_esttarea_cerrado,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
            --se ingresa comentario en la tarea
            lv_observacion := 'Verificado en Conax.';
            insert into tareawfseg
              (idtareawf, observacion)
            values
              (r_regverif.ulttareawf, lv_observacion);
          else
            --se averigua si ha habido error en los archivos enviados
            select count(1)
              into l_canfileenv_con_error
              from operacion.reg_archivos_enviados
             where estado = 3 --error
               and numregins = r_regverif.numregistro
               and fecenv is not null;

            if l_canfileenv_con_error > 0 then
              --se cambia a estado con errores
              SELECT tipesttar
                INTO ls_tipesttar
                FROM esttarea
               WHERE esttarea = cn_esttarea_error;

              OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                               ls_tipesttar,
                                               cn_esttarea_error,
                                               0,
                                               SYSDATE,
                                               SYSDATE);
              begin
                select b.codsolot
                  into ln_codsolot
                  from tareawf a, wf b
                 where a.idtareawf = r_regverif.ulttareawf
                   and a.idwf = b.idwf;

                --se ingresa comentario en la tarea
                insert into tareawfseg
                  (idtareawf, observacion)
                values
                  (r_regverif.ulttareawf, ls_mensaje);

              exception
                when others then
                  ln_codsolot := null;
              end;

              p_envia_correo_c_attach('Cortes BUNDLE',
                                      'DL-PE-ITSoportealNegocio@claro.com.pe', --7.0
                                      'No se completó la verificación del corte  de servicio DTH, SOT: ' ||
                                      to_char(ln_codsolot) ||
                                      ', NumRegistro: ' ||
                                      r_regverif.numregistro || ', PID: ' ||
                                      r_regverif.pid || ', mensaje: ' ||
                                      ls_mensaje,
                                      null,
                                      'SGA'); --7.0

              lv_observacion := 'Se verifico en conax con errores.';
            else
              lv_observacion := 'No hubo resultado de verificación.';
            end if;

            --se ingresa comentario en la tarea
            insert into tareawfseg
              (idtareawf, observacion)
            values
              (r_regverif.ulttareawf, lv_observacion);
          end if;
        end if;
        commit;
      end;
    end loop;
  end;
  --2.0>

  --ini 5.0
  procedure p_job_genera_cortexextorno is
    cursor c_regcorte is
      select *
        from cortedth_web
       where flgtransferir = 1
         and pid is null
       order by idcupon;

    ln_idctrlcorte number;
    ln_estado      number;
    lc_numregistro ope_srv_recarga_cab.numregistro%type;

  begin
    for r_regcorte in c_regcorte loop
      -- Valida si la SOT de reconexión se cerró

      select a.numregistro
        into lc_numregistro
        from cuponpago_dth a
       where a.idcupon = r_regcorte.idcupon;

      select s.estsol
        into ln_estado
        from cuponpago_dth a, solot s
       where a.idcupon = r_regcorte.idcupon
         and a.codsolot = s.codsolot;

      if ln_estado = c_estsol_cerrado then
        select sq_ctrlcortedth.nextval into ln_idctrlcorte from dummy_ope;

        insert into operacion.control_corte_dth
          (idctrlcorte, numregistro, feccortereal, estcorte, motivo, tipo)
        values
          (ln_idctrlcorte,
           lc_numregistro,
           sysdate,
           1,
           'CORTE POR EXTORNO',
           'CORTE');

        update cortedth_web a
           set a.flgtransferir = 2
         where a.idcupon = r_regcorte.idcupon;

        update cuponpago_dth
           Set estado = 9
         where idcupon = r_regcorte.idcupon;

        begin
          p_crea_sot(lc_numregistro, r_regcorte.idcupon, ln_idctrlcorte);
        exception
          when others then
            rollback;
            -- Se anula el envio del corte
            update control_corte_dth
               set estcorte = 9,
                   mensaje  = 'Error en generación de corte,al crear SOT'
             where idctrlcorte = ln_idctrlcorte;
        end;
        pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(null,
                                                               lc_numregistro);
        commit;
      end if;
    end loop;
    p_job_verifica_corte; --cuando se termina generacion de cortes se realiza la verificacion
  end;
  --fin 5.0

  --ini 13.0
  /**********************************************************************
  Procedimiento que genera solicitudes de suspension/activacion al conax de servicios recargables
  **********************************************************************/
  procedure p_gen_archivo_tvsat_rec(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) is

    lc_mensaje     varchar2(2000);
    ln_codsolot    solot.codsolot%type;
    ln_tipsol      ope_tvsat_sltd_cab.tiposolicitud%type;
    ln_codinssrv   cxc_inscabcorte.codinssrv%type;
    lc_codcli      cxc_inscabcorte.codcli%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    lc_bouquets    tystabsrv.codigo_ext%type;
    ln_largo       number(4);
    ln_numbouquets number(4);
    lc_codext      varchar2(10);
    lc_numregistro reginsdth.numregistro%type;
    lc_correos_it  varchar2(2000);
    le_error exception;
    ln_tiptrs tiptrabajo.tiptrs%type;
    ln_num    number(4);
  begin
    --Obtencion del numero de solot
    begin
      select codsolot into ln_codsolot from wf where idwf = a_idwf;
    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion el codigo de solot';
        raise le_error;
    end;

    --Se actualiza el estado de la tarea a ejecucion
    update tareawf
       set esttarea = 2 -- En ejecucion
     where idtareawf = a_idtareawf;

    --Obtencion de la transaccion
    begin

      select a.tiptrs, b.codcli, c.codinssrv
        into ln_tiptrs, lc_codcli, ln_codinssrv
        from tiptrabajo a, solot b, solotpto c, inssrv d
       where b.codsolot = ln_codsolot
         and a.tiptra = b.tiptra
         and b.codsolot = c.codsolot
         and c.codinssrv = d.codinssrv
         and d.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');

    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion de la transaccion';
        raise le_error;
    end;

    --identificacion del tipo de solicitud
    if ln_tiptrs = 3 then
      --Es una solicitud de suspension
      ln_tipsol := 1; --Suspension
    elsif ln_tiptrs = 4 then
      --Es una solicitud de reconexion
      ln_tipsol := 2; --Reconexion
    end if;

    --Obtener Registro de Cliente DTH
    begin
      lc_numregistro := pq_inalambrico.f_obtener_numregistro(ln_codsolot);
    exception
      when others then
        lc_mensaje := 'Error al obtener el numero de registro dth';
        raise le_error;
    end;

    --Se genera el idsol
    select sq_ope_tvsat_sltd_cab_idsol.nextval
      into ln_idsol
      from DUMMY_OPE;

    --creacion de la cabecera de la solicitud
    insert into ope_tvsat_sltd_cab
      (idsol,
       tiposolicitud,
       codinssrv,
       codcli,
       codsolot,
       idwf,
       idtareawf,
       estado,
       numregistro,
       FLG_RECARGA)
    values
      (ln_idsol,
       ln_tipsol,
       ln_codinssrv,
       lc_codcli,
       ln_codsolot,
       a_idwf,
       a_idtareawf,
       PQ_OPE_INTERFAZ_TVSAT.FND_ESTADO_PEND_EJECUCION,
       lc_numregistro,
       1 --recargable
       );

    /**********************************************************
    Cursor para obtener las tarjetas y boquetes
    ***********************************************************/
    --ini 14.0
    --for reg in( select distinct cab.numregistro,a.numserie serie, a.tipequ,
    for reg in (select distinct cab.numregistro,
                                trim(a.numserie) serie,
                                a.tipequ,
                                --fin 14.0
                                (select --distinct tystabsrv.codigo_ext 16.0 se comento
                                 distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv)) --16.0
                                   from paquete_venta,
                                        detalle_paquete,
                                        linea_paquete,
                                        producto,
                                        tystabsrv
                                  where paquete_venta.idpaq = cab.idpaq
                                    and paquete_venta.idpaq =
                                        detalle_paquete.idpaq
                                    and detalle_paquete.iddet =
                                        linea_paquete.iddet
                                    and detalle_paquete.idproducto =
                                        producto.idproducto
                                    and detalle_paquete.flgestado = 1
                                    and linea_paquete.flgestado = 1
                                    and detalle_paquete.flgprincipal = 1
                                    and producto.tipsrv =
                                        (select valor
                                           from constante
                                          where constante = 'FAM_CABLE') --12.0
                                    and linea_paquete.codsrv =
                                        tystabsrv.codsrv
                                    and PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv) is not null -- 16.0
                                 --and tystabsrv.codigo_ext is not null 16.0 se comento
                                 ) codigo_ext
                  from ope_srv_recarga_cab cab,
                       solotptoequ a,
                       (select a.codigon tipequope, codigoc grupoequ
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX') b
                 where cab.codsolot = a.codsolot
                   and a.tipequ = b.tipequope
                   and b.grupoequ = '1'
                   and cab.numregistro = lc_numregistro) loop

      --fin REQ-MIGRACION-DTH 4.00

      lc_bouquets    := trim(reg.codigo_ext);
      ln_largo       := length(lc_bouquets);
      ln_numbouquets := (ln_largo + 1) / 4;

      /**********************************
      Se separan los bouquetes
      **********************************/
      for i in 1 .. ln_numbouquets loop

        lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i), 8, '0');

        --Insercion en la tabla temporal
        insert into ope_tmp_tarjeta_bouquete
          (numregistro, serie, codext)
        values
          (reg.numregistro, reg.serie, lc_codext);

      end loop;

    end loop;

    /***********************************************
    Registro del detalle de la solicitud (Tarjetas)
    ************************************************/
    for reg in (select distinct serie
                  from ope_tmp_tarjeta_bouquete
                 where numregistro = lc_numregistro
                 order by serie asc) loop

      insert into ope_tvsat_sltd_det
        (idsol, serie)
      values
        (ln_idsol, reg.serie);
    end loop;

    /***********************************************
    Registro de los bouquetes
    ************************************************/
    for reg in (select distinct serie, codext
                  from ope_tmp_tarjeta_bouquete
                 order by serie, codext) loop

      select count(1)
        into ln_num
        from OPE_TVSAT_SLTD_BOUQUETE_DET
       where idsol = ln_idsol
         and serie = reg.serie
         and bouquete = reg.codext;

      if ln_num = 0 then
        insert into ope_tvsat_sltd_bouquete_det
          (idsol, serie, bouquete, tipo)
        values
          (ln_idsol,
           reg.serie,
           reg.codext,
           2 --principal
           );
      end if;
    end loop;

    if ln_tipsol = 1 then
      --suspension
      /**************************************************
      Bouquetes adicionales
      **************************************************/
      for reg in (select b.idsol,
                         --ini 14.0
                         --b.serie,
                         trim(b.serie) serie,
                         --fin 14.0
                         a.bouquets bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 0
                     and a.estado = 1
                     and a.numregistro = lc_numregistro
                    --<ini 16.0
                  union all
                  select b.idsol,
                         trim(b.serie) serie,
                         a.bouquets bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 3--adicional cnr
                     and a.estado=1
                     and a.numregistro=lc_numregistro
                     and a.fecha_fin_vigencia < trunc(sysdate)
                     --fin 16.0>
                     ) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               1 --adicional
               );
          end if;
        end loop;

      end loop;

    elsif ln_tipsol = 2 then
      --reconexion

      for reg in (select b.idsol,
                         --ini 14.0
                         --b.serie,
                         trim(b.serie) serie,
                         --fin 14.0
                         --c.codigo_ext bouquets --16.0 se comenta
                         trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(a.codsrv)) bouquets --16.0 se agrega
                    from bouquetxreginsdth  a,
                         ope_tvsat_sltd_det b,
                         tystabsrv          c
                   where b.idsol = ln_idsol
                     and a.codsrv = c.codsrv
                     and (a.tipo = 0
                         --<ini 16.0
                         or (a.tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(a.pid,
                                                                                              sysdate),
                                                 0) > 0) --adicional cnr
                         )
                        --fin 16.0>
                     and a.estado = 0
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               1 --adicional
               );
          end if;
        end loop;

      end loop;

    end if;

    /**************************************************
    Bouquetes promocionales
    **************************************************/
    if ln_tipsol = 1 then
      --suspension
      for reg in (select b.idsol,
                         --ini 14.0
                         trim(b.serie) serie,
                         --fin 14.0
                         a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               3 --promocional
               );
          end if;
        end loop;
      end loop;
    end if;

    if ln_tipsol = 1 then
      --suspension
      --se actualizan los bouquets adicionales y promocionales
      update bouquetxreginsdth
         set estado = 0, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo in (0, 2, 3) --adicional, promocional --16.0 se agrego el tipo:3
         and estado = 1;
    else
      --for reg in (select a.codsrv, b.codigo_ext
      for reg in (select a.codsrv, trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(b.codsrv))codigo_ext --19.0
                    from bouquetxreginsdth a, tystabsrv b
                   where a.codsrv = b.codsrv
                     and (a.tipo = 0
                         --<ini 16.0
                         or (a.tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(a.pid,
                                                                                              sysdate),
                                                 0) > 0))
                        -- fin 16.0>
                     and a.estado = 0
                     and a.numregistro = lc_numregistro) loop
        --se actualizan los bouquets adicionales
        update bouquetxreginsdth
           set estado = 1, fecultenv = sysdate, bouquets = reg.codigo_ext --se actualiza el codigo externo
         where numregistro = lc_numregistro
           and (tipo = 0 --adicional
               --<ini 16.0
               or (tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(pid,
                                                                                  sysdate),
                                     0) > 0)) -- fin 16.0>
           and estado = 0
           and codsrv = reg.codsrv;
      end loop;
    end if;

    insert into tareawfseg
      (idtareawf, observacion)
    values
      (a_idtareawf, 'Solicitud conax generada');

  exception
    when le_error then
      --ini 17.0
      if lc_numregistro is not null then
         pq_control_dth.p_graba_log('Error generacion de solicitud de Corte/Reconexion - DTH, numero de registro:'||lc_numregistro,sqlerrm);
      else
         pq_control_dth.p_graba_log('Error generacion de solicitud de Corte/Reconexion - DTH',sqlerrm);
      end if;
      --fin 17.0
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      --ini 17.0
      lc_mensaje := sqlerrm;
      /*update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);*/
      --fin 17.0
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      --Se envia correo
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
    when others then
      --ini 17.0
      if lc_numregistro is not null then
         operacion.pq_control_dth.p_graba_log('Error generacion de solicitud de Corte/Reconexion - DTH, numero de registro:'||lc_numregistro,sqlerrm);
      else
         operacion.pq_control_dth.p_graba_log('Error generacion de solicitud de Corte/Reconexion - DTH',sqlerrm);
      end if;
      --fin 17.0
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      --ini 17.0
      /*update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;*/
       --fin 17.0
      lc_mensaje := sqlerrm;
      --Se ingresa una anotacion
      --ini 17.0
      /*insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);
      lc_mensaje    := 'Se produjo un error en la ejecucion de la tarea ' ||
                       a_idtareawf || 'de la SOT Nro. ' || ln_codsolot ||
                       sqlerrm;*/
      --fin 17.0
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
  end;
  procedure p_gen_archivo_tvsat_recprom(a_numregistro     in varchar2,
                                        a_tiposolicitud   in number,
                                        a_flg_instantanea in number default 0) is

    lc_mensaje     varchar2(2000);
    ln_tipsol      ope_tvsat_sltd_cab.tiposolicitud%type;
    ln_codinssrv   cxc_inscabcorte.codinssrv%type;
    lc_codcli      cxc_inscabcorte.codcli%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    lc_bouquets    tystabsrv.codigo_ext%type;
    ln_largo       number(4);
    ln_numbouquets number(4);
    lc_codext      varchar2(10);
    lc_numregistro reginsdth.numregistro%type;
    lc_correos_it  varchar2(2000);
    le_error exception;
    ln_num number(4);
  begin

    begin
      select a.codcli, b.codinssrv
        into lc_codcli, ln_codinssrv
        from ope_srv_recarga_cab a, ope_srv_recarga_det b
       where a.numregistro = b.numregistro
         and a.numregistro = a_numregistro;

    exception
      when others then
        lc_mensaje := 'Error al obtener informacion';
        raise le_error;
    end;

    ln_tipsol := a_tiposolicitud;

    lc_numregistro := a_numregistro;

    --Se genera el idsol
    select sq_ope_tvsat_sltd_cab_idsol.nextval
      into ln_idsol
      from DUMMY_OPE;

    --creacion de la cabecera de la solicitud
    insert into ope_tvsat_sltd_cab
      (idsol,
       tiposolicitud,
       codinssrv,
       codcli,
       estado,
       numregistro,
       FLG_RECARGA)
    values
      (ln_idsol,
       ln_tipsol,
       ln_codinssrv,
       lc_codcli,
       PQ_OPE_INTERFAZ_TVSAT.FND_ESTADO_PEND_EJECUCION,
       lc_numregistro,
       1);

    --if ln_tipsol = 1 then --suspension promocional
    /**********************************************************
    Cursor para obtener las tarjetas y boquetes
    ***********************************************************/
    --ini 14.0
    --for reg in( select distinct cab.numregistro,a.numserie serie, a.tipequ,
    for reg in (select distinct cab.numregistro,
                                trim(a.numserie) serie,
                                a.tipequ,
                                --fin 14.0
                                (select --distinct tystabsrv.codigo_ext 16.0 se comento
                                 distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv)) --16.0
                                   from paquete_venta,
                                        detalle_paquete,
                                        linea_paquete,
                                        producto,
                                        tystabsrv
                                  where paquete_venta.idpaq = cab.idpaq
                                    and paquete_venta.idpaq =
                                        detalle_paquete.idpaq
                                    and detalle_paquete.iddet =
                                        linea_paquete.iddet
                                    and detalle_paquete.idproducto =
                                        producto.idproducto
                                    and detalle_paquete.flgestado = 1
                                    and linea_paquete.flgestado = 1
                                    and detalle_paquete.flgprincipal = 1
                                    and producto.tipsrv =
                                        (select valor
                                           from constante
                                          where constante = 'FAM_CABLE') --12.0
                                    and linea_paquete.codsrv =
                                        tystabsrv.codsrv
                                       --and tystabsrv.codigo_ext is not null 16.0 se comento
                                    and (PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv)) is not null --16.0
                                 ) codigo_ext
                  from ope_srv_recarga_cab cab,
                       solotptoequ a,
                       (select a.codigon tipequope, codigoc grupoequ
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX') b
                 where cab.codsolot = a.codsolot
                   and a.tipequ = b.tipequope
                   and b.grupoequ = '1'
                   and cab.numregistro = lc_numregistro) loop

      --lc_bouquets   := trim(reg.codigo_ext);
      --ln_largo       := length(lc_bouquets);
      --ln_numbouquets := (ln_largo + 1)/4;

      /**********************************
      Se separan los bouquetes
      **********************************/
      --for i in 1..ln_numbouquets loop

      --lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets,i),8,'0');

      --Insercion en la tabla temporal
      insert into ope_tmp_tarjeta_bouquete
        (numregistro,
         serie --,
         --codext
         )
      values
        (reg.numregistro,
         reg.serie --,
         --lc_codext
         );

    --end loop;

    end loop;

    /***********************************************
    Registro del detalle de la solicitud (Tarjetas)
    ************************************************/
    for reg in (select distinct serie
                  from ope_tmp_tarjeta_bouquete
                 where numregistro = lc_numregistro
                 order by serie asc) loop

      insert into ope_tvsat_sltd_det
        (idsol, serie)
      values
        (ln_idsol, reg.serie);
    end loop;

    /***********************************************
     Bouquetes promocionales
    ************************************************/

    if ln_tipsol = 3 then
      --suspension de bouquetes promociones
      for reg in (select b.idsol,
                         --ini 14.0
                         --b.serie,
                         trim(b.serie) serie,
                         --fin 14.0
                         a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and (a.fecha_inicio_vigencia is not null and
                         a.fecha_fin_vigencia is not null and
                         trunc(a.fecha_fin_vigencia) < trunc(sysdate))
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               3 --promocional
               );
          end if;

        end loop;
      end loop;
    else
      --activacion de bouquetes por promocion pronto pago o promociones instantaneas
      for reg in (select b.idsol,
                         --ini 14.0
                         --b.serie,
                         trim(b.serie) serie,
                         --fin 14.0
                         a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and flg_transferir = 0
                     and nvl(flg_instantanea, 0) = a_flg_instantanea
                     and bouquets is not null
                     and (a.fecha_inicio_vigencia is not null and
                         a.fecha_fin_vigencia is not null and
                         trunc(a.fecha_inicio_vigencia) = trunc(sysdate))
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               3 --promocional
               );
          end if;
        end loop;
      end loop;
    end if;
    --

    if ln_tipsol = 3 then
      update bouquetxreginsdth
         set estado = 0, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo = 2
         and estado = 1
         and (fecha_inicio_vigencia is not null and
             fecha_fin_vigencia is not null and
             trunc(fecha_fin_vigencia) < trunc(sysdate));
    else
      update bouquetxreginsdth
         set flg_transferir = 1, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo = 2
         and estado = 1
         and flg_transferir = 0
         and nvl(flg_instantanea, 0) = a_flg_instantanea
         and bouquets is not null
         and (fecha_inicio_vigencia is not null and
             fecha_fin_vigencia is not null and
             trunc(fecha_inicio_vigencia) = trunc(sysdate));
      --ini 14.0
      update rec_bouquetxreginsdth_cab
         set flg_rectransferir = 1, --para que no lo vuelva a actualizar de INT a PRD
             fecultenv         = sysdate
       where numregistro = lc_numregistro
         and tipo = 2
         and estado = 1
         and flg_transferir = 0
         and nvl(flg_instantanea, 0) = a_flg_instantanea
         and bouquets is not null
         and (fecha_inicio_vigencia is not null and
             fecha_fin_vigencia is not null and
             trunc(fecha_inicio_vigencia) = trunc(sysdate));
      --fin 14.0
    end if;

  exception
    when le_error then
      rollback;
      --Se ingresa una anotacion
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      --Se envia correo
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
    when others then
      rollback;
      lc_mensaje := sqlerrm;
      --Se ingresa una anotacion
      lc_mensaje    := 'Se produjo un error en las promociones: ' ||
                       sqlerrm;
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
  end;
  --fin 13.0
  --<ini 16.0
  /**********************************************************************
  Procedimiento que genera solicitudes de media suspension al conax de servicios recargables
  **********************************************************************/
  procedure p_gen_archivo_tvsat_rec_susp(a_idtareawf in number,
                                         a_idwf      in number,
                                         a_tarea     in number,
                                         a_tareadef  in number) is

    lc_mensaje     varchar2(2000);
    ln_codsolot    solot.codsolot%type;
    ln_tipsol      ope_tvsat_sltd_cab.tiposolicitud%type;
    ln_codinssrv   cxc_inscabcorte.codinssrv%type;
    lc_codcli      cxc_inscabcorte.codcli%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    lc_bouquets_p    tystabsrv.codigo_ext%type;--bouquets servicio principal 19.0
    lc_bouquets_a    tystabsrv.codigo_ext%type;--bouquets servicio adicional 19.0
    lc_bouquets    tystabsrv.codigo_ext%type;
    ln_largo       number(4);
    ln_numbouquets number(4);
    lc_codext      varchar2(10);
    lc_codigo_ext  varchar2(10);--19.0
    lc_numregistro reginsdth.numregistro%type;
    lc_correos_it  varchar2(2000);
    le_error exception;
    ln_tiptrs tiptrabajo.tiptrs%type;
    ln_num    number(4);
    ln_valido number(4);--19.0
  begin
    --Obtencion del numero de solot
    begin
      select codsolot into ln_codsolot from wf where idwf = a_idwf;
    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion el codigo de solot';
        raise le_error;
    end;

    --Se actualiza el estado de la tarea a ejecucion
    update tareawf
       set esttarea = 2 -- En ejecucion
     where idtareawf = a_idtareawf;

    --Obtencion de la transaccion
    begin

      select a.tiptrs, b.codcli, c.codinssrv
        into ln_tiptrs, lc_codcli, ln_codinssrv
        from tiptrabajo a, solot b, solotpto c, inssrv d
       where b.codsolot = ln_codsolot
         and a.tiptra = b.tiptra
         and b.codsolot = c.codsolot
         and c.codinssrv = d.codinssrv
         and d.tipsrv =
             (select valor from constante where constante = 'FAM_CABLE');

    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion de la transaccion';
        raise le_error;
    end;

    --identificacion del tipo de solicitud
    if ln_tiptrs = 3 then
      --Es una solicitud de suspension
      ln_tipsol := 5; -- media Suspension
    end if;

    --Obtener Registro de Cliente DTH
    begin
      lc_numregistro := pq_inalambrico.f_obtener_numregistro(ln_codsolot);
    exception
      when others then
        lc_mensaje := 'Error al obtener el numero de registro dth';
        raise le_error;
    end;

    --Se genera el idsol
    select sq_ope_tvsat_sltd_cab_idsol.nextval
      into ln_idsol
      from DUMMY_OPE;

    --creacion de la cabecera de la solicitud
    insert into ope_tvsat_sltd_cab
      (idsol,
       tiposolicitud,
       codinssrv,
       codcli,
       codsolot,
       idwf,
       idtareawf,
       estado,
       numregistro,
       FLG_RECARGA)
    values
      (ln_idsol,
       ln_tipsol,
       ln_codinssrv,
       lc_codcli,
       ln_codsolot,
       a_idwf,
       a_idtareawf,
       PQ_OPE_INTERFAZ_TVSAT.FND_ESTADO_PEND_EJECUCION,
       lc_numregistro,
       1 --recargable
       );

    /**********************************************************
    Cursor para obtener las tarjetas y boquetes
    ***********************************************************/
    for reg in (select distinct cab.numregistro,
                                trim(a.numserie) serie,
                                a.tipequ,
                                (select distinct trim(operacion.PQ_OPE_BOUQUET.f_conca_bouquet_srv_susp(tystabsrv.codsrv))
                                   from paquete_venta,
                                        detalle_paquete,
                                        linea_paquete,
                                        producto,
                                        tystabsrv
                                  where paquete_venta.idpaq = cab.idpaq
                                    and paquete_venta.idpaq =
                                        detalle_paquete.idpaq
                                    and detalle_paquete.iddet =
                                        linea_paquete.iddet
                                    and detalle_paquete.idproducto =
                                        producto.idproducto
                                    and detalle_paquete.flgestado = 1
                                    and linea_paquete.flgestado = 1
                                    and detalle_paquete.flgprincipal = 1
                                    and producto.tipsrv =
                                        (select valor
                                           from constante
                                          where constante = 'FAM_CABLE')
                                    and linea_paquete.codsrv =
                                        tystabsrv.codsrv
                                    and PQ_OPE_BOUQUET.f_conca_bouquet_srv_susp(tystabsrv.codsrv) is not null) codigo_ext
                  from ope_srv_recarga_cab cab,
                       solotptoequ a,
                       (select a.codigon tipequope, codigoc grupoequ
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX') b
                 where cab.codsolot = a.codsolot
                   and a.tipequ = b.tipequope
                   and b.grupoequ = '1'
                   and cab.numregistro = lc_numregistro) loop
      --lc_bouquets    := trim(reg.codigo_ext);
      lc_bouquets_p    := trim(reg.codigo_ext); --19.0
      ln_largo       := length(lc_bouquets_p);
      ln_numbouquets := (ln_largo + 1) / 4;

      /**********************************
      Se separan los bouquetes
      **********************************/
      for i in 1 .. ln_numbouquets loop

        lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets_p, i), 8, '0');

        --Insercion en la tabla temporal
        insert into ope_tmp_tarjeta_bouquete
          (numregistro, serie, codext)
        values
          (reg.numregistro, reg.serie, lc_codext);

      end loop;

    end loop;

    /***********************************************
    Registro del detalle de la solicitud (Tarjetas)
    ************************************************/
    for reg in (select distinct serie
                  from ope_tmp_tarjeta_bouquete
                 where numregistro = lc_numregistro
                 order by serie asc) loop

      insert into ope_tvsat_sltd_det
        (idsol, serie)
      values
        (ln_idsol, reg.serie);
    end loop;

    /***********************************************
    Registro de los bouquetes
    ************************************************/
    for reg in (select distinct serie, codext
                  from ope_tmp_tarjeta_bouquete
                 order by serie, codext) loop

      select count(1)
        into ln_num
        from OPE_TVSAT_SLTD_BOUQUETE_DET
       where idsol = ln_idsol
         and serie = reg.serie
         and bouquete = reg.codext;

      if ln_num = 0 then
        insert into ope_tvsat_sltd_bouquete_det
          (idsol, serie, bouquete, tipo)
        values
          (ln_idsol,
           reg.serie,
           reg.codext,
           2 --principal
           );
      end if;
    end loop;

    /**************************************************
      Bouquetes adicionales
    **************************************************/
    if ln_tipsol = 5 then
      --suspension

      for reg in (select b.idsol, trim(b.serie) serie, a.bouquets bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and (a.tipo = 0 or a.tipo = 3) --adicional cnr
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop
        --lc_bouquets    := trim(reg.bouquets);
        lc_bouquets_a    := trim(reg.bouquets);--19.0
        ln_largo       := length(lc_bouquets_a);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets_a, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               1 --adicional
               );
          end if;
        end loop;

      end loop;
    end if;

    /**************************************************
    Bouquetes promocionales
    **************************************************/
    if ln_tipsol = 5 then
      --suspension
      for reg in (select b.idsol, trim(b.serie) serie, a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          --< 19.0 ini
          lc_codigo_ext:=operacion.f_cb_subcadena2(lc_bouquets, i);
          --Se valida que no este contenido en los bouquets del servicio principal
          ln_valido:=0;
          if lc_bouquets_p is not null then
             select instr(lc_bouquets_p,lc_codigo_ext) into ln_valido from dummy_ope;
          end if;

          --Se valida que no este contenido en los bouquets del servicio adicional
          if lc_bouquets_a is not null and ln_valido<>0  then
             select instr(lc_bouquets_a,lc_codigo_ext) into ln_valido from dummy_ope;
          end if;
        if ln_valido = 0 then
          --19.0>
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                  8,
                  '0');
          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

            if ln_num = 0 then
              insert into OPE_TVSAT_SLTD_BOUQUETE_DET
                (idsol, serie, bouquete, tipo)
              values
                (reg.idsol,
                 reg.serie,
                 lc_codext,
                 3 --promocional
                 );
            end if;
          end if;--19.0
        end loop;
      end loop;
    end if;

    if ln_tipsol = 5 then
      --suspension
      --se actualizan los bouquets adicionales y promocionales
      update bouquetxreginsdth
         set estado = 0, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo in (0, 2, 3) --adicional, promocional, adicional cnr
         and estado = 1;
    end if;

    insert into tareawfseg
      (idtareawf, observacion)
    values
      (a_idtareawf, 'Solicitud conax generada');

  exception
    when le_error then
      --ini 17.0
      if lc_numregistro is not null then
         pq_control_dth.p_graba_log('Error generacion de solicitud de Suspension DTH, numero de registro:'||lc_numregistro,sqlerrm);
      else
         pq_control_dth.p_graba_log('Error generacion de solicitud de Suspension DTH',sqlerrm);
      end if;
      --fin 17.0
      rollback;
      lc_mensaje := sqlerrm;
      --Se actualiza el estado de la tarea a ejecucion
      --ini 17.0
      /*update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);*/
      --fin 17.0
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      --Se envia correo
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
    when others then
      --ini 17.0
      if lc_numregistro is not null then
         operacion.pq_control_dth.p_graba_log('Error generacion de solicitud de Suspension DTH, numero de registro:'||lc_numregistro,sqlerrm);
      else
         operacion.pq_control_dth.p_graba_log('Error generacion de solicitud de Suspension DTH',sqlerrm);
      end if;
      --fin 17.0
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      --ini 17.0
      /*update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;*/
      --fin 17.0
      lc_mensaje := sqlerrm;
      --Se ingresa una anotacion
      --ini 17.0
      /*insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);

      lc_mensaje    := 'Se produjo un error en la ejecucion de la tarea ' ||
                       a_idtareawf || 'de la SOT Nro. ' || ln_codsolot ||
                       sqlerrm;*/
      --fin 17.0
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      p_envia_correo_c_attach('Error generacion de solicitud de Suspension/Reconexion - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
  end;

  procedure p_job_genera_suspension(ld_feccorte date) is
    cursor c_regcorte(an_dias_gracia number) is
      select a.*
        from ope_srv_recarga_cab a, vtatabslcfac v
       where a.flg_recarga = 1
         and trunc(a.feccorte) + an_dias_gracia <= trunc(ld_feccorte)
         and a.estado = '02'
         and a.numslc = v.numslc
         and exists (select 1
                from opedd o, tipopedd b
               where o.tipopedd = b.tipopedd
                 and b.abrev = 'SUSPTIPTRA'
                 and o.codigon is not null
                 and o.codigon_aux is not null
                 and o.codigoc = to_char(v.idsolucion));

    ln_idctrlcorte            number;
    ln_num_cortes_pendientes  number;
    ln_fecha_menor            number;
    ln_sots_no_cerradas       number;
    ln_recargas_no_procesadas number;
    ln_proceso_sot            number;
    ln_dias_gracias           number;

  begin

    begin
      select b.codigon
        into ln_dias_gracias
        from operacion.tipopedd a, operacion.opedd b
       where a.abrev = 'DTHRECARDIAS'
         and a.tipopedd = b.tipopedd
         and b.abreviacion = 'SUSPENSION';
    exception
      when no_data_found then
        ln_dias_gracias := 0;
    end;

    for r_regcorte in c_regcorte(ln_dias_gracias) loop

      select count(1)
        into ln_fecha_menor
        from ope_srv_recarga_cab a
       where (trunc(a.feccorte) + ln_dias_gracias) <= trunc(ld_feccorte)
         and a.numregistro = r_regcorte.numregistro;

      select count(1)
        into ln_sots_no_cerradas
        from cuponpago_dth a, solot s
       where a.numregistro = r_regcorte.numregistro
         and a.codsolot = s.codsolot
         and s.estsol <> c_estsol_cerrado
         and ((trunc(s.fecusu) >= (trunc(ld_feccorte) - ln_dias_gracias)) and
             (trunc(s.fecusu) <= trunc(ld_feccorte)));

      select count(1)
        into ln_recargas_no_procesadas
        from cuponpago_dth_web
       where numregistro = r_regcorte.numregistro
         and flgtransferir in (0, 1)
         and ((trunc(fecreg) >= (trunc(ld_feccorte) - ln_dias_gracias)) and
             (trunc(fecreg) <= trunc(ld_feccorte)));

      if ln_fecha_menor > 0 and ln_sots_no_cerradas = 0 and
         ln_recargas_no_procesadas = 0 then

        select count(1)
          into ln_num_cortes_pendientes
          from operacion.control_corte_dth
         where numregistro = r_regcorte.numregistro
           and codsolot is not null
           and estcorte in (1, 2); --1:Generado - 2:Enviado - 3:Verificado - 9 Anulado

        if ln_num_cortes_pendientes = 0 then

          select sq_ctrlcortedth.nextval
            into ln_idctrlcorte
            from dummy_ope;
          insert into operacion.control_corte_dth
            (idctrlcorte,
             numregistro,
             feccorteprg,
             feccortereal,
             estcorte,
             motivo,
             tipo)
          values
            (ln_idctrlcorte,
             r_regcorte.numregistro,
             r_regcorte.feccorte,
             sysdate,
             1,
             'FIN DE VIGENCIA',
             'SUSPENSION');

          commit;

          begin
            p_crea_sot(r_regcorte.numregistro, null, ln_idctrlcorte);
            ln_proceso_sot := 1;
          exception
            when others then
              rollback;

              ln_proceso_sot := 0;
              update operacion.control_corte_dth
                 set estcorte = 9, --anulado
                     mensaje  = 'Error en generación de suspension, al crear SOT'
               where idctrlcorte = ln_idctrlcorte;
          end;

          if ln_proceso_sot = 1 then
            begin
              update reginsdth_web
                 set estado = '03', estinsprd = 2
               where numregistro = r_regcorte.numregistro;

            exception
              when others then
                rollback;
                update operacion.control_corte_dth
                   set estcorte = 9, --anulado
                       mensaje  = 'Error al actualizar en INT'
                 where idctrlcorte = ln_idctrlcorte;
            end;
          end if;
          commit;

        end if;

      end if;

    end loop;
    --se generan los cortes para los bouquets promocionales
    -- billcolper.pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(sysdate,null);

  end;
  --fin 16.0>
END;
/
