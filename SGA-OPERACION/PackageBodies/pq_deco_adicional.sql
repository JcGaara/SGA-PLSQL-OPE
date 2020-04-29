create or replace package body operacion.pq_deco_adicional is
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
  5.0      2015-11-24  Alfonso Muñante                      SD-438726 Deco Adicional
  6.0     2015-12-16  Alfonso Muñante            SGA-SD-534868 BAJA DECO
  7.0      2016-09-01  Alfonso Muñante                      SD865432
  8.0     2016-12-29  Servicios Fallas - Hitss        SD925014
  9.0     2017-07-18  Felipe Maguiña                        PROY-27792
  10.0    2018-06-13  Justiniano Condori                    PROY-32581-Postventa LTE/HFC] - [Deco Adicional]
  11.0    2018-08-17  Hitss                                 PROY-31513-TOA    
  *******************************************************************************/
  FUNCTION deco_adicional(p_idprocess     siac_postventa_proceso.idprocess%TYPE,
                          p_idinteraccion sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                          p_cod_id        sales.sot_sisact.cod_id%TYPE,
                          p_cargo         solot.cargo%TYPE)
    RETURN solot.codsolot%TYPE IS
    l_numslc     vtatabslcfac.numslc%TYPE;
    l_codsolot   solot.codsolot%TYPE;
    l_wfdef      wf.wfdef%TYPE;
    ac_mensaje varchar2(200); --7.0
    l_interac    char(10); --11.0
  BEGIN
    validar_equipo_servicio(p_idinteraccion);

    l_numslc := registrar_venta(p_idprocess, p_idinteraccion, p_cod_id);

    registrar_insprd(p_cod_id, l_numslc);

    l_codsolot := registrar_solot(p_idprocess, p_cod_id, l_numslc, p_cargo);

    --ETAdirect
    --INI 11.0
    /*
    sales.pkg_etadirect.p_registro_eta(l_codsolot,
                                       TO_NUMBER(p_idinteraccion),
                                       0,     
                                      ac_mensaje);*/
                                       
    l_interac := LPAD(to_char(p_idinteraccion), 10, 0);
    sales.pkg_etadirect.registrar_agendamiento(l_codsolot, l_interac);
                                       
    --FIN 11.0
    --ETAdirect

    registrar_solotpto(p_cod_id, l_numslc, l_codsolot);

    l_wfdef := get_wfdef();

    pq_solot.p_asig_wf(l_codsolot, l_wfdef);

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

    l_comodato     sales.pq_comodato_sisact.comodato_type;
    l_servicio     sales.pq_servicio_sisact.servicio_type;
    l_idlinea      linea_paquete.idlinea%type;
    l_servicio_sga linea_paquete.codsrv%type;

    cursor lineas_iteraccion is
      select t.*
        from sales.sisact_postventa_det_serv_hfc t
       where t.idinteraccion = p_idinteraccion;

  begin
    for linea_iteraccion in lineas_iteraccion loop
      if es_servicio_adicional(linea_iteraccion.idgrupo) then
        if not existe_servicio(linea_iteraccion.servicio) then
          l_servicio.servicio          := linea_iteraccion.servicio;
          l_servicio.dscsrv            := linea_iteraccion.dscsrv;
          l_servicio.idgrupo           := linea_iteraccion.idgrupo;
          l_servicio.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          l_servicio.flag_lc           := linea_iteraccion.flag_lc;
          l_servicio.codigo_ext        := linea_iteraccion.codigo_ext;
          l_servicio.bandwid           := linea_iteraccion.bandwid;

          crear_idlinea_servicio(l_servicio, l_idlinea, l_servicio_sga);
        end if;
      elsif es_servicio_comodato(linea_iteraccion.idgrupo,
                                 linea_iteraccion.idgrupo_principal) or
            es_servicio_alquiler(linea_iteraccion.idgrupo,
                                 linea_iteraccion.idgrupo_principal) then
        if not existe_equipo(linea_iteraccion.idgrupo, linea_iteraccion.tipequ) then
          l_comodato.idgrupo           := linea_iteraccion.idgrupo;
          l_comodato.idgrupo_principal := linea_iteraccion.idgrupo_principal;
          l_comodato.codtipequ         := linea_iteraccion.codtipequ;
          l_comodato.tipequ            := linea_iteraccion.tipequ;
          l_comodato.dscequ            := linea_iteraccion.dscequ;

          crear_idlinea_equipo(l_comodato, l_idlinea);
        end if;
      end if;
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

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.es_servicio_alquiler(p_idgrupo => ' ||
                              p_idgrupo || ', p_idgrupo_principal => ' ||
                              p_idgrupo_principal || ') ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  function es_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_PRIN', p_idgrupo);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.es_servicio_principal(p_idgrupo => ' ||
                              p_idgrupo || ') ' || sqlerrm);

  end;
  --------------------------------------------------------------------------------
  function es_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%type,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_COMO', p_idgrupo) and es_servicio_principal(p_idgrupo_principal);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.es_servicio_comodato(p_idgrupo => ' ||
                              p_idgrupo || ', p_idgrupo_principal => ' ||
                              p_idgrupo_principal || ') ' || sqlerrm);

  end;
  --------------------------------------------------------------------------------
  function es_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%type)
    return boolean is

  begin
    return grupo_servicios('GRUP_SERV_ADIC', p_idgrupo);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.es_servicio_adicional(p_idgrupo => ' ||
                              p_idgrupo || ') ' || sqlerrm);

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

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.grupo_servicios(p_tip_servicio => ' ||
                              p_tip_servicio || ', p_cod_servicio => ' ||
                              p_cod_servicio || ') ' || sqlerrm);

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
       where t.idinteraccion = p_idinteraccion;

  begin
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);
    l_tiptra               := get_parametro_deco('RVTIPTRA', 0);
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
      if es_servicio_adicional(servicio.idgrupo) then
        l_idlinea := ubicar_idlinea_servicio(servicio.servicio);
      elsif es_servicio_comodato(servicio.idgrupo, servicio.idgrupo_principal) or
            es_servicio_alquiler(servicio.idgrupo, servicio.idgrupo_principal) then
        l_idlinea := ubicar_idlinea_equipo(servicio.tipequ, servicio.idgrupo);
      end if;

      l_detalle_idlinea := detalle_idlinea(l_idlinea);

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
    l_tiptra      := get_parametro_deco('RVTIPTRA', 0);

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
       idplataforma)
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
       7);

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

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crea_instalacion ' ||
                              sqlerrm);

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
           0);
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
    l_tiptra               := get_parametro_deco('RVTIPTRA', 0);
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);

    select sq_solot.nextval into l_codsolot from dual;
    insert into solot
      (codsolot,
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
       cargo)
    values
      (l_codsolot,
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
       p_cargo);

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
  procedure registrar_solotpto(p_cod_id   sales.sot_sisact.cod_id%type,
                               p_numslc   solot.numslc%type,
                               p_codsolot solot.codsolot%type) is
    l_detalle_vtadetptoenl detalle_vtadetptoenl_type;

    cursor insprds is
      select i.pid, i.descripcion, i.codsrv, i.codinssrv
        from insprd i
       where i.numslc = p_numslc;

  begin
    l_detalle_vtadetptoenl := detalle_vtadetptoenl_alta(p_cod_id);

    for insprd in insprds loop
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
         pid)
      values
        (p_codsolot,
         insprd.codsrv,
         0,
         insprd.codinssrv,
         insprd.descripcion,
         l_detalle_vtadetptoenl.dirpto,
         6,
         1,
         1,
         l_detalle_vtadetptoenl.ubipto,
         insprd.pid);
    end loop;

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
       and d.abreviacion = 'SOLINSALTA'; --9.0

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
    no_existe_sot exception;
    ln_codsolot_max number;
  begin
    -- Inicio 5.0
     begin
       l_tipsrv := get_parametro_deco('TIPSRVDECO', 0);

       ln_codsolot_max := operacion.pq_sga_iw.f_max_sot_x_cod_id(p_cod_id);

       if ln_codsolot_max = 0 then
         raise no_existe_sot;
       end if;

       select ins.codinssrv
         into l_codinssrv
         from inssrv ins
        where ins.tipsrv = l_tipsrv
        and ins.codinssrv in (select codinssrv from solotpto where codsolot = ln_codsolot_max);


     exception
       when no_existe_sot then
         raise_application_error(-20000,
                                 $$plsql_unit ||
                                 '.get_codinssrv(p_cod_id => ' || p_cod_id || ') No existe SOT de alta' ||
                                 sqlerrm);
     end;

    return l_codinssrv;

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

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.existe_equipo(p_idgrupo => ' ||
                              p_idgrupo || ', p_tipequ => ' ||
                              p_tipequ || ') ' || sqlerrm);

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

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$plsql_unit || '.existe_servicio(p_servicio => ' ||
                              p_servicio || ') ' || sqlerrm);

  end;
  --------------------------------------------------------------------------------
  procedure crear_idlinea_equipo(p_comodato sales.pq_comodato_sisact.comodato_type,
                                 p_idlinea  out sales.linea_paquete.idlinea%type) is

  begin
    p_idlinea := sales.pq_comodato_sisact.configure_comodato(p_comodato);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.crear_idlinea_equipo(p_comodato => RECORD) ' ||
                              sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure crear_idlinea_servicio(p_servicio sales.pq_servicio_sisact.servicio_type,
                                   p_idlinea  out linea_paquete.idlinea%type,
                                   p_codsrv   out tystabsrv.codsrv%type) is
  begin
    sales.pq_servicio_sisact.create_servicio(p_servicio, p_idlinea, p_codsrv);

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
    ln_codsolot_max operacion.solot.codsolot%type;
    customer_id_max operacion.solot.customer_id%type;
    codsolot_s1 operacion.solot.codsolot%type;
    codsolot_s2 operacion.solot.codsolot%type;
    cont1 number;
    numslc_max char(10);
    no_existe_sot exception;

 begin

    begin
      ln_codsolot_max := operacion.pq_sga_iw.f_max_sot_x_cod_id(p_cod_id);

      if ln_codsolot_max = 0 then
        raise no_existe_sot;
      end if;

      select s.customer_id, s.numslc
        into customer_id_max, numslc_max
        from solot s
       where s.codsolot = ln_codsolot_max;

    exception
      when no_existe_sot then
        raise_application_error(-20000,
                                'No existe SOT de alta para el : ' ||
                                p_cod_id);
      when no_data_found then
        raise_application_error(-20000,
                                'No se encuentra datos en la solot para el cod_id: ' ||
                                p_cod_id);
    end;

    select count(0) into cont1
    from sales.sot_siac s1
    where s1.cod_id = p_cod_id;

    if cont1 > 0 then

       select max(s1.codsolot) into codsolot_s1
       from sales.sot_siac s1
       where s1.cod_id=p_cod_id;

       if(ln_codsolot_max <> codsolot_s1)then
           insert into sales.sot_siac(cod_id, codsolot,cod_error,msg_error,customer_id)
           values(p_cod_id,ln_codsolot_max,0,'Transaccion ejecutada correctamente.',customer_id_max);
       end if;

    else
       begin
         select s2.codsolot into codsolot_s2
         from sales.sot_sisact s2
         where s2.cod_id=p_cod_id;
       exception
         when no_data_found then
           insert into sales.sot_sisact(cod_id, codsolot, numslc)
           values(p_cod_id,ln_codsolot_max,numslc_max);
       end;

       if(ln_codsolot_max <> codsolot_s2)then
          insert into sales.sot_siac(cod_id, codsolot,cod_error,msg_error,customer_id)
          values(p_cod_id,ln_codsolot_max,0,'Transaccion ejecutada correctamente.',customer_id_max);
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
           v.idpaq
      into l_detalle_vtadetptoenl
      from solot t, vtadetptoenl v
     where (t.codsolot = ln_codsolot_max)
       and t.numslc = v.numslc
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
  function get_codsrv return tystabsrv.codsrv%type is
    l_codsrv tystabsrv.codsrv%type;

  begin
    select d.codigoc
      into l_codsrv
      from tipopedd c, opedd d
     where c.abrev = 'DECO_ADICIONAL'
       and c.tipopedd = d.tipopedd
       and d.abreviacion = 'CODSRV';

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

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' ||
                              'aplicar_cambio(p_val_err => ' ||
                              p_val_err || ') ' || sqlerrm);

  end;
  --------------------------------------------------------------------------------
  --INI 9.0
  FUNCTION SGAFUN_OBT_MONTO_OCC(K_TIPO NUMBER) RETURN VARCHAR2 IS
    v_monto_occ VARCHAR2(20);
  BEGIN
    IF K_TIPO = 1 THEN
      SELECT a.codigoc
        INTO v_monto_occ
        FROM opedd a, tipopedd b
       WHERE a.tipopedd = b.tipopedd
         AND b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
         AND a.abreviacion = 'MONT_OCC';
    ELSIF K_TIPO = 2 THEN
      SELECT a.codigoc
        INTO v_monto_occ
        FROM opedd a, tipopedd b
       WHERE a.tipopedd = b.tipopedd
         AND b.abrev = 'HFC_SIAC_DEC_ADICIONAL'
         AND a.abreviacion = 'MONTB_OCC';
    --10.0 Ini
    ELSIF K_TIPO = 3 THEN
      SELECT a.codigoc
        INTO v_monto_occ
        FROM opedd a, tipopedd b
       WHERE a.tipopedd = b.tipopedd
         AND b.abrev = 'WLL_SIAC_DEC_ADICIONAL'
         AND a.abreviacion = 'MONT_OCC_ALTA';
    --10.0 Fin
    END IF;
    RETURN v_monto_occ;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;
  --FIN 9.0
  --------------------------------------------------------------------------------

  PROCEDURE sp_atender_baja_deco(p_idtareawf tareawf.idtareawf%TYPE,
                                 p_idwf      tareawf.idwf%TYPE,
                                 p_tarea     tareawf.tarea%TYPE,
                                 p_tareadef  tareawf.tareadef%TYPE) IS

    c_sot_est_eje      CONSTANT NUMBER(2) := 17;
    c_wf_baja_deco     CONSTANT NUMBER := 1251;
    c_wf_est_cancel    CONSTANT NUMBER := 5;
    c_sot_est_atendida CONSTANT NUMBER := 29;

    ln_sot solot.codsolot%TYPE;
  BEGIN

    SELECT DISTINCT wf.codsolot
      INTO ln_sot
      FROM wf wf, solot s
     WHERE wf.idwf = p_idwf
       AND wf.codsolot = s.codsolot
       AND s.estsol = c_sot_est_eje
       AND wf.wfdef = c_wf_baja_deco
       AND wf.estwf NOT IN (c_wf_est_cancel);

    operacion.pq_solot.p_chg_estado_solot(ln_sot, c_sot_est_atendida);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT ||
                              '.sp_atender_baja_deco(p_idtareawf => ' ||
                              p_idtareawf || ', p_idwf => ' || p_idwf ||
                              ', p_tarea => ' || p_tarea ||
                              ', p_tareadef => ' || p_tareadef || ') ' ||
                              SQLERRM);
  END;
end;
/
