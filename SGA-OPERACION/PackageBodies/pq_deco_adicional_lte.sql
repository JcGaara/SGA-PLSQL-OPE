create or replace package body operacion.pq_deco_adicional_lte is
  /*******************************************************************************
  PROPOSITO: Incluir el registro de una solicitud de orden trabajo que contemple un
           nuevo tipo y flujo de trabajo para la atención de instalación de
           decodificadores adicionales que solicite el cliente.

  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
  1.0      2014-10-09  Edwin Vasquez     Hector Huaman      Deco Adicional
  2.0      2014-11-07  Edwin Vasquez     Hector Huaman      Deco Adicional servicios
  3.0      2015-01-22  Freddy Gonzales   Hector Huaman      Registrar datos en la tabla sales.int_negocio_instancia
  4.0      2015-10-29  Luis Polo         Hector Huaman      PROY-LTE
  5.0      2015-11-24  Alfonso Muñante                     SD-438726 Deco Adicional
  6.0      2015-12-31  Emma Guzman       Emma Guzman         SD-616407
  7.0      2016-05-30  Luis Polo B.      Karen Vasquez      SGA-SD-794552
  8.0      2017-03-02  Danny Sánchez     Mauro Zegarra      SGA-INC000000726842
  9.0      2018-05-24  Marleny Teque     Justiniano Condori [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 10.0      2018-08-01  Marleny Teque     Justiniano Condori [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
                       Abel Ojeda
 11.0      2018-10-03  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 12.0      2018-10-15  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 13.0      2018-10-22  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 14.0      2018-11-07  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 15.0      2018-11-15  Luis Flores       Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 16.0      2018-11-28  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 17.0      2018-12-03  Marleny Teque     Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 18.0      2019-01-28  Jose Arriola      Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 19.0      2019-05-03  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 20.0      2019-18-03  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
 21.0      2019-18-25  Abel Ojeda        Luis Flores        [IDEA-40758/PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
  *******************************************************************************/
  FUNCTION deco_adicional(p_idprocess     siac_postventa_proceso.idprocess%TYPE,
                          p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                          p_cod_id        sales.sot_sisact.cod_id%TYPE,
                          p_cargo         solot.cargo%TYPE)
    RETURN solot.codsolot%TYPE IS
    l_numslc     vtatabslcfac.numslc%TYPE;
    l_codsolot   solot.codsolot%TYPE;
    l_wfdef      wf.wfdef%TYPE;
    ln_tiptra    NUMBER; --4.0
    an_resultado NUMBER; --4.0
    ac_mensaje   VARCHAR2(200); --4.0
  BEGIN
    validar_equipo_servicio(p_idinteraccion);

    l_numslc := registrar_venta(p_idprocess, p_idinteraccion, p_cod_id);

    registrar_insprd(p_cod_id, l_numslc);

    l_codsolot := registrar_solot(p_idprocess, p_cod_id, l_numslc, p_cargo);

    registrar_solotpto(p_cod_id, l_numslc, l_codsolot, p_idinteraccion , 'A');  --11.0

    ln_tiptra := f_get_tiptra(p_idprocess); --4.0
    --<ini 4.0>
    IF ln_tiptra = f_get_wfdef_adc THEN
       l_wfdef := get_wfdef_adi(); --7.0
    ELSE
      l_wfdef := get_wfdef();
    END IF;
    --<fin 4.0>
    pq_solot.p_asig_wf(l_codsolot, l_wfdef);
  IF ln_tiptra = f_get_wfdef_adc THEN --6.0
      p_gen_detalle_sot(l_codsolot,
                        p_idinteraccion,
                        an_resultado,
                        ac_mensaje); --7.0
    end if ;


    RETURN l_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.deco_adicional(p_idprocess => ' ||
                              p_idprocess || ', p_idinteraccion => ' ||
                              p_idinteraccion || ', p_cod_id => ' || p_cod_id ||
                              ', p_cargo => ' || p_cargo || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure validar_equipo_servicio(p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type) is

    l_comodato     sales.pq_comodato_sisact_lte.comodato_type; --7.0
    l_servicio     sales.pq_servicio_sisact_lte.servicio_type; --7.0
    l_idlinea      sales.linea_paquete.idlinea%type;  --7.0
    l_servicio_sga sales.linea_paquete.codsrv%type;  --7.0

    cursor lineas_iteraccion is
      select t.*
        from sales.sisact_postventa_det_serv_hfc t
       where t.idinteraccion = p_idinteraccion
       AND t.dscequ IS NOT NULL; --7.0

  begin
    for linea_iteraccion in lineas_iteraccion loop
      --<ini 7.0>
      IF es_servicio_adicional_lte(linea_iteraccion.idgrupo) THEN
        IF NOT existe_servicio_lte(linea_iteraccion.servicio) THEN
          l_servicio.servicio          := linea_iteraccion.servicio;
          l_servicio.dscsrv            := linea_iteraccion.dscsrv;
          l_servicio.idgrupo           := linea_iteraccion.idgrupo;
          l_servicio.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          l_servicio.flag_lc           := linea_iteraccion.flag_lc;
          l_servicio.codigo_ext        := linea_iteraccion.codigo_ext;
          l_servicio.bandwid           := linea_iteraccion.bandwid;

          crear_idlinea_servicio(l_servicio, l_idlinea, l_servicio_sga);
        END IF;
      ELSIF es_servicio_comodato_lte(linea_iteraccion.idgrupo,
                                     linea_iteraccion.idgrupo_principal) OR
            es_servicio_alquiler_lte(linea_iteraccion.idgrupo,
                                     linea_iteraccion.idgrupo_principal) THEN
        IF NOT
            existe_equipo(linea_iteraccion.idgrupo, linea_iteraccion.tipequ) THEN
          l_comodato.idgrupo           := linea_iteraccion.idgrupo;
          l_comodato.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          l_comodato.codtipequ         := linea_iteraccion.codtipequ;
          l_comodato.tipequ            := linea_iteraccion.tipequ;
          l_comodato.dscequ            := linea_iteraccion.dscequ;

          crear_idlinea_equipo(l_comodato, l_idlinea);
        END IF;
      END IF;
      --<fin 7.0>
    end loop;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.validar_equipo_servicio(p_idinteraccion => ' ||
                              p_idinteraccion || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function es_servicio_alquiler(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_ALQU', p_idgrupo) and es_servicio_principal(p_idgrupo_principal);
  end;
  --------------------------------------------------------------------------------
  function es_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_PRIN', p_idgrupo);
  end;
  --------------------------------------------------------------------------------
  function es_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_COMO', p_idgrupo) and es_servicio_principal(p_idgrupo_principal);
  end;
  --------------------------------------------------------------------------------
  function es_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_ADIC', p_idgrupo);
  end;
  --------------------------------------------------------------------------------
  function grupo_servicios(p_tip_servicio opedd.abreviacion%type,
                           p_cod_servicio sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is
    l_count number;

  begin
    select count(d.codigoc)
      into l_count
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = p_tip_servicio
       and d.codigoc = p_cod_servicio;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  function registrar_venta(p_idprocess     siac_postventa_proceso.idprocess%type,
                           p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                           p_cod_id        sales.sot_sisact.cod_id%type)
    return vtatabslcfac.numslc%type is
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;
    l_numslc               vtatabslcfac.numslc%type;
    l_tiptra               tiptrabajo.tiptra%type;
    l_codsol               vtatabslcfac.codsol%type;
    l_obssolfac            vtatabslcfac.obssolfac%type;
    l_idlinea              linea_paquete.idlinea%type;
    l_detalle_idlinea      detalle_idlinea_type;
    l_srvpri               vtatabslcfac.srvpri%type;

    cursor servicios is
      select t.*
        from sales.sisact_postventa_det_serv_hfc t
       where t.idinteraccion = p_idinteraccion
     AND t.dscequ IS NOT NULL; --7.0

  begin
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);
    l_tiptra               := get_parametro_deco_lte('WLL/SIAC - DECO ADICIONAL',0); --<7.0>
    l_codsol               := get_parametro_deco('RVCODSOL', 0);
    l_obssolfac            := get_parametro_deco('OBSSOLFAC', 1);
    l_srvpri               := get_parametro_deco('SRVPRI', 1);

    l_numslc := sales.f_get_clave_proyecto();
    insert into vtatabslcfac
      (numslc,
       fecpedsol,
       estsolfac,
       srvpri,
       codcli,
       codsol,
       idsolucion, --7.0
       obssolfac,
       tipsrv,
       tipsolef,
       plazo_srv,
       moneda_id,
       tipo,
       fecapr)
    values
      (l_numslc,
       sysdate,
       '03',
       l_srvpri,
       l_detalle_vtadetptoenl.codcli,
       l_codsol,
     l_detalle_vtadetptoenl.idsolucion, --7.0
       l_obssolfac,
       l_detalle_vtadetptoenl.tipsrv,
       2,
       11,
       1,
       0,
       sysdate);

    operacion.pq_siac_postventa.set_siac_instancia(p_idprocess,
                                                   'DECO ADICIONAL',
                                                   'PROYECTO DE POSTVENTA',
                                                   l_numslc);

    operacion.pq_siac_postventa.set_int_negocio_instancia(p_idprocess,
                                                          'PROYECTO DE VENTA',
                                                          l_numslc);

    crear_srv_instalacion(l_numslc, l_detalle_vtadetptoenl);

    for servicio in servicios loop
      if es_servicio_adicional_lte(servicio.idgrupo) then --7.0
        l_idlinea := ubicar_idlinea_servicio_lte(servicio.servicio); --7.0
      elsif es_servicio_comodato_lte(servicio.idgrupo, servicio.idgrupo_principal) or --7.0
            es_servicio_alquiler_lte(servicio.idgrupo, servicio.idgrupo_principal) then --7.0
        l_idlinea := ubicar_idlinea_equipo(servicio.tipequ, servicio.idgrupo);
      end if;

      l_detalle_idlinea := detalle_idlinea_lte(l_idlinea); --7.0

      insert into vtadetptoenl
        (numslc,
         descpto,
         dirpto,
         ubipto,
         crepto,
         codsrv,
         codsuc,
         estcts,
         estcse,
         tiptra,
         idprecio,
         cantidad,
         codinssrv,
         paquete,
         codequcom,
         idproducto,
         plazo_instalacion,
         grupo,
         tipo_vta,
         moneda_id,
         idpaq,
         iddet,
         idplataforma)
      values
        (l_numslc,
         l_detalle_vtadetptoenl.descpto,
         l_detalle_vtadetptoenl.dirpto,
         l_detalle_vtadetptoenl.ubipto,
         1,
         l_detalle_idlinea.codsrv,
         l_detalle_vtadetptoenl.codsuc,
         l_detalle_vtadetptoenl.estcts,
         1,
         l_tiptra,
         l_detalle_idlinea.idprecio,
         servicio.cantidad,
         l_detalle_vtadetptoenl.codinssrv,
         1,
         l_detalle_idlinea.codequcom,
         l_detalle_idlinea.idproducto,
         7,
         1,
         6,
         1,
         l_detalle_idlinea.idpaq,
         l_detalle_idlinea.iddet,
         7);
    end loop;

    update vtadetptoenl t
       set t.numpto_prin = t.numpto
     where t.numslc = l_numslc;

    return l_numslc;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.registrar_venta(p_idprocess => ' || p_idprocess ||
                              ', p_idinteraccion => ' || p_idinteraccion ||
                              ', p_cod_id => ' || p_cod_id || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure crear_srv_instalacion(p_numslc               vtatabslcfac.numslc%type,
                                  p_detalle_vtadetptoenl detalle_vtadetptoenl_type) is
    l_instalacion tystabsrv%rowtype;
    l_tiptra      tiptrabajo.tiptra%type;

  begin
    if not crea_instalacion() then
      return;
    end if;

    l_instalacion := ubicar_servicio_instalacion();
    l_tiptra      := get_parametro_deco_lte('WLL/SIAC - DECO ADICIONAL', 0); --<7.0>

    insert into vtadetptoenl
      (numslc,
       descpto,
       dirpto,
       ubipto,
       crepto,
       codsrv,
       codsuc,
       estcts,
       estcse,
       tiptra,
       cantidad,
       codinssrv,
       paquete,
       idproducto,
       plazo_instalacion,
       grupo,
       tipo_vta,
       moneda_id,
       idpaq,
       iddet,
       idplataforma,
       flgsrv_pri) --7.0
    values
      (p_numslc,
       p_detalle_vtadetptoenl.descpto,
       p_detalle_vtadetptoenl.dirpto,
       p_detalle_vtadetptoenl.ubipto,
       1,
       l_instalacion.codsrv,
       p_detalle_vtadetptoenl.codsuc,
       p_detalle_vtadetptoenl.estcts,
       1,
       l_tiptra,
       1,
       p_detalle_vtadetptoenl.codinssrv,
       1,
       l_instalacion.idproducto,
       7,
       1,
       6,
       1,
       p_detalle_vtadetptoenl.idpaq,
       p_detalle_vtadetptoenl.iddet,
       7,
     p_detalle_vtadetptoenl.flgsrv_pri);  -- 7.0

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crear_srv_instalacion(p_detalle_vtadetptoenl => RECORD) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function crea_instalacion return boolean is
    l_count number;

  begin
    select count(d.codigon)
      into l_count
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'CREAR_INSTALACION'
       and d.codigon = 1;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  procedure registrar_insprd(p_cod_id sales.sot_sisact.cod_id%type,
                             p_numslc vtatabslcfac.numslc%type) is
    l_pid       insprd.pid%type;
    l_codinssrv inssrv.codinssrv%type;

    cursor detalles is
      select t.* from vtadetptoenl t where t.numslc = p_numslc;

  begin
    l_codinssrv := get_codinssrv(p_cod_id);

    for detalle in detalles loop
      for idx in 1 .. detalle.cantidad loop
        select sq_id_insprd.nextval into l_pid from dual;

        insert into insprd
          (pid,
           descripcion,
           estinsprd,
           codsrv,
           codinssrv,
           cantidad,
           numslc,
           numpto,
           codequcom,
           iddet,
           idplataforma,
           flgprinc)
        values
          (l_pid,
           detalle.descpto,
           4,
           detalle.codsrv,
           l_codinssrv,
           1,
           p_numslc,
           detalle.numpto,
           detalle.codequcom,
           detalle.iddet,
           7,
           decode(detalle.codequcom,null,1,0));
      end loop;
    end loop;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.registrar_insprd(p_cod_id => ' ||
                              p_cod_id || ', p_numslc => ' || p_numslc || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function registrar_solot(p_idprocess siac_postventa_proceso.idprocess%type,
                           p_cod_id    sales.sot_sisact.cod_id%type,
                           p_numslc    vtatabslcfac.numslc%type,
                           p_cargo     solot.cargo%type)
    return solot.codsolot%type is
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;
    l_codsolot             solot.codsolot%type;
    l_tiptra               tiptrabajo.tiptra%type;

  begin
    l_tiptra               := get_parametro_deco_lte('WLL/SIAC - DECO ADICIONAL',0); --<7.0>
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);

    --select sq_solot.nextval into l_codsolot from dual;  --9.0
  insert into solot
      (--codsolot,  --9.0
     tiptra,
       estsol,
       tipsrv,
       codcli,
       numslc,
       codmotot,
       areasol,
       feccom,
       customer_id,
       cod_id,
     --10.0 Ini
     cargo,
       observacion)
     --10.0 Fin
    values
      (--l_codsolot,  --9.0
      l_tiptra,
       10,
       l_detalle_vtadetptoenl.tipsrv,
       l_detalle_vtadetptoenl.codcli,
       p_numslc,
       get_codmotot(),
       l_detalle_vtadetptoenl.areasol,
       sysdate,
       l_detalle_vtadetptoenl.customer_id,
       p_cod_id,
     --10.0 Ini
     p_cargo,
       (select a.observacion from operacion.siac_postventa_proceso a where a.idprocess = p_idprocess))
     --10.0 Fin
       returning codsolot into l_codsolot;  --9.0

    operacion.pq_siac_postventa.set_siac_instancia(p_idprocess,
                                                   'DECO ADICIONAL',
                                                   'SOT',
                                                   l_codsolot);

    operacion.pq_siac_postventa.set_int_negocio_instancia(p_idprocess,
                                                          'SOT',
                                                          l_codsolot);

    return l_codsolot;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.registrar_solot(p_idprocess => ' || p_idprocess ||
                              ', p_cod_id => ' || p_cod_id || ', p_numslc => ' ||
                              p_numslc || ', p_cargo => ' || p_cargo || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
procedure registrar_solotpto(p_cod_id        sales.sot_sisact.cod_id%type,
                             p_numslc        solot.numslc%type,
                             p_codsolot      solot.codsolot%type,
                             p_idinteraccion sales.sisact_postventa_det_serv_lte.idinteraccion%type,  --11.0
                             p_accion        varchar2) is  --11.0
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;

  --13.0 Ini
  v_serie sales.sisact_postventa_det_serv_lte.num_serie%type;
  l_punto solotpto.punto%type;   --15.0

  cursor c_prin_b is
  select distinct su.num_serie
    from sales.sisact_postventa_det_serv_lte su
   where su.idinteraccion = p_idinteraccion
     and su.flag_accion = C_BAJA;

  cursor c_baja_deco(v_serie varchar2) is
  SELECT XX.*
  FROM (SELECT DISTINCT X.dscequ,
                        X.codsrv,
                        x.descripcion,
                        x.codinssrv,
                        x.pid,
                        x.cod_id,
                        te.tipequ,
                        te.codtipequ,
                        x.codequcom,
                        X.CODSOLOT,
                        X.PUNTO_PRIN,
                        (SELECT DISTINCT EQU.NUMSERIE
                           FROM SOLOTPTOEQU EQU
                          WHERE EQU.CODSOLOT = X.CODSOLOT
                            AND equ.tipequ = te.tipequ
                            And equ.codequcom = x.codequcom
                            and equ.numserie = v_serie
                            ) NUMSERIE
          FROM (SELECT DISTINCT (SELECT ve.dscequ
                                   FROM vtaequcom ve
                                  WHERE ve.codequcom = ip.codequcom) dscequ,
                                IV.TIPSRV,
                                iv.codinssrv,
                                ip.codsrv,
                                ip.pid,
                                ip.descripcion,
                                s.cod_id,
                                IP.codequcom,
                                S.CODSOLOT,
                                (select DISTINCT spP.punto
                                   from solotpto spP,
                                        insprd p,
                                        inssrv i
                                  where spP.codsolot = S.CODSOLOT
                                    and spP.codinssrv = i.codinssrv
                                    and sPp.pid = p.pid
                                    and p.flgprinc = 1
                                    and i.tipsrv = IV.TIPSRV) PUNTO_PRIN -- PUNTO PRINCIPAL DEL EQUIPO
                  FROM solot s,
                       solotpto sp,
                       inssrv iv,
                       insprd ip
                 WHERE s.codsolot = sp.codsolot
                   AND sp.codinssrv = iv.codinssrv
                   AND ip.codinssrv = iv.codinssrv
                   AND S.ESTSOL IN (12, 29)
                   AND SP.PID = IP.PID
                   AND s.COD_ID = p_cod_id
                   and ip.estinsprd in (1, 2)
                   AND iv.tipsrv IN ('0062')
                   and nvl(ip.codequcom, 'X') != 'X') X,
               vtaequcom eq,
               equcomxope v,
               tipequ te
         where x.codequcom = eq.codequcom
           and eq.codequcom = v.codequcom
           and v.codtipequ = te.codtipequ) XX
 WHERE XX.numserie = v_serie
 AND NOT EXISTS (SELECT * FROM SOLOTPTO PTO WHERE PTO.PID = XX.PID AND PTO.CODSOLOT = p_codsolot);
  --13.0 Fin

    cursor insprds is
      select i.pid, i.descripcion, i.codsrv, i.codinssrv
        from insprd i
       where i.numslc = p_numslc;

  begin
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);
  if p_accion = 'A' then  --11.0
    for insprd in insprds loop
    select nvl(max(punto),0)+1 into l_punto from solotpto where codsolot = p_codsolot;  --15.0

      insert into solotpto
        (codsolot,
         codsrvnue,
         bwnue,
         codinssrv,
         descripcion,
         direccion,
         tipo,
         estado,
         visible,
         codubi,
         pid,tiptrs
     ,punto) --15.0
      values
        (p_codsolot,
         insprd.codsrv,
         0,
         insprd.codinssrv,
         '(Activación) ' || insprd.descripcion,  --11.0
         l_detalle_vtadetptoenl.dirpto,
         6,
         1,
         1,
         l_detalle_vtadetptoenl.ubipto,
         insprd.pid, 1
     ,l_punto );  --15.0
    end loop;
  --11.0 Ini
  elsif p_accion = 'B' then
    for bp in c_prin_b loop  --13.0
        for b in c_baja_deco(bp.num_serie) loop  --13.0

      select nvl(max(punto),0)+1 into l_punto from solotpto where codsolot = p_codsolot;  --15.0

          insert into solotpto
            (codsolot,
             codsrvnue,
             bwnue,
             codinssrv,
             descripcion,
             direccion,
             tipo,
             estado,
             visible,
             codubi,
             pid, tiptrs
             ,punto) --13.0
          values
            (p_codsolot,
             b.codsrv,
             0,
             b.codinssrv,
             '(Desactivación) '||b.descripcion,
             l_detalle_vtadetptoenl.dirpto,
             6,
             1,
             1,
             l_detalle_vtadetptoenl.ubipto,
             b.pid, 5
             ,l_punto);  --15.0
        end loop;
    end loop;  --13.0
  end if;
  --11.0 Fin

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.registrar_solotpto(p_cod_id => ' || p_cod_id ||
                              ', p_numslc => ' || p_numslc ||
                              ', p_codsolot => ' || p_codsolot || ') ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_codmotot return opedd.codigon%type is
    l_codmotot motot.codmotot%type;

  begin
    select d.codigon
      into l_codmotot
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'CODMOTOT';

    return l_codmotot;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_codmotot() ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_codinssrv(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv.codinssrv%type is
    l_codinssrv inssrv.codinssrv%type;
    l_tipsrv    inssrv.tipsrv%type;
  begin
    -- Inicio 5.0
    begin
    l_tipsrv := get_parametro_deco('TIPSRVDECO', 0);

    select i.codinssrv
      into l_codinssrv
      from sales.sot_sisact t, inssrv i
     where t.cod_id = p_cod_id
       and t.numslc = i.numslc
       and i.tipsrv = l_tipsrv;

     RETURN l_codinssrv; --<7.0>
 exception
   when no_data_found then

         select i.codinssrv
          into l_codinssrv
      from sales.sot_siac t,solot s ,inssrv i
     where t.cod_id = p_cod_id
       and t.codsolot = s.codsolot
       and s.numslc=i.numslc
       and i.tipsrv = l_tipsrv;
  -- Fin 5.0
    return l_codinssrv;
  end;
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_codinssrv(p_cod_id => ' ||
                              p_cod_id || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function existe_equipo(p_idgrupo sales.equipo_sisact.grupo%type,
                         p_tipequ  sales.equipo_sisact.tipequ%type)
    return boolean is
    l_count number;

  begin
    select count(t.idlinea)
      into l_count
      from sales.equipo_sisact t
     where t.grupo = p_idgrupo
       and t.tipequ = p_tipequ;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  function existe_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return boolean is
    l_count number;

  begin
    select count(lp.idlinea)
      into l_count
      from sales.servicio_sisact s, linea_paquete lp, tystabsrv t
     where s.idservicio_sisact = p_servicio
       and s.codsrv = lp.codsrv
       and lp.codsrv = t.codsrv
       and t.flg_sisact_sga = 1;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  procedure crear_idlinea_equipo(p_comodato sales.pq_comodato_sisact_lte.comodato_type, -- 7.0
                                 p_idlinea  out sales.linea_paquete.idlinea%type) is

  begin
    p_idlinea := sales.pq_comodato_sisact_lte.configure_comodato_deco_lte(p_comodato); --<7.0>

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crear_idlinea_equipo(p_comodato => RECORD) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure crear_idlinea_servicio(p_servicio sales.pq_servicio_sisact_lte.servicio_type, --7.0
                                   p_idlinea  out linea_paquete.idlinea%type,
                                   p_codsrv   out tystabsrv.codsrv%type) is
  begin

    sales.pq_servicio_sisact_lte.create_servicio(p_servicio,
                                                 p_idlinea,
                                                 p_codsrv); --<7.0>
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crear_idlinea_servicio(p_servicio => RECORD) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function ubicar_idlinea_equipo(p_tipequ  sales.sisact_postventa_det_serv_hfc.tipequ%type,
                                 p_idgrupo sales.sisact_postventa_det_serv_hfc.idgrupo%type)
    return linea_paquete.idlinea%type is
    l_idlinea linea_paquete.idlinea%type;

  begin
    select t.idlinea
      into l_idlinea
      from sales.equipo_sisact t
     where t.tipequ = p_tipequ
       and t.grupo = p_idgrupo;

    return l_idlinea;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.ubicar_idlinea_equipo(p_tipequ => ' || p_tipequ ||
                              ', p_idgrupo => ' || p_idgrupo || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function ubicar_idlinea_servicio(p_servicio sales.servicio_sisact.idservicio_sisact%type)
    return linea_paquete.idlinea%type is
    l_idlinea linea_paquete.idlinea%type;

  begin

    select lp.idlinea
      into l_idlinea
      from sales.servicio_sisact s, linea_paquete lp, tystabsrv t
     where s.idservicio_sisact = upper(trim(p_servicio))
       and s.codsrv = lp.codsrv
       and lp.codsrv = t.codsrv
       and t.flg_sisact_sga = 1;

    return l_idlinea;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.ubicar_idlinea_servicio(' ||
                              'p_servicio => ' || p_servicio || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function detalle_idlinea(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type is
    l_detalle_idlinea detalle_idlinea_type;

  begin
    select a.flgprincipal,
           a.idproducto,
           b.codsrv,
           b.codequcom,
           c.idprecio,
           b.cantidad,
           c.moneda_id,
           a.idpaq,
           a.iddet,
           a.paquete,
           s.banwid
      into l_detalle_idlinea.flgprincipal,
           l_detalle_idlinea.idproducto,
           l_detalle_idlinea.codsrv,
           l_detalle_idlinea.codequcom,
           l_detalle_idlinea.idprecio,
           l_detalle_idlinea.cantidad,
           l_detalle_idlinea.moneda_id,
           l_detalle_idlinea.idpaq,
           l_detalle_idlinea.iddet,
           l_detalle_idlinea.paquete,
           l_detalle_idlinea.banwid
      from linea_paquete b, detalle_paquete a, tystabsrv s, define_precio c
     where b.idlinea = p_idlinea
       and b.flgestado = 1
       and b.iddet = a.iddet
       and b.codsrv = c.codsrv
       and b.codsrv = s.codsrv
       and a.idpaq in (select x.idpaq
                         from paquete_venta x, soluciones y
                        where x.idsolucion = y.idsolucion
                          and y.flg_sisact_sga = 1)
       and c.plazo = 11
       and c.tipo = 1
       and a.flgestado = 1;

    return l_detalle_idlinea;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.detalle_idlinea(' ||
                              'p_idlinea => ' || p_idlinea || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function detalle_vtadetptoenl_alta(p_cod_id sales.sot_sisact.cod_id%type)
    return detalle_vtadetptoenl_type is
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;
    -- Inicio 5.0
    codsolot_max operacion.solot.codsolot%type;
    customer_id_max operacion.solot.customer_id%type;
    codsolot_s1 operacion.solot.codsolot%type;
    codsolot_s2 operacion.solot.codsolot%type;
    cont1 number;
    numslc_max char(10);
    no_existe_sot EXCEPTION; --7.0

 begin

    begin
      -- Ini 7.0
      codsolot_max := f_max_sot_x_cod_id(p_cod_id);

      IF codsolot_max = 0 THEN
        RAISE no_existe_sot;
      END IF;
      -- Fin 7.0
      select s.customer_id, s.numslc
        into customer_id_max, numslc_max
        from solot s
       where s.codsolot = codsolot_max;
    exception
       -- Ini 7.0
     WHEN no_existe_sot THEN
         raise_application_error(-20000,
                         'No existe SOT de alta para el : ' ||
                  p_cod_id);
         -- Fin 7.0
         when no_data_found then
           RAISE_APPLICATION_ERROR(-20000,
                              'No se encuentra datos en la solot para el cod_id: ' || p_cod_id );
    end;

    select count(0) into cont1
    from sales.sot_siac s1
    where s1.cod_id=p_cod_id;

    if cont1 > 0 then

       select max(s1.codsolot) into codsolot_s1
       from sales.sot_siac s1
       where s1.cod_id=p_cod_id;

       if(codsolot_max <> codsolot_s1)then
           insert into sales.sot_siac(cod_id, codsolot,cod_error,msg_error,customer_id)
           values(p_cod_id,codsolot_max,0,'Transaccion ejecutada correctamente.',customer_id_max);
       end if;

    else
       begin
         select s2.codsolot into codsolot_s2
         from sales.sot_sisact s2
         where s2.cod_id=p_cod_id;
       exception
         when no_data_found then
           insert into sales.sot_sisact(cod_id, codsolot, numslc)
           values(p_cod_id,codsolot_max,numslc_max);
       end;

       if(codsolot_max <> codsolot_s2)then
          insert into sales.sot_siac(cod_id, codsolot,cod_error,msg_error,customer_id)
          values(p_cod_id,codsolot_max,0,'Transaccion ejecutada correctamente.',customer_id_max);
       end if;
    end if;

    select v.descpto,
           v.dirpto,
           v.ubipto,
           v.codsuc,
           v.codinssrv,
           v.estcts,
           t.tipsrv,
           t.codcli,
           v.cantidad,
           t.areasol,
           t.customer_id,
           v.iddet,
           v.idpaq,
           vt.idsolucion, --7.0
           v.flgsrv_pri   --7.0
      into l_detalle_vtadetptoenl
      from solot t, vtadetptoenl v, vtatabslcfac vt -- 7.0
     where (t.codsolot = codsolot_max)
     and t.numslc = vt.numslc -- 8.0
       and vt.numslc = v.numslc -- 8.0
       and v.idproducto in
           (select o.codigon
              from opedd o
             where o.tipopedd = (select t.tipopedd
                                   from tipopedd t
                                  where t.abrev = 'DECO_ADICIONAL')
               and o.abreviacion = 'IDPROD_SISACT')
       and rownum = 1;

    return l_detalle_vtadetptoenl;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.sot_sisact cod_id(p_cod_id => ' ||
                              p_cod_id || ') ' || sqlerrm);
  end;
  -- Fin 5.0
  --------------------------------------------------------------------------------
  function ubicar_servicio_instalacion return tystabsrv%rowtype is
    l_codsrv   tystabsrv.codsrv%type;
    l_servicio tystabsrv%rowtype;

  begin
    l_codsrv := get_codsrv();

    select t.* into l_servicio from tystabsrv t where t.codsrv = l_codsrv;

    return l_servicio;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.ubicar_servicio_instalacion() ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_codsrv return tystabsrv.codsrv%type is  -- 7.0
    l_codsrv tystabsrv.codsrv%type;

  begin
    -- Ini 7.0
    /*select d.codigoc
      into l_codsrv
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'CODSRV';*/

  SELECT t.codsrv
      INTO l_codsrv
      FROM sales.tystabsrv t
     WHERE t.dscsrv = 'Inst. Deco Adicional LTE Post Instalacion';
    -- Fin 7.0
    return l_codsrv;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_codsrv() ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function get_wfdef return number is
    l_wfdef wfdef.wfdef%type;

  begin
    select d.codigon
      into l_wfdef
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'WFDECADIC';

    return l_wfdef;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_wfdef() ' || sqlerrm);
  end;
 /* *********************************************************************************************/
  --<ini 4.0>
  FUNCTION f_get_wfdef_adc RETURN NUMBER IS
    l_codigon NUMBER;  --7.0

  BEGIN
    --SELECT d.codigon  --9.0
  SELECT distinct d.codigon --9.0
      INTO l_codigon --7.0
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPO_TRANS_SIAC_LTE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'WLL/SIAC - DECO ADICIONAL';

    RETURN l_codigon;  --7.0

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.get_wfdef() ' || SQLERRM);

  END;
  /* **********************************************************************************************/

  FUNCTION f_get_tiptra(p_idprocess IN NUMBER) RETURN NUMBER IS
    ln_tiptra NUMBER;
  BEGIN
    BEGIN --< 6.0>
      SELECT s.tiptra
      INTO ln_tiptra
      FROM sales.siac_postventa_lte s
      WHERE s.id_siac_postventa_lte = p_idprocess;
    EXCEPTION--<ini 6.0>
      WHEN NO_DATA_FOUND THEN
        ln_tiptra := 0;
    end;--<fin 6.0>

    RETURN ln_tiptra;
--<ini 6.0>
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.f_get_tiptra(p_idprocess => ' ||
                              p_idprocess || ') ' || sqlerrm);
--<ini 6.0>
  END;
  --<fin 4.0>
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  function get_parametro_deco(p_abreviacion opedd.abreviacion%type,
                              p_codigon_aux opedd.codigon_aux%type)
    return varchar2 is
    l_parametro varchar2(1000);

  begin
    if p_codigon_aux = 0 then
      select d.codigoc
        into l_parametro
        from tipopedd c, opedd d
       where c.abrev = 'DECO_ADICIONAL'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = p_abreviacion;
    else
      select d.descripcion
        into l_parametro
        from tipopedd c, opedd d
       where c.abrev = 'DECO_ADICIONAL'
         and c.tipopedd = d.tipopedd
         and d.abreviacion = p_abreviacion
         and nvl(d.codigon_aux, 0) = p_codigon_aux;
    end if;

    return l_parametro;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_param_regventa(p_abreviacion => ' ||
                              p_abreviacion || ', p_codigon_aux => ' ||
                              p_codigon_aux || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function detalle_idlinea_instalacion(p_idlinea linea_paquete.idlinea%type)
    return detalle_idlinea_type is
    l_detalle_idlinea detalle_idlinea_type;

  begin
    select a.flgprincipal,
           a.idproducto,
           b.codsrv,
           b.codequcom,
           c.idprecio,
           b.cantidad,
           c.moneda_id,
           a.idpaq,
           a.iddet,
           a.paquete,
           s.banwid
      into l_detalle_idlinea.flgprincipal,
           l_detalle_idlinea.idproducto,
           l_detalle_idlinea.codsrv,
           l_detalle_idlinea.codequcom,
           l_detalle_idlinea.idprecio,
           l_detalle_idlinea.cantidad,
           l_detalle_idlinea.moneda_id,
           l_detalle_idlinea.idpaq,
           l_detalle_idlinea.iddet,
           l_detalle_idlinea.paquete,
           l_detalle_idlinea.banwid
      from linea_paquete b, detalle_paquete a, tystabsrv s, define_precio c
     where b.idlinea = p_idlinea
       and b.flgestado = 1
       and b.iddet = a.iddet
       and b.codsrv = c.codsrv
       and b.codsrv = s.codsrv
       and c.plazo = 11
       and c.tipo = 1
       and a.flgestado = 1;

    return l_detalle_idlinea;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' ||
                              'detalle_idlinea_instalacion(p_idlinea => ' ||
                              p_idlinea || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure aplicar_cambio(p_val_err varchar2) is
  begin
    case p_val_err
      when 0 then
        rollback;
      when 1 then
        commit;
    end case;
  end;
  --------------------------------------------------------------------------------
  --<ini 7.0>
  FUNCTION es_servicio_adicional_lte(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    RETURN grupo_servicios_lte('GRP_ADI', p_idgrupo);
  END;
  --------------------------------------------------------------------------------
  FUNCTION es_servicio_alquiler_lte(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                    p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    RETURN grupo_servicios_lte('GRP_ALQ', p_idgrupo) AND es_servicio_principal_lte(p_idgrupo_principal); --<7.0>
  END;
  --------------------------------------------------------------------------------
  FUNCTION es_servicio_comodato_lte(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                    p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    RETURN grupo_servicios_lte('GRP_COM', p_idgrupo) AND es_servicio_principal_lte(p_idgrupo_principal); --<7.0>
  END;
  --------------------------------------------------------------------------------
  FUNCTION es_servicio_principal_lte(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    RETURN grupo_servicios_lte('GRP_PRI', p_idgrupo);
  END;
  --------------------------------------------------------------------------------
  FUNCTION grupo_servicios_lte(p_tip_servicio opedd.abreviacion%TYPE,
                               p_cod_servicio sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS
    l_count NUMBER;

  BEGIN

    SELECT COUNT(d.codigoc)
      INTO l_count
      FROM sales.crmdd d, sales.tipcrmdd c
     WHERE d.tipcrmdd = c.tipcrmdd
       AND c.abrev = 'CONF_GRP_LTE'
       AND d.abreviacion = p_tip_servicio
       AND d.codigoc = p_cod_servicio;

    RETURN l_count > 0;
  END;
  --------------------------------------------------------------------------------
  FUNCTION existe_servicio_lte(p_servicio sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN BOOLEAN IS
    l_count NUMBER;

  BEGIN
    SELECT COUNT(lp.idlinea)
      INTO l_count
      FROM sales.servicio_sisact s, linea_paquete lp, tystabsrv t
     WHERE s.idservicio_sisact = p_servicio
       AND s.codsrv = lp.codsrv
       AND lp.codsrv = t.codsrv
       AND t.flg_sisact_sga = 2;

    RETURN l_count > 0;
  END;
  --------------------------------------------------------------------------------
  FUNCTION get_parametro_deco_lte(p_abreviacion opedd.abreviacion%TYPE,
                                  p_codigon_aux opedd.codigon_aux%TYPE)
    RETURN VARCHAR2 IS
    l_parametro VARCHAR2(1000);

  BEGIN
    IF p_codigon_aux = 0 THEN

      --SELECT o.codigon  --9.0
    SELECT distinct o.codigon  --9.0
        INTO l_parametro
        FROM opedd o
       WHERE o.tipopedd =
             (SELECT t.tipopedd
                FROM tipopedd t
               WHERE t.abrev = 'TIPO_TRANS_SIAC_LTE')
         AND o.abreviacion = p_abreviacion;

    END IF;

    RETURN l_parametro;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.get_parametro_deco_lte(p_abreviacion => ' ||
                              p_abreviacion || ', p_codigon_aux => ' ||
                              p_codigon_aux || ') ' || SQLERRM);
  END;
  --------------------------------------------------------------------------------
  FUNCTION f_valida_deco_lte(ln_codsolot operacion.solot.codsolot%TYPE)
    RETURN NUMBER IS
    ln_tiptra  NUMBER;
    ln_codigon NUMBER;
  BEGIN

    SELECT tiptra INTO ln_tiptra FROM solot WHERE codsolot = ln_codsolot;

    --SELECT codigon  --9.0
  SELECT distinct codigon  --9.0
      INTO ln_codigon
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'TIPO_TRANS_SIAC_LTE')
       AND abreviacion = 'WLL/SIAC - DECO ADICIONAL';

    IF ln_tiptra = ln_codigon THEN
      RETURN 1; --proy deco adicional
    ELSE
      RETURN 0; --proy no deco adicional
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'f_valida_deco_lte(ln_codsolot => ' ||
                              ln_codsolot || ') ' || SQLERRM);

  END;
  --------------------------------------------------------------------------------
  FUNCTION ubicar_idlinea_servicio_lte(p_servicio sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE IS
    l_idlinea linea_paquete.idlinea%TYPE;

  BEGIN

    SELECT lp.idlinea
      INTO l_idlinea
      FROM sales.servicio_sisact s, linea_paquete lp, tystabsrv t
     WHERE s.idservicio_sisact = upper(TRIM(p_servicio))
       AND s.codsrv = lp.codsrv
       AND lp.codsrv = t.codsrv
       AND t.flg_sisact_sga = 2;

    RETURN l_idlinea;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.ubicar_idlinea_servicio_lte(' ||
                              'p_servicio => ' || p_servicio || ') ' ||
                              SQLERRM);
  END;
  --------------------------------------------------------------------------------
  FUNCTION detalle_idlinea_lte(p_idlinea linea_paquete.idlinea%TYPE)
    RETURN detalle_idlinea_type IS
    l_detalle_idlinea detalle_idlinea_type; --<7.0>

  BEGIN
    SELECT a.flgprincipal,
           a.idproducto,
           b.codsrv,
           b.codequcom,
           c.idprecio,
           b.cantidad,
           c.moneda_id,
           a.idpaq,
           a.iddet,
           a.paquete,
           s.banwid
      INTO l_detalle_idlinea.flgprincipal,
           l_detalle_idlinea.idproducto,
           l_detalle_idlinea.codsrv,
           l_detalle_idlinea.codequcom,
           l_detalle_idlinea.idprecio,
           l_detalle_idlinea.cantidad,
           l_detalle_idlinea.moneda_id,
           l_detalle_idlinea.idpaq,
           l_detalle_idlinea.iddet,
           l_detalle_idlinea.paquete,
           l_detalle_idlinea.banwid
      FROM linea_paquete b, detalle_paquete a, tystabsrv s, define_precio c
     WHERE b.idlinea = p_idlinea
       AND b.flgestado = 1
       AND b.iddet = a.iddet
       AND b.codsrv = c.codsrv
       AND b.codsrv = s.codsrv
       AND a.idpaq IN (SELECT x.idpaq
                         FROM paquete_venta x, soluciones y
                        WHERE x.idsolucion = y.idsolucion
                          AND y.flg_sisact_sga = 2)
       AND c.plazo = 11
       AND c.tipo = 1
       AND a.flgestado = 1;

    RETURN l_detalle_idlinea;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.detalle_idlinea(' ||
                              'p_idlinea => ' || p_idlinea || ') ' ||
                              SQLERRM);
  END;
  --<fin 7.0>
  --<<ini 7.0>>
  FUNCTION get_wfdef_adi RETURN NUMBER IS
    l_codigon NUMBER;
    l_wfdef   wfdef.wfdef%TYPE;
  BEGIN
    --SELECT d.codigon  --9.0
  SELECT distinct d.codigon --9.0
      INTO l_codigon
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'TIPO_TRANS_SIAC_LTE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'WLL/SIAC - DECO ADICIONAL';
    SELECT c.wfdef
      INTO l_wfdef
      FROM cusbra.br_sel_wf c
     WHERE c.tiptra = l_codigon;

    RETURN l_wfdef;

  END;
  --<<fin 7.0>>
  --<ini 7.0>
  /*********************************************************************
   PROCEDIMIENTO: GENERAR DETALLE DE LA SOT
   PARAMETROS:
      Entrada:
        - an_codsolot     : codigo de sot
        - l_idprocess     : codigo de proceso
      Salida:
        - an_resultado    : 0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje      : Descripción de Resultado
  *********************************************************************/
  PROCEDURE P_GEN_DETALLE_SOT(p_solot         operacion.solot.codsolot%TYPE,
                              p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                              an_resultado    OUT NUMBER,
                              av_mensaje      OUT VARCHAR2) IS
    ln_tiptrabajo        NUMBER;
    ln_cant_std          NUMBER;
    ln_cant_hd           NUMBER;
    ln_cant_dvr          NUMBER;
    ln_costo_instalacion NUMBER;
    ln_num_servicio      VARCHAR2(20);
    lv_delimitador       VARCHAR2(1) := '|';
    av_detalle           VARCHAR2(4000);
  V_OBSERVACION OPERACION.SOLOT.OBSERVACION%TYPE;  --10.0

    CURSOR cur_detalle IS
      SELECT DISTINCT t.sncode,
                      t.tipequ,
                      t.dscequ,
                      t.cargofijo,
                      (SELECT tiptra FROM solot WHERE codsolot = so.codsolot) tiptra,
            (select ti.tipo_abrev from operacion.tipequ ti where ti.tipequ = t.tipequ) tipo_equipo,--10.0
                      i.numero
        FROM sales.sisact_postventa_det_serv_hfc t, inssrv i, solotpto so
       WHERE t.idinteraccion = p_idinteraccion
         AND so.codinssrv = i.codinssrv
         AND so.codsolot = p_solot
         AND t.tipequ IN
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'));

  BEGIN

    ln_cant_std          := 0;
    ln_cant_hd           := 0;
    ln_cant_dvr          := 0;
    ln_costo_instalacion := 0;

  --10.0 Ini
  --Obtenemos la observacion original de la tabla solot para no perderlo
    SELECT A.OBSERVACION INTO V_OBSERVACION FROM OPERACION.SOLOT A WHERE A.CODSOLOT = p_solot;
  --10.0 Fin

    FOR r_cur IN cur_detalle LOOP
      ln_tiptrabajo := r_cur.tiptra;

      IF trim(r_cur.tipo_equipo) = 'REGULAR' THEN --10.0
        ln_cant_std          := ln_cant_std + 1;
        ln_costo_instalacion := ln_costo_instalacion + r_cur.cargofijo;
      ELSIF trim(r_cur.tipo_equipo) = 'HD' THEN--10.0
        ln_cant_hd           := ln_cant_hd + 1;
        ln_costo_instalacion := ln_costo_instalacion + r_cur.cargofijo;
      ELSIF trim(r_cur.tipo_equipo) = 'DVR' THEN--10.0
        ln_cant_dvr          := ln_cant_dvr + 1;
        ln_costo_instalacion := ln_costo_instalacion + r_cur.cargofijo;
      END IF;

      ln_num_servicio := r_cur.numero;

    END LOOP;

  --10.0 Ini
  IF V_OBSERVACION IS NOT NULL THEN
      av_detalle := av_detalle || CHR(13);
    END IF;

  av_detalle := av_detalle || ln_tiptrabajo || '+' || lv_delimitador || '+' || ' ' ||
  --10.0 Fin
                  ln_cant_std || ' ' || 'STD' || ' ' || '+' || ' ' ||
                  ln_cant_hd || ' ' || 'HD' || ' ' || '+' || ' ' ||
                  ln_cant_dvr || ' ' || 'DVR' || lv_delimitador || 'S/.' ||
                  ln_costo_instalacion || lv_delimitador || ln_num_servicio ||
                  lv_delimitador || lv_delimitador || lv_delimitador;

    UPDATE operacion.solot s
       SET s.observacion = av_detalle
     WHERE s.codsolot = p_solot;

    COMMIT;

    an_resultado := 1;
    av_mensaje   := 'exito';
  EXCEPTION
    WHEN OTHERS THEN
      an_resultado := -1;
      av_mensaje   := $$PLSQL_UNIT ||
                      '.p_gen_detalle_sot: No se pudo generar la trama: ' ||
                      SQLERRM || '.';

  END;
  /* **********************************************************************************************/
  FUNCTION f_obt_tipo_deco(p_codsolot solot.codsolot%TYPE) RETURN NUMBER IS
    ln_tiptra  NUMBER;
    ln_codigon NUMBER;
  BEGIN
    SELECT tiptra INTO ln_tiptra FROM solot WHERE codsolot = p_codsolot;

    --SELECT codigon  --9.0
  SELECT distinct codigon  --9.0
      INTO ln_codigon
      FROM opedd
     WHERE tipopedd = (SELECT tipopedd
                         FROM tipopedd
                        WHERE abrev = 'TIPO_TRANS_SIAC_LTE')
       AND abreviacion = 'WLL/SIAC - DECO ADICIONAL';

    IF ln_tiptra = ln_codigon THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;

  END;
  /* **********************************************************************************************/
  FUNCTION f_obt_data_vta_ori(l_codsolot solot.codsolot%TYPE) RETURN VARCHAR2 IS

    ls_numregistro  operacion.ope_srv_recarga_cab.numregistro%TYPE;
    ln_tiptra       NUMBER;
    lv_customer_id  VARCHAR2(8);
    ln_codsolot_ori NUMBER;
    lv_codcli       VARCHAR2(8);
    lv_numslc       VARCHAR2(10);
  BEGIN

    --obtiene customer_id
    SELECT s.customer_id
      INTO lv_customer_id
    --FROM sales.siac_postventa_lte s  --9.0
  FROM solot s  --9.0
    WHERE s.codsolot = l_codsolot;

    --obtiene solot, tiptra, codigo cliente,proyecto de la venta inicial
    SELECT s.codsolot, s.tiptra, s.codcli, s.numslc
      INTO ln_codsolot_ori, ln_tiptra, lv_codcli, lv_numslc
      FROM solot s
     WHERE s.customer_id = lv_customer_id
       AND s.tiptra in (SELECT D.CODIGON
                          FROM TIPOPEDD C, OPEDD D
                         WHERE C.ABREV = 'TIPTRABAJO'
                           AND C.TIPOPEDD = D.TIPOPEDD
                           AND D.ABREVIACION = 'SISACT_WLL');

    --obtenemos el numregistro de la venta original
    SELECT o.numregistro
      INTO ls_numregistro
      FROM ope_srv_recarga_cab o
     WHERE o.codsolot = ln_codsolot_ori;

    RETURN ls_numregistro;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.f_obt_data_vta_ori' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_obt_data_numslc_ori(l_codsolot solot.codsolot%TYPE)
    RETURN VARCHAR2 IS

    ln_tiptra       NUMBER;
    lv_customer_id  VARCHAR2(8);
    ln_codsolot_ori NUMBER;
    lv_codcli       VARCHAR2(8);
    lv_numslc       VARCHAR2(10);
  BEGIN

    --obtiene customer_id
     SELECT s.customer_id
      INTO lv_customer_id
     --FROM sales.siac_postventa_lte s  --9.0
   FROM solot s  --9.0
     WHERE s.codsolot = l_codsolot;

    --obtiene solot, tiptra, codigo cliente,proyecto de la venta inicial
    SELECT s.codsolot, s.tiptra, s.codcli, s.numslc
      INTO ln_codsolot_ori, ln_tiptra, lv_codcli, lv_numslc
      FROM solot s
     WHERE s.customer_id = lv_customer_id
       AND s.tiptra IN (SELECT D.CODIGON
                          FROM TIPOPEDD C, OPEDD D
                         WHERE C.ABREV = 'TIPTRABAJO'
                           AND C.TIPOPEDD = D.TIPOPEDD
                           AND D.ABREVIACION = 'SISACT_WLL');

    RETURN lv_numslc;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.f_obt_data_numslc_ori' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION f_max_sot_x_cod_id(an_cod_id NUMBER) RETURN NUMBER IS

    ln_codsolot NUMBER;

  BEGIN

    SELECT nvl(MAX(s.codsolot), 0)
      INTO ln_codsolot
      FROM solot s, solotpto pto, inssrv ins
     WHERE s.codsolot = pto.codsolot
       AND pto.codinssrv = ins.codinssrv
       AND ins.estinssrv IN (1, 2)
       AND s.estsol IN (12, 29)
       AND s.tiptra IN (SELECT o.codigon
                          FROM tipopedd t, opedd o
                         WHERE t.tipopedd = o.tipopedd
                           AND t.abrev = 'TIPTRAVALIDECO')
       AND s.cod_id = an_cod_id;

    RETURN ln_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;
  /* **********************************************************************************************/
  PROCEDURE p_tipo_deco_lte(p_tipequ    IN NUMBER,
                            p_tipo_deco OUT VARCHAR2,
                            p_cod       OUT NUMBER,
                            p_mensaje   OUT VARCHAR2) IS
  BEGIN
    p_cod     := 0;
    p_mensaje := 'Exito';

    SELECT crm.abreviacion
      INTO p_tipo_deco
      FROM sales.crmdd crm
     WHERE crm.tipcrmdd IN
           (SELECT tip.tipcrmdd
              FROM sales.tipcrmdd tip
             WHERE tip.abrev = 'DTHPOSTEQU')
       AND crm.codigon = p_tipequ;
  EXCEPTION
    WHEN no_data_found THEN
      p_cod       := 0;
      p_mensaje   := 'No se encontro tipo de deco para este equipo';
      p_tipo_deco := NULL;
    WHEN OTHERS THEN
      p_cod     := -1;
      p_mensaje := $$PLSQL_UNIT ||
                   '.p_tipo_deco_lte: No se pudo devolver el tipo de deco: ' ||
                   SQLERRM || '.';
  END;
  --<fin 7.0>

  --<Ini 9.0>
  FUNCTION SGAFUN_DECO_ADIC(PI_ID_PROCESS     siac_postventa_proceso.idprocess%TYPE,
                            PI_TIPTRA         NUMBER,
                            PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%TYPE,
                            PI_COD_ID         sales.sot_sisact.cod_id%TYPE,
                            PI_CUSTOMER_ID    NUMBER,
                            PI_CARGO          solot.cargo%TYPE)
    RETURN solot.codsolot%TYPE IS
    C_NUMSLC     vtatabslcfac.numslc%TYPE;
    C_CODSOLOT   solot.codsolot%TYPE;
    V_RESULTADO NUMBER;
    V_MENSAJE   VARCHAR2(200);
    V_COD_ID    NUMBER;
    V_COD_DD    NUMBER;
  V_COD_AD    NUMBER;  --10.0
    C_TIPPOSTVENTA constant varchar2(50) := 'DESINSTALACION DECO ADICIONAL';

  BEGIN

      V_COD_ID := get_parametro_deco_lte('WLL/SIAC - DECO ADICIONAL',0);
      V_COD_DD := get_parametro_deco_lte('WLL/SIAC - BAJA DECO ALQUILER',0);   --10.0
    V_COD_AD := get_parametro_deco_lte('WLL/SIAC - CAMBIO DE DECOS',0);  --10.0

      IF PI_TIPTRA = V_COD_ID THEN

          SGASI_VALID_EQU_SERV(PI_ID_INTERACCION);

          C_NUMSLC := SGAFUN_REGISTRAR_VENTA(PI_ID_PROCESS, PI_ID_INTERACCION, PI_COD_ID);

          registrar_insprd(PI_COD_ID, C_NUMSLC);

          C_CODSOLOT := registrar_solot(PI_ID_PROCESS, PI_COD_ID, C_NUMSLC, PI_CARGO);

          registrar_solotpto(PI_COD_ID, C_NUMSLC, C_CODSOLOT, PI_ID_INTERACCION, 'A');  --11.0

          IF PI_TIPTRA = f_get_wfdef_adc THEN
            SGASU_GEN_DETALLE_SOT(C_CODSOLOT,
                                  PI_ID_INTERACCION,
                                  PI_TIPTRA, --11.0
                                  V_RESULTADO,
                                  V_MENSAJE);
          END IF ;
      --10.0 Ini
      ELSIF PI_TIPTRA in (V_COD_AD, V_COD_DD) THEN
--11.0 Ini
            --GENERACION DE SOT
            C_CODSOLOT := OPERACION.PKG_CAMBIO_EQUIPO_LTE.SGAFUN_REG_SOT(PI_ID_PROCESS,PI_COD_ID,PI_CUSTOMER_ID,PI_TIPTRA,C_TIPPOSTVENTA);

     IF PI_TIPTRA = V_COD_AD THEN

              C_NUMSLC := SGASI_REGISTRAR_VENTA_MIXTO(PI_ID_PROCESS, PI_ID_INTERACCION, PI_COD_ID);
              registrar_insprd(PI_COD_ID, C_NUMSLC);
               registrar_solotpto(PI_COD_ID, C_NUMSLC, C_CODSOLOT, PI_ID_INTERACCION, 'A');
               registrar_solotpto(PI_COD_ID, C_NUMSLC, C_CODSOLOT, PI_ID_INTERACCION, 'B');

            elsif PI_TIPTRA = V_COD_DD THEN

               select s.numslc into C_NUMSLC from solot s
               where s.codsolot  =operacion.pq_sga_iw.f_max_sot_x_cod_id(PI_COD_ID);

               --Insertamos en la SOLOTPTO asociando el PID obtenido
               registrar_solotpto(PI_COD_ID, C_NUMSLC, C_CODSOLOT, PI_ID_INTERACCION,   'B');

            END IF;

            SGASU_GEN_DETALLE_SOT(C_CODSOLOT, PI_ID_INTERACCION, PI_TIPTRA, V_RESULTADO, V_MENSAJE);

            UPDATE OPERACION.SOLOT
            SET NUMSLC = C_NUMSLC
            WHERE CODSOLOT = C_CODSOLOT;
--11.0 Fin
      END IF;

      PQ_SOLOT.p_chg_estado_solot(C_CODSOLOT, 11, 10,'Aprobacion Automatica de SOT');  --12.0

      RETURN C_CODSOLOT;

  EXCEPTION
   WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.deco_adicional(p_idprocess => ' ||
                              PI_ID_PROCESS || ', p_idinteraccion => ' ||
                              PI_ID_INTERACCION || ', p_cod_id => ' || PI_COD_ID ||
                              ', p_cargo => ' || PI_CARGO ||
                              ' Linea Error: ' || dbms_utility.format_error_backtrace ||
                              ') ' || sqlerrm);

  end;
------
procedure SGASI_VALID_EQU_SERV(PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type) is

    C_COMODATO     sales.pq_comodato_sisact_lte.comodato_type;
    C_SERVICIO     sales.pq_servicio_sisact_lte.servicio_type;
    C_IDLINEA      sales.linea_paquete.idlinea%type;
    C_SERVICIO_SGA sales.linea_paquete.codsrv%type;

    cursor lineas_iteraccion is
      select t.*
        from sales.sisact_postventa_det_serv_lte t
         where t.idinteraccion = PI_ID_INTERACCION
         AND t.dscequ IS NOT NULL;

  begin
    for linea_iteraccion in lineas_iteraccion loop
      IF es_servicio_adicional_lte(linea_iteraccion.idgrupo) THEN
        IF NOT existe_servicio_lte(linea_iteraccion.servicio) THEN
          C_SERVICIO.servicio          := linea_iteraccion.servicio;
          C_SERVICIO.dscsrv            := linea_iteraccion.dscsrv;
          C_SERVICIO.idgrupo           := linea_iteraccion.idgrupo;
          C_SERVICIO.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          C_SERVICIO.flag_lc           := linea_iteraccion.flag_lc;
          C_SERVICIO.codigo_ext        := linea_iteraccion.codigo_ext;
          C_SERVICIO.bandwid           := linea_iteraccion.bandwid;

          crear_idlinea_servicio(C_SERVICIO, C_IDLINEA, C_SERVICIO_SGA);
        END IF;
      ELSIF es_servicio_comodato_lte(linea_iteraccion.idgrupo,
                                     linea_iteraccion.idgrupo_principal) OR
            es_servicio_alquiler_lte(linea_iteraccion.idgrupo,
                                     linea_iteraccion.idgrupo_principal) THEN
        IF NOT
            existe_equipo(linea_iteraccion.idgrupo, linea_iteraccion.tipequ) THEN
          C_COMODATO.idgrupo           := linea_iteraccion.idgrupo;
          C_COMODATO.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          C_COMODATO.codtipequ         := linea_iteraccion.codtipequ;
          C_COMODATO.tipequ            := linea_iteraccion.tipequ;
          C_COMODATO.dscequ            := linea_iteraccion.dscequ;

          crear_idlinea_equipo(C_COMODATO, C_IDLINEA);
        END IF;
      END IF;
    end loop;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGASI_VALID_EQU_SERV(p_idinteraccion => ' ||
                              PI_ID_INTERACCION || ') ' || sqlerrm);
  end;

------
function SGAFUN_REGISTRAR_VENTA(PI_IDPROCESS      siac_postventa_proceso.idprocess%type,
                                PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type,
                                PI_COD_ID          sales.sot_sisact.cod_id%type)
    return vtatabslcfac.numslc%type is
    C_DETALLE_VTADETPTOENL detalle_vtadetptoenl_type;
    C_NUMSLC               vtatabslcfac.numslc%type;
    C_TIPTRA               tiptrabajo.tiptra%type;
    C_CODSOL               vtatabslcfac.codsol%type;
    C_OBSSOLFAC            vtatabslcfac.obssolfac%type;
    C_IDLINEA              linea_paquete.idlinea%type;
    C_DETALLE_IDLINEA      detalle_idlinea_type;
    C_SRVPRI               vtatabslcfac.srvpri%type;

    cursor servicios is
      select t.*
        from sales.sisact_postventa_det_serv_lte t
        where t.idinteraccion = PI_ID_INTERACCION
        AND t.dscequ IS NOT NULL;

  begin
    C_DETALLE_VTADETPTOENL := detalle_vtadetptoenl_alta(PI_COD_ID);
    C_TIPTRA               := sales.pq_siac_postventa_lte.SGAFUN_OBTIENE_TIPTRA(PI_IDPROCESS);
    C_CODSOL               := get_parametro_deco('RVCODSOL', 0);
    C_OBSSOLFAC            := get_parametro_deco('OBSSOLFAC', 1);
    C_SRVPRI               := get_parametro_deco('SRVPRI', 1);

    C_NUMSLC := sales.f_get_clave_proyecto();
    insert into vtatabslcfac
      (numslc,
       fecpedsol,
       estsolfac,
       srvpri,
       codcli,
       codsol,
       idsolucion,
       obssolfac,
       tipsrv,
       tipsolef,
       plazo_srv,
       moneda_id,
       tipo,
       fecapr)
    values
      (C_NUMSLC,
       sysdate,
       '03',
       C_SRVPRI,
       C_DETALLE_VTADETPTOENL.codcli,
       C_CODSOL,
       C_DETALLE_VTADETPTOENL.idsolucion,
       C_OBSSOLFAC,
       C_DETALLE_VTADETPTOENL.tipsrv,
       2,
       11,
       1,
       0,
       sysdate);

    operacion.pq_siac_postventa.set_siac_instancia(PI_IDPROCESS,
                                                   'DECO ADICIONAL',
                                                   'PROYECTO DE POSTVENTA',
                                                   C_NUMSLC);

    operacion.pq_siac_postventa.set_int_negocio_instancia(PI_IDPROCESS,
                                                          'PROYECTO DE VENTA',
                                                          C_NUMSLC);

    crear_srv_instalacion(C_NUMSLC, C_DETALLE_VTADETPTOENL);

    for servicio in servicios loop
      if es_servicio_adicional_lte(servicio.idgrupo) then
        C_IDLINEA := ubicar_idlinea_servicio_lte(servicio.servicio);
      elsif es_servicio_comodato_lte(servicio.idgrupo, servicio.idgrupo_principal) or
            es_servicio_alquiler_lte(servicio.idgrupo, servicio.idgrupo_principal) then
        C_IDLINEA := SGAFUN_ubicar_idlinea_equipo(servicio.tipequ, servicio.idgrupo);
      end if;

      C_DETALLE_IDLINEA := detalle_idlinea_lte(C_IDLINEA);

      insert into vtadetptoenl
        (numslc,
         descpto,
         dirpto,
         ubipto,
         crepto,
         codsrv,
         codsuc,
         estcts,
         estcse,
         tiptra,
         idprecio,
         cantidad,
         codinssrv,
         paquete,
         codequcom,
         idproducto,
         plazo_instalacion,
         grupo,
         tipo_vta,
         moneda_id,
         idpaq,
         iddet,
         idplataforma)
      values
        (C_NUMSLC,
         C_DETALLE_VTADETPTOENL.descpto,
         C_DETALLE_VTADETPTOENL.dirpto,
         C_DETALLE_VTADETPTOENL.ubipto,
         1,
         C_DETALLE_IDLINEA.codsrv,
         C_DETALLE_VTADETPTOENL.codsuc,
         C_DETALLE_VTADETPTOENL.estcts,
         1,
         C_TIPTRA,
         C_DETALLE_IDLINEA.idprecio,
         servicio.cantidad,
         C_DETALLE_VTADETPTOENL.codinssrv,
         1,
         C_DETALLE_IDLINEA.codequcom,
         C_DETALLE_IDLINEA.idproducto,
         7,
         1,
         6,
         1,
         C_DETALLE_IDLINEA.idpaq,
         C_DETALLE_IDLINEA.iddet,
         7);
    end loop;

    update vtadetptoenl t
       set t.numpto_prin = t.numpto
     where t.numslc = C_NUMSLC;

    return C_NUMSLC;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_REGISTRAR_VENTA(PI_IDPROCESS => ' || PI_IDPROCESS ||
                              ', PI_ID_INTERACCION => ' || PI_ID_INTERACCION ||
                              ', PI_COD_ID => ' || PI_COD_ID || ') ' || sqlerrm);
  end;
------

FUNCTION SGAFUN_UBICAR_IDLINEA_EQUIPO(PI_TIPEQU  sales.sisact_postventa_det_serv_lte.tipequ%type,
                                      PI_IDGRUPO sales.sisact_postventa_det_serv_lte.idgrupo%type)
    return linea_paquete.idlinea%type is
    V_IDLINEA linea_paquete.idlinea%type;

  begin
    select t.idlinea
      into V_IDLINEA
    from sales.equipo_sisact t
    where t.tipequ = PI_TIPEQU
    and t.grupo = PI_IDGRUPO;

    return V_IDLINEA;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_UBICAR_IDLINEA_EQUIPO(p_tipequ => ' || PI_TIPEQU ||
                              ', p_idgrupo => ' || PI_IDGRUPO || ') ' || sqlerrm);
  end;

-----
PROCEDURE SGASU_GEN_DETALLE_SOT(PI_SOLOT         operacion.solot.codsolot%TYPE,
                                PI_IDINTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%TYPE,
                                PI_TIPTRA        operacion.solot.tiptra%TYPE, --11.0
                                PO_RESULTADO     OUT NUMBER,
                                PO_MENSAJE       OUT VARCHAR2) IS
    V_TIP_TRABAJO       NUMBER;
    V_CANT_STD          NUMBER;
    V_CANT_HD           NUMBER;
    V_CANT_DVR          NUMBER;
    V_COSTO_INSTALACION NUMBER;
    V_NUM_SERVICIO      VARCHAR2(20);
    V_DELIMITADOR       VARCHAR2(1) := '|';
    V_DETALLE           VARCHAR2(4000);
  V_OBSERVACION       OPERACION.SOLOT.OBSERVACION%TYPE; --10.0
  --11.0 Ini
  V_COD_AD            NUMBER := 0;
  V_CANT_STD_A        NUMBER := 0;
  V_CANT_HD_A         NUMBER := 0;
  V_CANT_DVR_A        NUMBER := 0;
  V_CANT_STD_B        NUMBER := 0;
  V_CANT_HD_B         NUMBER := 0;
  V_CANT_DVR_B        NUMBER := 0;
  V_COSTO_INST_A      NUMBER := 0;
  V_COSTO_INST_B      NUMBER := 0;
  --11.0 Fin

    CURSOR cur_detalle IS
      SELECT DISTINCT t.sncode,
                      t.tipequ,
                      t.dscequ,
                      t.cargofijo,
                      (SELECT tiptra FROM solot WHERE codsolot = so.codsolot) tiptra,
                    (select ti.tipo_abrev from operacion.tipequ ti where ti.tipequ = t.tipequ) tipo_equipo, --10.0
                    i.numero,
                    t.flag_accion  --11.0
        FROM sales.sisact_postventa_det_serv_lte t, inssrv i, solotpto so
       WHERE t.idinteraccion = PI_IDINTERACCION
         AND so.codinssrv = i.codinssrv
         AND so.codsolot = PI_SOLOT
         AND t.tipequ IN
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'));

  BEGIN

    V_CANT_STD          := 0;
    V_CANT_HD           := 0;
    V_CANT_DVR          := 0;
    V_COSTO_INSTALACION := 0;
  PO_RESULTADO        := 0;
  PO_MENSAJE          := 'Exito';
  V_COD_AD            := get_parametro_deco_lte('WLL/SIAC - CAMBIO DE DECOS',0); --11.0

   --Obtenemos la observacion original de la tabla solot para no perderlo
  SELECT A.OBSERVACION INTO V_OBSERVACION  FROM OPERACION.SOLOT A WHERE A.CODSOLOT = PI_SOLOT; --10.0

  --11.0 Ini
  IF PI_TIPTRA = V_COD_AD THEN
    V_TIP_TRABAJO := PI_TIPTRA;
    FOR r_cur IN cur_detalle LOOP
      IF TRIM(r_cur.flag_accion) = 'A' THEN
          IF TRIM(r_cur.tipo_equipo) = 'SD' THEN
            V_CANT_STD_A        := V_CANT_STD_A + 1;
            V_COSTO_INST_A      := V_COSTO_INST_A + r_cur.cargofijo;
          ELSIF TRIM(r_cur.tipo_equipo) = 'HD' THEN
            V_CANT_HD_A         := V_CANT_HD_A + 1;  --12.0
            V_COSTO_INST_A      := V_COSTO_INST_A + r_cur.cargofijo;
          ELSIF TRIM(r_cur.tipo_equipo) = 'DVR' THEN
            V_CANT_DVR_A        := V_CANT_DVR_A + 1;  --12.0
            V_COSTO_INST_A      := V_COSTO_INST_A + r_cur.cargofijo;
          END IF;
      ELSIF TRIM(r_cur.flag_accion) = 'B' THEN
          IF TRIM(r_cur.tipo_equipo) = 'SD' THEN
            V_CANT_STD_B        := V_CANT_STD_B + 1;
            V_COSTO_INST_B      := V_COSTO_INST_B + r_cur.cargofijo;
          ELSIF TRIM(r_cur.tipo_equipo) = 'HD' THEN
            V_CANT_HD_B         := V_CANT_HD_B + 1;
            V_COSTO_INST_B      := V_COSTO_INST_B + r_cur.cargofijo;
          ELSIF TRIM(r_cur.tipo_equipo) = 'DVR' THEN
            V_CANT_DVR_B          := V_CANT_DVR_B + 1;
            V_COSTO_INST_B      := V_COSTO_INST_B + r_cur.cargofijo;
          END IF;
      END IF;

      V_NUM_SERVICIO := r_cur.numero;

    END LOOP;
  ELSE
    --11.0 Fin
    FOR r_cur IN cur_detalle LOOP
      V_TIP_TRABAJO := r_cur.tiptra;

      IF TRIM(r_cur.tipo_equipo) = 'SD' THEN --11.0
        V_CANT_STD          := V_CANT_STD + 1;
        V_COSTO_INSTALACION := V_COSTO_INSTALACION + r_cur.cargofijo;
      ELSIF TRIM(r_cur.tipo_equipo) = 'HD' THEN--10.0
        V_CANT_HD           := V_CANT_HD + 1;
        V_COSTO_INSTALACION := V_COSTO_INSTALACION + r_cur.cargofijo;
      ELSIF TRIM(r_cur.tipo_equipo) = 'DVR' THEN--10.0
        V_CANT_DVR          := V_CANT_DVR + 1;
        V_COSTO_INSTALACION := V_COSTO_INSTALACION + r_cur.cargofijo;
      END IF;

      V_NUM_SERVICIO := r_cur.numero;

    END LOOP;
  END IF; --11.0
  --10.0 Ini
  IF V_OBSERVACION IS NOT NULL THEN
      V_DETALLE := V_OBSERVACION || CHR(13);
    END IF;

  --11.0 Ini
  IF V_COSTO_INST_A IS NULL THEN
        V_COSTO_INST_A := 0;
  END IF;
  IF V_COSTO_INST_B IS NULL THEN
        V_COSTO_INST_B := 0;
  END IF;
  IF V_COSTO_INSTALACION IS NULL THEN
        V_COSTO_INSTALACION := 0;
  END IF;

  IF PI_TIPTRA = V_COD_AD THEN
      V_DETALLE := V_DETALLE || 'ACTIVACION '|| V_TIP_TRABAJO || '+' || V_DELIMITADOR || '+' || ' ' ||
                   V_CANT_STD_A || ' ' || 'STD' || ' ' || '+' || ' ' ||
                   V_CANT_HD_A || ' ' || 'HD' || ' ' || '+' || ' ' ||
                   V_CANT_DVR_A || ' ' || 'DVR' || V_DELIMITADOR || 'S/.' ||
                   V_COSTO_INST_A || V_DELIMITADOR || V_NUM_SERVICIO ||
                   V_DELIMITADOR || V_DELIMITADOR || V_DELIMITADOR;

      V_DETALLE := V_DETALLE || CHR(13) || 'DESACTIVACION '|| V_TIP_TRABAJO || '+' || V_DELIMITADOR || '+' || ' ' ||
                   V_CANT_STD_B || ' ' || 'STD' || ' ' || '+' || ' ' ||
                   V_CANT_HD_B || ' ' || 'HD' || ' ' || '+' || ' ' ||
                   V_CANT_DVR_B || ' ' || 'DVR' || V_DELIMITADOR || 'S/.' ||
                   V_COSTO_INST_B || V_DELIMITADOR || V_NUM_SERVICIO ||
                   V_DELIMITADOR || V_DELIMITADOR || V_DELIMITADOR;
  ELSE
  --11.0 Fin
  V_DETALLE := V_DETALLE || V_TIP_TRABAJO || '+' || V_DELIMITADOR || '+' || ' ' ||
  --10.0 Fin
                  V_CANT_STD || ' ' || 'STD' || ' ' || '+' || ' ' ||
                  V_CANT_HD || ' ' || 'HD' || ' ' || '+' || ' ' ||
                  V_CANT_DVR || ' ' || 'DVR' || V_DELIMITADOR || 'S/.' ||
                  V_COSTO_INSTALACION || V_DELIMITADOR || V_NUM_SERVICIO ||
                  V_DELIMITADOR || V_DELIMITADOR || V_DELIMITADOR;
  END IF; --11.0
    UPDATE operacion.solot s
       SET s.observacion = V_DETALLE
     WHERE s.codsolot = PI_SOLOT;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := $$PLSQL_UNIT ||
                      '.SGASU_GEN_DETALLE_SOT: No se pudo generar la trama: ' ||
                      SQLERRM || '.';

  END;
  PROCEDURE SGASD_ELIMINA_DECO_LTE(PI_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%TYPE,
                                 PI_ACTION        SALES.SISACT_POSTVENTA_DET_SERV_LTE.FLAG_ACCION%TYPE,
                                 PO_RESULTADO     OUT NUMBER,
                                 PO_MENSAJE       OUT VARCHAR2) IS

  V_CO_ID             OPERACION.SOLOT.COD_ID%TYPE;
  V_NRO_SERIE_DECO    OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE;
  V_NRO_SERIE_TARJETA OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE;
  V_TIPO_EQUIPO       VARCHAR2(10) := 'DECO';
  V_TIPO_DECO         SALES.CRMDD.DESCRIPCION%TYPE;

  CURSOR CUR_DECO_TARJETA IS
    SELECT S.COD_ID,
      --10.0 Ini
       DECODE(TM.TIPO, 2, TM.IMEI_ESN_UA) SERIE_DECO,
            (select spd2.num_serie
               from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD2
              where spd2.codsolot = spd.codsolot
                and spd2.asoc = spd.asoc
                and spd2.tipequ = C_TIPEQU_TARJ) SERIE_TARJETA,
    --10.0 Fin
           (SELECT CRM.DESCRIPCION
              FROM SALES.CRMDD CRM
             WHERE CRM.TIPCRMDD IN
                   (SELECT TIP.TIPCRMDD
                      FROM SALES.TIPCRMDD TIP
                     WHERE TIP.ABREV = 'DTHPOSTEQU')
               AND CODIGON = SPD.TIPEQU) TIPO_DECO
      FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD,
           OPERACION.TABEQUIPO_MATERIAL        TM,
           OPERACION.SOLOT                     S
     WHERE SPD.IDINTERACCION = PI_IDINTERACCION
       AND SPD.NUM_SERIE = TM.NUMERO_SERIE
       AND SPD.CODSOLOT = S.CODSOLOT
     AND TM.TIPO = 2  --10.0
       AND SPD.FLAG_ACCION = PI_ACTION
       --10.0 Ini
     AND SPD.CODSOLOT IS NOT NULL
        AND EXISTS (select ST.TRXN_IDTRANSACCION, ST.TRXV_SERIE_TARJETA
               from OPERACION.SGAT_TRXCONTEGO ST
              WHERE ST.TRXN_CODSOLOT = S.CODSOLOT
                AND ST.TRXV_SERIE_TARJETA =
                    (select spd2.num_serie
                       from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD2
                      where spd2.codsolot = spd.codsolot
                        and spd2.asoc = spd.asoc
                        and spd2.tipequ = C_TIPEQU_TARJ)
             UNION
             select STD.TRXN_IDTRANSACCION, STD.TRXV_SERIE_TARJETA
               from OPERACION.SGAT_TRXCONTEGO_HIST STD
              WHERE STD.TRXN_CODSOLOT = S.CODSOLOT
                AND STD.TRXV_SERIE_TARJETA =
                    (select spd2.num_serie
                       from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD2
                      where spd2.codsolot = spd.codsolot
                        and spd2.asoc = spd.asoc
                        and spd2.tipequ = C_TIPEQU_TARJ))
      ORDER BY SPD.ASOC;
    --10.0 Fin
BEGIN

  PO_RESULTADO:= 0;--10.0
  PO_MENSAJE := 'OK';--10.0

  FOR I IN CUR_DECO_TARJETA LOOP
      V_NRO_SERIE_TARJETA := I.SERIE_TARJETA;
      V_CO_ID          := I.COD_ID;
      V_NRO_SERIE_DECO := I.SERIE_DECO;
      V_TIPO_DECO      := I.TIPO_DECO;

    IF V_CO_ID IS NOT NULL AND V_NRO_SERIE_DECO IS NOT NULL AND V_TIPO_DECO IS NOT NULL AND V_NRO_SERIE_TARJETA IS NOT NULL THEN  --10.0
    TIM.PP021_VENTA_LTE.SP_ELIMINA_DECO_LTE@DBL_BSCS_BF(V_CO_ID,
                              V_NRO_SERIE_DECO,
                              V_NRO_SERIE_TARJETA,
                              V_TIPO_EQUIPO,
                              V_TIPO_DECO,
                              PO_RESULTADO,
                              PO_MENSAJE);
         --17.0 Ini
		 IF PO_RESULTADO <> 0 THEN
		    OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CO_ID, 'SGASD_ELIMINA_DECO_LTE', PO_MENSAJE, V_NRO_SERIE_DECO || ' - ' || V_NRO_SERIE_TARJETA,
                           PO_RESULTADO, PO_MENSAJE);
			PO_RESULTADO:= 0;
			PO_MENSAJE := 'OK';
		 END IF;
		 --17.0 Fin
    END IF; --10.0
  END LOOP;
END;
  ---
  PROCEDURE SGASU_BAJA_EQUIPOS(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                               PI_ACCION     IN CHAR,
                               PI_ASOC       IN sales.sisact_postventa_det_serv_lte.asoc%type,
                               PO_RESULTADO  OUT NUMBER,
                               PO_MENSAJE    OUT VARCHAR2) IS

  BEGIN

   PO_RESULTADO := 0;
   PO_MENSAJE   := 'Exito';

   UPDATE OPERACION.TABEQUIPO_MATERIAL M
   SET M.ESTADO = 0
   WHERE M.NUMERO_SERIE IN (SELECT NUM_SERIE FROM  SALES.SISACT_POSTVENTA_DET_SERV_LTE LTE
          WHERE LTE.CODSOLOT = PI_CODSOLOT AND LTE.FLAG_ACCION = PI_ACCION AND LTE.ASOC = pi_asoc);

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := $$PLSQL_UNIT ||
                      '.SGASU_BAJA_EQUIPOS: No se pudo dar de baja a equipos. ' ||
                      SQLERRM || '.' || ' - Linea ('||dbms_utility.format_error_backtrace ||')';  --17.0
					  
	OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(PI_CODSOLOT, 'SGASU_BAJA_EQUIPOS', PO_MENSAJE, '', PO_RESULTADO, PO_MENSAJE);  --17.0

  END;
  ---
PROCEDURE SGASU_VALIDA_DES_DECO(PI_IDTAREAWF IN NUMBER,
                                PI_IDWF      IN NUMBER,
                                PI_TAREA     IN NUMBER,
                                PI_TAREADEF  IN NUMBER) IS

  V_COD NUMBER;
  V_MSG VARCHAR2(100);
  V_CONT_CONTG NUMBER := 0;
  V_CODSOLOT    operacion.solot.codsolot%type;
  V_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%type;
  V_STSOL         operacion.solot.estsol%type;  --14.0
  EX_ERROR EXCEPTION;

  CURSOR CUR_TARJETAS_CONTEGO IS
  select distinct lte.num_serie, lte.asoc, c.trxn_action_id  --10.0
      from sales.sisact_postventa_det_serv_lte lte,
           operacion.tabequipo_material        m,
       --10.0 Ini
            (SELECT DISTINCT S.TRXV_SERIE_TARJETA, S.TRXC_ESTADO, S.TRXN_ACTION_ID
            FROM OPERACION.SGAT_TRXCONTEGO S
            WHERE S.TRXN_CODSOLOT = V_CODSOLOT
            UNION ALL
            SELECT DISTINCT SH.TRXV_SERIE_TARJETA, SH.TRXC_ESTADO, SH.TRXN_ACTION_ID
            FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
            WHERE SH.TRXN_CODSOLOT = V_CODSOLOT) c
       --10.0 Fin
     where lte.codsolot = V_CODSOLOT
       and lte.flag_accion = C_BAJA
       and m.numero_serie = lte.num_serie
       and lte.num_serie = c.trxv_serie_tarjeta
       and c.trxc_estado = 3
       AND M.TIPO = 1;

BEGIN

  V_COD := 0;
  V_MSG := 'Exito';


  BEGIN
      SELECT w.codsolot, s.estsol  --14.0
      INTO V_CODSOLOT, V_STSOL  --14.0
      FROM opewf.wf w, operacion.solot s WHERE w.idwf = PI_IDWF  --14.0
      AND w.codsolot = s.codsolot --14.0
      AND w.valido = 1;
  EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20500,
                            'ERROR AL OBTENER CODIGO DE SOT. ' || sqlerrm);  --17.0
  END;
  BEGIN
      select count(*)
      into V_CONT_CONTG
    --10.0 Ini
    FROM (SELECT DISTINCT S.TRXV_SERIE_TARJETA, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
         WHERE S.TRXN_CODSOLOT = V_CODSOLOT
        UNION ALL
        SELECT DISTINCT SH.TRXV_SERIE_TARJETA, SH.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
         WHERE SH.TRXN_CODSOLOT = V_CODSOLOT) C
     WHERE C.TRXC_ESTADO = C_PROV_OK;
     --10.0 Fin
  EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20500,
                                'ERROR EN LA VALIDACION DE PROVISION : ' || sqlerrm ); --17.0
  END;
  BEGIN
      SELECT DISTINCT LTE.IDINTERACCION
      INTO V_IDINTERACCION
        FROM SALES.SISACT_POSTVENTA_DET_SERV_LTE LTE
       WHERE LTE.CODSOLOT = V_CODSOLOT;
  EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20500,
                            'ERROR AL OBTENER IDINTERACCION. ' || sqlerrm);  --17.0
  END;

  IF V_CONT_CONTG > 0 THEN

        FOR I IN CUR_TARJETAS_CONTEGO LOOP

      --10.0 Ini
      SGASU_BAJA_SOLOTPTOEQU(V_CODSOLOT, C_BAJA, I.ASOC, I.TRXN_ACTION_ID, V_COD, V_MSG);
          IF V_COD <> 0 THEN
            RAISE EX_ERROR;
          END IF;
      --10.0 Fin
      SGASU_BAJA_EQUIPOS(V_CODSOLOT, C_BAJA, I.ASOC, V_COD, V_MSG);
          IF V_COD <> 0 THEN
            RAISE EX_ERROR;
          END IF;
        END LOOP;
    --10.0 Ini
    SGASD_ELIMINA_DECO_LTE(V_IDINTERACCION, C_BAJA, V_COD, V_MSG);
          IF V_COD <> 0 THEN
            RAISE EX_ERROR;
          END IF;
    --10.0 Fin

   --14.0 Ini
    SGASU_ACTUALIZAR_PID(V_CODSOLOT, 5, 3, V_COD, V_MSG);
          IF V_COD <> 0 THEN
                RAISE EX_ERROR;
          END IF;

    IF V_STSOL <> 29 THEN
        operacion.pq_solot.p_chg_estado_solot(V_CODSOLOT, 29);  --17.0
    END IF;
    --14.0 Fin
    ELSE
       V_COD := -1;
       V_MSG := 'BAJA DE DECO: NO SE HA ACTUALIZADO ESTADO DE EQUIPOS EN CONTEGO';
       RAISE EX_ERROR;
    END IF;

EXCEPTION
  WHEN EX_ERROR THEN
      V_MSG := V_MSG || ' Linea (' || dbms_utility.format_error_backtrace || ')';  --17.0

      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT,
                                                  'SGASU_VALIDA_DES_DECO',
                                                  V_MSG,
                                                  'EX_ERROR',
                                                  V_COD,
                                                  V_MSG); --17.0
      raise_application_error(-20500,
                              $$plsql_unit || ' ' || V_MSG || sqlerrm); --17.0

  WHEN OTHERS THEN
      V_MSG := 'ERROR: '||sqlerrm || ' Linea (' || dbms_utility.format_error_backtrace || ')';  --17.0
      OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(V_CODSOLOT,
                                                  'SGASU_VALIDA_DES_DECO',
                                                  V_MSG,
                                                  'OTHERS',
                                                  V_COD,
                                                  V_MSG); --17.0
      raise_application_error(-20500,
                              'ERROR AL VALIDAR DESINSTALACION DE DECOS. ' ||
                              sqlerrm); --17.0

END;
/*'****************************************************************
'* Nombre SP         : operacion.sgass_matriz_decos
'* Propósito         : Obtener la matriz de decos LTE
'* Input             : No aplica
'* Output            : po_cantidad - Cantidad de Decos configurado en la matriz
                       po_matriz   - Matriz de Decos LTE y sus pesos correspondientes
                       po_mensaje  - Envia 0 si el procedimiento se ejecuto de manera
                                     correcta.
                       po_mensaje  - Retorna 'Exito' en caso de la ejecucion correcta
                                     del procedimiento, caso contrario envia el mensaje
                                     del error presentado por la BD.
'* Creado por        : Alfredo Yi
'* Fec Creación      : 17/04/2018
'* Fec Actualización : 17/04/2018
'****************************************************************/
procedure sgass_matriz_decos(po_cantidad out number,
                             po_matriz out sys_refcursor,
                             po_mensaje out varchar2,
                             po_cod_error out number,
                             po_msg_error out varchar2)
is

begin

po_cod_error  := 0;
po_mensaje  := 'Exito';


select MAX(CODIGON_AUX)
into po_cantidad
from operacion.OPEDD D
WHERE D.ABREVIACION ='MATRIZ_DECOS_LTE';

open po_matriz for
select D.DESCRIPCION AS MODELO,D.CODIGON AS PESO
from operacion.OPEDD D, operacion.TIPOPEDD C
WHERE C.TIPOPEDD=D.TIPOPEDD AND D.ABREVIACION ='MATRIZ_DECOS_LTE';

exception
  when others then
    po_mensaje:='ERROR';
    po_cod_error := -99;
    po_msg_error := 'Codigo Error: ' || to_char(sqlcode) || chr(13) ||
                   'Mensaje Error: ' || to_char(sqlerrm) || chr(13) ||
                   'Linea Error: ' || dbms_utility.format_error_backtrace;

end;
  /******************************************************************
'* Nombre SP : SGASS_LISTA_DECOS_DESINS
'* Proposito : LISTAR DECOS QUE SE PUEDEN DESINSTALAR DESDE PW
'* Input : <PI_CODSOLOT> - CODIGO DE SOT
'* Output : <PO_LISTA> - LISTA DE DECOS A DESINSTALAR
'* Creado por : MARLENY TEQUE
'* Fec Creacion : 19/07/2018
'* Fec Actualizacion :
'*****************************************************************/
  procedure SGASS_LISTA_DECOS_DESINS(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                     PO_LISTA       OUT SYS_REFCURSOR) IS
  begin

    open po_lista for
     select equ_conax.grupo codigo,
           t.descripcion,
           se.numserie,
           se.mac,
           0 sel,
           i.codinssrv,
           se.codsolot,
           se.punto,
           se.orden,
           a.cod_sap,
           se.tipequ,
           se.estado,
           spd.asoc,
           decode(se.estado, 4, 'Instalado', 12, 'Desinstalado') estado_eq,
           NVL((select trxc_estado
              from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
               and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),LAG((select trxc_estado
              from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
               and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),1,'') OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) estado_contego,
           NVL((select trxn_action_id action
              from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
               and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),LAG((select trxn_action_id action
              from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
               and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),1,'') OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) action_contego,
            0 check_deco,
            NVL((SELECT decode((select distinct trxn_action_id
                   from operacion.sgat_trxcontego
                   where trxn_codsolot = se.codsolot
                     and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),
                   103,'ACTIVACION ',105,'DESACTIVACION ') ||
                   decode((select distinct trxc_estado
                    from operacion.sgat_trxcontego
                    where trxn_codsolot = se.codsolot
                    and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),
                    1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') FROM DUAL),LAG((SELECT decode((select distinct trxn_action_id
                   from operacion.sgat_trxcontego
                   where trxn_codsolot = se.codsolot
                     and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),
                   103,'ACTIVACION ',105,'DESACTIVACION ') ||
                   decode((select distinct trxc_estado
                    from operacion.sgat_trxcontego
                    where trxn_codsolot = se.codsolot
                    and trxv_serie_tarjeta = spd.num_serie and trxn_action_id = 105),
                    1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') FROM DUAL),1,'')OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) descrip_est_cntg,
           se.cantidad,
           0 grupo
      from solotptoequ se,
           solot s,
           solotpto sp,
           inssrv i,
           tipequ t,
           almtabmat a,
           (select a.codigon tipequ, to_number(codigoc) grupo
              from opedd a, tipopedd b
             where a.tipopedd = b.tipopedd
               and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax,
           sales.sisact_postventa_det_serv_lte spd
     where se.codsolot = s.codsolot
       and s.codsolot = sp.codsolot
       and se.codsolot = spd.codsolot
       and spd.num_serie = se.numserie
       and se.punto = sp.punto
       and sp.codinssrv = i.codinssrv
       and t.tipequ = se.tipequ
       and a.codmat = t.codtipequ
       and se.codsolot = PI_CODSOLOT
       and t.tipequ = equ_conax.tipequ
     order by spd.asoc, equ_conax.grupo asc;
  end;

  PROCEDURE SGASU_BAJA_DECO_CONTEGO(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                    PI_SERIE_TARJ IN OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE,
                                    PO_RESPUESTA   IN OUT VARCHAR2,
                                    PO_MENSAJE     IN OUT VARCHAR2) IS

    V_RESP     VARCHAR2(10);
    V_MSJ      VARCHAR2(1000);
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = PI_CODSOLOT
         AND S.TRXV_SERIE_TARJETA= PI_SERIE_TARJ
         AND S.TRXN_ACTION_ID = C_ACTION_BAJA
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = PI_CODSOLOT
         AND H.TRXV_TIPO = C_ACTION_BAJA
         AND H.TRXV_SERIE_TARJETA= PI_SERIE_TARJ
       ORDER BY 2 DESC;
  BEGIN
    PO_RESPUESTA := 'OK';
    PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
        IF OPERACION.PKG_CONTEGO.SGAFUN_VALIDA_SOT(C_SOT.TRXN_CODSOLOT) = -1 THEN
          PO_RESPUESTA := 'ERROR';
          PO_MENSAJE   := 'ERROR: OCURRIO UN ERROR EL TRATAR DE ACTUALIZAR TABLA TRANSACCIONAL/HISTORICA';
          RAISE EX_ERROR;
        END IF;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) AND
            C_SOT_REEMPLAZO%ROWCOUNT = 1 THEN
        PO_RESPUESTA := 'OK';
        PO_MENSAJE   := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) AND
            C_SOT_REEMPLAZO%ROWCOUNT = 1 THEN
        PO_RESPUESTA := 'PENDIENTE';
        PO_MENSAJE   := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: SE ENCONTRO ERRORES AL REALIZAR LA PROVISION EN CONTEGO.';
        RAISE EX_ERROR;
      END IF;

    END LOOP;

    SGASU_DESACTIVARBOUQUET_CTG(PI_CODSOLOT, PI_SERIE_TARJ, V_RESP, V_MSJ);

    IF V_RESP = 'ERROR' THEN
      PO_RESPUESTA := V_RESP;
      PO_MENSAJE   := V_MSJ;
      RAISE EX_ERROR;
    END IF;

  EXCEPTION
    WHEN EX_ERROR THEN
         OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASU_BAJA_DECO_CONTEGO','',PI_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
    WHEN OTHERS THEN
      PO_MENSAJE := 'sds';
  END;
  PROCEDURE SGASU_DESACTIVARBOUQUET_CTG(PI_CODSOLOT   IN SOLOT.CODSOLOT%TYPE,
                                    PI_SERIE_TARJ IN OPERACION.TABEQUIPO_MATERIAL.NUMERO_SERIE%TYPE,
                                    PO_RESPUESTA   IN OUT VARCHAR2,
                                    PO_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_BOUQUET OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_COD_ID  NUMBER;
    V_CUSTOMER_ID  NUMBER;
    EX_ERROR EXCEPTION;

  BEGIN
    PO_RESPUESTA := 'OK';
    PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    BEGIN
        select s.cod_id, s.customer_id
        into V_COD_ID,V_CUSTOMER_ID
        from solot s where s.codsolot = PI_CODSOLOT;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA CODIGO DE CONTRATO PARA LA SOT: ' || PI_CODSOLOT;
        RAISE EX_ERROR;
    END;

	V_BOUQUET := SGAFUN_OBT_BOUQUET_ACT(V_COD_ID);  --16.0


      V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
      V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','BAJA-CONTEGO','N');
      V_CONTEGO.TRXV_SERIE_TARJETA := PI_SERIE_TARJ;
      V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
      V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','BAJA-CONTEGO','AU');

      OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);

      IF PO_RESPUESTA = 'ERROR' THEN
        PO_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
        RAISE EX_ERROR;
      END IF;
  EXCEPTION
    WHEN EX_ERROR then
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASU_DESACTIVARBOUQUET_CTG',NULL,PI_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE DESACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASU_DESACTIVARBOUQUET_CTG',NULL,PI_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
  END;

  PROCEDURE SGASU_BAJA_SOLOTPTOEQU(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                   PI_ACCION     IN CHAR,
                                   PI_ASOC       IN sales.sisact_postventa_det_serv_lte.asoc%type,
                                   PI_ID_ACT     IN NUMBER,
                                   PO_RESULTADO  OUT NUMBER,
                                   PO_MENSAJE    OUT VARCHAR2) IS
  V_ESTADO NUMBER := 0;
  BEGIN

   PO_RESULTADO := 0;
   PO_MENSAJE   := 'Exito';

   IF PI_ID_ACT = C_ACTION_BAJA THEN
      V_ESTADO :=  C_BAJA_EQU;
   ELSE
      V_ESTADO :=  C_ALTA_EQU;
   END IF;

   UPDATE OPERACION.SOLOTPTOEQU
   SET ESTADO = V_ESTADO
   WHERE CODSOLOT = PI_CODSOLOT AND NUMSERIE IN
   (SELECT NUM_SERIE FROM  SALES.SISACT_POSTVENTA_DET_SERV_LTE LTE
          WHERE LTE.CODSOLOT = PI_CODSOLOT AND LTE.FLAG_ACCION = PI_ACCION AND LTE.ASOC = PI_ASOC);

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := $$PLSQL_UNIT ||
                      '.SGASU_BAJA_SOLOTPTOEQU: No se pudo dar de baja a equipos en solotptoequ. ' ||
                      SQLERRM || '.' || ' - Linea ('||dbms_utility.format_error_backtrace ||')';  --17.0
	OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(PI_CODSOLOT, 'SGASU_BAJA_SOLOTPTOEQU', PO_MENSAJE, '', PO_RESULTADO, PO_MENSAJE);  --17.0

  END;
  FUNCTION SGAFUN_OBT_BOUQUET(PI_COD_ID         NUMBER,
                              PI_CUSTOMER_ID    NUMBER) RETURN VARCHAR2 IS

    LN_COUNTER    NUMBER;
    LN_BOUQUET    VARCHAR2(500) := NULL;
    V_LARGO       NUMBER;
    V_NUMBOUQUETS NUMBER;
    V_CANAL       VARCHAR2(4000);
    FLG_CNR       NUMBER;
    V_NUMSLC      VARCHAR2(10);
    V_NUMREGISTRO VARCHAR2(10);



    CURSOR C_CODIGOS_EXT_VENTAS IS
      SELECT TRIM(PQ_OPE_BOUQUET.F_CONCA_BOUQUET_C(R.IDGRUPO)) CODIGO_EXT,
             R.IDGRUPO,
             PQ_VTA_PAQUETE_RECARGA.F_GET_PID((select NUMREGISTRO
                                                from operacion.ope_srv_recarga_cab
                                               where codsolot =
                                                     (select CODSOLOT
                                                        from SOLOT
                                                       WHERE TIPTRA =
                                                             (select codigon
                                                                from opedd
                                                               where abreviacion =
                                                                     'SISACT_WLL')
                                                         AND cod_id =
                                                             PI_COD_ID
                                                         and customer_id =
                                                             PI_CUSTOMER_ID)),
                                              V.IDDET) PID,
             T.CODSRV,
             DECODE(V.FLGSRV_PRI, 1, 'PRINCIPAL', 'ADICIONAL') CLASE,
             V.IDDET
        FROM VTADETPTOENL V, TYSTABSRV T, TYS_TABSRVXBOUQUET_REL R
       WHERE V.NUMSLC = V_NUMSLC
         AND V.CODSRV = T.CODSRV
         AND T.CODSRV = R.CODSRV
         AND R.ESTBOU = 1
         AND R.STSRVB = 1
      UNION ALL
      SELECT DISTINCT B.DESCRIPCION,
                      GB.IDGRUPO,
                      NULL PID,
                      PV.CODSRV,
                      'PROMOCION' CLASE,
                      NULL IDDET
        FROM FAC_PROM_DETALLE_VENTA_MAE PV,
             OPE_GRUPO_BOUQUET_DET      GB,
             OPE_BOUQUET_MAE            B
       WHERE PV.NUMSLC = V_NUMSLC
         AND PV.IDGRUPO = GB.IDGRUPO
         AND GB.CODBOUQUET = B.CODBOUQUET
         AND GB.FLG_ACTIVO = 1
         AND B.FLG_ACTIVO = 1
         AND B.DESCRIPCION IS NOT NULL;

  BEGIN
    LN_COUNTER := 0;

        select NUMSLC
      INTO V_NUMSLC
      from SOLOT
     WHERE TIPTRA =
           (select codigon from opedd where abreviacion = 'SISACT_WLL')
       AND cod_id = PI_COD_ID
       and customer_id = PI_CUSTOMER_ID;

     select NUMREGISTRO
     into V_NUMREGISTRO
     from operacion.ope_srv_recarga_cab
     where codsolot =
         (select CODSOLOT
            from SOLOT
           WHERE TIPTRA =
                 (select codigon
                    from opedd
                   where abreviacion =
                         'SISACT_WLL')
             AND cod_id =
                 PI_COD_ID
             and customer_id =
                 PI_CUSTOMER_ID);

      FOR C_COD_EXT_V IN C_CODIGOS_EXT_VENTAS LOOP
        IF LN_COUNTER = 0 THEN
          LN_BOUQUET := TRIM(C_COD_EXT_V.CODIGO_EXT);
        ELSE
          LN_BOUQUET := LN_BOUQUET || ',' || TRIM(C_COD_EXT_V.CODIGO_EXT);
        END IF;
        LN_COUNTER := LN_COUNTER + 1;
        V_LARGO       := LENGTH(LN_BOUQUET);
        V_NUMBOUQUETS := (V_LARGO + 1) / 4;
        FOR I IN 1 .. V_NUMBOUQUETS LOOP
          V_CANAL := LPAD(OPERACION.F_CB_SUBCADENA2(trim(LN_BOUQUET), I),8,'0');
        END LOOP;

        IF C_COD_EXT_V.CLASE = 'PRINCIPAL' THEN
          FLG_CNR := 1;
        ELSIF C_COD_EXT_V.CLASE = 'ADICIONAL' THEN
          FLG_CNR := PQ_VTA_PAQUETE_RECARGA.F_IS_CNR(V_NUMSLC,C_COD_EXT_V.IDDET);
          IF PQ_VTA_PAQUETE_RECARGA.F_IS_CNR(V_NUMSLC, C_COD_EXT_V.IDDET) = 1 THEN
            FLG_CNR := 3;
          ELSE
            FLG_CNR := 0;
          END IF;
        END IF;
      END LOOP;

    RETURN LN_BOUQUET;
  EXCEPTION
    WHEN OTHERS THEN
	  OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(PI_COD_ID, 'SGAFUN_OBT_BOUQUET', 'ERROR AL OBTENER BOUQUET EN DECO ADICIONAL', 
		'V_NUMSLC: ' || V_NUMSLC || '- V_NUMREGISTRO: ' || V_NUMREGISTRO, LN_COUNTER, V_CANAL);  --17.0
      RETURN NULL;
  END;
  --<Fin 9.0>
  --<Ini 10.0>
 /******************************************************************
'* Nombre SP : SGASS_LISTA_EQUIPO_CONAX_LTE
'* Propósito : LISTAR DECOS QUE SE VAN A INSTALAR DESDE PW
'* Input : <PI_CODSOLOT> - CODIGO DE SOT
'* Output : <PO_LISTA> - LISTA DE DECOS NUEVOS
'* Creado por : ABEL OJEDA
'* Fec Creación : 30/07/2018
'* Fec Actualización :
'*****************************************************************/
  procedure SGASS_LISTA_EQUIPO_CONAX_LTE(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                         PO_LISTA       OUT SYS_REFCURSOR) IS
  begin

    open po_lista for
       select equ_conax.grupo codigo,t.descripcion, se.numserie, se.mac, se.cantidad, 0 sel, i.codinssrv, se.codsolot,
       se.punto, se.orden, a.cod_sap, se.tipequ,
       case when nvl(trim(se.numserie),'0') <> '0'
            then (select distinct tipo from operacion.tabequipo_material where numero_serie = se.numserie)
       else
          0
       end tipo, 0 grupo, se.estado, se.iddet,
       decode(se.estado, 4, 'Instalado', 12, 'Desinstalado') estado_eq,
       NVL((select trxc_estado from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
             and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),
         LAG((select trxc_estado from operacion.sgat_trxcontego
              where trxn_codsolot = se.codsolot
              and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),1,'')
        OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) estado_contego,
        NVL((select trxn_action_id action from operacion.sgat_trxcontego
             where trxn_codsolot = se.codsolot
             and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103 ),
         LAG((select trxn_action_id action from operacion.sgat_trxcontego
              where trxn_codsolot = se.codsolot
              and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),1,'')
        OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) action_contego,
        NVL((SELECT decode((select distinct trxn_action_id from operacion.sgat_trxcontego
                            where trxn_codsolot = se.codsolot
                            and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),
             103,'ACTIVACION ',105,'DESACTIVACION ') ||
             decode((select distinct trxc_estado from operacion.sgat_trxcontego
                     where trxn_codsolot = se.codsolot
                     and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),
                    1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') FROM DUAL),
         LAG((SELECT decode((select distinct trxn_action_id from operacion.sgat_trxcontego
                             where trxn_codsolot = se.codsolot
                             and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),
             103,'ACTIVACION ',105,'DESACTIVACION ') ||
             decode((select distinct trxc_estado from operacion.sgat_trxcontego
                     where trxn_codsolot = se.codsolot
                     and (trxv_serie_tarjeta = spd.num_serie or trxv_serie_tarjeta = se.numserie) and trxn_action_id = 103),
                    1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') FROM DUAL),1,'')
         OVER (PARTITION BY spd.asoc ORDER BY equ_conax.grupo)) descrip_est_cntg,
       nvl(spd.flag_accion,'A') flag_accion
      from   solotptoequ se, solot s, solotpto sp, inssrv i, tipequ t, almtabmat a,
        (select a.codigon tipequ,to_number(codigoc) grupo
         from opedd a,tipopedd b
         where a.tipopedd = b.tipopedd
         and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax,
         sales.sisact_postventa_det_serv_lte spd
       where  se.codsolot  = s.codsolot
        and    s.codsolot   = sp.codsolot
        and    se.codsolot = spd.codsolot(+)
        and    se.numserie = spd.num_serie(+)
        and    se.punto     = sp.punto
        and    sp.codinssrv = i.codinssrv
        and    t.tipequ     = se.tipequ
        and    a.codmat     = t.codtipequ
       and    se.codsolot  = PI_CODSOLOT
       and    t.tipequ = equ_conax.tipequ;

    end;

 /******************************************************************
'* Nombre SP : SGASS_LISTA_TARJETA_DECO_ASOC
'* Proposito : LISTAR LAS ASOCIACIONES POR CÓDIGO DE SOT PARA PW
'* Input : <PI_CODSOLOT> - CODIGO DE SOT
'* Output : <PO_LISTA> - LISTA DATOS DE OPERACION.TARJETA_DECO_ASOC
'* Creado por : ABEL OJEDA
'* Fec Creacion : 30/07/2018
'* Fec Actualizacion :
'*****************************************************************/
  procedure SGASS_LISTA_TARJETA_DECO_ASOC(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                         PO_LISTA       OUT SYS_REFCURSOR) IS
  begin

    open po_lista for
         select '0' flg_asoc,
         t.nro_serie_tarjeta,
         t.nro_serie_deco,
         t.codsolot,
         t.id_asoc,
         '1' asociado,
         '1' instalado,
         md.numero_serie serie_deco,
         md.tipo tipo_deco,
         mt.numero_serie serie_tarjeta,
         mt.tipo tipo_tarjeta,
         0 grupo,
         0 codinssrv,
         '0' flg_tipo_proceso,
         t.iddet_deco,
         t.iddet_tarjeta,
         '' mac,
         '' mensaje
         from operacion.tarjeta_deco_asoc t
         left join operacion.tabequipo_material md
         on (t.nro_serie_deco = md.numero_serie and md.tipo = 2)
         left join operacion.tabequipo_material mt
         on (t.nro_serie_tarjeta = mt.numero_serie and mt.tipo = 1)
         where t.codsolot = PI_CODSOLOT;
    end;

/******************************************************************
'* Nombre SP : SGASU_VALIDACION_MIXTO
'* Proposito : Validar la correcta instalacion/desinstalacion de decos
'* Input     : <PI_IDTAREAWF> - <PI_IDWF> - <PI_TAREA> - <PI_TAREADEF>
'* Output    :
'* Creado por : Marleny Teque
'* Fec Creacion : 01/08/2018
'* Fec Actualizacion :
'*****************************************************************/
    PROCEDURE SGASU_VALIDACION_MIXTO(PI_IDTAREAWF IN NUMBER,
                                     PI_IDWF      IN NUMBER,
                                     PI_TAREA     IN NUMBER,
                                     PI_TAREADEF  IN NUMBER) IS
    V_CODSOLOT OPEWF.WF.CODSOLOT%TYPE;
    V_DESC_ERROR    VARCHAR2(500);
    V_COD_RPTA      NUMBER;
    EX_ERROR        EXCEPTION;
    V_DESC_ERROR_LOG VARCHAR2(500); --19.0
  BEGIN
    --CONSULTA DE SOT
    BEGIN
      SELECT W.CODSOLOT
        INTO V_CODSOLOT
        FROM OPEWF.WF W
       WHERE W.IDWF = PI_IDWF
         AND W.VALIDO = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20500,
                                'ERROR AL OBTENER CODIGO DE SOT: ' ||
                                sqlerrm);
    END;

    --VALIDANDO INSTALACION DE DECO
    SGASU_VALIDA_INST_DECO(V_CODSOLOT,V_COD_RPTA, V_DESC_ERROR);

    IF V_COD_RPTA <> 0 THEN
      RAISE EX_ERROR;
    END IF;

    --VALIDANDO DESINSTALACION DE DECO
    SGASU_VALIDA_DES_DECO(PI_IDTAREAWF, PI_IDWF, PI_TAREA, PI_TAREADEF );
	
	-- ini 20.0
    begin
      operacion.pq_siac_cambio_plan_lte.sgai_carga_equipo_post(V_CODSOLOT, V_COD_RPTA, V_DESC_ERROR);
    exception
      when others then
        null;
    end;
    -- fin 20.0
	
  EXCEPTION
    WHEN EX_ERROR THEN
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT, 'SGASU_VALIDACION_MIXTO', V_DESC_ERROR, 'EX_ERROR', V_COD_RPTA, V_DESC_ERROR_LOG); --17.0
      RAISE_APPLICATION_ERROR(-20001,
                              'ERROR EN LA VALIDACION INSTALACION/DESINSTALACION DE DECO: ' || V_DESC_ERROR);
    WHEN OTHERS THEN
      V_DESC_ERROR := TO_CHAR(SQLERRM); --19.0
      OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(V_CODSOLOT, 'SGASU_VALIDACION_MIXTO', V_DESC_ERROR, 'OTHERS', V_COD_RPTA, V_DESC_ERROR_LOG); --17.0
      RAISE_APPLICATION_ERROR(-20001,
                              'ERROR EN LA VALIDACION INSTALACION/DESINSTALACION DE DECO: ' || SQLERRM);
  END;
/******************************************************************
'* Nombre SP : SGASI_INSERT_TARJ_DECO_ASOC
'* Propósito : INSERTAR REGISTRO EN TARJETA_DECO_ASOC DESDE PW
'* Input     : <PI_CODSOLOT> - CODIGO DE SOT, <PI_IDDECO> - IDDET DECO,
               <PI_MAC> - MAC DEL DECO, <PI_IDTARJETA> - IDDET TARJETA,
               <PI_NUMSERIE> - SERIE DEL EQUIPO
'* Creado por : ABEL OJEDA
'* Fec Creación : 01/08/2018
'* Fec Actualización :
'*****************************************************************/
  procedure SGASI_INSERT_TARJ_DECO_ASOC (PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                             PI_IDDECO      IN NUMBER,
                                             PI_MAC         IN VARCHAR2,
                                             PI_IDTARJETA   IN NUMBER,
                                             PI_NUMSERIE    IN VARCHAR2) IS
  begin

     INSERT INTO operacion.tarjeta_deco_asoc t (t.CODSOLOT, t.IDDET_DECO,
       t.NRO_SERIE_DECO, t.IDDET_TARJETA, t.NRO_SERIE_TARJETA)
       VALUES (PI_CODSOLOT, PI_IDDECO, PI_MAC, PI_IDTARJETA, PI_NUMSERIE) ;

  end;

/******************************************************************
'* Nombre SP : SGASU_SERIE_SOLOTPTOEQU
'* Propósito : ACTUALIZAR SERIE Y MAC EN LA TABLA SOLOTPTOEQU DESDE PW
'* Input     : <PI_CODSOLOT> - CÓDIGO DE SOT,
               <PI_PUNTO> - PUNTO DE LA SOLICITUD DE OT,
               <PI_ORDEN> - ORDEN DEL EQUIPO EN EL PUNTO,
               <PI_NUMSERIE> - SERIE DEL EQUIPO,
               <PI_MAC> - MAC DEL DECO
'* Creado por : ABEL OJEDA
'* Fec Creación : 02/08/2018
'* Fec Actualización :
'*****************************************************************/
  procedure SGASU_SERIE_SOLOTPTOEQU (PI_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                     PI_PUNTO    IN NUMBER,
                                     PI_ORDEN    IN NUMBER,
                                     PI_NUMSERIE IN VARCHAR2,
                                     PI_MAC      IN VARCHAR2) IS
  begin

     UPDATE operacion.solotptoequ
     SET numserie = PI_NUMSERIE, mac = PI_MAC
       WHERE codsolot = PI_CODSOLOT and punto = PI_PUNTO and orden = PI_ORDEN;

  end;

 /******************************************************************
'* Nombre SP : SGASU_VALIDA_INST_DECO
'* Propósito : VALIDAR INSTALACION DE DECO ADICIONAL LTE
'* Input     : <PI_CODSOLOT> - CÓDIGO DE SOT
'* Creado por : MARLENY TEQUE
'* Fec Creación : 03/08/2018
'* Fec Actualización :
'*****************************************************************/

  PROCEDURE SGASU_VALIDA_INST_DECO(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                   PO_RESULTADO  OUT NUMBER,
                                   PO_MENSAJE    OUT VARCHAR2) IS

  V_CO_ID operacion.solot.cod_id%TYPE;
  V_CUSTOMERID operacion.solot.customer_id%TYPE;
  V_IDINTERACCION SALES.SISACT_POSTVENTA_DET_SERV_LTE.IDINTERACCION%type;
  V_RESP             NUMERIC := 0;
  V_MENSAJE          VARCHAR2(3000);
  V_ESTSOL           SOLOT.ESTSOL%TYPE;
  V_CARGO_INST       NUMBER;
  V_CONT_ALTA        NUMBER := 0;
  V_CONT_ALTAD       NUMBER := 0;
  V_TIPSRV           VARCHAR2(100);
  EX_ERROR EXCEPTION;

  CURSOR c_equ_bscs IS
      SELECT a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        FROM (SELECT DISTINCT asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (SELECT DISTINCT nvl(crm.abreviacion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (SELECT DISTINCT nvl(crm.descripcion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) modelo_equipo
                FROM operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               WHERE asoc.codsolot = se.codsolot
                 AND se.mac = asoc.nro_serie_deco
                 AND se.tipequ = to_number(tieq.tipequ)
                 AND (se.tipequ) IN
                     (SELECT crm.codigon
                        FROM sales.crmdd crm
                       WHERE crm.tipcrmdd IN
                             (SELECT tip.tipcrmdd
                                FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
                 AND asoc.codsolot = PI_CODSOLOT) a;

  CURSOR c_solotpequ IS
  select s.numserie
    from solotptoequ s
   where s.codsolot = PI_CODSOLOT
     and s.numserie not in (select lte.num_serie
                              from sales.sisact_postventa_det_serv_lte lte
                             where lte.idinteraccion = V_IDINTERACCION
                               and lte.flag_accion = C_BAJA);

  BEGIN
    PO_RESULTADO := 0;
    PO_MENSAJE := 'OK';				   

  SELECT A.COD_ID, A.CUSTOMER_ID, A.ESTSOL, A.CARGO
    INTO V_CO_ID, V_CUSTOMERID, V_ESTSOL, V_CARGO_INST
    FROM OPERACION.SOLOT A
   WHERE A.CODSOLOT = PI_CODSOLOT;

  --TOMANDO IDINTERACCION
  BEGIN
    select DISTINCT SPP.IDINTERACCION
      INTO V_IDINTERACCION
      from OPERACION.SIAC_POSTVENTA_PROCESO SPP
     WHERE SPP.CODSOLOT = PI_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  PO_RESULTADO := -1;
      PO_MENSAJE   := 'ERROR: Error al obtener idinteraccion de la tabla OPERACION.SIAC_POSTVENTA_PROCESO';
      RAISE EX_ERROR;
  END;

    --CANTIDAD DE DECOS A DAR DE ALTA EN LA TABLA DETALLE
    select count(*)
      into V_CONT_ALTAD
      from SALES.SISACT_POSTVENTA_DET_SERV_LTE SPD
     where SPD.IDINTERACCION = V_IDINTERACCION
       AND SPD.CODSOLOT = PI_CODSOLOT
       AND SPD.TIPEQU = C_TIPEQU_TARJ
       AND SPD.FLAG_ACCION = C_ALTA;

    --CANTIDAD DE DECOS PROVISIONADOS - ALTA
    SELECT COUNT(*)
      INTO V_CONT_ALTA
      FROM (SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO, S.TRXN_ACTION_ID,S.TRXV_SERIE_TARJETA
              FROM OPERACION.SGAT_TRXCONTEGO S
             WHERE S.TRXN_CODSOLOT = PI_CODSOLOT
             AND S.TRXC_ESTADO = C_PROV_OK
             AND S.TRXN_ACTION_ID IN (C_ACTION_ACTIVACION)
            union all
            SELECT DISTINCT SH.TRXN_CODSOLOT, SH.TRXC_ESTADO, SH.TRXN_ACTION_ID, SH.TRXV_SERIE_TARJETA
              FROM OPERACION.SGAT_TRXCONTEGO_HIST SH
             WHERE SH.TRXN_CODSOLOT = PI_CODSOLOT
             AND SH.TRXC_ESTADO = C_PROV_OK
             AND SH.TRXN_ACTION_ID IN (C_ACTION_ACTIVACION)) C;

    SELECT VALOR INTO V_TIPSRV FROM CONSTANTE WHERE CONSTANTE = 'FAM_CABLE';

    ---Verficamos que los equipos esten provisionados en contego
    IF V_CONT_ALTAD = V_CONT_ALTA THEN
          -- Insertar Equipos a BSCS
          FOR c1 IN c_equ_bscs LOOP
            OPERACION.PQ_3PLAY_INALAMBRICO.p_registra_deco_lte(V_CO_ID,
                                c1.nro_serie_deco,
                                c1.nro_serie_tarjeta,
                                c1.tipo_equipo,
                                c1.modelo_equipo,
                                V_RESP,
                                V_MENSAJE);

            IF V_RESP <> 0 THEN
              PO_RESULTADO := V_RESP;
              PO_MENSAJE := V_MENSAJE;
              OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASU_VALIDA_INST_DECO', PO_MENSAJE, 'EX_ERROR', PO_RESULTADO, PO_MENSAJE);
              raise_application_error(-20500,
                                      'tim.pp021_venta_lte.sp_registra_deco_lte: ' ||
                                      V_MENSAJE);
            END IF;
          END LOOP;

      -- Actualizar Los numeros de Serie de los Equipos
      FOR c2 IN c_solotpequ LOOP
        UPDATE operacion.tabequipo_material tm
           SET estado = 1
         WHERE TRIM(tm.numero_serie) = TRIM(c2.numserie);
      END LOOP;

      --14.0 Ini
      SGASU_ACTUALIZAR_PID(PI_CODSOLOT, 1, 1, V_RESP, V_MENSAJE);
      IF V_RESP <> 0 THEN
            PO_RESULTADO := V_RESP;
            PO_MENSAJE := V_MENSAJE;					
            RAISE EX_ERROR;
      END IF;

      SGASI_REGISTRAR_CARGO_REC_DECO(PI_CODSOLOT, V_RESP, V_MENSAJE);
      IF V_RESP <> 0 THEN
            PO_RESULTADO := V_RESP;
            PO_MENSAJE := V_MENSAJE;					
            RAISE EX_ERROR;
      END IF;
      --14.0 Fin

   ELSE
       V_RESP    := -1;
       V_MENSAJE := 'PROCESO DE PROVISION DE INSTALACION DE DECO NO SE HA CONCLUIDO CORRECTAMENTE';

   END IF;

   PO_RESULTADO := V_RESP;
   PO_MENSAJE   := V_MENSAJE;

  EXCEPTION
    WHEN EX_ERROR THEN
	  OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASU_VALIDA_INST_DECO', PO_MENSAJE, 'EX_ERROR', PO_RESULTADO, PO_MENSAJE); --17.0
      raise_application_error(-20500, $$plsql_unit || ' ' || PO_MENSAJE || sqlerrm);  --17.0

    WHEN OTHERS THEN
	  OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASU_VALIDA_INST_DECO', PO_MENSAJE, 'OTHERS', PO_RESULTADO, PO_MENSAJE); --17.0
      raise_application_error(-20500, 'ERROR AL VALIDAR INSTALACION DE DECOS. ' || sqlerrm);  --17.0

  END;

  PROCEDURE SGASI_ALTA_MIXTO(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                             PO_RESPUESTA   IN OUT VARCHAR2,
                             PO_MENSAJE     IN OUT VARCHAR2) IS

    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    V_REG_DECO NUMBER;
    V_RESP     VARCHAR2(10);
    V_MSJ      VARCHAR2(1000);
    V_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE := ''; --14.0
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = V_CODSOLOT
         AND H.TRXN_ACTION_ID IN (C_ACTION_ALTA, C_ACTION_ACTIVACION)
       ORDER BY 2 DESC;

  BEGIN
    PO_RESPUESTA := 'OK';
    PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    -- BLOQUE CONSULTAS
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = PI_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
          PO_RESPUESTA := 'PENDIENTE';
          PO_MENSAJE   := 'PENDIENTE: EN ESPERA DE ENVIO A CONTEGO.';
          RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) THEN
        PO_RESPUESTA := 'OK';
        PO_MENSAJE   := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) THEN
        PO_RESPUESTA := 'PENDIENTE';
        PO_MENSAJE   := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        DELETE OPERACION.SGAT_TRXCONTEGO S WHERE s.trxn_codsolot = V_CODSOLOT;
        EXIT;
      END IF;
    END LOOP;

    SELECT COUNT(*)
      INTO V_REG_DECO
      FROM OPERACION.TARJETA_DECO_ASOC T
     WHERE CODSOLOT = V_CODSOLOT;

    IF V_REG_DECO = 0 THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ASOCIO TARJETA CON DECODIFICADOR';
      RAISE EX_ERROR;
    END IF;

    SGASI_ACTIVARBOUQUET(PI_NUMREGISTRO, V_CODSOLOT, V_NUMSERIE, V_RESP, V_MSJ);  --14.0

    IF V_RESP = 'ERROR' THEN
      PO_RESPUESTA := V_RESP;
      PO_MENSAJE   := V_MSJ;
      RAISE EX_ERROR;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ALTA_MIXTO',PI_NUMREGISTRO,V_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ALTA_MIXTO',PI_NUMREGISTRO,V_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
  END;

  PROCEDURE SGASI_ACTIVARBOUQUET(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                 PI_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE,
                                 PI_NUMSERIE    OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE DEFAULT NULL, --14.0
                                 PO_RESPUESTA   IN OUT VARCHAR2,
                                 PO_MENSAJE     IN OUT VARCHAR2) IS

    V_CONTEGO     OPERACION.SGAT_TRXCONTEGO%ROWTYPE;
    V_NUMSLC      OPERACION.SOLOT.NUMSLC%TYPE;
    V_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE := PI_NUMREGISTRO;
    V_BOUQUET     OPERACION.SGAT_TRXCONTEGO.TRXV_BOUQUET%TYPE;
    V_CO_ID       OPERACION.SOLOT.COD_ID%TYPE;  --14.0
    EX_ERROR EXCEPTION;

    CURSOR C_TARJETAS(PU_NUMSERIE OPERACION.SOLOTPTOEQU.NUMSERIE%TYPE) IS  --14.0
     --14.0 Ini
     SELECT SE.NUMSERIE,
            SE.MAC,
            SE.CODEQUCOM,
            T.NRO_SERIE_DECO,
            T.NRO_SERIE_TARJETA
       FROM SOLOTPTOEQU SE,
            TIPEQU TE,
            OPERACION.TARJETA_DECO_ASOC T,
            (SELECT A.CODIGON TIPEQU, CODIGOC GRUPO
               FROM OPEDD A, TIPOPEDD B
              WHERE A.TIPOPEDD = B.TIPOPEDD
                AND B.ABREV IN ('TIPEQU_DTH_CONAX')) EQU_CONAX
      WHERE SE.CODSOLOT = PI_CODSOLOT
        AND TE.TIPEQU = SE.TIPEQU
        AND TRIM(EQU_CONAX.GRUPO) = '2'
        AND TE.TIPEQU = EQU_CONAX.TIPEQU
        AND T.CODSOLOT = SE.CODSOLOT
        AND SE.MAC = T.NRO_SERIE_DECO
        AND (T.Nro_Serie_Tarjeta = PU_NUMSERIE or NVL(PU_NUMSERIE,'x') = 'x')
        AND SE.ESTADO = 4;
     --14.0 Fin
  BEGIN
    PO_RESPUESTA := 'OK';
    PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';

    select cod_id into V_CO_ID from solot where codsolot = PI_CODSOLOT;  --14.0

    IF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(PI_CODSOLOT) =
       C_DESACTIVO THEN
      V_NUMSLC := OPERACION.PKG_CONTEGO.SGAFUN_OBT_NUMSLC(V_NUMREGISTRO);
    ELSIF OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_TIPO_DECO(PI_CODSOLOT) =
          C_ACTIVADO THEN
      V_NUMSLC      := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_NUMSLC_ORI(PI_CODSOLOT);
      V_NUMREGISTRO := OPERACION.PQ_DECO_ADICIONAL_LTE.F_OBT_DATA_VTA_ORI(PI_CODSOLOT);
    END IF;
    IF V_NUMSLC IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL NUMERO DE PROYECTO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
      RAISE EX_ERROR;
    END IF;

    V_BOUQUET := SGAFUN_OBT_BOUQUET_ACT(V_CO_ID);  --14.0

    IF V_BOUQUET IS NULL THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA LOS BOUQUETS PARA REALIZAR LA ACTIVACION';
      RAISE EX_ERROR;
    END IF;

    --14.0 Ini
    FOR C_LINE IN C_TARJETAS(PI_NUMSERIE) LOOP

        V_CONTEGO.TRXV_TIPO          := OPERACION.PKG_CONTEGO.SGAFUN_ES_PAREO(C_LINE.NUMSERIE);

        IF V_CONTEGO.TRXV_TIPO = 'PAREO' THEN
           V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','PAREO-CONTEGO','N');
           V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','PAREO-CONTEGO','AU');
        ELSIF V_CONTEGO.TRXV_TIPO = 'DESPAREO' THEN
           V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','DESPAREO-CONTEGO','N');
           V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','DESPAREO-CONTEGO','AU');
        END IF;

        V_CONTEGO.TRXN_CODSOLOT      := PI_CODSOLOT;
        V_CONTEGO.TRXV_BOUQUET       := V_BOUQUET;
        V_CONTEGO.TRXV_SERIE_TARJETA := C_LINE.NRO_SERIE_TARJETA;
        V_CONTEGO.TRXV_SERIE_DECO    := C_LINE.Nro_Serie_Deco;

        -- Registro la Asociación 101
        OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);

        IF PO_RESPUESTA = 'ERROR' THEN
          PO_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE PAREO EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
        -- Registro la Activación 103
        V_CONTEGO.TRXV_TIPO  := NULL;
        V_CONTEGO.TRXN_ACTION_ID     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','ALTA-CONTEGO','N');
        V_CONTEGO.TRXN_PRIORIDAD     := OPERACION.PKG_CONTEGO.SGAFUN_PARAM_CONTEGO('CONF_CONTEGO_ACT','CONF_ACT','ALTA-CONTEGO','AU');

        OPERACION.PKG_CONTEGO.SGASI_REGCONTEGO(V_CONTEGO, PO_RESPUESTA);

        IF PO_RESPUESTA = 'ERROR' THEN
          PO_MENSAJE := 'ERROR: AL GRABAR LAS TRANSACCIONES DE ACTIVACION EN LA TABLA OPERACION.SGAT_TRXCONTEGO.';
          EXIT;
        END IF;
    END LOOP;
    --14.0 Fin

  EXCEPTION
    WHEN EX_ERROR then
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ACTIVARBOUQUET',V_NUMREGISTRO,PI_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: AL GRABAR LAS TRANSACIONES DE ACTIVACION' ||
                     SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ACTIVARBOUQUET',V_NUMREGISTRO,PI_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
  END;

/******************************************************************
'* Nombre SP : SGASS_ESTADO_SOLOT_CONTEGO
'* Proposito : LISTA ESTADO DE LAS TARJETAS EN CONTEGO POR CÓDIGO DE SOT PARA PW
'* Input : <PI_CODSOLOT> - CODIGO DE SOT
'* Input : <PI_NUM_SERIE> - NÚMERO DE SERIE DE LA TARJETA A CONSULTAR
'* Output : <PO_LISTA> - LISTA DE ESTADOS DE OPERACION.SGAT_TRXCONTEGO
'* Creado por : ABEL OJEDA
'* Fec Creacion : 07/08/2018
'* Fec Actualizacion :
'*****************************************************************/
   procedure SGASS_ESTADO_SOLOT_CONTEGO(PI_CODSOLOT    IN SOLOT.CODSOLOT%TYPE,
                                       PI_NUM_SERIE   IN VARCHAR2,
                                       PO_LISTA       OUT SYS_REFCURSOR) IS
  begin
   if PI_NUM_SERIE is null then
    begin
     open po_lista for
          select distinct trxn_action_id, trxc_estado, trxv_serie_tarjeta,
          decode(trxn_action_id, 103,'ACTIVACION ',105,'DESACTIVACION ') accion,
          decode(trxc_estado,1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') estado
          from operacion.sgat_trxcontego
          where trxn_codsolot = PI_CODSOLOT and trxn_action_id in (C_ACTION_ACTIVACION, C_ACTION_BAJA)
          and (trxv_serie_tarjeta = PI_NUM_SERIE OR PI_NUM_SERIE IS NULL)
          and trxc_estado not in (6)
         order by 2 desc;
    end;
   else
    begin
     open po_lista for
          select distinct trxn_action_id, trxc_estado, trxv_serie_tarjeta,
          decode(trxn_action_id, 103,'ACTIVACION ',105,'DESACTIVACION ') accion,
          decode(trxc_estado,1,'EN PROCESO',2,'EN PROCESO',3,'CORRECTA',4,'TIENE ERROR',6,'CANCELADA') estado
          from operacion.sgat_trxcontego
          where trxn_codsolot = PI_CODSOLOT
          and trxn_idtransaccion = (select max(trxn_idtransaccion) from operacion.sgat_trxcontego where trxn_codsolot = PI_CODSOLOT
          and trxn_action_id in (C_ACTION_ACTIVACION, C_ACTION_BAJA) and trxv_serie_tarjeta = PI_NUM_SERIE and trxc_estado not in (6));
    end;
   end if;
  end;

  function SGASI_REGISTRAR_VENTA_MIXTO(PI_IDPROCESS      siac_postventa_proceso.idprocess%type,
                                PI_ID_INTERACCION sales.sisact_postventa_det_serv_lte.idinteraccion%type,
                                PI_COD_ID          sales.sot_sisact.cod_id%type)
    return vtatabslcfac.numslc%type is
    C_DETALLE_VTADETPTOENL detalle_vtadetptoenl_type;
    C_NUMSLC               vtatabslcfac.numslc%type;
    C_TIPTRA               tiptrabajo.tiptra%type;
    C_CODSOL               vtatabslcfac.codsol%type;
    C_OBSSOLFAC            vtatabslcfac.obssolfac%type;
    C_IDLINEA              linea_paquete.idlinea%type;
    C_DETALLE_IDLINEA      detalle_idlinea_type;
    C_SRVPRI               vtatabslcfac.srvpri%type;

    cursor servicios is
     select t.*
       from sales.sisact_postventa_det_serv_lte t
      where t.idinteraccion = PI_ID_INTERACCION
        AND t.dscequ IS NOT NULL
        AND t.flag_accion = C_ALTA;

  begin
    C_DETALLE_VTADETPTOENL := detalle_vtadetptoenl_alta(PI_COD_ID);
    C_TIPTRA               := sales.pq_siac_postventa_lte.SGAFUN_OBTIENE_TIPTRA(PI_IDPROCESS);
    C_CODSOL               := get_parametro_deco('RVCODSOL', 0);
    C_OBSSOLFAC            := get_parametro_deco('OBSSOLFAC', 1);
    C_SRVPRI               := get_parametro_deco('SRVPRI', 1);

    C_NUMSLC := sales.f_get_clave_proyecto();
    insert into vtatabslcfac
      (numslc,
       fecpedsol,
       estsolfac,
       srvpri,
       codcli,
       codsol,
       idsolucion,
       obssolfac,
       tipsrv,
       tipsolef,
       plazo_srv,
       moneda_id,
       tipo,
       fecapr)
    values
      (C_NUMSLC,
       sysdate,
       '03',
       C_SRVPRI,
       C_DETALLE_VTADETPTOENL.codcli,
       C_CODSOL,
       C_DETALLE_VTADETPTOENL.idsolucion,
       C_OBSSOLFAC,
       C_DETALLE_VTADETPTOENL.tipsrv,
       2,
       11,
       1,
       0,
       sysdate);

    operacion.pq_siac_postventa.set_siac_instancia(PI_IDPROCESS,
                                                   'DECO ADICIONAL',
                                                   'PROYECTO DE POSTVENTA',
                                                   C_NUMSLC);

    operacion.pq_siac_postventa.set_int_negocio_instancia(PI_IDPROCESS,
                                                          'PROYECTO DE VENTA',
                                                          C_NUMSLC);

    crear_srv_instalacion(C_NUMSLC, C_DETALLE_VTADETPTOENL);

    for servicio in servicios loop
      if es_servicio_adicional_lte(servicio.idgrupo) then
        C_IDLINEA := ubicar_idlinea_servicio_lte(servicio.servicio);
      elsif es_servicio_comodato_lte(servicio.idgrupo, servicio.idgrupo_principal) or
            es_servicio_alquiler_lte(servicio.idgrupo, servicio.idgrupo_principal) then
        C_IDLINEA := SGAFUN_ubicar_idlinea_equipo(servicio.tipequ, servicio.idgrupo);
      end if;

      C_DETALLE_IDLINEA := detalle_idlinea_lte(C_IDLINEA);

      insert into vtadetptoenl
        (numslc,
         descpto,
         dirpto,
         ubipto,
         crepto,
         codsrv,
         codsuc,
         estcts,
         estcse,
         tiptra,
         idprecio,
         cantidad,
         codinssrv,
         paquete,
         codequcom,
         idproducto,
         plazo_instalacion,
         grupo,
         tipo_vta,
         moneda_id,
         idpaq,
         iddet,
         idplataforma)
      values
        (C_NUMSLC,
         C_DETALLE_VTADETPTOENL.descpto,
         C_DETALLE_VTADETPTOENL.dirpto,
         C_DETALLE_VTADETPTOENL.ubipto,
         1,
         C_DETALLE_IDLINEA.codsrv,
         C_DETALLE_VTADETPTOENL.codsuc,
         C_DETALLE_VTADETPTOENL.estcts,
         1,
         C_TIPTRA,
         C_DETALLE_IDLINEA.idprecio,
         servicio.cantidad,
         C_DETALLE_VTADETPTOENL.codinssrv,
         1,
         C_DETALLE_IDLINEA.codequcom,
         C_DETALLE_IDLINEA.idproducto,
         7,
         1,
         6,
         1,
         C_DETALLE_IDLINEA.idpaq,
         C_DETALLE_IDLINEA.iddet,
         7);
    end loop;

    update vtadetptoenl t
       set t.numpto_prin = t.numpto
     where t.numslc = C_NUMSLC;

    return C_NUMSLC;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.SGAFUN_REGISTRAR_VENTA(PI_IDPROCESS => ' || PI_IDPROCESS ||
                              ', PI_ID_INTERACCION => ' || PI_ID_INTERACCION ||
                              ', PI_COD_ID => ' || PI_COD_ID || ') ' || sqlerrm);
  end;

  PROCEDURE SGASS_DATOSXSOLOT(K_CODSOLOT IN OPERACION.SOLOT.CODSOLOT%TYPE,
                              K_DATOS    OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN K_DATOS FOR
      SELECT S.CODCLI, S.CUSTOMER_ID, S.COD_ID, S.CODSOLOT
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT = K_CODSOLOT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      OPEN K_DATOS FOR
        SELECT NULL, NULL, NULL, NULL FROM DUAL;
  END;
PROCEDURE SGASI_ALTA_MIXTO_ACTION(PI_NUMREGISTRO OPERACION.OPE_SRV_RECARGA_CAB.NUMREGISTRO%TYPE,
                                   PI_ACTION       IN NUMBER,
                                   PI_NUMSERIE     IN VARCHAR2,
                                   PO_RESPUESTA   IN OUT VARCHAR2,
                                   PO_MENSAJE     IN OUT VARCHAR2) IS

    V_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    V_REG_DECO NUMBER;
    V_RESP     VARCHAR2(10);
    V_MSJ      VARCHAR2(1000);
    EX_ERROR EXCEPTION;

    CURSOR C_SOT_REEMPLAZO IS
      SELECT DISTINCT S.TRXN_CODSOLOT, S.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO S
       WHERE S.TRXN_CODSOLOT = V_CODSOLOT
         AND S.TRXN_ACTION_ID = PI_ACTION
         AND S.TRXV_SERIE_TARJETA = PI_NUMSERIE
      UNION ALL
      SELECT DISTINCT H.TRXN_CODSOLOT, H.TRXC_ESTADO
        FROM OPERACION.SGAT_TRXCONTEGO_HIST H
       WHERE H.TRXC_ESTADO = C_PROV_OK
         AND H.TRXN_CODSOLOT = V_CODSOLOT
         AND H.TRXN_ACTION_ID = PI_ACTION
         AND H.TRXV_SERIE_TARJETA = PI_NUMSERIE
       ORDER BY 2 DESC;

  BEGIN
    PO_RESPUESTA := 'OK';
    PO_MENSAJE   := 'PROCESO TERMINADO SATISFACTORIAMENTE';
    -- BLOQUE CONSULTAS
    BEGIN
      SELECT CODSOLOT
        INTO V_CODSOLOT
        FROM OPERACION.OPE_SRV_RECARGA_CAB
       WHERE NUMREGISTRO = PI_NUMREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_RESPUESTA := 'ERROR';
        PO_MENSAJE   := 'ERROR: NO SE ENCUENTRA EL SOT ASOCIADO AL NUMREGISTRO EN LA TABLA OPERACION.OPE_SRV_RECARGA_CAB';
        RAISE EX_ERROR;
    END;

    /*Verificamos que la linea no se encuentre registrada en la transaccional con estado 1 o en
    el historico con estado 3*/
    FOR C_SOT IN C_SOT_REEMPLAZO LOOP
      IF (C_SOT.TRXC_ESTADO = C_GENERADO) THEN
          PO_RESPUESTA := 'PENDIENTE';
          PO_MENSAJE   := 'PENDIENTE: EN ESPERA DE ENVIO A CONTEGO.';
          RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_PROV_OK) THEN
        PO_RESPUESTA := 'OK';
        PO_MENSAJE   := 'PROVISIONADO: SE EJECUTO CORRECTAMENTE.';
        RAISE EX_ERROR;
      ELSIF (C_SOT.TRXC_ESTADO = C_ENVIADO) THEN
        PO_RESPUESTA := 'PENDIENTE';
        PO_MENSAJE   := 'PENDIENTE: EN ESPERA DE RESPUESTA DE CONTEGO.';
        RAISE EX_ERROR;
      ELSE
        DELETE OPERACION.SGAT_TRXCONTEGO S WHERE s.trxn_codsolot = V_CODSOLOT
        AND s.TRXN_ACTION_ID in (PI_ACTION, 101) AND s.trxv_serie_tarjeta = PI_NUMSERIE;
        EXIT;
      END IF;
    END LOOP;

    SELECT COUNT(*)
      INTO V_REG_DECO
      FROM OPERACION.TARJETA_DECO_ASOC T
     WHERE CODSOLOT = V_CODSOLOT;

    IF V_REG_DECO = 0 THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: NO SE ASOCIO TARJETA CON DECODIFICADOR';
      RAISE EX_ERROR;
    END IF;

    SGASI_ACTIVARBOUQUET(PI_NUMREGISTRO, V_CODSOLOT, PI_NUMSERIE, V_RESP, V_MSJ);  --14.0

    IF V_RESP = 'ERROR' THEN
      PO_RESPUESTA := V_RESP;
      PO_MENSAJE   := V_MSJ;
      RAISE EX_ERROR;
    END IF;
  EXCEPTION
    WHEN EX_ERROR THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ALTA_MIXTO_ACTION',PI_NUMREGISTRO,V_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
    WHEN OTHERS THEN
      PO_RESPUESTA := 'ERROR';
      PO_MENSAJE   := 'ERROR: ' || SQLCODE || ' ' || SQLERRM || ' ' ||
                     DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGASI_ALTA_MIXTO_ACTION',PI_NUMREGISTRO,V_CODSOLOT,PO_RESPUESTA,PO_MENSAJE);
  END;

  FUNCTION SGAFUN_VALIDA_SOT(PI_CODSOLOT OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                             PI_SERIE OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE)
    RETURN NUMBER IS
    PO_RESPUESTA NUMBER;
  BEGIN
    UPDATE OPERACION.SGAT_TRXCONTEGO TRX
    SET TRX.TRXC_ESTADO  = C_PROV_CANCELADO,
        TRX.TRXV_MSJ_ERR = C_MSG_CANCELADO
    WHERE TRX.TRXN_CODSOLOT = PI_CODSOLOT
    AND TRX.TRXV_SERIE_TARJETA = PI_SERIE;
    SGASI_REGCONTEGOHIST(PI_CODSOLOT, PI_SERIE, PO_RESPUESTA);
    RETURN PO_RESPUESTA;
  EXCEPTION
    WHEN OTHERS THEN
      OPERACION.PKG_CONTEGO.SGASP_LOGERR('SGAFUN_VALIDA_SOT',NULL,PI_CODSOLOT,SQLCODE,SQLERRM || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN - 1;
  END;

/****************************************************************
  * Nombre SP      : SGASI_REGCONTEGOHIST
  * Proposito      : SP utilizado para grabar en la tabla historica y
                     eliminarlo de la transaccional, es una variante del SP
                     en PKG_CONTEGO porque se utiliza para Mixto
  * Input          : PI_CODSOLOT - SOT
  * Input          : PI_SERIE - SERIE QUE SE DESEA REENVIAR
  * Output         : PO_RESPUESTA
  * Creado por     : Abel Ojeda
  * Fec. Creacion  : 08/08/2018
  * Fec. Actualizacion : --
  ****************************************************************/
  PROCEDURE SGASI_REGCONTEGOHIST(PI_CODSOLOT  IN OPERACION.SGAT_TRXCONTEGO.TRXN_CODSOLOT%TYPE,
                                 PI_SERIE IN OPERACION.SGAT_TRXCONTEGO.TRXV_SERIE_TARJETA%TYPE,
                                 PO_RESPUESTA OUT NUMBER) IS
  BEGIN
    PO_RESPUESTA := 0;

    BEGIN
      INSERT INTO OPERACION.SGAT_TRXCONTEGO_HIST
        (TRXN_IDTRANSACCION,
         TRXN_CODSOLOT,
         TRXN_ACTION_ID,
         TRXV_TIPO,
         TRXV_SERIE_TARJETA,
         TRXV_SERIE_DECO,
         TRXV_BOUQUET,
         TRXC_ESTADO,
         TRXV_MSJ_ERR,
         TRXN_IDLOTE,
         TRXN_PRIORIDAD,
         TRXN_IDSOL,
         TRXD_FECUSU,
         TRXV_CODUSU,
         TRXD_FECMOD,
         TRXV_USUMOD)
        SELECT A.TRXN_IDTRANSACCION,
               A.TRXN_CODSOLOT,
               A.TRXN_ACTION_ID,
               A.TRXV_TIPO,
               A.TRXV_SERIE_TARJETA,
               A.TRXV_SERIE_DECO,
               A.TRXV_BOUQUET,
               A.TRXC_ESTADO,
               A.TRXV_MSJ_ERR,
               A.TRXN_IDLOTE,
               A.TRXN_PRIORIDAD,
               A.TRXN_IDSOL,
               A.TRXD_FECUSU,
               A.TRXV_CODUSU,
               SYSDATE,
               USER
          FROM OPERACION.SGAT_TRXCONTEGO A
         WHERE A.TRXN_CODSOLOT = PI_CODSOLOT AND TRXV_SERIE_TARJETA = PI_SERIE
         AND A.TRXC_ESTADO = C_PROV_CANCELADO;
    EXCEPTION
      WHEN OTHERS THEN
        PO_RESPUESTA := -1;
        OPERACION.PKG_CONTEGO.SGASP_LOGERR(C_SP_REGCONTEGO,null,PI_CODSOLOT,PO_RESPUESTA,sqlerrm);
        RETURN;
    END;

    DELETE FROM OPERACION.SGAT_TRXCONTEGO B
     WHERE B.TRXN_CODSOLOT = PI_CODSOLOT AND B.TRXV_SERIE_TARJETA = PI_SERIE
     AND B.TRXC_ESTADO = C_PROV_CANCELADO;
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESPUESTA := -2;
      OPERACION.PKG_CONTEGO.SGASP_LOGERR(C_SP_REGCONTEGO, null, PI_CODSOLOT, PO_RESPUESTA, sqlerrm);
      RETURN;
  END;

  PROCEDURE sgasi_valida_dec_adc(pi_idtareawf IN NUMBER,
                                 pi_idwf      IN NUMBER,
                                 pi_tarea     IN NUMBER,
                                 pi_tareadef  IN NUMBER)
    IS
    ln_cod_id           NUMBER;
    ln_sot              NUMBER;
    ln_estsol           solot.estsol%TYPE;
    ln_estsolact        solot.estsol%TYPE;
    n_cont              NUMBER;
    ln_resp             NUMERIC := 0;
    lv_mensaje          VARCHAR2(3000);
    ln_cod1             NUMBER;
    lv_resul            VARCHAR2(4000);
    ln_cargo_inst       NUMBER;
    lv_codigo_occ_bscs  NUMBER;
    ln_customerid       NUMBER;
    av_trama            CLOB;
    ln_idinteraccion    NUMBER;
    lv_occ_bscs         INTEGER;
    ln_cargo_recurrente VARCHAR2(50);
    ln_val_cnr          number;
    li_verify_count     INTEGER := 0;

    CURSOR c_pid IS
      select ip.pid
      from operacion.insprd ip
      where ip.pid in (SELECT sp.pid
                       FROM operacion.solotpto sp
                       WHERE sp.codsolot = ln_sot)
      and ip.flgprinc = 0
      minus
      -- Cursor de Equipos para Costos Recurrente en BSCS
      select i.pid
      from operacion.solotpto   sp,
           operacion.insprd     i,
           operacion.equcomxope eco
      where sp.pid = i.pid
      and i.flgprinc=0
      and i.codequcom = eco.codequcom
      and eco.tipequ in (SELECT crm.codigon
                        FROM sales.crmdd crm
                        WHERE crm.tipcrmdd IN
                              (SELECT tip.tipcrmdd
                               FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
      and sp.codsolot = ln_sot;

    CURSOR c_inssrv IS
      SELECT i.codinssrv, i.tipsrv
        FROM operacion.inssrv i
       WHERE i.codinssrv IN (SELECT sp.codinssrv
                               FROM operacion.solotpto sp
                              WHERE sp.codsolot = ln_sot);
    CURSOR c_equ_bscs IS
      SELECT a.nro_serie_deco,
             a.nro_serie_tarjeta,
             a.tipo_equipo,
             a.modelo_equipo
        FROM (SELECT DISTINCT asoc.nro_serie_deco,
                              asoc.nro_serie_tarjeta,
                              (SELECT DISTINCT nvl(crm.abreviacion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) tipo_equipo,
                              (SELECT DISTINCT nvl(crm.descripcion, '')
                                 FROM sales.crmdd crm
                                WHERE se.tipequ = to_number(crm.codigon)) modelo_equipo
                FROM operacion.tarjeta_deco_asoc asoc,
                     operacion.solotptoequ       se,
                     operacion.tipequ            tieq
               WHERE asoc.codsolot = se.codsolot
                 AND se.mac = asoc.nro_serie_deco
                 AND se.tipequ = to_number(tieq.tipequ)
                 AND (se.tipequ) IN
                     (SELECT crm.codigon
                        FROM sales.crmdd crm
                       WHERE crm.tipcrmdd IN
                             (SELECT tip.tipcrmdd
                                FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
                 AND asoc.codsolot = ln_sot) a;

    CURSOR c_solotpequ IS
      SELECT spe.numserie
        FROM operacion.solotptoequ spe
       WHERE spe.codsolot = ln_sot
         AND spe.numserie IS NOT NULL;

    cursor c_val_cr_bscs is
      select i.pid,
             i.estinsprd,
             eco.tipequ,
             (select spds.sncode
              from sales.sisact_postventa_det_serv_hfc spds
              where spds.tipequ = eco.tipequ
              and spds.idinteraccion =
                    (select spl.idinteraccion
                     from sales.siac_postventa_lte spl
                     where spl.codsolot = sp.codsolot)) sncode
      from operacion.solotpto   sp,
           operacion.insprd     i,
           operacion.equcomxope eco
      where sp.pid = i.pid
      and i.codequcom = eco.codequcom
      and i.flgprinc=0
      and eco.tipequ in (SELECT crm.codigon
                        FROM sales.crmdd crm
                        WHERE crm.tipcrmdd IN
                              (SELECT tip.tipcrmdd
                               FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
      and sp.codsolot = ln_sot;


      cursor c_val_cr_bscs_proceso is
      select i.pid,
             i.estinsprd,
             eco.tipequ,
             (select spds.sncode
              from sales.sisact_postventa_det_serv_lte spds
              where spds.tipequ = eco.tipequ
              and spds.idinteraccion =
                    (select spl.idinteraccion
                     from operacion.siac_postventa_proceso spl
                     where spl.codsolot = sp.codsolot)) sncode
      from operacion.solotpto   sp,
           operacion.insprd     i,
           operacion.equcomxope eco
      where sp.pid = i.pid
      and i.codequcom = eco.codequcom
      and i.flgprinc=0
      and eco.tipequ in (SELECT crm.codigon
                        FROM sales.crmdd crm
                        WHERE crm.tipcrmdd IN
                              (SELECT tip.tipcrmdd
                               FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
      and sp.codsolot = ln_sot;


    cursor c_reg_servicio is
      select spds.sncode
       from sales.sisact_postventa_det_serv_hfc spds
       where spds.idinteraccion =
             (select spl.idinteraccion
                from sales.siac_postventa_lte spl
               where spl.codsolot = ln_sot)
         and spds.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'));


    cursor c_reg_servicio_proceso is
      select spds.sncode
        from sales.sisact_postventa_det_serv_lte spds
        where spds.idinteraccion =
             (select spl.idinteraccion
                from operacion.siac_postventa_proceso spl
               where spl.codsolot = ln_sot)
         and spds.tipequ in
             (SELECT crm.codigon
                FROM sales.crmdd crm
               WHERE crm.tipcrmdd IN
                     (SELECT tip.tipcrmdd
                        FROM sales.tipcrmdd tip
                       WHERE tip.abrev = 'DTHPOSTEQU'));


   cursor c_reg_pid_serv is
      select i.pid
      from operacion.solotpto   sp,
           operacion.insprd     i,
           operacion.equcomxope eco
      where sp.pid = i.pid
      and i.codequcom = eco.codequcom
      and i.flgprinc = 0
      and i.estinsprd <> 1
      and eco.tipequ in (SELECT crm.codigon
                        FROM sales.crmdd crm
                        WHERE crm.tipcrmdd IN
                              (SELECT tip.tipcrmdd
                               FROM sales.tipcrmdd tip
                               WHERE tip.abrev = 'DTHPOSTEQU'))
      and sp.codsolot = ln_sot;

  BEGIN

    SELECT w.codsolot INTO ln_sot FROM wf w WHERE w.idwf = pi_idwf;

    SELECT COUNT(1)
      INTO n_cont
      FROM operacion.inssrv i
     WHERE i.codinssrv IN (SELECT sp.codinssrv
                             FROM operacion.solotpto sp
                            WHERE sp.codsolot = ln_sot);

    IF n_cont > 0 THEN
      SELECT a.cod_id, a.customer_id, a.estsol, a.cargo
        INTO ln_cod_id, ln_customerid, ln_estsol, ln_cargo_inst
        FROM operacion.solot a
       WHERE a.codsolot = ln_sot;

      -- Actualizar Insprd de SGA
      FOR cx IN c_pid LOOP
        UPDATE operacion.insprd SET estinsprd = 1 WHERE pid = cx.pid;
      END LOOP;

      -- Actualizar Servicios de SGA
      FOR c1 IN c_inssrv LOOP

        UPDATE operacion.inssrv
           SET estinssrv = 1
         WHERE codinssrv = c1.codinssrv;

        IF c1.tipsrv = '0062' THEN

          -- Insertar Equipos a BSCS
          FOR c1 IN c_equ_bscs LOOP
            PQ_3PLAY_INALAMBRICO.p_registra_deco_lte(ln_cod_id,
                                c1.nro_serie_deco,
                                c1.nro_serie_tarjeta,
                                c1.tipo_equipo,
                                c1.modelo_equipo,
                                ln_resp,
                                lv_mensaje);

            IF ln_resp <> 0 THEN
              raise_application_error(-20500,
                                      'tim.pp021_venta_lte.sp_registra_deco_lte: ' ||
                                      lv_mensaje);
            END IF;
          END LOOP;

        END IF;

      END LOOP;
      -- Actualizar Los numeros de Serie de los Equipos
      FOR c1 IN c_solotpequ LOOP
        UPDATE operacion.tabequipo_material tm
           SET estado = 1
         WHERE TRIM(tm.numero_serie) = TRIM(c1.numserie);
      END LOOP;

      --17.0 Ini
      SGASI_REGISTRAR_CARGO_REC_DECO(ln_sot, ln_resp, lv_mensaje);
      IF ln_resp <> 0 THEN
            OPERACION.PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(ln_sot, 'sgasi_valida_dec_adc', lv_mensaje,
                           'SGASI_REGISTRAR_CARGO_REC_DECO', LN_RESP, lv_mensaje);

            raise_application_error(-20001, 'Error al registrar cargo recurrente en Deco Adiciional '|| SQLERRM);
          END IF;
      --17.0 Fin

      -- Verificando el Estado de SOT para cambiar a Atendido
      IF ln_estsol <> 29 THEN
        operacion.pq_solot.p_chg_estado_solot(ln_sot, 29);
      END IF;

      SELECT s.estsol
        INTO ln_estsolact
        FROM solot s
       WHERE s.codsolot = ln_sot;

      --REGISTRO OCC INSTALACION - Cargo no Recurrente
      IF ln_estsolact = 29 THEN
        IF ln_cargo_inst IS NOT NULL THEN
          IF ln_cargo_inst > 0 THEN
            select count(1) into ln_val_cnr
            from operacion.insprd ip
            where ip.pid in (select pid
                             from operacion.solotpto sp
                             where sp.codsolot = ln_sot)
              and ip.estinsprd=1
              and ip.flgprinc=1;
            if ln_val_cnr=0 then

              BEGIN
                -- Consultar el Codigo de OCC de BSCS enviado por SIAC
                SELECT spl.codigo_occ
                  INTO lv_codigo_occ_bscs
                  FROM sales.siac_postventa_lte spl
                 WHERE spl.codsolot = ln_sot;

                --Se valida para poder realizar el proceso con la tabla operacion.siac_postventa_proceso
                IF lv_codigo_occ_bscs IS NULL OR lv_codigo_occ_bscs = 0 THEN
                   li_verify_count := 1;
                END IF;
                -- Invocacion de Web Service de OCC
                sales.pq_siac_postventa_lte.p_insert_occ(ln_customerid,
                                                         ln_sot,
                                                         lv_codigo_occ_bscs,
                                                         '1',
                                                         ln_cargo_inst,
                                                         av_trama,
                                                         ln_resp,
                                                         lv_mensaje);

               if ln_resp=1 then
                  select ip.pid into ln_val_cnr
                    from operacion.insprd ip
                   where ip.pid in (select pid
                                      from operacion.solotpto sp
                                     where sp.codsolot = ln_sot)
                    and ip.flgprinc=1;
                   -- Actualizar Pid(s) para saber si se envio a BSCS el cargo no recurrente
                   PQ_3PLAY_INALAMBRICO.p_act_pid_x_bscs(ln_val_cnr,ln_resp,lv_mensaje);
               else
                 PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(LN_SOT, 'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF', 'ERROR WEB SERVICE OCC',
                              'VALIDACION SERVICIOS DECO ADICIONAL', LN_RESP, LV_MENSAJE);
               end if;

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                  -- Consultar el Codigo de OCC de BSCS enviado por SIAC
                      SELECT spl.codocc
                      INTO lv_codigo_occ_bscs
                      FROM operacion.siac_postventa_proceso spl
                      WHERE spl.codsolot = ln_sot;
                      -- Invocacion de Web Service de OCC
                      sales.pq_siac_postventa_lte.p_insert_occ(ln_customerid,
                                                               ln_sot,
                                                               lv_codigo_occ_bscs,
                                                               '1',
                                                               ln_cargo_inst,
                                                               av_trama,
                                                               ln_resp,
                                                               lv_mensaje);

                     if ln_resp=1 then
                        select ip.pid into ln_val_cnr
                          from operacion.insprd ip
                         where ip.pid in (select pid
                                            from operacion.solotpto sp
                                           where sp.codsolot = ln_sot)
                          and ip.flgprinc=1;
                         -- Actualizar Pid(s) para saber si se envio a BSCS el cargo no recurrente
                         PQ_3PLAY_INALAMBRICO.p_act_pid_x_bscs(ln_val_cnr,ln_resp,lv_mensaje);
                     else
                       PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(LN_SOT, 'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF', 'ERROR WEB SERVICE OCC',
                                    'VALIDACION SERVICIOS DECO ADICIONAL', LN_RESP, LV_MENSAJE);
                     end if;

                    EXCEPTION
                      WHEN OTHERS THEN
                        PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(LN_SOT, 'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF', 'ERROR WEB SERVICE OCC',
                                     'VALIDACION SERVICIOS DECO ADICIONAL', LN_RESP, LV_MENSAJE);
                    END;
                    -- FIN operacion.siac_postventa_proceso

                WHEN OTHERS THEN
                  PQ_3PLAY_INALAMBRICO.P_LOG_3PLAYI(LN_SOT, 'TIM.TFUN003_REGISTER_SERVICE@DBL_BSCS_BF', 'ERROR WEB SERVICE OCC',
                               'VALIDACION SERVICIOS DECO ADICIONAL', LN_RESP, LV_MENSAJE);

              END;

            end if;
          END IF;
        END IF;
      END IF;
    ELSE
      raise_application_error(-20001,
                              'Error al validar servicio Deco adicional  : Se debe de tener Servicios Asociados');
    END IF;

    PQ_3PLAY_INALAMBRICO.p_log_3playi(ln_sot,
                 'sgasi_valida_dec_adc',
                 'OK',
                 'Cierre de Validación de Servicios Inalámbricos Post',
                 ln_cod1,
                 lv_resul);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      lv_mensaje := SQLERRM;
      PQ_3PLAY_INALAMBRICO.p_log_3playi(ln_sot,
                   'sgasi_valida_dec_adc',
                   lv_mensaje,
                   'Cierre de Validación de Servicios Inalámbricos Post',
                   ln_cod1,
                  lv_resul);
      raise_application_error(-20001,
                              'Error al validar servicio Deco adicional  : ' ||
                              SQLERRM);
  END;
  --<Fin 10.0>
  --<Ini 14.0>
  PROCEDURE SGASU_ACTUALIZAR_PID(PI_CODSOLOT  IN operacion.solot.codsolot%TYPE,
                                 PI_TIPTRS    IN operacion.solotpto.tiptrs%type,
                                 PI_ESTADO    IN operacion.insprd.estinsprd%type,
                                 PO_RESULTADO OUT NUMBER,
                                 PO_MENSAJE   OUT VARCHAR2) IS

    CURSOR C_PID IS
      SELECT TS.DESCRIPCION, PTO.PID, PTO.CODINSSRV, pto.tiptrs
        FROM SOLOTPTO PTO, TIPTRS TS
       WHERE TS.TIPTRS = PTO.TIPTRS
         AND PTO.CODSOLOT = PI_CODSOLOT
         AND PTO.tiptrs = PI_TIPTRS;

  BEGIN

    PO_RESULTADO := 0;
    PO_MENSAJE   := 'Exito';

    -- Actualizacion de PID
    FOR c3 IN C_PID LOOP
      if c3.tiptrs = 1 then
        UPDATE OPERACION.INSPRD P
           SET P.ESTINSPRD = PI_ESTADO, p.fecini = sysdate
         WHERE P.PID = c3.pid;

      elsif c3.tiptrs = 5 then

        UPDATE OPERACION.INSPRD P
           SET P.ESTINSPRD = PI_ESTADO,
               p.fecfin = sysdate
         WHERE P.PID = c3.pid;

      end if;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := $$PLSQL_UNIT ||
                      '.SGASU_ACTUALIZAR_PID: Error al actualizar PID. ' ||
                      SQLERRM || '.' || ' - Linea ('||dbms_utility.format_error_backtrace ||')';  --17.0
					  
	OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASU_ACTUALIZAR_PID', PO_MENSAJE, '', PO_RESULTADO, PO_MENSAJE); --17.0

  END;
  PROCEDURE SGASI_REGISTRAR_CARGO_REC_DECO(PI_CODSOLOT  IN operacion.solot.codsolot%TYPE,
                                           PO_RESULTADO OUT NUMBER,
                                           PO_MENSAJE   OUT VARCHAR2) IS

    v_cargo_recurrente VARCHAR2(50);
    v_sncode INTEGER;  --16.0
	ln_val	 NUMBER;
	v_coderr number;--18.0
	v_deserr varchar2(300);--18.0
	
    CURSOR C_CUR IS
      select distinct spds.SNCODE, s.cod_id, NVL(spds.cargofijo,0) cargof  --17.0 
        from sales.sisact_postventa_det_serv_lte spds,
             operacion.solot s
       where spds.idinteraccion =
             (select spl.idinteraccion
                from operacion.siac_postventa_proceso spl
               where spl.codsolot = PI_CODSOLOT)
         and spds.flag_accion = C_ALTA
         and s.codsolot = spds.codsolot;
    
    v_mensaje_user varchar2(100); --19.0

  BEGIN

    PO_RESULTADO := 0;
    PO_MENSAJE   := 'Exito';    
	ln_val := operacion.pq_sga_janus.f_get_constante_conf('ACTFACTDECOLTE');
	
	if ln_val = 1 then
		-- Registro Cargo Recurrente de Deco Adicional
		FOR c1 IN C_CUR LOOP
	--16.0 Ini
			v_sncode := to_number(c1.sncode);
			v_cargo_recurrente := TIM.TIM111_PKG_ACCIONES_SGA.FN_REGISTER_SERVICE@DBL_BSCS_BF(c1.cod_id,
																			NULL,
																			NULL,
																			v_sncode,
																			'1');
	--16.0 Fin
	--Ini 19.0
        v_mensaje_user := '';
      	Begin
        	select o.descripcion
        	into v_mensaje_user
        	from opedd o 
        	inner join tipopedd a on (o.tipopedd = a.tipopedd and a.abrev = 'ERRORS REGSERV BSCS')
        	where o.codigon_aux = 1 
        	and o.codigoc = v_cargo_recurrente;
      	Exception
        	When Others Then
        	v_mensaje_user := '';
      	End;
      --Fin 19.0
      IF v_cargo_recurrente NOT IN  ('0','-3') THEN--18.0
         PO_RESULTADO := -1;
         PO_MENSAJE   := 'ERROR AL REGISTRAR CARGO RECURRENTE DE DECO ADICIONAL. VER ERROR '||v_cargo_recurrente || ' - ' || v_mensaje_user || ' EN TIM.TIM111_PKG_ACCIONES_SGA.FN_REGISTER_SERVICE';--18.0 --19.0
         OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASI_REGISTRAR_CARGO_REC_DECO', PO_MENSAJE, '', v_coderr, v_deserr); --18.0
         RETURN;--18.0
--17.0 Ini
      ELSE
         -- Actualizamos cargo fijo
         UPDATE PROFILE_SERVICE@DBL_BSCS_BF PS
            SET PS.OVW_ACCESS     = 'A',
                PS.ACCESSFEE      = c1.cargof,
                PS.OVW_ACC_PRD    = -1,
                PS.OVW_ADV_CHARGE = 'A',
                PS.ADV_CHARGE     = c1.cargof,
                PS.ADV_CHARGE_PRD = -1
          WHERE PS.CO_ID = c1.cod_id
            AND PS.SNCODE = v_sncode
            AND PS.STATUS_HISTNO = (SELECT MAX(HISTNO)
                          FROM PR_SERV_STATUS_HIST@DBL_BSCS_BF PR
                         WHERE PR.CO_ID = PS.CO_ID
                           AND PR.SNCODE = PS.SNCODE
                           AND PR.STATUS in ('O', 'A'));
      END IF;    
--17.0 Fin 
		END LOOP;
	end if;
	
  EXCEPTION
    WHEN OTHERS THEN
      PO_RESULTADO := -1;
      PO_MENSAJE   := $$PLSQL_UNIT ||
                      '.SGASI_REGISTRAR_CARGO_REC_DECO: Error al Registra cargo recurrente en BSCS. ' ||
                      SQLERRM || '.' || ' - Linea ('||dbms_utility.format_error_backtrace ||')';  --17.0
					  
	OPERACION.PQ_3PLAY_INALAMBRICO.p_log_3playi(PI_CODSOLOT, 'SGASI_REGISTRAR_CARGO_REC_DECO', PO_MENSAJE, '', v_coderr, v_deserr); --17.0 --19.0

  END;
  FUNCTION SGAFUN_OBT_BOUQUET_ACT(PI_COD_ID operacion.solot.cod_id%type) RETURN VARCHAR2 IS

    LN_COUNTER    NUMBER := 0;
    LN_BOUQUET    VARCHAR2(500) := NULL;

    CURSOR c_bouquet IS
      select distinct SSH.CO_ID, ssh.sncode, BU.COD_BUQUET
        from sysadm.PR_SERV_STATUS_HIST@dbl_bscs_bf SSH
       inner join tim.PP_GMD_BUQUET@dbl_bscs_bf BU
          on BU.SNCODE = SSH.SNCODE
       where HISTNO = (select STATUS_HISTNO
                         from sysadm.PROFILE_SERVICE@dbl_bscs_bf
                        where CO_ID = SSH.CO_ID
                          and SNCODE = SSH.SNCODE)
         and SSH.STATUS = 'A'
         and SSH.CO_ID = PI_COD_ID;

  BEGIN
      FOR c_c1 IN c_bouquet LOOP
        IF LN_COUNTER = 0 THEN
           LN_BOUQUET := TRIM(c_c1.cod_buquet);
        ELSE
           LN_BOUQUET := LN_BOUQUET || ',' || TRIM(c_c1.cod_buquet);
        END IF;
        LN_COUNTER := LN_COUNTER + 1;
      END LOOP;

    RETURN LN_BOUQUET;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  --<Fin 14.0>
--<Ini 21.0>
PROCEDURE SGASS_EQUIPOXPUNTOXSOT(PI_CODSOLOT   IN operacion.solot.codsolot%TYPE,
                                 PI_CODIGO     IN NUMBER,
                                 PI_NUMSERIE   IN VARCHAR2,
                                 PO_CURSOR     OUT SYS_REFCURSOR) 
IS
 LN_COD_ID    operacion.solot.cod_id%TYPE;

BEGIN    
    BEGIN
     select cod_id into LN_COD_ID from operacion.solot 
     where codsolot = PI_CODSOLOT;
    EXCEPTION     
     WHEN OTHERS THEN
      OPEN PO_CURSOR FOR
        SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL;
      RETURN;
    END;
    OPEN PO_CURSOR FOR
      select pto.codsolot, pto.punto, pto.orden, te.descripcion, te.tipo, pto.numserie,
      pto2.mac, pto.tipequ, pto.codequcom, pto.iddet, pto.estado, te.codtipequ,
      te2.descripcion des_deco, te2.tipo tipo_deco, pto2.numserie serie_deco, asoc.id_asoc,
      pto2.tipequ tipequ_deco, spto.codinssrv, spto2.codinssrv codinssrv_deco, te2.codtipequ codtipequ_deco
      from operacion.solot s
      inner join operacion.solotpto spto on (s.codsolot = spto.codsolot)
      inner join operacion.solotptoequ pto on (s.codsolot = pto.codsolot and spto.punto = pto.punto and
                 (case PI_CODIGO when 1 then trim(pto.numserie)                                
                                else '' end <> PI_NUMSERIE
                  or
                  PI_CODIGO = 2 )
      )
      inner join operacion.solotpto spto2 on (s.codsolot = spto2.codsolot)
      inner join operacion.solotptoequ pto2 on (s.codsolot = pto2.codsolot and spto2.punto = pto2.punto and
                 (case PI_CODIGO when 2 then trim(pto2.numserie)                                
                                else '' end <> PI_NUMSERIE
                  or
                  PI_CODIGO = 1 )
      )
      inner join (select a.codigon tipequ, to_number(codigoc) grupo
                  from opedd a, tipopedd b where a.tipopedd = b.tipopedd
                  and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax on pto.tipequ = equ_conax.tipequ
      inner join (select a.codigon tipequ, to_number(codigoc) grupo
                  from opedd a, tipopedd b where a.tipopedd = b.tipopedd
                  and b.abrev = 'TIPEQU_DTH_CONAX') equ_conax_2 on pto2.tipequ = equ_conax_2.tipequ
      inner join operacion.tipequ te on pto.tipequ = te.tipequ
      inner join operacion.tipequ te2 on pto2.tipequ = te2.tipequ
      inner join operacion.tarjeta_deco_asoc asoc on s.codsolot = asoc.codsolot
      and trim(nvl(asoc.nro_serie_tarjeta,'')) = trim(nvl(pto.numserie,'')) 
      and trim(nvl(asoc.nro_serie_deco,'')) = trim(nvl(pto2.mac,''))
      where s.cod_id = LN_COD_ID and s.estsol in (12,29);
  EXCEPTION
    WHEN OTHERS THEN
      OPEN PO_CURSOR FOR
        SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL;
  END;
--<Fin 21.0>
end;
/