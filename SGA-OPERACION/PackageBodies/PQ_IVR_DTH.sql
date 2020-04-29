CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_IVR_DTH IS
  /******************************************************************************
     NOMBRE:       OPERACION.PQ_IVR
     DESCRIPCION:
     Paquete con lógica Automatización de la activación TV SAT a través del IVR


  ver   Date        Author           Solicitado por     Description
  ----  ----------  ---------------  --------------     ----------------------
  1.0   28/06/2013  Fernando Pacheco                     Req. 163602 - Creación de Proceso Automatización
                                                                       de la activación TV SAT a través del IVR
  2.0   07/09/2012  Alfonso Perez R. Hector Huaman       REQ-164553: Actualizar campo resumen en la sot
  ******************************************************************************/
  procedure p_consultar_instalador(av_dni      varchar2,
                                   av_telefono varchar2,
                                   av_codresp  out varchar2,
                                   av_desresp  out varchar2,
                                   an_codcon   out number) is
    ln_count  number;
    an_estado number;
  begin
    if nvl(av_dni, 0) <> 0 and nvl(av_telefono, 0) <> 0 then
      --contar instaladores
      select count(*)
        into ln_count
        from pvt.tabusuario@dbl_pvtdb t
       where t.numdoc = av_dni
         and t.instalacion = 1;

      if ln_count = 1 then
        select DECODE(t.ACTIVO, 'ACTIVO', 1, 'DESACTIVO', 0), t.codcon
          into an_estado, an_codcon
          from pvt.tabusuario@dbl_pvtdb t
         where t.numdoc = av_dni
           and t.tel_rpc = av_telefono
           and t.instalacion = 1;
           gn_codcon:=an_codcon;
        if nvl(an_estado, 0) = 1 then
          av_codresp := '00';
          av_desresp := 'OK';
        else
          av_codresp := '02';
          av_desresp := 'El instalador se encuentra Desactivado, comuniquese con su Supervisor ';
        end if;
      else
        if ln_count >= 2 then
          av_codresp := '04';
          av_desresp := 'Nro. de DNI duplicado, comuniquese con su Supervisor';
        else
          av_codresp := '03';
          av_desresp := 'El instalador no se encuentra registrado, comuniquese con su Supervisor';
        end if;
      end if;
    end if;

  exception
    when others then
      av_codresp := '01';
      av_desresp := 'Error en la consulta,  intente nuevamente';
  end;

  procedure p_consulta_solicitud(an_sec        number,
                                 av_numdoc     out varchar2,
                                 av_codsolot   out varchar2,
                                 av_numslc     out varchar2,
                                 av_nrodecos   out varchar2,
                                 av_codresp    out varchar2,
                                 av_desresp    out varchar2) is
    ln_count    number;
    lv_codcli   varchar2(15);
    ln_nrodecos number;
    ln_tareadef tareadef.tareadef%type;
    ln_idtareawf tareawfcpy.idtareawf%type;

  begin

   begin
    select count(*)
      into ln_count
      from operacion.inssrv
      --where numero = to_char(an_sec) ; 2.0
     where numsec = to_char(an_sec) ;
    exception
      when others then
        ln_count   := '01';
        av_desresp := 'Error en la consulta,  validación';
    end;

    if ln_count = 1 then
      begin
        select numslc
          into av_numslc
          from operacion.inssrv
        --where numero = to_char(an_sec) ; 2.0
         where numsec = to_char(an_sec);
      exception
        when others then
          ln_count   := '01';
          av_desresp := 'Error en la consulta,  en obtener el proyecto';
      end;

      begin
        select i.codcli, to_char(s.codsolot)
          into lv_codcli, av_codsolot
          from operacion.inssrv i, sales.vtatabslcfac f, operacion.solot s
         where i.numslc = f.numslc
           and f.numslc = s.numslc
           --  i.numero = to_char(an_sec) 2.0
           and i.numsec = to_char(an_sec)
           and i.numslc = av_numslc
           and sales.pq_dth_postventa.f_obt_facturable_dth(av_numslc)=1;

      exception
        when others then
          av_codresp   := '01';
          av_desresp := 'Error en la consulta,  en obtener cliente y SOT';
      end;

  --Procedemos a Cerrar la Tarea de Programacion de instalador:
    begin
        update operacion.agendamiento
           set codcon = nvl(gn_codcon,1)
         where codsolot = av_codsolot;

      select p.codigon into ln_tareadef
        from operacion.tipopedd t, operacion.opedd p
       where t.tipopedd = p.tipopedd
         and p.abreviacion = 'PROG_DTH'
         and t.abrev = 'IVR_DTH';

      select idtareawf
        into ln_idtareawf
        from opewf.tareawf t
       where t.IDWF = (select IDWF
                         from wf
                        where valido = 1
                          and codsolot = av_codsolot)
         AND t.TAREADEF = ln_tareadef;

      pq_wf.P_CHG_STATUS_TAREAWF(ln_idtareawf,
                                 4,
                                 4,
                                 0,
                                 sysdate,
                                 sysdate);
   exception
    when others then
      null;
    end;


      if nvl(av_codsolot, 0) <> 0 then
        if nvl(lv_codcli, 0) <> 0 then
          select ntdide
            into av_numdoc
            from marketing.vtatabcli
           where codcli = lv_codcli;
          av_codresp := '00';
          av_desresp := 'Ok';
          operacion.pq_ivr_DTH.p_cant_equiposxsot(av_codsolot,
                                              ln_nrodecos,
                                              av_codresp,
                                              av_desresp);
          av_nrodecos := to_char(ln_nrodecos);
        else
          av_codresp := '03';
          av_desresp := 'Código del cliente no existe';
        end if;
      else
        av_codresp := '02';
        av_desresp := 'Solicitud ingresada no existe';
      end if;
    else
      if ln_count >= 2 then
        av_codresp := '04';
        av_desresp := 'Solicitud duplicada';
      else
        av_codresp := '02';
        av_desresp := 'Solicitud ingresada no existe';
      end if;
    end if;
  --Procedemos a Cerrar la Tarea de Programacion de instalador:
    begin
        update operacion.agendamiento
           set codcon = nvl(gn_codcon,1)
         where codsolot = av_codsolot;

      select p.codigon into ln_tareadef
        from operacion.tipopedd t, operacion.opedd p
       where t.tipopedd = p.tipopedd
         and p.abreviacion = 'PROG_DTH'
         and t.abrev = 'IVR_DTH';

      select idtareawf
        into ln_idtareawf
        from opewf.tareawf t
       where t.IDWF = (select IDWF
                         from wf
                        where valido = 1
                          and codsolot = av_codsolot)
         AND t.TAREADEF = ln_tareadef
         and t.tipesttar in (1, 2);

      pq_wf.P_CHG_STATUS_TAREAWF(ln_idtareawf,
                                 4,
                                 4,
                                 0,
                                 sysdate,
                                 sysdate);
   exception
    when others then
      null;
    end;

  exception
    when others then
      av_codresp := '01';
      av_desresp := 'Error en la consulta,  error 2';

  end;

  procedure p_reg_contrato(an_sec         number,
                           av_nrocontrato varchar2,
                           av_codresp     out varchar2,
                           av_desresp     out varchar2) is

  begin

    operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                          gv_numdoc_cli,
                                          gv_codsolot,
                                          gv_numslc,
                                          gv_nrodecos,
                                          av_codresp,
                                          av_desresp);
    if av_codresp = '00' then
      update vtatabprecon
         set nrodoc = av_nrocontrato
       where numslc = gv_numslc;

      av_codresp := '00';
      av_desresp := 'Ok';
    end if;

  exception

    when others then
      av_codresp := '04';
      av_desresp := 'No se logro registrar el contrato';

  end;

  procedure p_reg_boleta(an_sec       number,
                         av_nroboleta varchar2,
                         av_codresp   out varchar2,
                         av_desresp   out varchar2) is

    lv_codigo_recarga  operacion.ope_srv_recarga_cab.codigo_recarga%type;
    ln_idtareawf       tareawfcpy.idtareawf%type;
    ln_tareadef        tareadef.tareadef%Type;
  begin

    operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                          gv_numdoc_cli,
                                          gv_codsolot,
                                          gv_numslc,
                                          gv_nrodecos,
                                          av_codresp,
                                          av_desresp);

    gn_codsolot := to_number(gv_codsolot);

    if av_codresp = '00' then

      update operacion.ope_srv_recarga_cab
         set codigo_recarga = lv_codigo_recarga,
             tipdocfac      = 'B/V',
             numsut         = av_nroboleta
       where codsolot = gn_codsolot;

  --Procedemos a Cerrar la Tarea de Programacion de instalador:
    begin
        update operacion.agendamiento
           set codcon = 1
         where codsolot = gv_codsolot;

      select p.codigon into ln_tareadef
        from operacion.tipopedd t, operacion.opedd p
       where t.tipopedd = p.tipopedd
         and p.abreviacion = 'REG_DTH'
         and t.abrev = 'IVR_DTH';

      select idtareawf
        into ln_idtareawf
        from opewf.tareawf t
       where t.IDWF = (select IDWF
                         from wf
                        where valido = 1
                          and codsolot = gv_codsolot)
         AND t.TAREADEF = ln_tareadef
         and t.tipesttar in (1, 2);

      pq_wf.P_CHG_STATUS_TAREAWF(ln_idtareawf,
                                 4,
                                 4,
                                 0,
                                 sysdate,
                                 sysdate);
   exception
    when others then
      null;
    end;

      av_codresp := '00';
      av_desresp := 'Ok';
    end if;

  exception

    when others then
      av_codresp := '04';
      av_desresp := 'No se logro registrar la boleta';
  end;

  procedure p_cant_equipos    (an_sec number,
                               an_nrodecos out number,
                               av_codresp  out varchar2,
                               av_desresp  out varchar2) is
    lv_codresp     varchar2(15);
    lv_desresp     varchar2(400);
  begin
    operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                          gv_numdoc_cli,
                                          gv_codsolot,
                                          gv_numslc,
                                          gv_nrodecos,
                                          lv_codresp,
                                          lv_desresp);

    an_nrodecos:=gv_nrodecos;

    if an_nrodecos > 0 then
      av_codresp := '00';
      av_desresp := 'Ok';
    else
      av_codresp := '05';
      av_desresp := 'No se logro obtener la información, intente nuevamente';
    end if;

  exception

    when others then
      av_codresp := '05';
      av_desresp := 'No se logro obtener la información, intente nuevamente';

  end;


  procedure p_cant_equiposxsot(an_codsolot number,
                               an_nrodecos out number,
                               av_codresp  out varchar2,
                               av_desresp  out varchar2) is

  begin
     select nvl(sum(cantidad), 0)
     into an_nrodecos
       from solotptoequ s
      where S.CODEQUCOM IN (SELECT P.CODIGOC
                              FROM OPERACION.TIPOPEDD T, OPERACION.OPEDD P
                             WHERE T.TIPOPEDD = P.TIPOPEDD
                               AND T.ABREV = 'DECO_DTH')
        and s.codsolot = an_codsolot;

    if an_nrodecos > 0 then
      av_codresp := '00';
      av_desresp := 'Ok';
    else
      av_codresp := '05';
      av_desresp := 'No se logro obtener la información, intente nuevamente';
    end if;

  exception

    when others then
      av_codresp := '05';
      av_desresp := 'No se logro obtener la información, intente nuevamente';

  end;

  procedure p_reg_unitadress(an_sec     number,
                             av_ua      varchar2,
                             an_ndeco   number,
                             av_codresp out varchar2,
                             av_desresp out varchar2) is
    cursor c1 is
      select se.*, rownum
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = gn_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = 2;

    ln_count    number;
    lv_nroserie varchar2(50);
    lv_mac      varchar2(50);
    ln_nrodecos number;
  begin

    select count(*)
      into ln_count
      from operacion.tabequipo_material
     where IMEI_ESN_UA = av_ua
       and tipo = 2;
    if ln_count > 0 then
      select numero_serie, imei_esn_ua
        into lv_nroserie, lv_mac
        from operacion.tabequipo_material
       where IMEI_ESN_UA = av_ua
         and tipo = 2
         and rownum = 1;
      operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                            gv_numdoc_cli,
                                            gv_codsolot,
                                            gv_numslc,
                                            gv_nrodecos,
                                            av_codresp,
                                            av_desresp);

      gn_codsolot := to_number(gv_codsolot);
      ln_nrodecos := to_number(gv_nrodecos);

      if an_ndeco <= ln_nrodecos then
        if an_ndeco = 1 then
          delete operacion.tarjeta_deco_asoc where codsolot = gv_codsolot;
        end if;
        for c1_rec in c1 loop
          if an_ndeco = c1_rec.rownum then

            update solotptoequ
               set numserie = lv_nroserie, mac = lv_mac
             where codsolot = c1_rec.codsolot
               and punto = c1_rec.punto
               and orden = c1_rec.orden;

            -- Asociar equipos
            insert into operacion.tarjeta_deco_asoc
              (codsolot, iddet_deco, nro_serie_deco)
            values
              (gn_codsolot, c1_rec.iddet, lv_mac);

            av_codresp := '00';
            av_desresp := 'Ok';
          end if;
        end loop;
      else
        av_codresp := '07';
        av_desresp := 'No se logro registrar el UnitAdress';
      end if;
    else
      av_codresp := '07';
      av_desresp := 'No se logro registrar el UnitAdress';
    end if;
  exception

    when others then
      av_codresp := '08';
      av_desresp := 'Error en la transacción, intente nuevamente en 5 minutos';

  end;

  procedure p_reg_tarjeta(an_sec     number,
                          av_serie   varchar2,
                          an_ndeco   number,
                          av_codresp out varchar2,
                          av_desresp out varchar2) is

    cursor c1 is
      select se.*, rownum
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = gn_codsolot
         and t.tipequ = equ_conax.tipequ
         and equ_conax.grupo = 1;

    ln_count     number;
    lv_nroserie  varchar2(50);
    ln_nrodecos  number;
  begin
    select count(*)
      into ln_count
      from operacion.tabequipo_material
     where numero_serie = av_serie
       and tipo = 1;

    if ln_count > 0 then
      select numero_serie
        into lv_nroserie
        from operacion.tabequipo_material
       where numero_serie = av_serie
         and tipo = 1
         and rownum = 1;
      operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                            gv_numdoc_cli,
                                            gv_codsolot,
                                            gv_numslc,
                                            gv_nrodecos,
                                            av_codresp,
                                            av_desresp);

      gn_codsolot := to_number(gv_codsolot);
      ln_nrodecos := to_number(gv_nrodecos);

      if an_ndeco <= ln_nrodecos then

        for c1_rec in c1 loop
          if an_ndeco = c1_rec.rownum then

            update solotptoequ
               set numserie = lv_nroserie
             where codsolot = c1_rec.codsolot
               and punto = c1_rec.punto
               and orden = c1_rec.orden;


            -- Asociar equipo
            update operacion.tarjeta_deco_asoc
               set iddet_tarjeta     = c1_rec.iddet,
                   nro_serie_tarjeta = lv_nroserie
             where codsolot = gn_codsolot
               and iddet_tarjeta is null;

            av_codresp := '00';
            av_desresp := 'Ok';
          end if;
        end loop;
      else
        av_codresp := '07';
        av_desresp := 'No se logro registrar la tarjeta';
      end if;
    else
      av_codresp := '07';
      av_desresp := 'No se logro registrar la tarjeta';
    end if;

    if av_codresp = '00' and an_ndeco = ln_nrodecos then

      operacion.pq_ivr_dth.p_activar_servicio(an_sec);

      av_codresp := '00';
      av_desresp := 'Ok';

    end if;

  exception
    when others then
      av_codresp := '08';
      av_desresp := 'Error en la transacción, intente nuevamente en 5 minutos';
  end;

  procedure p_activar_servicio(an_sec number) is
    cursor c1 is
      select equ_conax.grupo codigo,
             t.descripcion,
             se.numserie,
             se.mac,
             se.cantidad,
             0               sel,
             i.codinssrv,
             se.codsolot,
             se.punto,
             se.orden,
             a.cod_sap
        from solotptoequ se,
             solot s,
             solotpto sp,
             inssrv i,
             tipequ t,
             almtabmat a,
             (select a.codigon tipequ, to_number(codigoc) grupo
                from opedd a, tipopedd b
               where a.tipopedd = b.tipopedd
                 and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax
       where se.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and se.punto = sp.punto
         and sp.codinssrv = i.codinssrv
         and t.tipequ = se.tipequ
         and a.codmat = t.codtipequ
         and se.codsolot = gn_codsolot
         and t.tipequ = equ_conax.tipequ;

    lv_numregistro     varchar2(50);
    lv_codresp         varchar2(2);
    lv_desresp         varchar2(15);
    lv_serie_tarjeta   varchar2(150) := '0';
    lv_serie_deco      varchar2(150) := '0';
    ln_idtareawf       number;
    ln_estsol          number;
    ln_resp            number;
    lv_mensaje         varchar2(1000);
    lv_nro_contrato    varchar2(150);
    ln_id_sisact       number;
    ln_tipcambio       number := 1;
    lv_resultado       varchar2(1000);
    lv_mensaje_act     varchar2(1000);
    ln_result_dth_post number;
    ln_count_envio     number;
    ln_tareadef        tareadef.tareadef%Type;
  begin
    operacion.pq_ivr_dth.p_consulta_solicitud(an_sec,
                                          gv_numdoc_cli,
                                          gv_codsolot,
                                          gv_numslc,
                                          gv_nrodecos,
                                          lv_codresp,
                                          lv_desresp);

    gn_codsolot := to_number(gv_codsolot);

    begin
      select p.codigon into ln_tareadef
        from operacion.tipopedd t, operacion.opedd p
       where t.tipopedd = p.tipopedd
         and p.abreviacion = 'ACT_DTH'
         and t.abrev = 'IVR_DTH';

      select idtareawf
        into ln_idtareawf
        from opewf.tareawf t
       where t.IDWF = (select IDWF
                         from wf
                        where valido = 1
                          and codsolot = gn_codsolot)
         AND t.TAREADEF = ln_tareadef
         and t.tipesttar in (1, 2);


    select s.estsol
      into ln_estsol
      from solot s
     where s.codsolot = gn_codsolot;
    exception
      when others then
       null;
    end;

    select pq_inalambrico.f_obtener_numregistro(gn_codsolot)
      into lv_numregistro
      from dual;

    select count(1)
      into ln_count_envio
      from operacion.ope_envio_conax
     where codsolot = gn_codsolot
       and tipo = 1;

    if ln_count_envio > 0 then
      delete from operacion.ope_envio_conax
       where codsolot = gn_codsolot
         and tipo = 1;
    end if;

    select sales.pq_dth_postventa.f_obt_facturable_dth(gv_numslc)
      into ln_result_dth_post
      from dual;

    if ln_result_dth_post = 1 then
      -- REGISTRO SISACT
      for c1_rec in c1 loop
        if c1_rec.codigo = 1 then
          if lv_serie_tarjeta = '0' then
            lv_serie_tarjeta := trim(c1_rec.numserie);
          else
            lv_serie_tarjeta := lv_serie_tarjeta || ',' ||
                                trim(c1_rec.numserie);
          end if;
        else
          if c1_rec.codigo = 2 then
            if lv_serie_deco = '0' then
              lv_serie_deco := trim(c1_rec.numserie);
            else
              lv_serie_deco := lv_serie_deco || ',' ||
                               trim(c1_rec.numserie);
            end if;
          end if;
        end if;
      end loop;

      sales.pq_dth_postventa.p_env_reg_sisact(gv_numslc,
                                              gn_codsolot,
                                              ln_estsol,
                                              ln_idtareawf,
                                              lv_serie_tarjeta,
                                              lv_serie_deco,
                                              ln_resp,
                                              lv_mensaje,
                                              lv_nro_contrato,
                                              ln_id_sisact);
      if ln_resp = 0 then
        commit;
      end if;

      -- ACTIVACION DTH
      OPERACION.PQ_DTH.p_crear_archivo_conax(lv_numregistro,
                                             lv_resultado,
                                             lv_mensaje_act);

      if lv_resultado = 'OK' then

        if ln_id_sisact is not null then
          UPDATE OPE_SRV_RECARGA_CAB O
             SET O.ID_SISACT = ln_id_sisact
           WHERE O.NUMSLC = gv_numslc;
        end if;

      else
        update ope_srv_recarga_det
           set mensaje = lv_mensaje_act
         where numregistro = lv_numregistro
           and tipsrv =
               (select valor from constante where constante = 'FAM_CABLE');
      end if;
    end if;

    -- VERIFICAR
      operacion.pq_dth.p_proc_recu_filesxcli(lv_numregistro,
                                             ln_tipcambio,
                                             lv_resultado,
                                             lv_mensaje);

      if lv_resultado = 'OK' then
          UPDATE OPE_SRV_RECARGA_CAB O SET O.FLAG_VERIF_CONAX = '1' WHERE O.NUMSLC = gv_numslc;
       END IF;

  END;
END;
/
