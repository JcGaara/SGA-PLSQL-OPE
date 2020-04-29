CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SIAC_CAMBIO_PLAN IS

  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SIAC_CAMBIO_PLAN
  PROPOSITO:  Generacion de cambio de plan

  REVISIONES:
   Version   Fecha          Autor            Solicitado por      Descripcion
   -------- ----------  ------------------   -----------------   ------------------------
   1.0      06/01/2013   Alex Alamo           Hector Huaman       Generar Cambio de Plan
                         Eustaquio Gibaja
                         Mauro Zegarra
   2.0      2014-01-30   Carlos Chamache      Hector Huaman       Creacion de Servicios POST-VENTA
   3.0      2014-02-10   Lady Curay           Hector Huaman       Creacion de Servicios POST-VENTA 2.0
   4.0      2014-03-24   Carlos Chamache      Hector Huaman       Registrar cantidad de Equipos
   5.0      2014-04-08   Carlos Chamache      Hector Huaman       Registrar observacion en solot
   6.0      2014-07-21   Alex Alamo           Hector Huaman       modificar Proceso Cambio de Plan
   7.0      2014-08-14   Hector Huaman        Hector Huaman       Registro y consulta contrato cambio de plan
   8.0      2014-08-25   Hector Huaman        Hector Huaman       Correci?n al proceso de actualizaci?n de contrato
   9.0      2015-06-16   Rosa Facundo         Hector Huaman       Cambio de Plan
  10.0      2015-07-09   Freddy Gonzales      Hector Huaman       SD-335922 SOTs con direcci?n errada
  11.0      2015-08-28   Fernando Loza        Hector Huaman       SD 318447 Error cambio de plan, traslado interno/externo
                                            Correccion de get_cntcli y agregar EXCEPTIONs
  12.0      2015-11-05   Fernando Loza        Hector Huaman       SD-522935
  13.0      2015-12-22   Fernando Loza        Karen Velezmoro     SD-522935
  14.0      2016-04-01                                            SD-642508 Cambio de Plan
  15.0      2016-04-28   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
  16.0      2016-07-20   Dorian Sucasaca      jessica villena     SD_795618
  17.0      2016-12-14   Servicio Fallas-HITSS                    SD1045894 - Problemas para generaci?n BAJA Para EL 2do Cambio de plan
  18.0      2017-05-02   Servicio Fallas-HITSS                    INC000000693947
  19.0      2017-06-20   Felipe Maguina        Tito Huertas       PROY-27792
  20.0      2018-07-06   Servicio Fallas-HITSS                    INC000001165159
  21.0      2018-07-06   Luis Flores           Luis Flores        PROY-32581
  22.0      2019-02-11   Luis Flores           Luis Flores        PROY-32581:: PostVenta :: Cambio de Plan HFC
  23.0      2019-03-14   Luis Flores           Luis Flores        PROY-32581:: PostVenta :: Cambio de Plan HFC
  24.0      2019-04-04   Luis Flores           Luis Flores        PROY-32581:: PostVenta :: Cambio de Plan HFC
  /************************************************************************************************/
  --<INI 2.0>
  /*
  PROCEDURE execute_main(p_services VARCHAR2,
                         p_equipos  VARCHAR2,
                         p_cod_id    sales.sot_sisact.cod_id%TYPE,
                         p_precon    precon_type) IS
  */
  PROCEDURE execute_main(p_id sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE,
                         --p_servicios servicios_type,--3.0
                         p_cod_id sales.sot_sisact.cod_id%TYPE,
                         p_precon precon_type) IS
    --<FIN 2.0>

    l_services  services_type;
    l_servicios servicios_type;
    vidconsulta varchar2(20);
    vobs varchar2(100);
    v_anotacion operacion.siac_postventa_proceso.anotacion_toa%type;
    vcount number;
    l_idx       NUMBER := 0; --3.0
    --<INI 3.0>
    lv_msgerror operacion.postventasiac_log.msgerror%type;
    CURSOR servicios IS
      SELECT t.*
        FROM sales.sisact_postventa_det_serv_hfc t
       WHERE t.idinteraccion = p_id;

  ln_error number; --21.0
    lv_error operacion.postventasiac_log.msgerror%type; --21.0
    ld_fec_prog  date; --22.0

  BEGIN

       BEGIN
        SELECT INSTR(p_precon.obsaprofe, '|',1,1)
            INTO VCOUNT
           FROM DUAL;

             IF VCOUNT > 0 THEN
     SELECT NVL(SUBSTR(p_precon.obsaprofe,1,INSTR(p_precon.obsaprofe, '|',1,1)-1), ''),
              NVL(SUBSTR(p_precon.obsaprofe,INSTR(p_precon.obsaprofe, '|',1,1)+1,INSTR(p_precon.obsaprofe, '|',1,2) - INSTR(p_precon.obsaprofe, '|',1,1) -1 ), ''),
              NVL(SUBSTR(p_precon.obsaprofe,INSTR(p_precon.obsaprofe, '|',1,2)+1,LENGTH(p_precon.obsaprofe) ), '')
         INTO vobs,
            vidconsulta,
            v_anotacion
       FROM DUAL;
         END IF;

       EXCEPTION WHEN OTHERS THEN
                vidconsulta :='';
                v_anotacion :='';
        END;

    FOR srv IN servicios LOOP

      l_idx := l_idx + 1;

      l_servicios(l_idx).servicio := srv.servicio;
      l_servicios(l_idx).idgrupo_principal := srv.idgrupo_principal;
      l_servicios(l_idx).idgrupo := srv.idgrupo;
      l_servicios(l_idx).cantidad_instancia := srv.cantidad_instancia;
      l_servicios(l_idx).dscsrv := srv.dscsrv;
      l_servicios(l_idx).bandwid := srv.bandwid;
      l_servicios(l_idx).flag_lc := srv.flag_lc;
      l_servicios(l_idx).cantidad_idlinea := srv.cantidad_idlinea;
      --<ini 4.0>
      --l_servicios(l_idx).tipequ := srv.tipequ;
      IF TRIM(srv.tipequ) = '0' OR LENGTH(TRIM(srv.tipequ)) = 0 THEN
        l_servicios(l_idx).tipequ := NULL;
      ELSE
        l_servicios(l_idx).tipequ := srv.tipequ;
      END IF;

      --l_servicios(l_idx).codtipequ := srv.codtipequ;
      IF TRIM(srv.codtipequ) = '0' OR LENGTH(TRIM(srv.codtipequ)) = 0 THEN
        l_servicios(l_idx).codtipequ := NULL;
      ELSE
        l_servicios(l_idx).codtipequ := srv.codtipequ;
      END IF;
      --<fin 4.0>
      l_servicios(l_idx).cantidad := srv.cantidad;
      l_servicios(l_idx).dscequ := srv.dscequ;
      l_servicios(l_idx).codigo_ext := srv.codigo_ext;

    END LOOP;
    --<FIN 3.0>

  --INI 21.0
  SGASS_VAL_EQUIPOXSERV(p_id, ln_error, lv_error);
    if ln_error != 1 then
      p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_error);
      RAISE_APPLICATION_ERROR(-20000,
                              lv_error);
    end if;
  --FIN 21.0

    --p_servicios := l_servicios(l_idx);
    --<INI 2.0>
    --l_services := get_services(p_services, p_equipos);
    l_services := get_services(l_servicios); --3.0

    update_negocio_proceso(l_services);
    --<FIN 2.0>

    g_cod_id := p_cod_id;

    --crear cabecera de venta menor
    create_regvtamentab(p_cod_id);

    --crear detalle de venta menor
    create_sales_detail(l_services);
    --fin instancias propias de la venta menor

    --crear cabecera de venta
    generar_sef(g_numregistro);

    --crear detalle de venta
    --<ini 5.0>
    --generar_ptoenl_cambio(g_numregistro, g_numslc_new);
    generar_ptoenl_cambio(g_numregistro, g_numslc_new, p_precon);
    --<fin 5.0>
    update_numslc_new();

    create_reginsprdbaja(g_numslc_old,p_cod_id); --6.0

    load_instancia_cambio(g_numslc_new);

    create_vtatabprecon(g_numslc_new, p_precon);
    --fin de instancias necesarias para el cambio de plan
    --COMMIT;  --6.0

    --inicio proceso analogo a "Verificar Proyecto"
    validar_tiposolucion(g_numslc_new);

    IF validar_checkproy(g_numslc_new) <> 'OK' THEN
      RAISE_APPLICATION_ERROR(-20000, 'ERROR AL VERIFICAR PROYECTO DE VENTA');
    END IF;

    sales.pkg_etadirect.actualizar_etadirect_req(vidconsulta, g_numslc_new);


    IF proyecto_preventa(g_numslc_new) <> 1 THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'ERROR EN LA INTERFAZ VENTAS/OPERACIONES');
    END IF;

    --actualiza_co_id(g_numslc_new,p_cod_id); --6.0 17.0
    -- PROY-31513
    IF length(TRIM(nvl(v_Anotacion,'')))>0 THEN
      IF SGAFUN_ACTUALIZA_ANOTACION(V_ANOTACION,g_codsolot,OPERACION.PQ_SIAC_POSTVENTA.g_idprocess)<>'OK' THEN
       lv_msgerror := $$plsql_unit || '.' || 'EXECUTE_MAIN.SGAFUN_ACTUALIZA_ANOTACION: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';
       p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
      END IF;
    END IF;
    --
    COMMIT;

    -- ini 22.0
    begin
       begin
         select distinct t.fecha_compromiso
         into ld_fec_prog
          from sales.etadirect_sel t
         where t.id_consulta = to_number(vidconsulta);
       exception
         when others then
           null;
           ld_fec_prog := null;
           lv_msgerror := '(AGENDA)Error al obtener fecha de compromiso';
           p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
       end;

       if ld_fec_prog is not null then
         update operacion.parametro_vta_pvta_adc t
         set t.fecha_progra = ld_fec_prog
         where t.codsolot = g_codsolot;
         commit;
       else
         lv_msgerror := '(AGENDA)Error al obtener fecha de compromiso (NULL)';
         p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
       end if;

    exception
      when others then
        null;
    end;
    -- fin 22.0

    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'EXECUTE_MAIN: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);

       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.EXECUTE_MAIN: ' || sqlerrm);
    --Fin 13.0
  END;
  --<INI 2.0>
  /* **********************************************************************************************/
  FUNCTION list_servicios(p_services_type services_type) RETURN VARCHAR2 IS
    l_list_servicios VARCHAR2(200);
    l_count_lineas   PLS_INTEGER;
    l_first_srv      BOOLEAN;
    /* *********************************/
    FUNCTION is_servicio(p_idlinea sales.linea_paquete.idlinea%TYPE)
      RETURN BOOLEAN IS
      l_count_srv PLS_INTEGER;

    BEGIN
      SELECT COUNT(*)
        INTO l_count_srv
        FROM sales.linea_paquete l
       INNER JOIN sales.servicio_sisact s
          ON l.codsrv = s.codsrv
         AND l.idlinea = p_idlinea;

      IF l_count_srv > 0 THEN
        RETURN TRUE;
      END IF;

      RETURN FALSE;
    END;
    /* *********************************/
    FUNCTION get_idservicio_sisact(p_idlinea sales.linea_paquete.idlinea%TYPE)
      RETURN sales.servicio_sisact.idservicio_sisact%TYPE IS
      l_idservicio_sisact sales.servicio_sisact.idservicio_sisact%TYPE;

    BEGIN
      SELECT s.idservicio_sisact
        INTO l_idservicio_sisact
        FROM sales.linea_paquete l
       INNER JOIN sales.servicio_sisact s
          ON l.codsrv = s.codsrv
         AND l.idlinea = p_idlinea;

      RETURN l_idservicio_sisact;
    END;
    /* *********************************/
  BEGIN
    l_count_lineas := p_services_type.first;
    l_first_srv    := TRUE;

    IF l_count_lineas < 1 THEN
      RETURN NULL;
    END IF;

    FOR idx IN p_services_type.first .. p_services_type.last LOOP
      IF is_servicio(p_services_type(idx).idlinea) THEN
        IF l_first_srv THEN
          l_list_servicios := get_idservicio_sisact(p_services_type(idx).idlinea);
          l_first_srv      := FALSE;
        ELSE
          l_list_servicios := l_list_servicios || ';' ||
                              get_idservicio_sisact(p_services_type(idx).idlinea);
        END IF;
      END IF;
    END LOOP;

    RETURN l_list_servicios;

    --<<ini 11.0>>

    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'get_idservicio_sisact: ' || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  FUNCTION list_equipos(p_services_type services_type) RETURN VARCHAR2 IS
    l_list_equipos VARCHAR2(200);
    l_count_lineas PLS_INTEGER;
    l_first_equ    BOOLEAN;
    /* *********************************/
    FUNCTION is_equipo(p_idlinea sales.linea_paquete.idlinea%TYPE) RETURN BOOLEAN IS
      l_count_equ PLS_INTEGER;

    BEGIN
      SELECT COUNT(*)
        INTO l_count_equ
        FROM sales.linea_paquete l
       INNER JOIN sales.equipo_sisact e
          ON l.idlinea = e.idlinea
         AND l.idlinea = p_idlinea;

      IF l_count_equ > 0 THEN
        RETURN TRUE;
      END IF;

      RETURN FALSE;
    END;
    /* *********************************/
    FUNCTION get_tipequ_grupo(p_idlinea sales.linea_paquete.idlinea%TYPE)
      RETURN VARCHAR2 IS
      l_tipequ_grupo VARCHAR2(200);
      l_tipequ       sales.equipo_sisact.tipequ%TYPE;
      l_grupo        sales.equipo_sisact.grupo%TYPE;

    BEGIN
      SELECT e.tipequ, e.grupo
        INTO l_tipequ, l_grupo
        FROM sales.linea_paquete l
       INNER JOIN sales.equipo_sisact e
          ON l.idlinea = e.idlinea
         AND l.idlinea = p_idlinea;

      l_tipequ_grupo := l_tipequ || '|' || l_grupo;

      RETURN l_tipequ_grupo;
    END;
    /* *********************************/
  BEGIN
    l_count_lineas := p_services_type.first;
    l_first_equ    := TRUE;

    IF l_count_lineas < 1 THEN
      RETURN NULL;
    END IF;

    FOR idx IN p_services_type.first .. p_services_type.last LOOP
      IF is_equipo(p_services_type(idx).idlinea) THEN
        IF l_first_equ THEN
          l_list_equipos := get_tipequ_grupo(p_services_type(idx).idlinea);
          l_first_equ    := FALSE;
        ELSE
          l_list_equipos := l_list_equipos || ';' ||
                            get_tipequ_grupo(p_services_type(idx).idlinea);
        END IF;
      END IF;
    END LOOP;

    RETURN l_list_equipos;

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'get_tipequ_grupo: ' || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  PROCEDURE update_negocio_proceso(p_services_type services_type) IS
    l_list_servicios VARCHAR2(200);
    l_list_equipos   VARCHAR2(200);

  BEGIN
    l_list_servicios := list_servicios(p_services_type);
    l_list_equipos   := list_equipos(p_services_type);

    UPDATE operacion.siac_postventa_proceso p
       SET p.lst_sncode = l_list_servicios, p.lst_tipequ = l_list_equipos
     WHERE p.idprocess = operacion.pq_siac_postventa.g_idprocess;

    --<<ini 11.0>>
      EXCEPTION
      WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
      $$PLSQL_UNIT || '.' || 'update_negocio_proceso' || SQLERRM);
    --<<fin 11.0>>
  END;
  --<FIN 2.0>
  /* **********************************************************************************************/
  FUNCTION get_codsolot RETURN solot.codsolot%TYPE IS
    l_codsolot solot.codsolot%TYPE;

  BEGIN
    SELECT t.codsolot
      INTO l_codsolot
      FROM solot t
     WHERE t.numslc = g_numslc_new;

    RETURN l_codsolot;
     --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.get_codsolot: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  PROCEDURE create_regvtamentab(p_cod_id sales.sot_sisact.cod_id%TYPE) IS
    l_inssrv inssrv%ROWTYPE;
    l_cntcli vtatabcntcli%ROWTYPE;
    l_slcfac vtatabslcfac%ROWTYPE;
    l_regmen regvtamentab%ROWTYPE;

    lv_msgerror operacion.postventasiac_log.msgerror%type;
  BEGIN
    g_cod_id := p_cod_id;

    l_inssrv     := get_inssrv(g_cod_id);
    l_cntcli     := get_cntcli(g_cod_id);
    l_slcfac     := get_slcfac(g_cod_id);
    g_numslc_old := l_slcfac.numslc;

    l_regmen.codcli         := l_inssrv.codcli;
    l_regmen.fecpedsol      := SYSDATE;
    l_regmen.codsol         := '00035885';
    l_regmen.srvpri         := 'PYMES - Servicios Complementarios';
    l_regmen.obssolfac      := 'Tipo de Venta: Cambio de Plan';
    l_regmen.codsucori      := l_inssrv.codsuc;
    l_regmen.descptoori     := l_inssrv.descripcion;
    l_regmen.dirptoori      := l_inssrv.direccion;
    l_regmen.ubiptoori      := l_inssrv.codubi;
    l_regmen.codcnt         := l_cntcli.codcnt;
    l_regmen.nomcnt         := l_cntcli.nomcnt;
    l_regmen.tipcnt         := l_cntcli.tipcnt;
    l_regmen.idpaq          := l_inssrv.idpaq;
    l_regmen.tipsrv         := l_slcfac.tipsrv;
    l_regmen.moneda_id      := l_slcfac.moneda_id;
    l_regmen.plazo_srv      := l_slcfac.plazo_srv;
    l_regmen.idsolucion     := l_slcfac.idsolucion;
    l_regmen.idcampanha     := l_slcfac.idcampanha;
    l_regmen.prec_rec       := 0.0000;
    l_regmen.prec_norec     := 0.0000;
    l_regmen.numslc_ori     := l_slcfac.numslc;
    l_regmen.tipsrv_des     := l_slcfac.tipsrv;
    l_regmen.idsolucion_des := l_slcfac.idsolucion;
    l_regmen.idcampanha_des := l_slcfac.idcampanha;
    --default
    l_regmen.codusu              := USER;
    l_regmen.fecusu              := SYSDATE;
    l_regmen.idprioridad         := 3;
    l_regmen.tippro              := 0;
    l_regmen.flgcategoria        := 0;
    l_regmen.flgpryesp           := 0;
    l_regmen.tipo                := 0;
    l_regmen.flgcban             := 0;
    l_regmen.flgcequ             := 0;
    l_regmen.derivado            := 0;
    l_regmen.flgcove             := 0;
    l_regmen.genfacpex           := '1';
    l_regmen.genfacpin           := '1';
    l_regmen.pcflg_transferencia := '0';
    l_regmen.genfactel           := '0';
    l_regmen.genfacisp           := '0';

    g_numregistro := insert_regvtamentab(l_regmen);
    set_instance('NUMREGISTRO', g_numregistro);
    -- ini 13.0
    EXCEPTION
      WHEN OTHERS THEN

       lv_msgerror := $$plsql_unit || '.' || 'CREATE_REGVTAMENTAB: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);

       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.CREATE_REGVTAMENTAB: ' || sqlerrm);
    -- fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION insert_regvtamentab(p_regmen regvtamentab%ROWTYPE)
    RETURN regvtamentab.numregistro%TYPE IS
    l_numregistro regvtamentab.numregistro%TYPE;

  BEGIN
    INSERT INTO regvtamentab
    VALUES p_regmen
    RETURNING numregistro INTO l_numregistro;

    RETURN l_numregistro;
    -- Ini 6.0
    EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'create_vtatabprecon' || SQLERRM);
    -- Fin 6.0
  END;
  /* **********************************************************************************************/
  PROCEDURE create_vtatabprecon(p_numslc vtatabslcfac.numslc%TYPE,
                                p_precon precon_type) IS
    l_precon vtatabprecon%ROWTYPE;
    C_PERU            CONSTANT vtatabprecon.codpai%TYPE := '51 ';
    C_CANALES_AGENTES CONSTANT vtatabmotivo_venta.codmotivo%TYPE := '009';
    C_CAMBIO_DE_PLAN  CONSTANT vtatabmotivo_venta.codmotivo%TYPE := '034';
    C_BCP             CONSTANT vtatabprecon.codban%TYPE := '007';
    C_GRABACION       CONSTANT vtatipdocofe.tipdoc%TYPE := '08';
    lv_msgerror       operacion.postventasiac_log.msgerror%type;

  BEGIN
    l_precon.numslc            := p_numslc;
    l_precon.nrodoc            := p_numslc;
    l_precon.tipdoc            := C_GRABACION;
    l_precon.fecace            := SYSDATE;
    l_precon.fecrec            := SYSDATE;
    l_precon.fecaplcom         := SYSDATE;
    l_precon.codmodelo         := 0;
    l_precon.codpai            := C_PERU;
    l_precon.flag_factxsegundo := 0;
    l_precon.flag_factxminuto  := 1;
    l_precon.codsucfac         := '';
    l_precon.codmotivo         := 1;
    l_precon.codcli            := get_codcli();
    l_precon.codmotivo_lv      := C_CANALES_AGENTES;
    l_precon.codmotivo_tc      := C_CAMBIO_DE_PLAN;
    l_precon.codban            := C_BCP;
    l_precon.obsaprofe         := p_precon.obsaprofe;
    l_precon.carta             := p_precon.carta;
    l_precon.carrier           := p_precon.carrier;
    l_precon.presusc           := p_precon.presusc;
    l_precon.publicar          := p_precon.publicar;
    --default
    l_precon.codusu      := USER;
    l_precon.fecusu      := SYSDATE;
    l_precon.feccodemail := SYSDATE;
    l_precon.flg_presusc := 0;

    INSERT INTO vtatabprecon VALUES l_precon;
    -- Ini 6.0
    EXCEPTION
      WHEN OTHERS THEN
        lv_msgerror := $$plsql_unit || '.' || 'CREATE_VTATABPRECON: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

        p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' || 'create_vtatabprecon' || SQLERRM);
    -- Fin 6.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_codcli RETURN vtatabcli.codcli%TYPE IS
    l_codcli vtatabcli.codcli%TYPE;

  BEGIN
   select distinct v.codcli
       into l_codcli
       from sales.v_sales_postventa_siac t, vtatabcli v
      where t.cod_id = g_cod_id
        and t.codcli = v.codcli;

     RETURN l_codcli;
  END;
  /* **********************************************************************************************/
  PROCEDURE update_numslc_new IS
  BEGIN
    UPDATE regvtamentab
       SET numslc = g_numslc_new
     WHERE numregistro = g_numregistro;

    UPDATE instancia_paquete_cambio
       SET numslc = g_numslc_new
     WHERE numregistro = g_numregistro;

    UPDATE regdetptoenlcambio
       SET numslc = g_numslc_new
     WHERE numregistro = g_numregistro;
    -- ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.UPDATE_NUMSLC_NEW: ' || sqlerrm);
    -- fin 13.0
  END;
  /* **********************************************************************************************/
  -- Ini 6.0
  PROCEDURE create_reginsprdbaja(p_numslc vtatabslcfac.numslc%TYPE,p_cod_id sales.sot_sisact.cod_id%TYPE) IS
    C_ACTIVO     CONSTANT inssrv.estinssrv%TYPE := 1;
    C_SUSPENDIDO CONSTANT inssrv.estinssrv%TYPE := 2;
    C_PENDIENTE_X_ACTIVAR CONSTANT inssrv.estinssrv%TYPE := 4; -- 6.0
    lv_msgerror  operacion.postventasiac_log.msgerror%type;

  BEGIN
    INSERT INTO SALES.reginsprdbaja
      (pid, numregistro, numslc, codinssrv)
      SELECT distinct p.pid, g_numregistro, p_numslc, p.codinssrv
        FROM inssrv s, insprd p, solotpto pto
        WHERE s.codinssrv = p.codinssrv
          AND pto.codinssrv = s.codinssrv
          AND s.numslc = p_numslc
          AND pto.codsolot = operacion.pq_siac_postventa.f_max_sot_siac_sisact(p_cod_id)
          AND p.estinsprd IN (C_ACTIVO, C_SUSPENDIDO,C_PENDIENTE_X_ACTIVAR)
          AND p.fecfin IS NULL;

    EXCEPTION  -- 6.0
      WHEN OTHERS THEN  -- 6.0
        lv_msgerror := $$plsql_unit || '.' || 'CREATE_REGINSPRDBAJA: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

        p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
        RAISE_APPLICATION_ERROR(-20000,  -- 6.0
                                $$PLSQL_UNIT || '.' || 'create_reginsprdbaja' || SQLERRM);  -- 6.0

  END;  -- Fin 6.0
  /* **********************************************************************************************/
  PROCEDURE create_sales_detail(p_services services_type) IS
    l_inssrv      inssrv%ROWTYPE;
    l_idsecuencia instancia_paquete_cambio.idsecuencia%TYPE;
    l_numpto      vtadetptoenl.numpto%TYPE;
    l_idinsxpaq   instancia_paquete_cambio.idinsxpaq%TYPE;
    lv_msgerror   operacion.postventasiac_log.msgerror%type;
  BEGIN
    l_inssrv    := get_inssrv(g_cod_id);
    l_idinsxpaq := get_idinsxpaq();
    FOR idx IN p_services.FIRST .. p_services.LAST LOOP
      l_idsecuencia := create_instancia_paquete_cambi(l_idinsxpaq,
                                                      p_services(idx).idlinea,
                                                      g_numregistro,
                                                      l_inssrv.codsuc);

      l_numpto := LPAD(idx, 5, '0');
      create_regdetptoenlcambio(l_idsecuencia,
                                p_services(idx).idlinea,
                                p_services(idx).cantidad,--<4.0>
                                l_numpto,
                                l_idinsxpaq);
    END LOOP;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'CREATE_SALES_DETAIL: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);

       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.create_sales_detail: ' || sqlerrm);
    --fin 13.0
  END;
  /* **********************************************************************************************/
  --<INI 2.0>
  FUNCTION get_linea(p_servicio servicio_type)
    RETURN sales.linea_paquete.idlinea%TYPE IS
    l_idlinea sales.linea_paquete.idlinea%TYPE;

  BEGIN
    --BUSCAR EQUIPO
    IF p_servicio.tipequ IS NOT NULL AND p_servicio.idgrupo IS NOT NULL THEN
      l_idlinea := get_idlinea_equipo(p_servicio.tipequ, p_servicio.idgrupo);
    END IF;

    --BUSCAR SERVICIO
    IF p_servicio.tipequ IS NULL THEN
      l_idlinea := get_idlinea_service(p_servicio.servicio);
    END IF;

    RETURN l_idlinea;
    -- ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.get_linea: ' || sqlerrm);
    --fin 13.0
  END;

    --Ini 6.0
  PROCEDURE actualiza_co_id(g_numslc_new vtatabslcfac.numslc%TYPE,
                            p_cod_id     inssrv.co_id%TYPE) IS

  BEGIN
    UPDATE inssrv SET co_id = p_cod_id WHERE numslc = g_numslc_new;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.actualiza_co_id: ' || sqlerrm);
    --fin 13.0
  END;
  --FIN 6.0

  /* **********************************************************************************************/
  FUNCTION fill_new_services(p_services      services_type,
                             p_new_servicios servicios_type) RETURN services_type IS
    l_count_srv PLS_INTEGER;
    l_services  services_type;
    l_lineas    idlineas_type;

  BEGIN
    insert_servicios(p_new_servicios, l_lineas);

    l_services  := p_services;
    l_count_srv := TO_NUMBER(l_services.last) + 1;

    FOR l IN l_lineas.FIRST .. l_lineas.LAST LOOP
      l_services(l_count_srv).idlinea := l_lineas(l).idlinea;
      l_services(l_count_srv).cantidad := l_lineas(l).cantidad; --<4.0>
      l_count_srv := l_count_srv + 1;

    END LOOP;

    RETURN l_services;

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'fill_new_services: ' || sqlerrm);
    --<<fin 11.0>>
  END;
  /* **********************************************************************************************/
  --FUNCTION get_services(p_services VARCHAR2, p_equipos VARCHAR2)
  FUNCTION get_services(p_servicios servicios_type)
  --<FIN 2.0>
   RETURN services_type IS
    --<INI 2.0>
    l_first_servicio PLS_INTEGER;
    l_count_srv      PLS_INTEGER;
    l_count_new_srv  PLS_INTEGER;
    l_idlinea        sales.linea_paquete.idlinea%TYPE;
    l_new_services   servicios_type;
    /*
    l_rows      NUMBER;
    l_string    VARCHAR2(32767);
    l_pointer   PLS_INTEGER := 1;
    l_idx       PLS_INTEGER;
    l_delimiter NUMBER;
    l_service   VARCHAR2(10);
    l_record    VARCHAR2(4000);
    */
    --<FIN 2.0>
    l_services services_type;

  BEGIN
    --<INI 2.0>
    /*
    --loop services
    l_rows   := row_count(p_services);
    l_string := p_services || ';';
    FOR idx IN 1 .. l_rows LOOP
      l_delimiter := INSTR(l_string, ';', 1, idx);
      l_service := SUBSTR(l_string, l_pointer, l_delimiter - l_pointer);
      l_services(idx).idlinea := get_idlinea_service(l_service);

      l_pointer := l_delimiter + 1;
      l_idx     := idx;
    END LOOP;
    l_idx := l_idx + 1;

    --loop hardware
    l_rows    := row_count(p_equipos);
    l_string  := p_equipos || ';';
    l_pointer := 1;
    FOR idx IN 1 .. l_rows LOOP
      l_delimiter := INSTR(l_string, ';', 1, idx);
      l_record := SUBSTR(l_string, l_pointer, l_delimiter - l_pointer);
      l_services(l_idx).idlinea := get_idlinea_equipo(l_record);

      l_pointer := l_delimiter + 1;
      l_idx     := l_idx + 1;
    END LOOP;
    */

    l_count_srv      := 1;
    l_count_new_srv  := 1;
    l_first_servicio := TO_NUMBER(p_servicios.first);

    IF l_first_servicio IS NOT NULL OR l_first_servicio > 0 THEN
      FOR l IN p_servicios.FIRST .. p_servicios.LAST LOOP

        l_idlinea := get_linea(p_servicios(l));

        IF l_idlinea IS NOT NULL THEN
          l_services(l_count_srv).idlinea := l_idlinea;
          l_services(l_count_srv).cantidad := p_servicios(l).cantidad; --<4.0>
          l_count_srv := l_count_srv + 1;

        END IF;

        IF l_idlinea IS NULL THEN
          l_new_services(l_count_new_srv) := p_servicios(l);
          l_count_new_srv := l_count_new_srv + 1;
        END IF;

      END LOOP;
    END IF;

    IF l_new_services.first > 0 THEN
      l_services := fill_new_services(l_services, l_new_services);
    END IF;
    --<FIN 2.0>

    RETURN l_services;

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'get_services: ' || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  FUNCTION get_idlinea_equipo(p_record VARCHAR2)
    RETURN linea_paquete.idlinea%TYPE IS
    l_delimiter PLS_INTEGER;
    l_tipequ    tipequ.tipequ%TYPE;
    l_idgrupo   sales.grupo_sisact.idgrupo_sisact%TYPE;

  BEGIN
    l_delimiter := INSTR(p_record, '|');
    l_tipequ    := SUBSTR(p_record, 1, l_delimiter - 1);
    l_idgrupo   := SUBSTR(p_record, l_delimiter + 1);

    RETURN get_idlinea_equipo(l_tipequ, l_idgrupo);

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'get_idlinea_equipo: ' || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  FUNCTION get_idlinea_equipo(p_tipequ  tipequ.tipequ%TYPE,
                              p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE IS
    l_idlinea linea_paquete.idlinea%TYPE;

  BEGIN
    SELECT t.idlinea
      INTO l_idlinea
      FROM sales.equipo_sisact t
     WHERE t.tipequ = p_tipequ
       AND t.grupo = p_idgrupo;

    RETURN l_idlinea;

  EXCEPTION
    --<INI 2.0>
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
      --<FIN 2.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'get_idlinea_equipo: ' ||
                              'p_tipequ = ' || p_tipequ || ' p_idgrupo = ' ||
                              p_idgrupo || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION create_instancia_paquete_cambi(p_idinsxpaq   regdetptoenlcambio.idinsxpaq%TYPE,
                                          p_idlinea     linea_paquete.idlinea%TYPE,
                                          p_numregistro regvtamentab.numregistro%TYPE,
                                          p_codsuc      vtasuccli.codsuc%TYPE)
    RETURN instancia_paquete_cambio.idsecuencia%TYPE IS
    l_servicio    detalle_servicio_type;
    l_sucursal    vtasuccli%ROWTYPE;
    l_inspaq      instancia_paquete_cambio%ROWTYPE;
    l_idsecuencia instancia_paquete_cambio.idsecuencia%TYPE;
  BEGIN
    l_servicio := get_detalle_servicio(p_idlinea);
    l_sucursal := get_sucursal(p_codsuc);

    l_inspaq.flgprincipal  := l_servicio.flgprincipal;
    l_inspaq.idproducto    := l_servicio.idproducto;
    l_inspaq.codsrv        := l_servicio.codsrv;
    l_inspaq.codequcom     := l_servicio.codequcom;
    l_inspaq.idprecio      := l_servicio.idprecio;
    l_inspaq.cantidad      := l_servicio.cantidad;
    l_inspaq.moneda_id     := l_servicio.moneda_id;
    l_inspaq.idpaq         := l_servicio.idpaq;
    l_inspaq.iddet         := l_servicio.iddet;
    l_inspaq.paquete       := l_servicio.paquete;
    l_inspaq.banwid        := l_servicio.banwid;
    l_inspaq.idinsxpaq     := p_idinsxpaq;
    l_inspaq.numregistro   := p_numregistro;
    l_inspaq.estcse        := 0.00;
    l_inspaq.estcts        := 0.00;
    l_inspaq.prelis_ins    := 0.00;
    l_inspaq.desc_ins      := 0.00;
    l_inspaq.porcimp_ins   := get_impuesto(1);
    l_inspaq.monto_ins     := 0.00;
    l_inspaq.monto_ins_imp := 0.00;
    l_inspaq.prelis_srv    := 0.00;
    l_inspaq.desc_srv      := 0.00;
    l_inspaq.porcimp_srv   := get_impuesto(1);
    l_inspaq.monto_srv     := 0.00;
    l_inspaq.monto_srv_imp := 0.00;
    l_inspaq.codsuc        := l_sucursal.codsuc;
    l_inspaq.descpto       := l_sucursal.nomsuc;
    l_inspaq.dirpto        := l_sucursal.dirsuc;
    l_inspaq.ubipto        := l_sucursal.ubisuc;
    l_inspaq.preuni_ins    := 0.00;
    l_inspaq.preuni_srv    := 0.00;
    l_inspaq.flg_tipo_vm   := 'CP';
    --default
    l_inspaq.fecusu     := SYSDATE;
    l_inspaq.codusu     := USER;
    l_inspaq.flgcontrol := 0;

    INSERT INTO instancia_paquete_cambio
    VALUES l_inspaq
    RETURNING idsecuencia INTO l_idsecuencia;

    RETURN l_idsecuencia;
   -- Ini 6.0
   EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'create_instancia_paquete_cambi' || SQLERRM);
   -- Fin 6.0
  END;
  /* **********************************************************************************************/
  PROCEDURE create_regdetptoenlcambio(p_idsecuencia instancia_paquete_cambio.idsecuencia%TYPE,
                                      p_idlinea     linea_paquete.idlinea%TYPE,
                                      p_cantidad    sales.vtadetptoenl.cantidad%TYPE, --<4.0>
                                      p_punto       vtadetptoenl.numpto%TYPE,
                                      p_idinsxpaq   regdetptoenlcambio.idinsxpaq%TYPE) IS
    l_servicio detalle_servicio_type;
    l_detalle  regdetptoenlcambio%ROWTYPE;
    l_inssrv   inssrv%ROWTYPE;

    lv_msgerror operacion.postventasiac_log.msgerror%type;
  BEGIN
    l_servicio := get_detalle_servicio(p_idlinea);

    l_inssrv := get_inssrv(g_cod_id);

    l_detalle.flgsrv_pri := l_servicio.flgprincipal;
    l_detalle.idproducto := l_servicio.idproducto;
    l_detalle.codsrv     := l_servicio.codsrv;
    l_detalle.codequcom  := l_servicio.codequcom;
    l_detalle.idprecio   := l_servicio.idprecio;
    --<ini 4.0>
    --l_detalle.cantidad      := l_servicio.cantidad;
    IF p_cantidad IS NULL THEN
      l_detalle.cantidad := 1;
    ELSE
      l_detalle.cantidad := p_cantidad;
    END IF;
    --<fin 4.0>
    l_detalle.moneda_id     := l_servicio.moneda_id;
    l_detalle.idpaq         := l_servicio.idpaq;
    l_detalle.iddet         := l_servicio.iddet;
    l_detalle.paquete       := l_servicio.paquete;
    l_detalle.tipo          := 1;
    l_detalle.banwid        := l_servicio.banwid;
    l_detalle.numregistro   := g_numregistro;
    l_detalle.numpto        := p_punto;
    l_detalle.descpto       := l_inssrv.descripcion;
    l_detalle.dirpto        := l_inssrv.direccion;
    l_detalle.ubipto        := l_inssrv.codubi;
    l_detalle.codsuc        := l_inssrv.codsuc;
    l_detalle.tipo_vta      := 1;
    l_detalle.crepto        := '1';
    l_detalle.estcts        := '0';
    l_detalle.estcse        := '0';
    l_detalle.prelis_srv    := 0.00;
    l_detalle.prelis_ins    := 0.00;
    l_detalle.desc_srv      := 0.00;
    l_detalle.desc_ins      := 0.00;
    l_detalle.monto_srv     := 0.00;
    l_detalle.monto_ins     := 0.00;
    l_detalle.porcimp_srv   := get_impuesto(1);
    l_detalle.porcimp_ins   := get_impuesto(1);
    l_detalle.monto_srv_imp := 0.00;
    l_detalle.monto_ins_imp := 0.00;
    --l_detalle.cantidad      := 1;--<4.0>
    l_detalle.flgredun    := 0;
    l_detalle.preuni_srv  := 0.00;
    l_detalle.preuni_ins  := 0.00;
    l_detalle.idinsxpaq   := p_idinsxpaq;
    l_detalle.idsecuencia := p_idsecuencia;
    l_detalle.estmt       := 0;
    l_detalle.flgpost     := 0;

    INSERT INTO regdetptoenlcambio VALUES l_detalle;
    -- Ini 6.0
    EXCEPTION
      WHEN OTHERS THEN
        lv_msgerror := $$plsql_unit || '.' || 'CREATE_REGDETPTOENLCAMBIO: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

        p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);

        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' || 'create_regdetptoenlcambio' || SQLERRM);
   -- Fin 6.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_detalle_servicio(p_idlinea linea_paquete.idlinea%TYPE)
    RETURN detalle_servicio_type IS
    l_servicio detalle_servicio_type;

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
      INTO l_servicio.flgprincipal,
           l_servicio.idproducto,
           l_servicio.codsrv,
           l_servicio.codequcom,
           l_servicio.idprecio,
           l_servicio.cantidad,
           l_servicio.moneda_id,
           l_servicio.idpaq,
           l_servicio.iddet,
           l_servicio.paquete,
           l_servicio.banwid
      FROM linea_paquete b, detalle_paquete a, tystabsrv s, define_precio c
     WHERE b.idlinea = p_idlinea
       AND b.flgestado = 1
       AND b.iddet = a.iddet
       AND b.codsrv = c.codsrv
       AND b.codsrv = s.codsrv
       AND a.idpaq IN (SELECT x.idpaq
                         FROM paquete_venta x, soluciones y
                        WHERE x.idsolucion = y.idsolucion
                          AND y.flg_sisact_sga = 1) /*2882*/
       AND c.plazo = 11
       AND c.tipo = 1
       AND a.flgestado = 1;

    RETURN l_servicio;

    --<<ini 11.0>>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
      $$plsql_unit || '.' || 'get_detalle_servicio: ' || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  FUNCTION get_idinsxpaq RETURN NUMBER IS
    l_idinsxpaq instancia_paquete_cambio.idinsxpaq%TYPE;

  BEGIN

    SELECT MAX(idinsxpaq) + 1 INTO l_idinsxpaq FROM instancia_paquete_cambio;

    RETURN l_idinsxpaq;
    --ini 13.0
  EXCEPTION
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.get_idinsxpaq: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_idlinea_service(p_serviceid_sisact sales.servicio_sisact.idservicio_sisact%TYPE)
    RETURN linea_paquete.idlinea%TYPE IS
    l_serviceid sales.servicio_sisact.idservicio_sisact%TYPE;
    l_idlinea   linea_paquete.idlinea%TYPE;

  BEGIN
    l_serviceid := UPPER(TRIM(p_serviceid_sisact));

    SELECT lp.idlinea
      INTO l_idlinea
      FROM sales.servicio_sisact s, linea_paquete lp, tystabsrv t
     WHERE s.idservicio_sisact = l_serviceid
       AND s.codsrv = lp.codsrv
       AND lp.codsrv = t.codsrv
       AND t.flg_sisact_sga = 1;

    RETURN l_idlinea;

  EXCEPTION
    --<INI 2.0>
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
      --<FIN 2.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'get_idlinea_service: ' ||
                              'p_serviceid_sisact = ' || p_serviceid_sisact ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION row_count(p_string VARCHAR2) RETURN NUMBER IS
    l_count  PLS_INTEGER := 0;
    l_value  CHAR(1);
    l_length PLS_INTEGER;

  BEGIN
    l_length := LENGTH(p_string);
    FOR idx IN 1 .. l_length LOOP
      l_value := SUBSTR(p_string, idx, 1);
      IF l_value = ';' THEN
        l_count := l_count + 1;
      END IF;
    END LOOP;

    RETURN l_count + 1;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.row_count: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_impuesto(p_idimpuesto impuesto.idimpuesto%TYPE) RETURN NUMBER IS
    l_porcentaje impuesto.porcentaje%TYPE;

  BEGIN
    SELECT porcentaje
      INTO l_porcentaje
      FROM impuesto
     WHERE idimpuesto = p_idimpuesto;

    RETURN l_porcentaje;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.get_impuesto: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_sucursal(p_codsuc vtasuccli.codsuc%TYPE) RETURN vtasuccli%ROWTYPE IS
    l_sucursal vtasuccli%ROWTYPE;

  BEGIN
    SELECT * INTO l_sucursal FROM vtasuccli WHERE codsuc = p_codsuc;

    RETURN l_sucursal;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.get_sucursal: ' || sqlerrm);
    --Fin 13.0
  END;
  --------------------------------------------------------------------------------
  function get_inssrv(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv%rowtype is
    l_inssrv inssrv%rowtype;
    lv_msgerror operacion.postventasiac_log.msgerror%type;
  begin

   select i.*
      into l_inssrv
      from sales.v_sales_postventa_siac s, inssrv i, vtatabslcfac v
     where s.cod_id = p_cod_id
       and s.numslc = v.numslc
       and v.idsolucion = (select so.idsolucion
                             from soluciones so
                            where so.flg_sisact_sga = 1)
       and s.numslc = i.numslc
       and s.codsolot = operacion.pq_siac_postventa.f_max_sot_siac_sisact(p_cod_id)
       and rownum = 1;

    return l_inssrv;

  exception

    when others then

      lv_msgerror := $$plsql_unit || '.' || 'GET_INSSRV: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);

      raise_application_error(-20000,
                              $$plsql_unit || '.' || 'get_inssrv: ' ||
                              'p_cod_id = ' || p_cod_id || ' - ' || sqlerrm);
  end;

  --------------------------------------------------------------------------------
  function existe_traslado(p_cod_id sales.sot_sisact.cod_id%type)
    return boolean is
    l_count pls_integer;
    lv_msgerror operacion.postventasiac_log.msgerror%type;
  begin
    select count(1)
     into l_count
      from sales.sot_siac t, solot s, solot ss, inssrv i
     where t.cod_id = p_cod_id
       and t.codsolot = s.codsolot
       and i.numslc = s.numslc
       and i.estinssrv = 1
       and s.codcli = ss.codcli
       and ss.tiptra in (select p.codigon
                           from tipopedd t, opedd p
                          where t.abrev = 'tipo_traslados'
                            and t.tipopedd = p.tipopedd
                            and p.abreviacion = 'tipo_traslado');
    return l_count > 0;

  exception
    when others then
      lv_msgerror := $$plsql_unit || '.' || 'EXISTE_TRASLADO: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
      raise_application_error(-20000,
                              $$plsql_unit || '.' || 'existe_traslado: ' ||
                              'p_cod_id = ' || p_cod_id || ' - ' || sqlerrm);
  end;
  --------------------------------------------------------------------------------

  function get_datos_traslado(p_cod_id sales.sot_sisact.cod_id%type)
    return inssrv%rowtype is
    l_inssrv inssrv%rowtype;
    lv_msgerror operacion.postventasiac_log.msgerror%type;
  begin
    select i.*
      into l_inssrv
        from sales.v_sales_postventa_siac s, solot l, inssrv i, vtatabslcfac v
       where s.cod_id = p_cod_id
         and s.codsolot = l.codsolot
         and l.numslc = v.numslc
         and v.idsolucion = (select so.idsolucion
                               from soluciones so
                              where so.flg_sisact_sga = 1)
         and l.numslc = i.numslc
         and i.estinssrv = 1
         and l.tiptra in (select p.codigon
                           from tipopedd t, opedd p
                          where t.abrev = 'tipo_traslados'
                            and t.tipopedd = p.tipopedd
                            and p.abreviacion = 'tipo_traslado')
         and rownum < 2;

    return l_inssrv;

   exception
      when others then
        lv_msgerror := $$plsql_unit || '.' || 'GET_DATOS_TRASLADO: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

        p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);
        raise_application_error(-20000,
                                $$plsql_unit || '.' || 'get_datos_traslado: ' ||
                                'p_cod_id = ' || p_cod_id || ' - ' || sqlerrm);
    --end;
  --<FIN 12.0>
  end;

  /* **********************************************************************************************/
  FUNCTION get_cntcli(p_cod_id sales.sot_sisact.cod_id%TYPE)
    RETURN vtatabcntcli%ROWTYPE IS
    l_cntcli vtatabcntcli%ROWTYPE;
    lv_msgerror operacion.postventasiac_log.msgerror%type;
  BEGIN
    SELECT c.*
      INTO l_cntcli
      FROM sales.v_sales_postventa_siac s, vtatabcntcli c
     WHERE s.cod_id = p_cod_id
       AND s.codcli = c.codcli
       AND ROWNUM = 1;

    RETURN l_cntcli;

  EXCEPTION
    WHEN OTHERS THEN
      lv_msgerror := $$plsql_unit || '.' || 'GET_CNTCLI: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);

      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.' || 'get_cntcli: ' ||
                              'p_cod_id = ' || p_cod_id || ' - ' || sqlerrm);
      --<<fin 11.0>>

  END;

  /* **********************************************************************************************/
  FUNCTION get_slcfac(p_cod_id sales.sot_sisact.cod_id%TYPE)
    RETURN vtatabslcfac%ROWTYPE IS
    l_slcfac vtatabslcfac%ROWTYPE;

    lv_msgerror operacion.postventasiac_log.msgerror%type;
  begin
    --begin
      select t.*
        into l_slcfac
        from sales.v_sales_postventa_siac s, vtatabslcfac t
       where s.cod_id = p_cod_id
         and s.codsolot = operacion.pq_siac_postventa.f_max_sot_siac_sisact(p_cod_id) --<16.0>
         and s.numslc = t.numslc;

    RETURN l_slcfac;

    --<<ini 11.0>>
  EXCEPTION
    --Ini 18.0
    WHEN TOO_MANY_ROWS THEN
      lv_msgerror := $$plsql_unit || '.' || 'GET_SLCFAC: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(p_cod_id, 0, g_proceso, lv_msgerror);

      select t.*
        into l_slcfac
        from sales.v_sales_postventa_siac s, vtatabslcfac t
       where s.cod_id = p_cod_id
         and s.codsolot = operacion.pq_siac_postventa.f_max_sot_siac_sisact(p_cod_id)
         and s.numslc = t.numslc
         and rownum = 1;

    return l_slcfac;
    --Fin 18.0
    WHEN OTHERS THEN
      lv_msgerror := $$plsql_unit || '.' || 'GET_SLCFAC: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(p_cod_id, 0, g_proceso,lv_msgerror);

      RAISE_APPLICATION_ERROR(-20000,
                              $$plsql_unit || '.' || 'get_slcfac: ' ||
                              'p_cod_id = ' || p_cod_id || sqlerrm);
      --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  FUNCTION proyecto_preventa(p_numslc vtatabslcfac.numslc%TYPE) RETURN NUMBER IS
    l_flgestcom      NUMBER;
    l_aprueba        NUMBER;
    l_proy_tpi       NUMBER;
    l_proy_pym       NUMBER;
    l_camp_pym       NUMBER;
    l_estsolfac      CHAR(2);
    l_cuenta         NUMBER;
    l_mensaje        VARCHAR2(100);
    l_idflujo        NUMBER;
    l_tipsrv         CHAR(4);
    l_retorna        NUMBER;
    l_texto          VARCHAR2(1000);
    l_cont_tipsrv    NUMBER;
    l_codsuc         vtadetptoenl.codsuc%TYPE;
    l_idpaq          vtadetptoenl.idpaq%TYPE;
    l_proy_venta_equ NUMBER;
    l_cant           NUMBER;

    lv_msgerror      operacion.postventasiac_log.msgerror%type;

  BEGIN
    -- buscamos la campanha pymes
    SELECT F_VERIFICA_CAMPANHA_PYMES(p_numslc) INTO l_camp_pym FROM dual;

    -- buscamos el proyecto pymes
    SELECT F_VERIFICA_PROYECTO_PYMES(p_numslc) INTO l_proy_pym FROM dual;

    -- buscamos si el proyecto es tpi
    SELECT F_VERIFICA_PROYECTO_TPI(p_numslc) INTO l_proy_tpi FROM dual;

    -- buscamos si el proyecto es venta equipos
    SELECT F_VERIFICA_PROYECTO_VE(p_numslc) INTO l_proy_venta_equ FROM DUAL;

    -- asiganacion de plataforma de acceso
    asignar_plataforma(p_numslc, l_retorna, l_texto);

    -- buscamos los estados del proyecto
    SELECT estsolfac, flgestcom, Tipsrv
      INTO l_estsolfac, l_flgestcom, l_tipsrv
      FROM vtatabslcfac
     WHERE numslc = p_numslc;

    IF l_estsolfac = '00' THEN
      l_aprueba := 1;
    END IF;

    IF l_proy_pym = 1 AND l_camp_pym = 1 OR l_proy_tpi = 1 OR
       l_proy_venta_equ = 1 THEN

      -- validacion de la cobertura
      SELECT COUNT(*)
        INTO l_cont_tipsrv
        FROM vtatabconftipored
       WHERE tipsrv = l_tipsrv;

      IF l_cont_tipsrv > 0 THEN
        -- obtenemos parametros para la funcion de validacion
        SELECT DISTINCT codsuc, idpaq
          INTO l_codsuc, l_idpaq
          FROM vtadetptoenl
         WHERE numslc = p_numslc;
        -- validamos el tipo de red
        SELECT sales.f_valida_tipo_red(l_codsuc, l_idpaq, l_tipsrv, 1)
          INTO l_cuenta
          FROM dual;
      ELSE
        l_cuenta := 1;
      END IF;

      IF l_cuenta <> 1 THEN
        l_aprueba := 0;
      ELSE
        l_aprueba := 1;
      END IF;

      IF l_aprueba = 1 THEN
        -- buscamos tipo de flujo
        SELECT idflujo
          INTO l_idflujo
          FROM tiposol_plantilla a, vtaflujoestado b, vtatabslcfac c
         WHERE a.idplantilla = b.idplantilla
           AND a.idtiposolucion = c.idtiposolucion
           AND c.numslc = p_numslc
           AND b.tabest = '00'
           AND b.codest_old = '00'
           AND b.codest_new = '01';

        SELECT COUNT(*) INTO l_cant FROM vtadetprmcom WHERE numslc = p_numslc;

        -- ejecutamos los flujos de estado
        pq_proyecto.p_ejecuta_flujo_automatico(p_numslc, '01', l_idflujo);

        SELECT COUNT(*) INTO l_cant FROM vtadetprmcom WHERE numslc = p_numslc;
      END IF;

      -- actualizamos flag estudio completo
      UPDATE vtatabslcfac SET flgestcom = 1 WHERE numslc = p_numslc;

      g_codsolot := get_codsolot();
      set_instance('SOT', g_codsolot);

      RETURN 1;
    ELSE
      BEGIN
        -- ejecutamos el autoprueba
        pq_auto_aprueba.p_auto_aprueba(l_flgestcom,
                                       l_estsolfac,
                                       p_numslc,
                                       l_mensaje);
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          RAISE_APPLICATION_ERROR(SQLCODE, SQLERRM);
          RETURN 0;
      END;

      IF l_mensaje <> 'OK' THEN
        RETURN 2;
      ELSE
        RETURN 1;
      END IF;
    END IF;

    g_codsolot := get_codsolot();
    set_instance('SOT', g_codsolot);
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'PROYECTO_PREVENTA: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.proyecto_preventa: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  PROCEDURE asignar_plataforma(p_numslc  vtatabslcfac.numslc%TYPE,
                               p_retorna OUT NUMBER,
                               p_texto   OUT VARCHAR2) IS
    l_idcampanha   vtatabslcfac.idcampanha%TYPE;
    l_idsolucion   vtatabslcfac.idsolucion%TYPE;
    l_idplataforma tys_plataformasicorp_det.idplataforma%TYPE;

    CURSOR c_ptoenl IS
      SELECT * FROM vtadetptoenl v WHERE v.numslc = p_numslc;

    CURSOR c_ptoenl_pri IS
      SELECT *
        FROM vtadetptoenl v
       WHERE v.numslc = p_numslc
         AND v.flgsrv_pri = 1;

  BEGIN
    BEGIN
      SELECT v.idcampanha, v.idsolucion
        INTO l_idcampanha, l_idsolucion
        FROM vtatabslcfac v
       WHERE v.numslc = p_numslc;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        p_retorna := 3;
        p_texto   := 'No existe proyecto (numslc): ' || to_char(p_numslc) || ' ' ||
                     SQLERRM;
    END;

    FOR r_ptoenl IN c_ptoenl LOOP
      l_idplataforma := NULL;
      BEGIN
        SELECT idplataforma
          INTO l_idplataforma
          FROM tys_matrizplataforma_mae vp
         WHERE nvl(vp.idsolucion, 0) = nvl(l_idsolucion, 0)
           AND nvl(vp.idcampanha, 0) = nvl(l_idcampanha, 0)
           AND nvl(vp.idproducto, 0) = nvl(r_ptoenl.idproducto, 0);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      BEGIN
        UPDATE vtadetptoenl v
           SET v.idplataforma = l_idplataforma
         WHERE v.numslc = p_numslc
           AND v.numpto = r_ptoenl.numpto;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          p_retorna := 3;
          p_texto   := 'No se puede actualizar Medio de Acceso' || p_numslc || ' ' ||
                       r_ptoenl.numpto || ' ' || l_idplataforma || ' ' ||
                       SQLERRM;
      END;
    END LOOP;

    FOR r_ptoenl_pri IN c_ptoenl_pri LOOP
      BEGIN
        UPDATE vtadetptoenl v
           SET v.idplataforma = r_ptoenl_pri.idplataforma
         WHERE v.numslc = p_numslc
           AND v.numpto_prin = r_ptoenl_pri.numpto_prin
           AND v.idplataforma IS NULL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
          p_retorna := 3;
          p_texto   := 'No se puede actualizar Medio de Acceso' || p_numslc || ' ' ||
                       r_ptoenl_pri.numpto || ' ' || r_ptoenl_pri.idplataforma || ' ' ||
                       SQLERRM;
      END;
    END LOOP;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.asignar_plataforma: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION validar_checkproy(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2 IS
    l_cuenta         NUMBER;
    l_conta          NUMBER;
    l_valida         NUMBER;
    l_total          NUMBER;
    l_proy_tpi       NUMBER;
    l_proy_pym       NUMBER;
    l_camp_pym       NUMBER;
    l_proy_bod       NUMBER;
    l_camp_bod       NUMBER;
    l_busca          NUMBER;
    l_mensaje        VARCHAR2(100);
    l_proy_venta_equ NUMBER;

    lv_msgerror      operacion.postventasiac_log.msgerror%type;
  BEGIN
    -- buscamos el proyecto pymes
    SELECT f_verifica_proyecto_pymes(p_numslc) INTO l_proy_pym FROM dual;

    -- buscamos si el proyecto es tpi
    SELECT f_verifica_proyecto_tpi(p_numslc) INTO l_proy_tpi FROM dual;

    -- verifica si el proyecto es bod
    SELECT f_verifica_proyecto_bod(p_numslc) INTO l_proy_bod FROM dual;

    -- verifica si la campanha es bod
    SELECT f_verifica_campanha_bod(p_numslc) INTO l_camp_bod FROM dual;

    -- verifica si el proyecto tiene los campos completos
    SELECT f_vtaevalua_datoscompletos(p_numslc) INTO l_cuenta FROM dual;

    -- verifica el proyecto venta de equipos
    SELECT f_verifica_proyecto_ve(p_numslc) INTO l_proy_venta_equ FROM DUAL;

    IF l_cuenta = 0 THEN
      -- validamos productos sla
      SELECT validar_producto_sla(p_numslc) INTO l_valida FROM DUAL;

      IF l_valida <> 0 THEN
        IF l_valida = 1 THEN
          RETURN('No se encuentra el documento asociado al producto SLA');
        ELSIF l_valida = 2 THEN
          RETURN('Existe mas de un documento asociado al producto SLA');
        END IF;
      ELSE
        -- buscamos la campanha pymes
        SELECT f_verifica_campanha_pymes(p_numslc) INTO l_camp_pym FROM dual;

        IF (l_proy_pym = 1 AND l_camp_pym = 1) OR l_proy_venta_equ = 1 THEN
          -- buscamos el producto
          SELECT COUNT(a.numslc)
            INTO l_conta
            FROM vtadetptoenl a, producto b
           WHERE a.numslc = p_numslc
             AND a.idproducto = b.idproducto
             AND a.crepto = '1'
             AND b.idgrupoproducto IS NULL
             AND a.idproducto = 524;

          IF l_conta > 0 THEN
            -- buscamos si tiene servicio de email
            SELECT COUNT(a.numslc)
              INTO l_total
              FROM vtadetnumpto a, vtadetptoenl b
             WHERE a.numslc = b.numslc
               AND a.numpto = b.numpto
               AND b.idproducto = 524
               AND a.numslc = p_numslc;
            l_total := 1;

            IF l_total = 0 THEN
              RETURN('No se ha generado emails para el paquete X-plor@');
            END IF;
          END IF;
        END IF;

        -- buscamos tipo solucion
        SELECT COUNT(a.numslc)
          INTO l_busca
          FROM vtatabslcfac a
         WHERE a.numslc = p_numslc
           AND a.idtiposolucion IS NOT NULL;

        IF l_busca = 0 THEN
          -- buscamos si tiene oferta comercial
          SELECT COUNT(numslc)
            INTO l_busca
            FROM vtatabpspcli
           WHERE numslc = p_numslc;

          IF l_busca = 0 THEN
            RETURN('No se ha generado Oferta Comercial');
          END IF;
        END IF;

        -- actualizamos flag estudio completo
        UPDATE vtatabslcfac SET flgestcom = 1 WHERE numslc = p_numslc;
      END IF;
    ELSE
      -- buscamos mensaje
      BEGIN
        SELECT mensaje
          INTO l_mensaje
          FROM control_mensaje
         WHERE tipo = 'SEF'
           AND idmensaje = l_cuenta;
      EXCEPTION
        WHEN no_data_found THEN
          RETURN('Verificar la tabla control_mensaje F_VTAEVALUA_DATOSCOMPLETOS');
      END;
      RETURN(l_mensaje);
    END IF;

    RETURN 'OK';
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'VALIDAR_CHECKPROY: ' || sqlerrm ||
                    ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.validar_checkproy: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  FUNCTION validar_producto_sla(p_numslc vtatabslcfac.numslc%TYPE) RETURN NUMBER IS
    l_valida NUMBER;
    l_docum  NUMBER;
    l_cuenta NUMBER;

    -- buscamos los productos
    CURSOR c_val_prd IS
      SELECT UNIQUE a.idproducto || '|' || a.codsrv AS producto
        FROM vtadetptoenl a, producto b
       WHERE a.numslc = p_numslc
         AND a.idproducto = b.idproducto
         AND a.crepto = '1'
         AND b.idgrupoproducto IS NULL;

    -- buscamos tipo documento
    CURSOR c_val_doc IS
      SELECT UNIQUE IDTIPDOC FROM proyecto_doc WHERE numslc = p_numslc;

  BEGIN
    l_valida := 0;

    FOR lx IN c_val_prd LOOP
      -- validamos sla
      SELECT PQ_VALIDA.F_VALIDA('VALIDACIONSLA', lx.producto)
        INTO l_valida
        FROM DUAL;

      IF l_valida = 1 THEN
        l_docum := 0;

        FOR li IN c_val_doc LOOP
          -- buscamos documentos sla
          SELECT PQ_VALIDA.F_VALIDA('DOCUMENTOSLA', li.idtipdoc)
            INTO l_cuenta
            FROM DUAL;

          IF l_cuenta = 1 THEN
            l_docum := l_docum + 1;
          END IF;
        END LOOP;

        IF l_docum = 1 THEN
          l_valida := 0;
        ELSIF l_docum > 1 THEN
          l_valida := 2;
        ELSE
          l_valida := 1;
        END IF;

        RETURN(l_valida);
      END IF;
    END LOOP;

    RETURN l_valida;

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'validar_producto_sla: ' ||
    'p_numslc = ' || p_numslc || sqlerrm);
    --<<fin 11.0>>
  END;
  /* **********************************************************************************************/
  PROCEDURE validar_tiposolucion(p_parametro VARCHAR2) IS
    l_valida    NUMBER;
    l_resultado NUMBER;

    lv_msgerror operacion.postventasiac_log.msgerror%type;

    -- buscamos los tipos solucion
    CURSOR c_valida IS
      SELECT idtiposolucion FROM tiposolucion WHERE estado = 1;

  BEGIN
    l_valida := 0;

    FOR val IN c_valida LOOP
      -- buscamos tipo de solucion - matriz
      l_valida := pq_proyecto.f_validar_tiposmatriz(val.idtiposolucion,
                                                    TRIM(p_parametro));

      IF l_valida > 0 THEN
        l_resultado := val.idtiposolucion;

        -- actualizamos tipo solucion
        UPDATE VTATABSLCFAC
           SET idtiposolucion = l_resultado
         WHERE numslc = TRIM(p_parametro);
      END IF;

    END LOOP;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'VALIDAR_TIPOSOLUCION: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.validar_tiposolucion: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  PROCEDURE load_instancia_cambio(p_numslc vtatabslcfac.numslc%TYPE) IS
    l_idpaq  NUMBER;
    l_cnt    NUMBER;
    l_inspaq instancia_paquete%ROWTYPE;
    lv_msgerror operacion.postventasiac_log.msgerror%type;

    CURSOR cur_paq IS
      SELECT * FROM instancia_paquete_cambio i WHERE i.numslc = p_numslc;

  BEGIN
    FOR c_paq IN cur_paq LOOP
      l_inspaq.idinsxpaq      := c_paq.idinsxpaq;
      l_inspaq.numslc         := c_paq.numslc;
      l_inspaq.idpaq          := c_paq.idpaq;
      l_inspaq.idproducto     := c_paq.idproducto;
      l_inspaq.flgobligatorio := c_paq.flgobligatorio;
      l_inspaq.flgprincipal   := c_paq.flgprincipal;
      l_inspaq.cantidad       := c_paq.cantidad;
      l_inspaq.paquete        := c_paq.paquete;
      l_inspaq.numero         := c_paq.numero;
      l_inspaq.descripcion    := c_paq.descripcion;
      l_inspaq.codinssrv      := c_paq.codinssrv;
      l_inspaq.codsrv         := c_paq.codsrv;
      l_inspaq.dscsrv         := c_paq.dscsrv;
      l_inspaq.estcse         := c_paq.estcse;
      l_inspaq.prelis_ins     := c_paq.prelis_ins;
      l_inspaq.desc_ins       := c_paq.desc_ins;
      l_inspaq.porcimp_ins    := c_paq.porcimp_ins;
      l_inspaq.monto_ins      := c_paq.monto_ins;
      l_inspaq.monto_ins_imp  := c_paq.monto_ins_imp;
      l_inspaq.estcts         := c_paq.estcts;
      l_inspaq.prelis_srv     := c_paq.prelis_srv;
      l_inspaq.desc_srv       := c_paq.desc_srv;
      l_inspaq.porcimp_srv    := c_paq.porcimp_srv;
      l_inspaq.monto_srv      := c_paq.monto_srv;
      l_inspaq.monto_srv_imp  := c_paq.monto_srv_imp;
      l_inspaq.codsuc         := c_paq.codsuc;
      l_inspaq.descpto        := c_paq.descpto;
      l_inspaq.dirpto         := c_paq.dirpto;
      l_inspaq.nomdst         := c_paq.nomdst;
      l_inspaq.ubipto         := c_paq.ubipto;
      l_inspaq.observacion    := c_paq.observacion;
      l_inspaq.codequcom      := c_paq.codequcom;
      l_inspaq.idprecio       := c_paq.idprecio;
      l_inspaq.preuni_ins     := c_paq.preuni_ins;
      l_inspaq.preuni_srv     := c_paq.preuni_srv;
      l_inspaq.nro_serv       := c_paq.nro_serv;
      l_inspaq.moneda_id      := c_paq.moneda_id;
      l_inspaq.dscequ         := c_paq.dscequ;
      l_inspaq.banwid         := c_paq.banwid;
      l_inspaq.idtipo_pto     := c_paq.idtipo_pto;
      l_inspaq.idsite         := c_paq.idsite;
      l_inspaq.iddet          := c_paq.iddet;
      l_inspaq.numpto         := c_paq.numpto;
      --default
      l_inspaq.fecusu     := SYSDATE;
      l_inspaq.codusu     := USER;
      l_inspaq.flgcontrol := 0;

      INSERT INTO instancia_paquete VALUES l_inspaq;
    END LOOP;

    SELECT idpaq
      INTO l_idpaq
      FROM vtadetptoenl
     WHERE numslc = p_numslc
       AND rownum = 1;

    SELECT COUNT(*)
      INTO l_cnt
      FROM instancia_paquete_cambio
     WHERE flg_tipo_vm = 'CR'
       AND numslc = p_numslc;

    IF l_cnt = 0 THEN
      UPDATE vtatabslcfac
         SET idsolucion =
             (SELECT idsolucion FROM paquete_venta WHERE idpaq = l_idpaq)
       WHERE numslc = p_numslc;
    END IF;
    -- Ini 6.0
    EXCEPTION
      WHEN OTHERS THEN
        lv_msgerror := $$plsql_unit || '.' || 'LOAD_INSTANCIA_CAMBIO: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

        p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' || 'load_instancia_cambio' || SQLERRM);
   -- Fin 6.0
  END;
  /* **********************************************************************************************/
  PROCEDURE generar_ptoenl_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                                  p_numslc      vtatabslcfac.numslc%TYPE,
                                  p_precon_type precon_type) IS--<5.0>
  lv_msgerror operacion.postventasiac_log.msgerror%type;
  BEGIN
    actualizar_pto_pri_cambio(p_numregistro);
    --crear detalle de venta
    load_detalle_cambio(p_numregistro, p_numslc);
    p_actualiza_pto_pri(p_numslc);
    actualizar_grupo_cambio(p_numslc);
    --p_actualizar_grupo_detptoenl(p_numslc); --24.0
    -- grabar_reservas(p_numregistro, p_numslc); -- 6.0
    pq_int_ventas_ope.p_actualiza_banwid_acceso(p_numslc);
    --<ini 5.0>
    --generar_des_cambio(p_numregistro, p_numslc);
    generar_des_cambio(p_numregistro, p_numslc, p_precon_type);
    --<fin 5.0>
    --ini 13.0
  EXCEPTION
     WHEN OTHERS THEN
       lv_msgerror := $$plsql_unit || '.' || 'GENERAR_PTOENL_CAMBIO: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

       p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);

       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.generar_ptoenl_cambio: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  PROCEDURE generar_des_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                               p_numslc      vtatabslcfac.numslc%TYPE,
                               p_precon_type precon_type) IS--<5.0>
    l_numslc_old   vtatabslcfac.numslc%TYPE;
    l_obs          vtatabslcfac.obssolfac%TYPE;
    l_solucion_old soluciones%ROWTYPE;
    l_solucion_new soluciones%ROWTYPE;
    l_linea_old    VARCHAR2(50);
    l_linea_new    VARCHAR2(50);
    l_fax_old      VARCHAR2(50);
    l_fax_new      VARCHAR2(50);
    l_rec          NUMBER;

  BEGIN
    SELECT numslc_ori
      INTO l_numslc_old
      FROM regvtamentab
     WHERE numregistro = p_numregistro;

    SELECT DISTINCT LOWER((SELECT solucion
                            FROM soluciones
                           WHERE idsolucion = a.idsolucion))
      INTO l_solucion_new.solucion
      FROM vtatabslcfac a, vtadetptoenl b
     WHERE a.numslc = b.numslc
       AND a.numslc = p_numslc;

    SELECT DISTINCT LOWER((SELECT solucion
                            FROM soluciones
                           WHERE idsolucion = a.idsolucion))
      INTO l_solucion_old.solucion
      FROM vtatabslcfac a, vtadetptoenl b
     WHERE a.numslc = b.numslc
       AND a.numslc = l_numslc_old;

    SELECT ' con ' || nvl(SUM(a.cantidad), 0) || ' lineas'
      INTO l_linea_new
      FROM vtadetptoenl a, producto b
     WHERE a.idproducto = b.idproducto
       AND b.idtipinstserv = 3
       AND a.numslc = p_numslc
       AND a.idproducto <> 702;

    SELECT ' con ' || nvl(SUM(a.cantidad), 0) || ' lineas'
      INTO l_linea_old
      FROM vtadetptoenl a, producto b
     WHERE a.idproducto = b.idproducto
       AND b.idtipinstserv = 3
       AND a.numslc = l_numslc_old
       AND a.idproducto <> 702;

    SELECT ' y ' || nvl(SUM(a.cantidad), 0) || ' fax server'
      INTO l_fax_new
      FROM vtadetptoenl a
     WHERE a.numslc = p_numslc
       AND idproducto = 702;

    SELECT ' y ' || nvl(SUM(a.cantidad), 0) || ' fax server'
      INTO l_fax_old
      FROM vtadetptoenl a
     WHERE a.numslc = l_numslc_old
       AND idproducto = 702;

    BEGIN
      SELECT DECODE(flg_tipo_vm,
                    'TE',
                    'Traslado Externo',
                    'TER',
                    'Traslado Externo',
                    'TI',
                    'Traslado Interno',
                    'TIR',
                    'Traslado Interno',
                    'SC',
                    'Servicios Complementarios',
                    NULL)
        INTO l_obs
        FROM REGDETSRVMEN
       WHERE numregistro = p_numregistro;

    EXCEPTION
      WHEN OTHERS THEN
        l_obs := '';
    END;

    IF l_obs IS NULL THEN
      SELECT COUNT(*)
        INTO l_rec
        FROM instancia_paquete_cambio
       WHERE numregistro = p_numregistro
         AND flg_tipo_vm = 'CR';

      IF l_rec > 0 THEN
        l_obs := 'Cambio de Recaudacion';
      ELSE
        SELECT DECODE(COUNT(*), 1, 'Migracion', 'Cambio de Plan')
          INTO l_obs
          FROM regvtamentab
         WHERE numregistro = p_numregistro
           AND tipsrv <> tipsrv_des;
      END IF;

      l_obs := 'Tipo de Venta: ' || l_obs || CHR(13) || CHR(10) || 'De: ' ||
               l_solucion_old.solucion || l_linea_old || l_fax_old || chr(13) ||
               CHR(10) || 'A: ';
      l_obs := l_obs || l_solucion_new.solucion || l_linea_new || l_fax_new;
      l_obs := p_precon_type.obsaprofe ||' - '||l_obs;--<5.0>
      UPDATE vtatabslcfac SET obssolfac = l_obs WHERE numslc = p_numslc;

      UPDATE regvtamentab
         SET numslc = p_numslc, obssolfac = l_obs
       WHERE numregistro = p_numregistro;
    ELSE
      l_obs := 'Tipo de Venta: ' || l_obs;
      l_obs := p_precon_type.obsaprofe ||' - '||l_obs;--<5.0>
      DBMS_OUTPUT.PUT_LINE(l_obs);
    END IF;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.generar_des_cambio: ' || sqlerrm);
    --Fin 13.0
  END;
  /* **********************************************************************************************/
  PROCEDURE grabar_reservas(p_numregistro regvtamentab.numregistro%TYPE,
                            p_numslc      vtatabslcfac.numslc%TYPE) IS

    -- cursor para las reservas de numero telefonico
    CURSOR c_numtel IS
      SELECT * FROM regreservatel WHERE numregistro = p_numregistro;

    -- cursor para las reservas de correo
    CURSOR C_CORREO IS
      SELECT * FROM regvtadetnumpto WHERE numregistro = p_numregistro;

  BEGIN
    FOR c_tel IN c_numtel LOOP
      INSERT INTO reservatel
        (codnumtel, numslc, numpto, valido, codcli, estnumtel, publicar)
      VALUES
        (c_tel.codnumtel,
         p_numslc,
         c_tel.numpto,
         c_tel.valido,
         c_tel.codcli,
         c_tel.estnumtel,
         c_tel.publicar);
    END LOOP;

    FOR c_corr IN c_correo LOOP
      INSERT INTO vtadetnumpto
        (numslc, numpto, detalle, detalle2)
      VALUES
        (p_numslc, c_corr.numpto, c_corr.detalle, c_corr.detalle2);
    END LOOP;

    UPDATE regreservatel
       SET numslc = p_numslc
     WHERE numregistro = p_numregistro;

    UPDATE regvtadetnumpto
       SET numslc = p_numslc
     WHERE numregistro = p_numregistro;
   -- Ini 6.0
   EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'grabar_reservas' || SQLERRM);
  -- Fin 6.0
  END;
  /* **********************************************************************************************/
  PROCEDURE actualizar_grupo_cambio(p_numslc vtatabslcfac.numslc%TYPE) IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM INSTANCIA_PAQUETE_CAMBIO
     WHERE numslc = p_numslc
       AND flg_tipo_vm IN ('CP', 'CR');

    IF l_count > 0 THEN
      UPDATE vtadetptoenl SET grupo = 1 WHERE numslc = p_numslc;
    END IF;

    UPDATE vtadetptoenl a
       SET a.codinssrv =
           (SELECT DISTINCT b.codinssrv
              FROM vtadetptoenl b
             WHERE a.numslc = b.numslc
               AND a.paquete = b.paquete
               AND b.codinssrv IS NOT NULL
               AND a.numpto_prin = b.numpto_prin
               AND b.numslc = p_numslc)
     WHERE a.numslc = p_numslc
       AND a.codinssrv IS NULL;

    --<<ini 11.0>>
    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,
    $$plsql_unit || '.' || 'actualizar_grupo_cambio: ' ||
    'p_numslc = ' || p_numslc || sqlerrm);
    --<<fin 11.0>>

  END;
  /* **********************************************************************************************/
  PROCEDURE load_detalle_cambio(p_numregistro regvtamentab.numregistro%TYPE,
                                p_numslc      vtatabslcfac.numslc%TYPE) IS

    CURSOR cur_det IS
      SELECT *
        FROM REGDETPTOENLCAMBIO
       WHERE numregistro = p_numregistro
       ORDER BY numpto;

    CURSOR cur_prm(aagrupador NUMBER, aiddet NUMBER) IS
      SELECT a.iddet,
             a.idprom,
             b.dscprom descripcion,
             b.porcentaje,
             b.afectacr,
             b.afectacnr,
             b.flg_prom_en_linea
        FROM instancia_promocion a, promocion b
       WHERE a.agrupador = aagrupador
         AND a.idprom = b.idprom
         AND a.flgestado = 0
         AND a.tipovta = 2
         AND a.iddet = aiddet;

    l_numslc    vtatabslcfac.numslc%TYPE;
    l_regvtamen regvtamentab%ROWTYPE;
    l_tipsrv    regvtamentab.tipsrv%TYPE;
    l_tiptra    vtadetptoenl.tiptra%TYPE;
    l_opcion    NUMBER(2);
    l_error     VARCHAR2(500);
    l_num_cr    NUMBER(5);
    l_agrupador instancia_promocion.agrupador%TYPE;
    l_vtadet    vtadetptoenl%ROWTYPE;

  BEGIN
    l_numslc := p_numslc;
    l_opcion := 6;

    SELECT a.tipsrv
      INTO l_tipsrv
      FROM regvtamentab a
     WHERE numregistro = p_numregistro;

    SELECT COUNT(*)
      INTO l_num_cr
      FROM regvtamentab r, instancia_paquete_cambio i
     WHERE r.numregistro = i.numregistro
       AND i.flg_tipo_vm = 'CR'
       AND r.numregistro = p_numregistro;

    IF l_num_cr > 0 THEN
      SELECT b.codigon
        INTO l_tiptra
        FROM tipcrmdd a, crmdd b
       WHERE a.tipcrmdd = b.tipcrmdd
         AND a.abrev = 'CXC_TIPTRA'
         AND codigoc = (SELECT idcampanha
                          FROM regvtamentab
                         WHERE numregistro = p_numregistro);
    ELSE
      SELECT f_obt_tiptraxtipsrv(l_tipsrv, l_opcion) INTO l_tiptra FROM dual;
    END IF;

    SELECT nvl(a.agrupador_prom_cp, ' ')
      INTO l_agrupador
      FROM regvtamentab a
     WHERE numregistro = p_numregistro;

    FOR c_det IN cur_det LOOP
      BEGIN
        l_vtadet.numslc        := l_numslc;
        l_vtadet.numpto        := c_det.numpto;
        l_vtadet.descpto       := c_det.descpto;
        l_vtadet.dirpto        := c_det.dirpto;
        l_vtadet.ubipto        := c_det.ubipto;
        l_vtadet.codsuc        := c_det.codsuc;
        l_vtadet.tipo_vta      := 1;
        l_vtadet.paquete       := c_det.paquete;
        l_vtadet.flgsrv_pri    := c_det.flgsrv_pri;
        l_vtadet.idproducto    := c_det.idproducto;
        l_vtadet.codsrv        := c_det.codsrv;
        l_vtadet.codequcom     := c_det.codequcom;
        l_vtadet.crepto        := '1';
        l_vtadet.estcts        := c_det.estcts;
        l_vtadet.estcse        := c_det.estcse;
        l_vtadet.banwid        := c_det.banwid;
        l_vtadet.tiptra        := l_tiptra;
        l_vtadet.idprecio      := c_det.idprecio;
        l_vtadet.prelis_srv    := c_det.prelis_srv;
        l_vtadet.prelis_ins    := c_det.prelis_ins;
        l_vtadet.desc_srv      := c_det.desc_srv;
        l_vtadet.desc_ins      := c_det.desc_ins;
        l_vtadet.monto_srv     := c_det.monto_srv;
        l_vtadet.monto_ins     := c_det.monto_ins;
        l_vtadet.porcimp_srv   := c_det.porcimp_srv;
        l_vtadet.porcimp_ins   := c_det.porcimp_ins;
        l_vtadet.monto_srv_imp := c_det.monto_srv_imp;
        l_vtadet.monto_ins_imp := c_det.monto_ins_imp;
        l_vtadet.cantidad      := c_det.cantidad;
        l_vtadet.codinssrv     := c_det.codinssrv_orig;
        l_vtadet.observacion   := c_det.observacion;
        l_vtadet.preuni_srv    := c_det.preuni_srv;
        l_vtadet.preuni_ins    := c_det.preuni_ins;
        l_vtadet.moneda_id     := c_det.moneda_id;
        l_vtadet.IDINSXPAQ     := c_det.IDINSXPAQ;
        l_vtadet.idpaq         := c_det.idpaq;
        l_vtadet.pid           := c_det.pid;
        l_vtadet.pid_old       := c_det.pid;
        l_vtadet.iddet         := c_det.iddet;
        --default
        l_vtadet.codusu        := USER;
        l_vtadet.fecusu        := SYSDATE;
        l_vtadet.on_net        := 1;
        l_vtadet.estser        := '00';
        l_vtadet.flgpost       := 0;
        l_vtadet.idmodo_acceso := 0;
        l_vtadet.flgredun      := 0;
        l_vtadet.flgmnt        := 0;
        l_vtadet.flgn_wireless := 0;
        l_vtadet.reserva       := 0;
        l_vtadet.estmt         := 0;
        l_vtadet.flgupg        := 0;

        INSERT INTO vtadetptoenl VALUES l_vtadet;

        -- promociones por punto
        FOR c_prm IN cur_prm(l_agrupador, c_det.iddet) LOOP
          BEGIN

            INSERT INTO vtadetprmcom
              (numslc,
               numpto,
               idprom,
               descripcion,
               porcentaje,
               afectacnr,
               afectacr,
               flgobligatorio,
               flg_promlinea)
            VALUES
              (l_numslc,
               c_det.numpto,
               c_prm.idprom,
               c_prm.descripcion,
               c_prm.porcentaje,
               c_prm.afectacnr,
               c_prm.afectacr,
               0,
               c_prm.flg_prom_en_linea);

            UPDATE instancia_promocion
               SET flgestado   = 2,
                   numslc      = l_numslc,
                   numregistro = p_numregistro,
                   numpto      = c_det.numpto
             WHERE iddet = c_det.iddet
               AND idprom = c_prm.idprom
               AND agrupador = l_agrupador
               AND tipovta = 2;

          EXCEPTION
            WHEN OTHERS THEN
              UPDATE instancia_promocion
                 SET flgestado   = 1,
                     numslc      = l_numslc,
                     numregistro = p_numregistro,
                     numpto      = c_det.numpto
               WHERE iddet = c_det.iddet
                 AND idprom = c_prm.idprom
                 AND agrupador = l_agrupador
                 AND tipovta = 2;
          END;
        END LOOP;

        UPDATE instancia_paquete_cambio
           SET flgcontrol = 2, numpto = c_det.numpto
         WHERE numregistro = c_det.numregistro
           AND idsecuencia = c_det.idsecuencia;

      EXCEPTION
        WHEN OTHERS THEN
          l_error := SQLERRM;
          UPDATE instancia_paquete_cambio
             SET flgcontrol = 1
           WHERE numregistro = c_det.numregistro
             AND numpto = c_det.idsecuencia;
      END;
    END LOOP;

    UPDATE vtadetptoenl a
       SET a.codinssrv =
           (SELECT DISTINCT b.codinssrv
              FROM vtadetptoenl b
             WHERE a.numslc = b.numslc
               AND a.paquete = b.paquete
               AND b.codinssrv IS NOT NULL
               AND a.numpto_prin = b.numpto_prin
               AND b.numslc = l_numslc)
     WHERE a.numslc = l_numslc
       AND a.codinssrv IS NULL;

    SELECT *
      INTO l_regvtamen
      FROM regvtamentab
     WHERE numregistro = p_numregistro;

    INSERT INTO vtadetcntslc
      (numslc, codcnt, nomcnt, tipcnt, flg_princ)
    VALUES
      (l_numslc,
       l_regvtamen.codcnt,
       l_regvtamen.nomcnt,
       l_regvtamen.tipcnt,
       l_regvtamen.flg_pricnt);
     -- Ini 6.0
     EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' || 'load_detalle_cambio' || SQLERRM);
    -- Fin 6.0
  END;
  /* **********************************************************************************************/
  PROCEDURE actualizar_pto_pri_cambio(p_numregistro regvtamentab.numregistro%TYPE) IS

    CURSOR c_actualiza_pto IS
      SELECT tipo_vta, paquete
        FROM regdetptoenlcambio
       WHERE numregistro = p_numregistro
       GROUP BY tipo_vta, paquete
       ORDER BY tipo_vta, paquete;

    l_numpto regdetptoenlcambio.numpto%TYPE;

  BEGIN
    --todo
    COMMIT;
    FOR r_cursor IN c_actualiza_pto LOOP
    begin
      SELECT numpto
        INTO l_numpto
        FROM regdetptoenlcambio
       WHERE numregistro = p_numregistro
         AND paquete = r_cursor.paquete
         AND flgsrv_pri = '1';

      UPDATE regdetptoenlcambio
         SET numpto_prin = l_numpto
       WHERE numregistro = p_numregistro
         AND paquete = r_cursor.paquete;
      exception
      when no_data_found then
        null;
    end;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'ACTUALIZAR_PTO_PRI_CAMBIO: Error de configuracion del Detalle Paquete: Numregistro '|| p_numregistro|| -- 6.0
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE generar_sef(p_numregistro regvtamentab.numregistro%TYPE) IS
    l_regvtamen           regvtamentab%ROWTYPE;
    l_idsolucion          regvtamentab.idsolucion%TYPE;
    l_cont_paquete_cambio NUMBER;
    l_found               BOOLEAN := FALSE;
    l_flg_cehfc           NUMBER;
    l_tip_cr              NUMBER;
    l_numslc              vtatabslcfac.numslc%TYPE;
    l_venta               vtatabslcfac%ROWTYPE;
    lv_msgerror           operacion.postventasiac_log.msgerror%type;
  BEGIN
    SELECT *
      INTO l_regvtamen
      FROM regvtamentab
     WHERE numregistro = p_numregistro;

    l_regvtamen.fecpedsol := SYSDATE;
    l_regvtamen.estsolfac := '00';
    l_regvtamen.flgestcom := 0;

    SELECT COUNT(*)
      INTO l_cont_paquete_cambio
      FROM instancia_paquete_cambio
     WHERE numregistro = p_numregistro;

    FOR x IN (SELECT *
                FROM opedd o
               WHERE o.abreviacion = 'SOL_CEHFC'
                 AND o.codigoc = l_regvtamen.tipsrv) LOOP
      l_found     := TRUE;
      l_flg_cehfc := 1;
      EXIT;
    END LOOP;

    IF NOT l_found THEN
      l_flg_cehfc := 0;
    END IF;

    --cambio de recaudacion
    SELECT COUNT(*)
      INTO l_tip_cr
      FROM instancia_paquete_cambio
     WHERE flg_tipo_vm = 'CR'
       AND numregistro = p_numregistro;

    IF l_tip_cr > 0 THEN
      l_idsolucion           := l_regvtamen.idsolucion_des;
      l_regvtamen.idsolucion := l_idsolucion;
    END IF;

    l_venta.codcli              := l_regvtamen.codcli;
    l_venta.fecpedsol           := l_regvtamen.fecpedsol;
    l_venta.estsolfac           := l_regvtamen.estsolfac;
    l_venta.codsol              := l_regvtamen.codsol;
    l_venta.srvpri              := l_regvtamen.srvpri;
    l_venta.obssolfac           := l_regvtamen.obssolfac;
    l_venta.fecapr              := l_regvtamen.fecapr;
    l_venta.tipsrv              := l_regvtamen.tipsrv_des;
    l_venta.coddpt              := l_regvtamen.coddpt;
    l_venta.codsolot            := l_regvtamen.codsolot;
    l_venta.codsrv              := l_regvtamen.codsrv;
    l_venta.cliint              := l_regvtamen.cliint;
    l_venta.codsocio            := l_regvtamen.codsocio;
    l_venta.idvendea            := l_regvtamen.idvendea;
    l_venta.flgestcom           := l_regvtamen.flgestcom;
    l_venta.codusuapr           := l_regvtamen.codusuapr;
    l_venta.fecestcom           := l_regvtamen.fecestcom;
    l_venta.flgcategoria        := l_regvtamen.flgcategoria;
    l_venta.moneda_id           := l_regvtamen.moneda_id;
    l_venta.nticket             := l_regvtamen.nticket;
    l_venta.plazo_srv           := l_regvtamen.plazo_srv;
    l_venta.on_net              := l_regvtamen.on_net;
    l_venta.flg_pricing         := l_regvtamen.flg_pricing;
    l_venta.idsolucion          := l_regvtamen.idsolucion_des;
    l_venta.area                := l_regvtamen.area;
    l_venta.numslc_lsg          := l_regvtamen.numslc_lsg;
    l_venta.idcampanha          := l_regvtamen.idcampanha_des;
    l_venta.pcflg_transferencia := l_regvtamen.pcflg_transferencia;
    l_venta.pcidplantilla       := l_regvtamen.pcidplantilla;
    l_venta.pcidproyecto        := l_regvtamen.pcidproyecto;
    l_venta.idprioridad         := l_regvtamen.idprioridad;
    l_venta.FLG_CEHFC_CP        := l_flg_cehfc;
    l_venta.flg_agenda          := l_regvtamen.flg_agenda;
    --default
    l_venta.codusu    := USER;
    l_venta.fecusu    := SYSDATE;
    l_venta.tipo      := 0;
    l_venta.derivado  := 0;
    l_venta.tippro    := 0;
    l_venta.flgpryesp := 0;
    l_venta.flgcove   := 0;
    l_venta.flgcban   := 0;
    l_venta.flgcequ   := 0;
    l_venta.genfacpin := '1';
    l_venta.genfacpex := '1';
    l_venta.genfacisp := '0';
    l_venta.genfactel := '0';

    INSERT INTO vtatabslcfac VALUES l_venta RETURNING numslc INTO l_numslc;

    g_numslc_new := l_numslc;
    set_instance('PROYECTO DE POSTVENTA', g_numslc_new);

  EXCEPTION
    WHEN OTHERS THEN
      lv_msgerror := $$plsql_unit || '.' || 'GENERAR_SEF: ' || sqlerrm ||
                      ' - Linea ('|| dbms_utility.format_error_backtrace ||')';

      p_insert_log_post_siac(g_cod_id, 0, g_proceso,lv_msgerror);

      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'generar_sef' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_instance(p_tipo_instancia operacion.siac_instancia.tipo_instancia%TYPE,
                         p_instancia      operacion.siac_instancia.instancia%TYPE) IS
    l_instancia operacion.siac_instancia%ROWTYPE;

  BEGIN
    l_instancia.idprocess      := operacion.pq_siac_postventa.g_idprocess;
    l_instancia.tipo_postventa := 'CAMBIO DE PLAN';
    l_instancia.tipo_instancia := p_tipo_instancia;
    l_instancia.instancia      := p_instancia;
    l_instancia.usureg         := USER;
    l_instancia.fecreg         := SYSDATE;

    INSERT INTO operacion.siac_instancia VALUES l_instancia;
    --Ini 6.0
    EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'set_instance' || SQLERRM);
    -- Fin 6.0
  END;
  /* **********************************************************************************************/
  --<INI 2.0>
  FUNCTION is_servicio_principal(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS
  BEGIN
    RETURN p_idgrupo IN('001', '002', '003', '004');
  END;
  /* **********************************************************************************************/
  FUNCTION is_servicio_adicional(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    IF p_idgrupo IN ('005', '006', '007') THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
  END;
  /* **********************************************************************************************/
  FUNCTION get_codsrv_comodato(p_idgrupo sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN sales.tystabsrv.codsrv%TYPE IS
    l_tipo_servicio billcolper.producto.tipsrv%TYPE;

  BEGIN
    SELECT b.tipsrv
      INTO l_tipo_servicio
      FROM sales.grupo_sisact a, billcolper.producto b
     WHERE a.idproducto = b.idproducto
       AND a.idgrupo_sisact = p_idgrupo;

    RETURN sales.pq_comodato_sisact.get_codsrv_comodato(l_tipo_servicio);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;
  /* **********************************************************************************************/
  FUNCTION is_servicio_comodato(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN
    IF p_idgrupo IN ('009') AND is_servicio_principal(p_idgrupo_principal) THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
  END;
  /* **********************************************************************************************/
  FUNCTION is_servicio_alquiler(p_idgrupo           sales.grupo_sisact.idgrupo_sisact%TYPE,
                                p_idgrupo_principal sales.grupo_sisact.idgrupo_sisact%TYPE)
    RETURN BOOLEAN IS

  BEGIN

    IF p_idgrupo IN ('008') AND is_servicio_principal(p_idgrupo_principal) THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
  END;
  /* **********************************************************************************************/
  PROCEDURE insert_servicios(p_servicios servicios_type,
                             p_idlinea   OUT idlineas_type) IS
    l_codsrv            sales.tystabsrv.codsrv%TYPE;
    l_servicio          sales.pq_servicio_sisact.servicio_type;
    l_comodato          sales.pq_comodato_sisact.comodato_type;
    l_idlinea_generado  sales.linea_paquete.idlinea%TYPE;
    l_servicio_generado sales.tystabsrv.codsrv%TYPE;

  BEGIN
    FOR idx IN p_servicios.first .. p_servicios.last LOOP

      IF is_servicio_principal(p_servicios(idx).idgrupo) OR
         is_servicio_adicional(p_servicios(idx).idgrupo) THEN

        l_servicio.servicio          := p_servicios(idx).servicio;
        l_servicio.dscsrv            := p_servicios(idx).dscsrv;
        l_servicio.bandwid           := p_servicios(idx).bandwid;
        l_servicio.idgrupo           := p_servicios(idx).idgrupo;
        l_servicio.idgrupo_principal := p_servicios(idx).idgrupo_principal;
        l_servicio.flag_lc           := p_servicios(idx).flag_lc;
        l_servicio.codigo_ext        := p_servicios(idx).codigo_ext;
        sales.pq_servicio_sisact.create_servicio(l_servicio,
                                                 l_idlinea_generado,
                                                 l_servicio_generado);
        p_idlinea(idx).idlinea := l_idlinea_generado;
        p_idlinea(idx).servicio_sga := l_servicio_generado;
        p_idlinea(idx).cantidad_instancia := p_servicios(idx).cantidad_instancia;
        p_idlinea(idx).cantidad := p_servicios(idx).cantidad;--<4.0>

      END IF;

      IF is_servicio_comodato(p_servicios(idx).idgrupo,
                              p_servicios(idx).idgrupo_principal) OR
         is_servicio_alquiler(p_servicios(idx).idgrupo,
                              p_servicios(idx).idgrupo_principal) THEN

        l_codsrv := get_codsrv_comodato(p_servicios(idx).idgrupo);
        l_comodato.idgrupo := p_servicios(idx).idgrupo;
        l_comodato.idgrupo_principal := p_servicios(idx).idgrupo_principal;
        l_comodato.codtipequ := p_servicios(idx).codtipequ;
        l_comodato.tipequ := p_servicios(idx).tipequ;
        l_comodato.dscequ := p_servicios(idx).dscequ;
        l_idlinea_generado := sales.pq_comodato_sisact.configure_comodato(l_comodato);
        p_idlinea(idx).idlinea := l_idlinea_generado;
        p_idlinea(idx).servicio_sga := l_codsrv;
        p_idlinea(idx).cantidad_instancia := p_servicios(idx).cantidad_instancia;
        p_idlinea(idx).codtipequ := p_servicios(idx).codtipequ;
        p_idlinea(idx).cantidad := p_servicios(idx).cantidad;--<4.0>

      END IF;
    END LOOP;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.insert_servicios: ' || sqlerrm);
    --Fin 13.0
  END;
  --<FIN 2.0>
 /* **********************************************************************************************/
  FUNCTION exist_sot_siac(p_codsolot solot.codsolot%TYPE) RETURN BOOLEAN IS
    C_SOT      CONSTANT operacion.siac_instancia.tipo_instancia%TYPE := 'SOT';
    C_TIPO_VTA CONSTANT operacion.siac_instancia.tipo_postventa%TYPE := 'CAMBIO DE PLAN';
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
     INTO l_count
      FROM operacion.siac_instancia n
     WHERE n.tipo_instancia =C_SOT
       --<8.0
       --AND n.tipo_instancia = C_TIPO_VTA
       --AND n.idinstancia = p_codsolot;
       AND n.tipo_postventa =  C_TIPO_VTA
       AND n.instancia = p_codsolot; --8.0>

     --ini 23.0
    IF L_COUNT = 0 THEN

      SELECT COUNT(*)
             INTO l_count
      FROM sales.int_negocio_instancia n
     WHERE n.instancia = C_SOT
       AND n.idinstancia = to_char(p_codsolot);

    END IF;
    --fin 23.0
    RETURN l_count > 0;
    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.exist_sot_siac: ' || sqlerrm);
    --Fin 13.0

  END;
/* **********************************************************************************************/
  PROCEDURE update_customer_co_id(p_codigo_sot  operacion.solot.codsolot%TYPE,
                                p_customer_id marketing.vtatabcli.codcli%TYPE,
                                p_cod_id      operacion.solot.cod_id%TYPE) IS
  BEGIN
    UPDATE solot s
       SET s.customer_id = p_customer_id, s.cod_id = p_cod_id
     WHERE s.codsolot = p_codigo_sot;

    --ini 13.0
    EXCEPTION
      WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20000,$$plsql_unit || '.' || 'OPERACION.PQ_SIAC_CAMBIO_PLAN.update_customer_co_id: ' || sqlerrm);
    --Fin 13.0

  END;
 /* **********************************************************************************************/
  PROCEDURE p_act_customer_sga(p_cod_sot     solot.codsolot%TYPE,
                               p_customer_id solot.customer_id%TYPE,
                               p_cod_id      solot.cod_id%TYPE,
                               p_error_code  OUT NUMBER,
                               p_mensaje     OUT VARCHAR2) IS
  BEGIN
    IF p_cod_sot IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No ingreso SOT necesario');
    END IF;

    IF p_customer_id IS NULL OR p_cod_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No ingreso datos necesarios');
    END IF;

    IF NOT exist_sot_siac(p_cod_sot) THEN
      RAISE_APPLICATION_ERROR(-20000, 'El codigo de la SOT no existe en SGA');
    END IF;

    update_customer_co_id(p_cod_sot, p_customer_id, p_cod_id);

    p_error_code := 0;
    p_mensaje    := 'OK';

   -- COMMIT; 8.0

  EXCEPTION
    WHEN OTHERS THEN
      p_error_code := -1;
      p_mensaje    := SQLERRM;
  END;


  --<7.0
  PROCEDURE p_consulta (p_cod_sot   in  solot.codsolot%TYPE,
                               p_customer_id OUT  solot.customer_id%TYPE,
                               p_cod_id      OUT   solot.cod_id%TYPE,
                               p_error_code  OUT NUMBER,
                               p_mensaje     OUT VARCHAR2) is

  BEGIN
  p_error_code:=0;
  p_mensaje:='OK';

  BEGIN
  SELECT S.COD_ID, S.CUSTOMER_ID
    INTO p_cod_id, p_customer_id
    FROM SALES.SOT_SIAC S
   WHERE CODSOLOT = p_cod_sot;
   EXCEPTION
    WHEN too_many_rows THEN
       p_error_code := -3;
      p_mensaje    := 'La consulta devuelve mas de un registro';
    WHEN NO_DATA_FOUND THEN
       p_error_code := -2;
      p_mensaje    := 'No existe informaci?n con la SOT ingresada';
    WHEN OTHERS THEN
      p_error_code := -1;
      p_mensaje    := 'Error en la consulta: '||SQLERRM;
   END;
  END;

  PROCEDURE p_insert_co_id(p_cod_sot     in solot.codsolot%TYPE,
                           p_customer_id IN solot.customer_id%TYPE,
                           p_cod_id      IN solot.cod_id%TYPE,
                           P_ERROR       IN NUMBER,
                           P_MSG_ERROR   IN VARCHAR2,
                           p_error_code  OUT NUMBER,
                           p_mensaje     OUT VARCHAR2) IS
  BEGIN
    p_error_code := 0;
    p_mensaje    := 'OK';

    BEGIN
      INSERT INTO SALES.SOT_SIAC
        (cod_id, codsolot, cod_error, msg_error, customer_id)
      VALUES
        (p_cod_id, p_cod_sot, P_ERROR, P_MSG_ERROR, p_customer_id);
    EXCEPTION
      WHEN OTHERS THEN
        p_error_code := -1;
        p_mensaje    := 'Error en el registro: ' || SQLERRM;
    END;
  END;
  --7.0>

  procedure p_insert_log_post_siac(an_cod_id      operacion.postventasiac_log.co_id%type,
                                   an_customer_id operacion.postventasiac_log.customer_id%type,
                                   av_proceso     operacion.postventasiac_log.proceso%type,
                                   av_msgerror    operacion.postventasiac_log.msgerror%type) is
    pragma autonomous_transaction;
  begin
    insert into operacion.postventasiac_log
      (co_id,customer_id,msgerror,proceso)
    values
      (an_cod_id,an_customer_id,av_msgerror,av_proceso);
    commit;
  exception
    when others then
      rollback;
  end;

  --INI 19.0
  /****************************************************************
  '* Nombre SP : SGAFUN_VALIDA_CB_PLAN
  '* Prop?sito : Validar el tipo de trabajo de la SOT para Cambio Plan HFC
  '* Input  : K_CODSOLOT - Codigo de SO
  '* Output :  - Valor devuelto por la funcion
                            - 1 - Con visita
                            - 0 - Sin visita
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/
  FUNCTION SGAFUN_VALIDA_CB_PLAN(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_TIPTRA     NUMBER;
    LN_TIPTRA_SOT NUMBER;
    LV_MSJ_ERR    VARCHAR2(4000);
  BEGIN

    SELECT A.CODIGON
      INTO LN_TIPTRA
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
       AND A.ABREVIACION IN ('HFC_SIAC_CPLAN');

    SELECT S.TIPTRA
      INTO LN_TIPTRA_SOT
      FROM SOLOT S
     WHERE S.CODSOLOT = K_CODSOLOT;

    IF LN_TIPTRA_SOT = LN_TIPTRA THEN
      RETURN 1; -- SOT - HFC CAMBIO DE PLAN
    ELSE
      RETURN 0; -- SOT - NO ES HFC CAMBIO DE PLAN
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                    'SGAFUN_VALIDA_CB_PLAN, ' || CHR(13) || 'P_CODSOLOT: ' ||
                    TO_CHAR(K_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                    TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                    TO_CHAR(SQLERRM); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              LV_MSJ_ERR || CHR(13) ||
                              ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  /****************************************************************
  '* Nombre SP : SGAFUN_VALIDA_CB_PLAN_VISITA
  '* Prop?sito : Validar el tipo de trabajo y motivo de la SOT para Cambio Plan HFC
  '* Input  : K_CODSOLOT - Codigo de SO
  '* Output :  - Valor devuelto por la funcion
                            - 1 - Con visita
                            - 0 - Sin visita
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/
  FUNCTION SGAFUN_VALIDA_CB_PLAN_VISITA(K_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE)
    RETURN NUMBER IS
    LN_TIPTRA       NUMBER;
    LN_TIPTRA_SOT   NUMBER;
    LN_CODMOTOT     NUMBER;
    LN_CODMOTOT_PAR NUMBER;
    LV_MSJ_ERR      VARCHAR2(4000);
  BEGIN

    SELECT A.CODIGON
      INTO LN_TIPTRA
      FROM OPEDD A, TIPOPEDD B
     WHERE A.TIPOPEDD = B.TIPOPEDD
       AND B.ABREV IN ('TIPTRA_HFC_LTE_CP')
       AND A.ABREVIACION IN ('HFC_SIAC_CPLAN');

    SELECT S.TIPTRA, S.CODMOTOT
      INTO LN_TIPTRA_SOT, LN_CODMOTOT
      FROM SOLOT S
     WHERE S.CODSOLOT = K_CODSOLOT;

    SELECT T.CODIGON
      INTO LN_CODMOTOT_PAR
      FROM OPERACION.OPEDD T
     WHERE T.ABREVIACION = 'HFC_SI_VISTA'
       AND T.TIPOPEDD =
           (SELECT TP.TIPOPEDD
              FROM OPERACION.TIPOPEDD TP
             WHERE TP.ABREV = 'TIPO_MOT_HFC_LTE_VIS');

    IF LN_TIPTRA_SOT = LN_TIPTRA AND LN_CODMOTOT = LN_CODMOTOT_PAR THEN
      RETURN 1; -- SOT - HFC CAMBIO DE PLAN SIN VISITA (NO GENERA AGENDA)
    ELSE
      RETURN 0; -- SOT - HFC CAMBIO DE PLAN CON VISITA (GENERA AGENDA)
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      LV_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                    'SGAFUN_VALIDA_CB_PLAN_VISITA, ' || CHR(13) ||
                    'P_CODSOLOT: ' || TO_CHAR(K_CODSOLOT) || CHR(13) ||
                    'CODIGO DE ERROR: ' || TO_CHAR(SQLCODE) || CHR(13) ||
                    'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM); -- 3.0
      RAISE_APPLICATION_ERROR(-20000,
                              LV_MSJ_ERR || CHR(13) ||
                              ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- 3.0
  END;

  /****************************************************************
  '* Nombre SP : SGASI_GEST_RECURSOS
  '* Prop?sito : Realiza la provision en IW, Carga de equipos
  '* Input  : K_IDTAREAWF - Id. tarea del workflow
              K_IDWF      - Id. de workflow
              K_TAREA     - Id. tarea
              K_TAREADEF  - Id. definicion de la tarea
  '* Output :  -
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/

 PROCEDURE SGASI_GEST_RECURSOS(K_IDTAREAWF IN NUMBER,
                               K_IDWF      IN NUMBER,
                               K_TAREA     IN NUMBER,
                               K_TAREADEF  IN NUMBER) IS

   V_CODSOLOT    operacion.solot.codsolot%TYPE;
   V_COD_ID      operacion.solot.cod_id%TYPE;
   V_CUSTOMER_ID operacion.solot.customer_id%TYPE;
   V_MSJ_ERR     VARCHAR2(4000);
   V_COD_ERR     NUMBER;
   V_VALOR       VARCHAR(1);
   V_FLGTIPTRA   NUMBER;
   v_error EXCEPTION;
 BEGIN
   BEGIN
      SELECT NVL(op.codigoc, '0')
        INTO V_VALOR
        FROM opedd op
       WHERE op.abreviacion = 'ACT_CPLAN'
         AND op.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd b
               WHERE B.ABREV = 'CONF_WLLSIAC_CP');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VALOR := '0';
    END;

   IF V_VALOR = '0' THEN
     RETURN;
   END IF;

   SELECT wf.codsolot
     INTO V_CODSOLOT
     FROM wf
    WHERE wf.idwf = K_IDWF
      AND wf.estwf = 2;

   SELECT s.cod_id, s.customer_id
     INTO V_COD_ID, V_CUSTOMER_ID
     FROM solot s
    WHERE s.codsolot = V_CODSOLOT;

    BEGIN
      SELECT SGAFUN_VALIDA_CB_PLAN(V_CODSOLOT) INTO V_FLGTIPTRA FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        V_FLGTIPTRA := 0;
    END;

   IF V_FLGTIPTRA = 1 THEN
     INTRAWAY.PQ_PROVISION_ITW.P_ICG_MODSERV(V_CODSOLOT, V_COD_ERR, V_MSJ_ERR , 0);

     /*INTRAWAY.PQ_INT_CAMBIO_PLAN_SISACT.SGASI_EXECUTE_MAIN(V_COD_ID,
                                                           V_CUSTOMER_ID,
                                                           V_CODSOLOT,
                                                           V_COD_ERR,
                                                           V_MSJ_ERR);*/

     IF V_COD_ERR <> 1 THEN
       RAISE_APPLICATION_ERROR(-20001, V_MSJ_ERR);
     END IF;

   END IF;
 EXCEPTION
   WHEN OTHERS THEN
     V_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                  'SGASI_GEST_RECURSOS, ' || CHR(13) || 'P_CODSOLOT: ' ||
                  TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                  TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                  TO_CHAR(SQLERRM);
     RAISE_APPLICATION_ERROR(-20000,
                             V_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                             DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
 END SGASI_GEST_RECURSOS;

  /****************************************************************
  '* Nombre SP : SGASI_REGISTRO_JANUS
  '* Prop?sito : Realiza la provision en JANUS
  '* Input  : K_IDTAREAWF - Id. tarea del workflow
              K_IDWF      - Id. de workflow
              K_TAREA     - Id. tarea
              K_TAREADEF  - Id. definicion de la tarea
  '* Output :  -
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/

  PROCEDURE SGASI_REGISTRO_JANUS(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER) IS

    V_CODSOLOT operacion.solot.codsolot%TYPE;
    V_MSJ_ERR  VARCHAR2(4000);
    v_error    NUMBER;
    V_VALOR    VARCHAR(1);
    v_exc_error EXCEPTION;
    V_VAL_ONHOLD   number;
    ln_visita_tecn number;
  BEGIN
    BEGIN
      SELECT NVL(op.codigoc, '0')
        INTO V_VALOR
        FROM opedd op
       WHERE op.abreviacion = 'ACT_CPLAN'
         AND op.tipopedd =
             (SELECT tipopedd
                FROM operacion.tipopedd b
               WHERE B.ABREV = 'CONF_WLLSIAC_CP');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VALOR := '0';
    END;

    IF V_VALOR = '0' THEN
      RETURN;
    END IF;

    SELECT w.codsolot,
           OPERACION.PQ_ANULACION_BSCS.F_VALIDA_BSCS(s.cod_id),
           SGAFUN_VALIDA_CB_PLAN_VISITA(s.codsolot)
      INTO V_CODSOLOT, V_VAL_ONHOLD, ln_visita_tecn
      FROM wf w, solot s
     WHERE w.codsolot = s.codsolot
       and w.idwf = K_IDWF
       AND w.valido = 1;

    IF V_VAL_ONHOLD = 1 and ln_visita_tecn = 0 THEN
      SGASI_CAMBIO_PLAN_JANUS(V_CODSOLOT, v_error, V_MSJ_ERR);
    end if;

    IF v_error <> 1 THEN
      ROLLBACK;
      RAISE v_exc_error;
    ELSE
      COMMIT;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      V_MSJ_ERR := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_REGISTRO_JANUS, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM);
      RAISE_APPLICATION_ERROR(-20000,
                              V_MSJ_ERR || CHR(13) || ' TRAZA DE ERROR:   ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  END SGASI_REGISTRO_JANUS;

  /****************************************************************
  '* Nombre SP : SGASI_INICIA_FACT_HFC
  '* Prop?sito : Realiza el proceso para inicio de facturacion.
  '* Input  : K_CODSOLOT - Codigo de SOT
  '* Output : K_ERROR   - Codigo de error
                        -1 : error
                        0  : OK
              K_MENSAJE - Descripcion del error
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/
  PROCEDURE SGASI_INICIA_FACT_HFC(K_CODSOLOT IN NUMBER,
                                  K_ERROR    OUT NUMBER,
                                  K_MENSAJE  OUT VARCHAR2) IS

    V_CODSOLOT   operacion.solot.codsolot%TYPE;
    v_error      NUMBER;
    v_mensaje    VARCHAR2(4000);
    v_cod_id     operacion.solot.cod_id%TYPE;
    v_cod_id_old operacion.solot.cod_id%TYPE;
    v_tiptra_cp  NUMBER;
    v_val_onhold NUMBER;
    error_general exception;

  BEGIN
    v_codsolot := k_codsolot;

    k_error    := 0;
    k_mensaje  := 'Exito en el Proceso';

    select s.cod_id, s.cod_id_old
      into v_cod_id, v_cod_id_old
      from solot s
     where s.codsolot = v_codsolot;

    -- para relanzar reservas hfc en bscs
    select operacion.pq_anulacion_bscs.f_valida_bscs(v_cod_id)
      into v_val_onhold
      from dual;

    if v_val_onhold = 1 then
      webservice.pq_ws_hfc.p_gen_reservahfc(v_cod_id,
                                            v_codsolot,
                                            v_error,
                                            v_mensaje);
    end if;

    --inicio de facturacion
    operacion.pq_cont_regularizacion.sp_regularizacion(v_cod_id,
                                                       v_error,
                                                       v_mensaje);
    if v_error <> 0 then
      rollback;
      v_mensaje := 'Error en el proceso de Inicio de Facturacion BSCS ' ||
                   v_mensaje;
      raise error_general; /*
          raise_application_error(-20001,
                                  'Error en el proceso de Inicio de Facturacion BSCS ' ||
                                  v_mensaje);*/
    end if;

    select operacion.pq_sga_bscs.f_get_is_cp_hfc(v_codsolot)
      into v_tiptra_cp
      from dual;

    -- desactivacion de contrario anterior
    if v_tiptra_cp > 0 then
      operacion.pq_sga_bscs.p_desactiva_contrato_cplan(v_codsolot,
                                                       v_cod_id_old,
                                                       v_error,
                                                       v_mensaje);

      if v_error <> 1 then
        rollback;
        v_mensaje := 'Error en la Desactivacion del Contrato Anterior por Cambio de Plan : ' ||
                     v_mensaje;
        raise error_general;
        /*raise_application_error(-20001,
        'Error en la Desactivacion del Contrato Anterior por Cambio de Plan');*/
      end if;
    end if;

  exception
    when error_general then
      k_error   := v_error;
      k_mensaje := v_mensaje;
    when others then
      k_error   := -1;
      k_mensaje := 'ERROR AL EJECUTAR FNC: ' || $$PLSQL_UNIT || '.' ||
                   'SGASI_INICIA_FACT_HFC, ' || CHR(13) || 'P_CODSOLOT: ' ||
                   TO_CHAR(V_CODSOLOT) || CHR(13) || 'CODIGO DE ERROR: ' ||
                   TO_CHAR(SQLCODE) || CHR(13) || 'MENSAJE DE ERROR: ' ||
                   TO_CHAR(SQLERRM) || ' Linea : ('||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||')';
  END;
  /****************************************************************
  '* Nombre SP : SGASS_VISITA_TECNICA
  '* Prop?sito : Realiza cierre automatico de las tareas para WF Cambio Plan HFC
  '* Input  : -
  '* Output : -
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/

  PROCEDURE SGASS_VISITA_TECNICA(P_OPER VARCHAR2) IS

    LN_COD_REP       NUMBER;
    LS_MSJ_RESP      VARCHAR2(1000);
    V_TIPTRA         OPERACION.SOLOT.TIPTRA%TYPE;
    V_CODMOTOT       OPERACION.SOLOT.CODMOTOT%TYPE;
    V_FECHA          VARCHAR2(50);
    V_LENGTH         NUMBER;
    LN_SERVTELEFONIA NUMBER;
    LN_VALPENDIENTE  NUMBER;
    LN_CIERRE_JANUS  NUMBER;
    V_VAL_ONHOLD     NUMBER;
    LN_TLF_OLD       NUMBER;

    CURSOR C_SOT_SVT(K_TIPTRA NUMBER, K_CODMOTOT NUMBER) IS
      SELECT S.CODSOLOT CPN_SOLOT, S.COD_ID, S.CUSTOMER_ID, S.CODCLI, S.COD_ID_OLD -- 24.0
        FROM OPERACION.SOLOT S
       WHERE S.TIPTRA = K_TIPTRA
         AND S.CODMOTOT = K_CODMOTOT
         AND S.ESTSOL = 17
         AND S.COD_ID IS NOT NULL
         AND S.CUSTOMER_ID IS NOT NULL;

    CURSOR C_TAREA_SOT(K_CODSOLOT NUMBER) IS
      SELECT TW.IDTAREAWF,
             TW.IDWF,
             TW.TAREA,
             TW.TAREADEF,
             XX.CODIGOC,
             XX.CODIGON_AUX,
             XX.DESCRIPCION
        FROM OPEWF.TAREAWF TW,
             OPEWF.WF W,
             (SELECT B.CODIGOC, B.CODIGON, B.CODIGON_AUX, B.DESCRIPCION
                FROM OPERACION.TIPOPEDD A, OPERACION.OPEDD B
               WHERE A.TIPOPEDD = B.TIPOPEDD
                 AND A.ABREV = 'CONF_CP_CIERRE_SVT'
                 AND B.ABREVIACION = P_OPER) XX
       WHERE W.IDWF = TW.IDWF
         AND W.CODSOLOT = K_CODSOLOT
         AND TW.TAREADEF = XX.CODIGON
         AND W.VALIDO = 1
         AND TW.ESTTAREA = 1;

  BEGIN

    V_LENGTH := 20;
    --Obtener tipo trabajo y codigo de motivo
    SELECT A.CODIGON
      INTO V_TIPTRA
      FROM OPEDD A
     WHERE A.TIPOPEDD =
           (SELECT B.TIPOPEDD
              FROM TIPOPEDD B
             WHERE B.ABREV = ('TIPTRA_HFC_LTE_CP'))
       AND A.ABREVIACION = (CASE
             WHEN P_OPER = 'HFC' THEN
              'HFC_SIAC_CPLAN'
             WHEN P_OPER = 'LTE' THEN
              'LTE_SIAC_CPLAN'
           END);

    SELECT T.CODIGON
      INTO V_CODMOTOT
      FROM OPERACION.OPEDD T
     WHERE T.TIPOPEDD =
           (SELECT TP.TIPOPEDD
              FROM OPERACION.TIPOPEDD TP
             WHERE TP.ABREV = 'TIPO_MOT_HFC_LTE_VIS')
       AND T.ABREVIACION = (CASE
             WHEN P_OPER = 'HFC' THEN
              'HFC_SI_VISTA'
             WHEN P_OPER = 'LTE' THEN
              'LTE_SI_VISTA'
           END);

    -- INICIO VISITA TECNICA HFC
    FOR C_SVT IN C_SOT_SVT(V_TIPTRA, V_CODMOTOT) LOOP
      BEGIN
        FOR C_TAREAS IN C_TAREA_SOT(C_SVT.CPN_SOLOT) LOOP

          DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(RPAD(' Tarea: ' ||
                                                    C_TAREAS.DESCRIPCION,
                                                    V_LENGTH + 8,
                                                    ' '),
                                               V_LENGTH + 8,
                                               ' ') ||
                               ' > Inicio de Cierre de Tarea');

          -- CIERRE DE TAREAS AUTOMATICAS
          CASE C_TAREAS.CODIGOC
            WHEN 'AUTO' THEN
              OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                               C_TAREAS.CODIGON_AUX,
                                                               LN_COD_REP,
                                                               LS_MSJ_RESP);

              OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                              C_SVT.CUSTOMER_ID,
                                              NULL,
                                              C_SVT.CPN_SOLOT,
                                              NULL,
                                              LN_COD_REP,
                                              LS_MSJ_RESP,
                                              C_SVT.COD_ID,
                                              'SGASS_CIERRE_TAREA-' ||
                                              C_TAREAS.DESCRIPCION);

              IF LN_COD_REP = 0 THEN
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') ||
                                     ' > Se cerro correctamente');
              ELSE
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') || ' > Error: ' ||
                                     LS_MSJ_RESP);
                GOTO SOT;
              END IF;

            WHEN 'PROV' THEN
              LN_COD_REP := 0;

              OPERACION.PQ_SIAC_CAMBIO_PLAN.P_REG_TRS_CP_VIS(C_SVT.CPN_SOLOT,
                                                             LN_COD_REP,
                                                             LS_MSJ_RESP);

              OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                              C_SVT.CUSTOMER_ID,
                                              NULL,
                                              C_SVT.CPN_SOLOT,
                                              NULL,
                                              LN_COD_REP,
                                              LS_MSJ_RESP,
                                              C_SVT.COD_ID,
                                              'SGASI_GEST_RECURSOS');

              /* BEGIN
                INTRAWAY.PQ_INT_CAMBIO_PLAN_SISACT.SGASI_EXECUTE_MAIN(C_SVT.COD_ID,
                                                                      C_SVT.CUSTOMER_ID,
                                                                      C_SVT.CPN_SOLOT,
                                                                      LN_COD_REP,
                                                                      LS_MSJ_RESP);
                IF LN_COD_REP <> 0 THEN
                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Error: ' || LS_MSJ_RESP);

                  OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                  C_SVT.CUSTOMER_ID,
                                                  NULL,
                                                  C_SVT.CPN_SOLOT,
                                                  NULL,
                                                  LN_COD_REP,
                                                  LS_MSJ_RESP,
                                                  C_SVT.COD_ID,
                                                  'SGASI_GEST_RECURSOS');
                  GOTO SOT;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN

                  LN_COD_REP  := -2020;
                  LS_MSJ_RESP := 'SGASI_GEST_RECURSOS :' || SQLERRM;

                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Error: ' || LS_MSJ_RESP);

                  OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                  C_SVT.CUSTOMER_ID,
                                                  NULL,
                                                  C_SVT.CPN_SOLOT,
                                                  NULL,
                                                  LN_COD_REP,
                                                  LS_MSJ_RESP,
                                                  C_SVT.COD_ID,
                                                  'SGASI_GEST_RECURSOS');
                  GOTO SOT;

              END;*/

              OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                               C_TAREAS.CODIGON_AUX,
                                                               LN_COD_REP,
                                                               LS_MSJ_RESP);

              IF LN_COD_REP = 0 THEN
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') ||
                                     ' > Se cerro correctamente');
              ELSE
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') || ' > Error: ' ||
                                     LS_MSJ_RESP);
                GOTO SOT;
              END IF;

            WHEN 'JANUS' THEN

              LN_SERVTELEFONIA := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(C_SVT.CPN_SOLOT);
              --INI 24.0
              LN_TLF_OLD       := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(C_SVT.COD_ID_OLD));

              OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                C_SVT.CUSTOMER_ID,
                                                NULL,
                                                C_SVT.CPN_SOLOT,
                                                NULL,
                                                1,
                                                'Inicia el Proceso : Antes ('||to_char(LN_TLF_OLD)||') - Ahora ('||to_char(LN_SERVTELEFONIA)||')',
                                                C_SVT.COD_ID,
                                                'SGASI_CAMBIO_PLAN_JANUS');
              --FIN 24.0
              IF LN_SERVTELEFONIA = 1 OR LN_TLF_OLD = 1 THEN --24.0

                SELECT OPERACION.PQ_ANULACION_BSCS.F_VALIDA_BSCS(C_SVT.COD_ID)
                  INTO V_VAL_ONHOLD
                  FROM DUAL;

                IF V_VAL_ONHOLD = 1 THEN
                  WEBSERVICE.PQ_WS_HFC.P_GEN_RESERVAHFC(C_SVT.COD_ID,
                                                        C_SVT.CPN_SOLOT,
                                                        LN_COD_REP,
                                                        LS_MSJ_RESP);
                END IF;

                SELECT COUNT(1)
                  INTO LN_VALPENDIENTE
                  FROM OPERACION.PROV_SGA_JANUS P
                 WHERE P.CODSOLOT = C_SVT.CPN_SOLOT
                   AND P.ACCION = 16;

                SELECT OPERACION.PQ_ANULACION_BSCS.F_VALIDA_BSCS(C_SVT.COD_ID)
                  INTO V_VAL_ONHOLD
                  FROM DUAL;

                IF LN_VALPENDIENTE > 0 or V_VAL_ONHOLD = 1 THEN
                  GOTO SOT;
                END IF;

                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASI_CAMBIO_PLAN_JANUS(C_SVT.CPN_SOLOT,
                                                                      LN_COD_REP,
                                                                      LS_MSJ_RESP);

                -- Cuando no cambia el plan base y opcional se coloca la tarea en No-Interviene
                if LN_COD_REP = -5 then
                  OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                                   8,
                                                                   LN_COD_REP,
                                                                   LS_MSJ_RESP);
                elsif LN_COD_REP = 0 then
                  OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                                   4,
                                                                   LN_COD_REP,
                                                                   LS_MSJ_RESP);
                end if;

                OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                C_SVT.CUSTOMER_ID,
                                                NULL,
                                                C_SVT.CPN_SOLOT,
                                                NULL,
                                                LN_COD_REP,
                                                LS_MSJ_RESP,
                                                C_SVT.COD_ID,
                                                'SGASI_CAMBIO_PLAN_JANUS');
              ELSE
                --INI 24.0
                OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                                C_SVT.CUSTOMER_ID,
                                                NULL,
                                                C_SVT.CPN_SOLOT,
                                                NULL,
                                                10,
                                                'Se coloca no Interviene la SOT porque no cuenta con Telefonia',
                                                C_SVT.COD_ID,
                                                'SGASI_CAMBIO_PLAN_JANUS');
                --FIN 24.0
                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                                 8,
                                                                 LN_COD_REP,
                                                                 LS_MSJ_RESP);
              END IF;

            WHEN 'INIFAC' THEN
              LN_SERVTELEFONIA := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(C_SVT.CPN_SOLOT);

              IF LN_SERVTELEFONIA = 1 THEN

                SELECT COUNT(1)
                  INTO LN_VALPENDIENTE
                  FROM OPERACION.PROV_SGA_JANUS P
                 WHERE P.CODSOLOT = C_SVT.CPN_SOLOT
                   AND P.ESTADO = 0;

                SELECT COUNT(TW.IDTAREAWF)
                  INTO LN_CIERRE_JANUS
                  FROM OPEWF.TAREAWF TW,
                       OPEWF.WF W,
                       (SELECT B.CODIGOC, B.CODIGON
                          FROM OPERACION.TIPOPEDD A, OPERACION.OPEDD B
                         WHERE A.TIPOPEDD = B.TIPOPEDD
                           AND A.ABREV = 'CONF_CP_CIERRE_SVT'
                           AND B.ABREVIACION = P_OPER
                           AND B.CODIGOC = 'JANUS') XX
                 WHERE W.IDWF = TW.IDWF
                   AND W.CODSOLOT = C_SVT.CPN_SOLOT
                   AND TW.TAREADEF = XX.CODIGON
                   AND W.VALIDO = 1
                   AND TW.ESTTAREA = 1;

                IF OPERACION.PQ_SGA_JANUS.F_VAL_PROV_JANUS_PEND(C_SVT.CPN_SOLOT) != 0 OR
                   LN_VALPENDIENTE > 0 OR LN_CIERRE_JANUS > 0 THEN

                  GOTO SOT;

                END IF;

              END IF;

              OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASI_INICIA_FACT_HFC(C_SVT.CPN_SOLOT,
                                                                  LN_COD_REP,
                                                                  LS_MSJ_RESP);

              OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                              C_SVT.CUSTOMER_ID,
                                              NULL,
                                              C_SVT.CPN_SOLOT,
                                              NULL,
                                              LN_COD_REP,
                                              LS_MSJ_RESP,
                                              C_SVT.COD_ID,
                                              'SGASI_INICIA_FACT_HFC');

              IF LN_COD_REP = 0 THEN
                OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(C_TAREAS.IDTAREAWF,
                                                                 C_TAREAS.CODIGON_AUX,
                                                                 LN_COD_REP,
                                                                 LS_MSJ_RESP);

                IF LN_COD_REP = 0 THEN
                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Se cerro correctamente');
                ELSE
                  DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                       C_TAREAS.DESCRIPCION,
                                                       V_LENGTH + 8,
                                                       ' ') ||
                                       ' > Error: ' || LS_MSJ_RESP);
                  GOTO SOT;
                END IF;
              ELSE
                DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD(' Tarea: ' ||
                                                     C_TAREAS.DESCRIPCION,
                                                     V_LENGTH + 8,
                                                     ' ') || ' > Error: ' ||
                                     LS_MSJ_RESP);
                GOTO SOT;
              END IF;
            ELSE
              DBMS_OUTPUT.PUT_LINE(V_FECHA || RPAD('No existe configuracion para la Tarea: ' ||
                                                   C_TAREAS.DESCRIPCION,
                                                   V_LENGTH + 8,
                                                   ' '));
          END CASE;

          <<SOT>>
          LN_COD_REP := 0;

        END LOOP;

        commit;
      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          LN_COD_REP  := SQLERRM;
          LS_MSJ_RESP := 'MENSAJE DE ERROR: ' || TO_CHAR(SQLERRM) ||
                         CHR(13) || '-TRAZA DE ERROR:   ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

          OPERACION.PQ_SGA_BSCS.P_REG_LOG(C_SVT.CODCLI,
                                          C_SVT.CUSTOMER_ID,
                                          NULL,
                                          C_SVT.CPN_SOLOT,
                                          NULL,
                                          LN_COD_REP,
                                          LS_MSJ_RESP,
                                          C_SVT.COD_ID,
                                          'C_TAREA_SOT');
      end;

    END LOOP;
  END SGASS_VISITA_TECNICA;

  /****************************************************************
  '* Nombre SP : SGASS_CIERRE_TAREA
  '* Prop?sito : Realiza cierre de tareas para WF Cambio Plan HFC
  '* Input  : P_CODSOLOT    : Codigo de SOT
              P_IDTAREAWF   : Id. Tarea de Workflow
              P_DESCRIPCION : Descripcion
              P_ESTADO      :
  '* Output : P_COD_RESP    :
              P_MSJ_RESP    :
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/

  PROCEDURE SGASS_CIERRE_TAREA(P_IDTAREAWF   OPEWF.TAREAWF.IDTAREAWF%TYPE,
                               P_ESTADO      NUMBER,
                               P_COD_RESP    OUT NUMBER,
                               P_MSJ_RESP    OUT VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(P_IDTAREAWF,
                                     4,
                                     P_ESTADO,
                                     0,
                                     SYSDATE,
                                     SYSDATE);
    COMMIT;
    P_COD_RESP := 0;
    P_MSJ_RESP := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
      P_COD_RESP := -99;
      P_MSJ_RESP := '-CODIGO  DE ERROR: '|| TO_CHAR(SQLCODE) || CHR(13) ||
                    '-TRAZA DE ERROR:   '|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
  END;

  /****************************************************************
  '* Nombre SP : SGASS_DET_EQUIPO
  '* Prop?sito : Retorna un cursos con los equipos actuales del cliente
  '* Input  : K_COD_ID - Codigo de SOT
  '* Output : K_CURSOR - Cursor de retorno
              K_ERROR   - Codigo de error
                        -1 : error
                        0  : OK
              K_MENSAJE - Descripcion del error
  '* Creado por : Felipe Magui?a
  '* Fec Creaci?n : 10/07/2017
  '* Fec Actualizaci?n :
  '****************************************************************/
 PROCEDURE SGASS_DET_EQUIPO(K_COD_ID  operacion.solot.cod_id%TYPE,
                            K_CURSOR  OUT SYS_REFCURSOR,
                            K_ERROR   OUT NUMBER,
                            K_MENSAJE OUT VARCHAR2) IS

   v_impuesto NUMBER;

 BEGIN

   SELECT T.PORCENTAJE
     INTO v_impuesto
     FROM BILLCOLPER.IMPUESTO T
    WHERE T.ESDEFAULT = 1;

   OPEN k_cursor FOR
     SELECT X.dscequ,
            CASE
              WHEN X.tipsrv = '0004' THEN
               'TELEFONO'
              WHEN X.tipsrv = '0006' THEN
               'INTERNET'
              WHEN X.tipsrv = '0062' THEN
               'CABLE'
            END tipsrv,
            SUM((SELECT TIM.TFUN115_CARGOFIJO_X_SERV@DBL_BSCS_BF(k_cod_id,
                                                                 sis.servv_id_bscs) *
                        ((v_impuesto + 100) / 100)
                   FROM sales.servicio_sisact        ses,
                        usrpvu.sisact_ap_servicio@dbl_pvudb sis
                  WHERE sis.servv_codigo = ses.idservicio_sisact
                    AND ses.codsrv = X.codsrv) * cantidad) cargo_fijo, SUM(cantidad) cantidad
       FROM (SELECT DISTINCT (SELECT ve.dscequ
                                FROM vtaequcom ve
                               WHERE ve.codequcom = ip.codequcom) dscequ,
                             IV.TIPSRV,
                             iv.codsrv,
                             ip.pid,
                             IP.codequcom,
                             ip.cantidad
               FROM solot s, solotpto sp, insprd ip, inssrv iv
              WHERE s.codsolot = sp.codsolot
                AND sp.codinssrv = iv.codinssrv
                AND ip.codinssrv = iv.codinssrv
                AND s.cod_id = k_cod_id
                AND iv.tipsrv IN ('0004', '0006', '0062')
                AND ip.estinsprd IN (1, 2)) X
      WHERE nvl(X.codequcom, 'X') != 'X'
      GROUP BY dscequ, tipsrv;

 END;
  --FIN 19.0

  PROCEDURE SGASI_CAMBIO_PLAN_JANUS(AN_CODSOLOT IN NUMBER,
                                    K_ERROR     OUT NUMBER,
                                    K_MENSAJE   OUT VARCHAR2) IS

    V_ERROR             NUMBER;
    V_MENSAJE           VARCHAR2(4000);
    LN_CUSTOMER         NUMBER;
    LV_NUMERO           VARCHAR2(20);
    LN_COD_ID           SOLOT.COD_ID%TYPE;
    LN_COD_ID_OLD       SOLOT.COD_ID_OLD%TYPE;
    LN_MAX_CODSOLOT_OLD SOLOT.CODSOLOT%TYPE;
    AN_ERROR            NUMBER;
    AV_ERROR            VARCHAR2(4000);
    LN_FLG_TLF_NEW      NUMBER;
    LN_FLG_TLF_OLD      NUMBER;
    --ERROR_GENERAL EXCEPTION;
    LV_TARFIF_PROV_NEW VARCHAR2(200);
    LV_TARFIF_PROV_OLD VARCHAR2(200);
    LN_EXI_JANUS       NUMBER;
    ln_existe_csc      number;
    error_general_log exception;
    LV_NUMERO_OLD INSSRV.NUMERO%TYPE;
    LV_CODCLI     VARCHAR2(100);
    LN_VAL        NUMBER;
    LN_CODINSSRV  NUMBER;

    LN_ERR  NUMBER;
    LN_ERR1 NUMBER := 0;
    LV_MEN  VARCHAR2(9000);
    LV_MEN1 VARCHAR2(9000) := 'Error :';
	  LN_ORDERID     NUMBER;	--MARP20190624
	
    --MARP20190624-INI
    -- OBTIENE LOS SNCODE DEL CONTRATO ANTERIOR QUE NO ESTAN EN EL CONTRATO NUEVO Y SE ENCUENTRAN ACTIVOS.
    CURSOR C_SERVADICDATOS IS
      SELECT SLT.COD_ID_OLD, CA.CUSTOMER_ID, CA.TMCODE, SSH.SNCODE
       FROM ( SELECT DISTINCT S.COD_ID, s.COD_ID_OLD  
                FROM operacion.solot s
               WHERE s.COD_ID_OLD is not null
           ) SLT,
           PROFILE_SERVICE@DBL_BSCS_BF       PS, 
           CONTRACT_ALL@DBL_BSCS_BF       	 CA,
           PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH,
           TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P,
           PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH 
      WHERE SLT.COD_ID  = LN_COD_ID      --CONTRATO ACTUAL
        AND PS.CO_ID    = SLT.COD_ID_OLD --CONTRATO ANTERIOR
        AND CA.CO_ID    = PS.CO_ID
        AND SSH.CO_ID   = PS.CO_ID
        AND SSH.SNCODE  = PS.SNCODE
        AND SSH.HISTNO  = PS.STATUS_HISTNO
        AND SSH.STATUS  IN ('O','A')
        AND P.CAMPO     = 'SERV_ADICIONAL'
        AND P.COD_PROD2 = PS.SNCODE
        AND SPH.CO_ID   = PS.CO_ID
        AND SPH.SNCODE  = PS.SNCODE
        AND SPH.HISTNO  = PS.SPCODE_HISTNO
        AND NOT EXISTS (SELECT ''
                          FROM PROFILE_SERVICE@DBL_BSCS_BF     PS2, 
                             PR_SERV_STATUS_HIST@DBL_BSCS_BF   SSH2,
                             TIM.PF_HFC_PARAMETROS@DBL_BSCS_BF P2,
                             PR_SERV_SPCODE_HIST@DBL_BSCS_BF   SPH2      
                          WHERE PS2.CO_ID    = SLT.COD_ID --CONTRATO ACTUAL
                          AND SSH2.CO_ID   = PS2.CO_ID
                          AND SSH2.SNCODE  = PS2.SNCODE
                          AND SSH2.HISTNO  = PS2.STATUS_HISTNO
                          AND SSH2.STATUS  IN ('O','A')
                          AND P2.CAMPO     = 'SERV_ADICIONAL'
                          AND P2.COD_PROD2 = PS2.SNCODE
                          AND SPH2.CO_ID   = PS2.CO_ID
                          AND SPH2.SNCODE  = PS2.SNCODE
                          AND SPH2.HISTNO  = PS2.SPCODE_HISTNO
                          AND SSH2.SNCODE  = SSH.SNCODE -- VALIDA SNCODE EXISTENTES
							 );
    --MARP20190624-FIN
	   
  BEGIN

    K_ERROR   := 0;
    K_MENSAJE := 'Exito';

    SELECT S.COD_ID_OLD,
           S.COD_ID,
           S.CUSTOMER_ID,
           OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID_OLD), -- Obtener la ultima SOT del contrato anterior
           OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(S.CODSOLOT), -- Validar si la SOT tiene el servicio de Telefonia
           (SELECT distinct INS.NUMERO
              FROM SOLOTPTO PTO, INSSRV INS
             WHERE PTO.CODINSSRV = INS.CODINSSRV
               AND PTO.CODSOLOT = S.CODSOLOT
               AND INS.TIPINSSRV = 3) -- Obtener el Numero Telefonico Actual
      INTO LN_COD_ID_OLD,
           LN_COD_ID,
           LN_CUSTOMER,
           LN_MAX_CODSOLOT_OLD,
           LN_FLG_TLF_NEW,
           LV_NUMERO
      FROM SOLOT S
     WHERE S.CODSOLOT = AN_CODSOLOT;

    LN_FLG_TLF_OLD := OPERACION.PQ_SGA_JANUS.F_VAL_SERV_TLF_SOT(LN_MAX_CODSOLOT_OLD);

    IF LN_FLG_TLF_NEW = LN_FLG_TLF_OLD AND LN_FLG_TLF_NEW != 0 THEN

      LN_EXI_JANUS := OPERACION.PQ_SGA_JANUS.F_VAL_EXIS_LINEA_JANUS(LV_NUMERO);

      IF LN_EXI_JANUS = 1 THEN

        ln_existe_csc := operacion.pq_sga_bscs.f_val_existe_contract_sercad(ln_cod_id);

        --Insertamos en la Contr_servicas si no existe
        if ln_existe_csc = 0 then
          begin
            operacion.pq_sga_bscs.p_reg_contr_services_cap(ln_cod_id,
                                                           lv_numero,
                                                           AN_ERROR,
                                                           AV_ERROR);
            commit;
          exception
            when others then
              K_MENSAJE := 'Error al Registrar en la contr_services_cap : ' ||
                           sqlcode || ' ' || sqlerrm || ' (' ||
                           dbms_utility.format_error_backtrace || ')';
              raise error_general_log;
          end;
        end if;

        LV_TARFIF_PROV_NEW := OPERACION.PQ_SGA_BSCS.F_GET_TARFIF_PROV_TLF_HFC(LN_COD_ID);

        LV_TARFIF_PROV_OLD := OPERACION.PQ_SGA_BSCS.F_GET_TARFIF_PROV_TLF_HFC(LN_COD_ID_OLD);

        IF LV_TARFIF_PROV_NEW != LV_TARFIF_PROV_OLD THEN

          OPERACION.PQ_SGA_JANUS.P_VALIDA_LINEA_BSCS_SGA(AN_CODSOLOT,
                                                         'REGU',
                                                         V_ERROR,
                                                         V_MENSAJE);

          IF V_ERROR != 1 THEN
            K_ERROR   := V_ERROR;
            K_MENSAJE := V_MENSAJE;
          END IF;
        ELSE
          K_ERROR   := -5;
          K_MENSAJE := 'Mismo Tarrift_ID';
        END IF;
		
        --MARP20190624-INI
        --DAR DE BAJA SERVICIOS ADICIONALES
        FOR CUR_SERV IN C_SERVADICDATOS LOOP
            OPERACION.PQ_SGA_JANUS.SP_PROV_ADIC_JANUS( CUR_SERV.COD_ID_OLD,
                                                       CUR_SERV.CUSTOMER_ID,
                                                       CUR_SERV.TMCODE,
                                                       CUR_SERV.SNCODE,
                                                       'D',
                                                       AN_ERROR,
                                                       AV_ERROR,
                                                       LN_ORDERID);	
            if an_error != 0 then
              K_ERROR   := an_error;
              K_MENSAJE := av_error;
              raise error_general_log;
            end if;
        END LOOP;
        --MARP20190624-FIN
	   
      ELSE
	  
        operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(1,
                                                           an_codsolot,
                                                           ln_cod_id,
                                                           LN_CUSTOMER,
                                                           to_char(LN_CUSTOMER),
                                                           null,
                                                           an_error,
                                                           av_error);
        if an_error != 1 then
          K_ERROR   := an_error;
          K_MENSAJE := av_error;
          raise error_general_log;
        end if;

        K_ERROR   := 0;
        K_MENSAJE := 'Se genero programo provision de Alta Janus porque la linea no esta Registrada';
      END IF;

    ELSIF LN_FLG_TLF_NEW = 0 AND LN_FLG_TLF_OLD = 1 THEN
      -- Baja en JANUS
      BEGIN
        SELECT DISTINCT INS.NUMERO, INS.CODINSSRV, INS.CODCLI
          INTO LV_NUMERO_OLD, LN_CODINSSRV, LV_CODCLI
          FROM SOLOTPTO PTO, INSSRV INS
         WHERE PTO.CODINSSRV = INS.CODINSSRV
           AND PTO.CODSOLOT = LN_MAX_CODSOLOT_OLD
           AND INS.TIPINSSRV = 3;
      EXCEPTION
        WHEN OTHERS THEN
          LV_NUMERO_OLD := NULL;
      END;

      IF LV_NUMERO_OLD IS NOT NULL THEN
        LN_EXI_JANUS := OPERACION.PQ_SGA_JANUS.F_VAL_EXIS_LINEA_JANUS(LV_NUMERO_OLD);
        IF LN_EXI_JANUS = 1 THEN
          OPERACION.PQ_SGA_JANUS.SGASI_BAJA_JANUS_TLFCLI(lv_numero_old,
                                                         LN_CUSTOMER,
                                                         ln_cod_id,
                                                         V_ERROR,
                                                         V_MENSAJE);
          if V_ERROR = 1 then
            K_ERROR   := 0;
            K_MENSAJE := V_MENSAJE;
          else
            K_ERROR   := V_ERROR;
            K_MENSAJE := V_MENSAJE;
          end if;
        ELSE
          K_ERROR   := 0;
          K_MENSAJE := 'OK';
        END IF;
        --Bajamos la Linea de IC
        BEGIN

          LN_VAL := OPERACION.PQ_SGA_JANUS.f_get_constante_conf('BAJANUMCPHFC');

          IF LN_VAL = 0 THEN
            INTRAWAY.PQ_INT_CAMBIO_PLAN_SISACT.SGASI_BAJA_NUMERO_CP(LV_NUMERO_OLD,
                                                                    LN_COD_ID_OLD,
                                                                    LN_MAX_CODSOLOT_OLD,
                                                                    V_ERROR,
                                                                    V_MENSAJE);

            OPERACION.PQ_SGA_BSCS.P_REG_LOG(LV_CODCLI,
                                            LN_CUSTOMER,
                                            NULL,
                                            AN_CODSOLOT,
                                            NULL,
                                            1,
                                            V_MENSAJE,
                                            LN_COD_ID,
                                            'SGASI_CAMBIO_PLAN_JANUS');

          ELSIF LN_VAL = 1 THEN

            LV_MEN1 := 'Ejecucion Baja Telefonia';

            INTRAWAY.PQ_PROVISION_ITW.P_INT_BAJALLTLF(to_char(LN_CUSTOMER),
                                                      LN_MAX_CODSOLOT_OLD,
                                                      LN_CODINSSRV,
                                                      0,
                                                      LN_ERR,
                                                      LV_MEN);

            IF LN_ERR <> 1 THEN
              LV_MEN1 := ' (Proceso INTRAWAY.PQ_PROVISION_ITW.P_INT_BAJALLTLF' ||
                         LV_MEN || ')|';
            END IF;

            OPERACION.PQ_SGA_BSCS.P_REG_LOG(LV_CODCLI,
                                            LN_CUSTOMER,
                                            NULL,
                                            AN_CODSOLOT,
                                            NULL,
                                            1,
                                            LV_MEN1,
                                            LN_COD_ID,
                                            'SGASI_CAMBIO_PLAN_JANUS');

            LV_MEN1 := 'Ejecucion Baja MTA';

            INTRAWAY.PQ_PROVISION_ITW.P_INT_BAJALLMTA(to_char(LN_CUSTOMER),
                                                      LN_MAX_CODSOLOT_OLD,
                                                      LN_CODINSSRV,
                                                      0,
                                                      LN_ERR,
                                                      LV_MEN);

            IF LN_ERR <> 1 THEN
              LV_MEN1 := ' (Proceso INTRAWAY.PQ_PROVISION_ITW.P_INT_BAJALLMTA' ||
                         LV_MEN || ')|';
            END IF;

            OPERACION.PQ_SGA_BSCS.P_REG_LOG(LV_CODCLI,
                                            LN_CUSTOMER,
                                            NULL,
                                            AN_CODSOLOT,
                                            NULL,
                                            1,
                                            LV_MEN1,
                                            LN_COD_ID,
                                            'SGASI_CAMBIO_PLAN_JANUS');

            LV_MEN1 := 'Ejecucion INT_ENVIO';

            INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO(LN_MAX_CODSOLOT_OLD,
                                                        4,
                                                        LN_ERR,
                                                        LV_MEN);

            IF LN_ERR <> 1 THEN
              LV_MEN1 := ' (Proceso INTRAWAY.PQ_PROVISION_ITW.P_INSERTXSECENVIO' ||
                         LV_MEN || ')|';
            END IF;

            OPERACION.PQ_SGA_BSCS.P_REG_LOG(LV_CODCLI,
                                            LN_CUSTOMER,
                                            NULL,
                                            AN_CODSOLOT,
                                            NULL,
                                            1,
                                            LV_MEN1,
                                            LN_COD_ID,
                                            'SGASI_CAMBIO_PLAN_JANUS');

          END IF;

        EXCEPTION
          WHEN OTHERS THEN
            OPERACION.PQ_SGA_BSCS.P_REG_LOG(LV_CODCLI,
                                            LN_CUSTOMER,
                                            NULL,
                                            AN_CODSOLOT,
                                            NULL,
                                            1,
                                            'ERROR ' || LV_MEN1,
                                            LN_COD_ID,
                                            'SGASI_CAMBIO_PLAN_JANUS');
        END;

      ELSE
        K_MENSAJE := 'No tiene Asignado Numero Telefonico en la INSSRV';
        raise error_general_log;
      END IF;

    ELSIF LN_FLG_TLF_NEW = 1 AND LN_FLG_TLF_OLD = 0 THEN
      operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(1,
                                                         an_codsolot,
                                                         ln_cod_id,
                                                         LN_CUSTOMER,
                                                         to_char(LN_CUSTOMER),
                                                         null,
                                                         an_error,
                                                         av_error);
      if an_error != 1 then
        K_ERROR   := an_error;
        K_MENSAJE := av_error;
        raise error_general_log;
      end if;

      K_ERROR   := 0;
      K_MENSAJE := 'Se genero programo provision de Alta Janus porque la linea no esta Registrada';

    ELSE
      K_ERROR   := 0;
      K_MENSAJE := 'Cliente no tiene servicio de Telefonia';
    END IF;

  EXCEPTION
    when error_general_log then
      K_ERROR := -100;
    WHEN OTHERS THEN
      K_ERROR   := -100;
      K_MENSAJE := 'SGASI_CAMBIO_PLAN_JANUS : Error en el Proceso ' ||
                   ' Linea : (' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';

  END SGASI_CAMBIO_PLAN_JANUS;

  PROCEDURE P_REG_TRS_CP_VIS(AN_CODSOLOT IN NUMBER,
                             AN_ERROR    OUT NUMBER,
                             AV_ERROR    OUT VARCHAR2) IS

    cursor c_sot is
      select operacion.pq_sga_iw.f_max_sot_x_cod_id(s.cod_id_old) codsolot_aux,
             s.codsolot,
             s.cod_id,
             s.customer_id,
             s.codcli,
             s.fecusu
        from operacion.solot s
       where s.tiptra = 695
         and s.codmotot = 1009
         and s.estsol = 17
         and s.cod_id is not null
         and s.customer_id is not null
         and s.codsolot = an_codsolot
         and exists (select 1
                from operacion.sga_visita_tecnica_siac v
               where v.co_id = s.cod_id_old
                 and v.customer_id = s.customer_id)
       order by s.codsolot desc;

    cursor c_iw(an_codsolot_ant number) is
      select t.*,
             e.modelo        modelo_itw,
             e.mac_address   mac_address_itw,
             e.unit_address  unit_address_itw,
             e.serial_number
        from operacion.trs_interface_iw t, operacion.tab_equipos_iw e
       where t.id_producto = e.id_producto
         and t.codsolot = an_codsolot_ant;

        cursor c_iw_tep(an_cod_solot_ant number) is
             SELECT iw.*
               FROM OPERACION.TRS_INTERFACE_IW iw
              WHERE iw.id_interfase in (824)
                and TIP_INTERFASE = 'TEP'
                and iw.CODSOLOT = an_cod_solot_ant;

    cursor c_itw_det(an_idtrs number) is
      select *
        from operacion.trs_interface_iw_det t
       where t.idtrs = an_idtrs;

    n_IDTRS    number;
    v_contador number;
    ann_error  number;
    avv_error  varchar2(4000);
    LN_CODINSSRV NUMBER;            -- 20.0
	  LN_PIDSGA 	 NUMBER;            -- 21.0

  BEGIN

    an_error := 0;
    av_error := 'Exito en el Proceso';

    for c in c_sot loop

      operacion.pq_cont_regularizacion.p_cons_det_iw(c.codsolot_aux,
                                                     ann_error,
                                                     avv_error);
      commit;

      for i in c_iw(c.codsolot_aux) loop

        select count(1)
          into v_contador
          from operacion.trs_interface_iw a
         where a.codsolot = c.codsolot
           and a.id_producto = i.id_producto
           and a.id_producto_padre = i.id_producto_padre;

        if v_contador = 0 then
          select operacion.sq_trs_interface_iw.nextval
            into n_idtrs
            from dual;
-- ini 20.0
            BEGIN
                SELECT DISTINCT PTO.CODINSSRV
                  into ln_codinssrv
                  FROM SOLOTPTO PTO, SOLOT S, INSSRV INS_NEW, INSSRV INS
                 WHERE PTO.CODSOLOT = C.CODSOLOT
                   AND PTO.CODSOLOT = S.CODSOLOT
                   AND PTO.CODINSSRV = INS_NEW.CODINSSRV
                   AND INS.CODINSSRV = I.CODINSSRV

                   AND INS_NEW.TIPSRV = INS.TIPSRV
                   AND S.CODCLI = INS.CODCLI;
             EXCEPTION
                 WHEN OTHERS THEN
                      ln_codinssrv := i.codinssrv ;
             END;
-- fin 20.0
          LN_PIDSGA := get_pid(C.CODSOLOT, ln_codinssrv, i.pidsga); --21.0

          insert into operacion.trs_interface_iw
            (idtrs,
             tip_interfase,
             id_interfase,
             valores,
             modelo,
             mac_address,
             unit_address,
             customer_id,
             codigo_ext,
             id_producto,
             id_producto_padre,
             id_servicio_padre,
             cod_id,
             codcli,
             codsolot,
             codinssrv,
             pidsga,
             id_servicio,
             estado,
             codactivacion,
             trs_prov_bscs,
             estado_bscs,
             estado_iw)
          values
            (n_idtrs,
             i.tip_interfase,
             i.id_interfase,
             i.valores,
             nvl(i.modelo, i.modelo_itw),
             nvl(i.serial_number, i.mac_address_itw),
             i.unit_address_itw,
             i.customer_id,
             i.codigo_ext,
             i.id_producto,
             i.id_producto_padre,
             i.id_servicio_padre,
             c.cod_id,
             i.codcli,
             c.codsolot,
             ln_codinssrv,    -- 20.0
			       LN_PIDSGA,		    -- 21.0
             i.id_servicio,
             i.estado,
             i.codactivacion,
             i.trs_prov_bscs,
             i.estado_bscs,
             i.estado_iw);

          for d in c_itw_det(i.idtrs) loop
            insert into operacion.trs_interface_iw_det
              (idtrs, atributo, valor, orden)
            values
              (n_idtrs, d.atributo, d.valor, d.orden);
          end loop;

        end if;
      end loop;


-- ini INC000001323597
       for it in c_iw_tep(c.codsolot_aux) loop

        select count(1)
          into v_contador
          from operacion.trs_interface_iw a
         where a.codsolot = c.codsolot
           and a.id_producto = it.id_producto
           and a.id_producto_padre = it.id_producto_padre;

        if v_contador = 0 then
          select operacion.sq_trs_interface_iw.nextval
            into n_idtrs
            from dual;

            BEGIN
                SELECT DISTINCT PTO.CODINSSRV
                  into ln_codinssrv
                  FROM SOLOTPTO PTO, SOLOT S, INSSRV INS_NEW, INSSRV INS
                 WHERE PTO.CODSOLOT = C.CODSOLOT
                   AND PTO.CODSOLOT = S.CODSOLOT
                   AND PTO.CODINSSRV = INS_NEW.CODINSSRV
                   AND INS.CODINSSRV = IT.CODINSSRV

                   AND INS_NEW.TIPSRV = INS.TIPSRV
                   AND S.CODCLI = INS.CODCLI;
             EXCEPTION
                 WHEN OTHERS THEN
                      ln_codinssrv := it.codinssrv ;
             END;

          LN_PIDSGA := get_pid(C.CODSOLOT, ln_codinssrv, it.pidsga); --21.0

          insert into operacion.trs_interface_iw
            (idtrs,
             tip_interfase,
             id_interfase,
             valores,
             modelo,
             mac_address,
             unit_address,
             customer_id,
             codigo_ext,
             id_producto,
             id_producto_padre,
             id_servicio_padre,
             cod_id,
             codcli,
             codsolot,
             codinssrv,
             pidsga,
             id_servicio,
             estado,
             codactivacion,
             trs_prov_bscs,
             estado_bscs,
             estado_iw)
          values
            (n_idtrs,
             it.tip_interfase,
             it.id_interfase,
             it.valores,
             it.modelo,
             it.mac_address,
             it.unit_address,
             it.customer_id,
             it.codigo_ext,
             it.id_producto,
             it.id_producto_padre,
             it.id_servicio_padre,
             c.cod_id,
             it.codcli,
             c.codsolot,
             ln_codinssrv,
             LN_PIDSGA,        -- 21.0
             it.id_servicio,
             it.estado,
             it.codactivacion,
             it.trs_prov_bscs,
             it.estado_bscs,
             it.estado_iw);

          for d in c_itw_det(it.idtrs) loop
            insert into operacion.trs_interface_iw_det
              (idtrs, atributo, valor, orden)
            values
              (n_idtrs, d.atributo, d.valor, d.orden);
          end loop;

        end if;
      end loop;

-- fin INC000001323597

      operacion.pq_cont_regularizacion.p_cons_det_iw(c.codsolot,
                                                     ann_error,
                                                     avv_error);
      commit;

    end loop;
  exception
    when others then
      an_error := -10;
      av_error := 'ERROR: ' || sqlerrm || ' Linea : (' ||
                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  END P_REG_TRS_CP_VIS;

  FUNCTION SGAFUN_ACTUALIZA_ANOTACION(AV_ANOTACION IN VARCHAR2,
                                      AN_CODSOLOT IN NUMBER,
                                      AN_PROCESS  IN NUMBER)
                                     RETURN VARCHAR2 IS
  BEGIN
    UPDATE operacion.siac_postventa_proceso
       SET ANOTACION_TOA = AV_ANOTACION,
           CODSOLOT = AN_CODSOLOT
     WHERE IDPROCESS = AN_PROCESS;
    RETURN 'OK';
  EXCEPTION
    when others then
      RETURN 'ERROR';
  END;

  /****************************************************************
  '* Nombre SP : SGASS_VAL_EQUIPOXSERV
  '* Prop?ito : Realiza la validacion que todos los servicios principales vienen con Comodato
  '* Input  : pi_idinteracion - Id Interacion
  '* Output : K_ERROR   - Codigo de error
                        -1 : error
                        1  : OK
              K_MENSAJE - Descripcion del error
  '* Creado por : Luis Flores
  '* Fec Creaci? : 17/08/2018
  '* Fec Actualizaci? :
  '****************************************************************/
 procedure SGASS_VAL_EQUIPOXSERV(pi_idinteracion sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                                 po_error        out number,
                                 po_mensaje      out varchar2) is
   cursor c_val is
     SELECT p.descripcion,
            p.flgprincipal,
            t.idinteraccion,
            xx.codigoc,
            t.servicio,
            t.idgrupo,
            t.idgrupo_principal
       FROM sales.sisact_postventa_det_serv_hfc t,
            sales.servicio_sisact ss,
            tystabsrv ts,
            producto p,
            (select o.codigon, o.codigon_aux, o.codigoc
               from tipopedd t, opedd o
              where t.tipopedd = o.tipopedd
                and t.abrev = 'IDPRODUCTOCONTINGENCIA') xx
      where t.servicio = ss.idservicio_sisact(+)
        and ss.codsrv = ts.codsrv
        and p.idproducto = ts.idproducto
        and xx.codigon = p.idproducto
        and t.idinteraccion = pi_idinteracion;

   ln_check   number;
   ln_val_equ number;
   exception_general exception;
 begin
   po_error   := 1;
   po_mensaje := 'OK';

   ln_check := operacion.pq_sga_janus.f_get_constante_conf('VALEQUXSERVFIJA');

   if ln_check = 1 then
     for c in c_val loop
       -- Buscamos si el servicio principal tiene un Equipo Asociado
       select count(1)
         into ln_val_equ
         from sales.sisact_postventa_det_serv_hfc svs
        where svs.idinteraccion = c.idinteraccion
          and svs.tipequ is not null
          and svs.idgrupo_principal = c.idgrupo;

       if ln_val_equ = 0 then
         po_mensaje := 'El producto ' || c.descripcion ||
                       ' no tiene Comodato Asociado ' || ' IDINTERACION (' ||
                       C.IDINTERACCION || ') - Grupo (' || c.idgrupo || ')';
         raise exception_general;

       end if;
     end loop;

   else
     po_error   := 1;
     po_mensaje := 'OK';
   end if;
 exception
   when exception_general then
     po_error := -1;
   when others then
     po_error   := -1;
     po_mensaje := 'ERROR : Proceso (SGASS_VAL_EQUIPOXSERV) ' || sqlerrm;
 end SGASS_VAL_EQUIPOXSERV;


 /*********************************************/
 /*********************************************/
 /*********************************************/

   PROCEDURE CAMBIO_CABLE(n_codsolot IN solot.codsolot%type,
                          v_codcli  IN solot.codcli%type,
                          n_codsolot_cur IN number
                          ) IS



  n_id_estado number;


  n_SID_Cable number;
  n_pid_cable number;
  n_pid_cable_e number;
  v_codact varchar2(32);
  n_indicador number;
  n_cuenta_stb NUMBER;
  n_cod_id number;
  v_mensaje varchar2(4000);
  v_codsuc vtasuccli.codsuc%type;



  n_error number;
  error_general EXCEPTION;
  v_tipsrv varchar2(4):= '0062';
  v_cod_ext_stb tystabsrv.codigo_ext%type;
  v_numslc vtatabslcfac.numslc%type;
  v_channelmap varchar2(100);
  v_configcrmid varchar2(100);
  v_sendtocontroler varchar2(30);
  n_cont_VOD number;
  v_pid_stb_fac varchar2(100);
  n_cuenta number;
  n_cantidad_stb number;
  n_customer_id number;
  n_cont_val number;

  L_VALDCODACT NUMBER;

  cursor c_stb is
    SELECT a.pid, a.punto, p.cantidad, a.codinssrv sid, c.dscsrv
    FROM solotpto a, tystabsrv c, tystipsrv d, insprd p
    WHERE a.codsrvnue = c.codsrv
    and c.tipsrv = d.tipsrv
    and a.pid = p.pid
   and a.codinssrv = n_SID_Cable
    and p.codequcom is not null
    and a.codsolot = n_codsolot;



  cursor c_complemento is
    SELECT a.pid,a.pid_old,a.codinssrv,
    OPERACION.PQ_PROMO3PLAY.F_PROMO3PLAY_SRVPROM(n_codsolot,v_codcli,c.CODSRV,3) codigo_ext
    FROM solotpto a, tystabsrv c, insprd p
    WHERE a.codsolot = n_codsolot_cur
    AND a.codsrvnue = c.codsrv
    AND c.tipsrv = v_tipsrv
    AND a.pid = p.pid
    AND p.flgprinc = 0
    AND c.codigo_ext IS NOT NULL
    and p.codequcom is null
    AND P.ESTINSPRD <> 3;
  BEGIN

    BEGIN
        SELECT CODIGON_AUX INTO L_VALDCODACT FROM opedd WHERE TIPOPEDD = 1716 AND CODIGOC = '99';
    EXCEPTION
      WHEN OTHERS THEN
        L_VALDCODACT := 0;
    END;

    select count(1) into n_cont_val from opedd a, tipopedd b
    where a.tipopedd=b.tipopedd and b.abrev='VALCARDATHFCBSCS';

    select b.cod_id,b.numslc,b.customer_id
    into n_cod_id,v_numslc,n_customer_id
    from  solot b
    where b.codsolot = n_codsolot;



    if n_customer_id is null then
      OPERACION.PQ_IW_SGA_BSCS.p_reg_log(v_codcli,n_customer_id,null,n_codsolot,null,null,null,n_cod_id,'SOT sin Customer_id.');
      return;
    end if;


    SELECT min(c.codsuc) INTO v_codsuc FROM vtadetptoenl c
    WHERE c.numslc = v_numslc;


    BEGIN
      SELECT a.pid, a.codinssrv
      INTO n_pid_cable, n_SID_Cable
      FROM solotpto a, tystabsrv c, tystipsrv d, insprd p
      WHERE a.codsrvnue = c.codsrv and c.tipsrv = d.tipsrv
      and a.pid = p.pid and a.codinssrv = p.codinssrv
      and p.flgprinc = 1 and d.tipsrv = v_tipsrv
      and a.codsolot = n_codsolot;
    EXCEPTION
      WHEN OTHERS THEN
        n_pid_cable := 0;

          BEGIN
            SELECT DISTINCT A.CODINSSRV
              INTO n_SID_Cable
              FROM SOLOTPTO A, INSPRD P, INSSRV I
             WHERE A.CODINSSRV = I.CODINSSRV
               AND I.tipsrv = v_tipsrv
               AND A.PID = P.PID
               AND A.CODINSSRV = P.CODINSSRV
               AND A.CODSOLOT = n_codsolot;
          EXCEPTION
            WHEN OTHERS THEN
        n_SID_Cable := 0;
    END;
    END;

    n_cuenta_stb :=0;
    FOR lc_stb IN c_stb LOOP
        v_cod_ext_stb := OPERACION.PQ_IW_SGA_BSCS.f_obt_channelmap(lc_stb.sid,3,1);
        v_channelmap := OPERACION.PQ_IW_SGA_BSCS.f_obt_channelmap(lc_stb.sid,3,2);
        v_sendtocontroler := 'FALSE';
        v_configcrmid := OPERACION.PQ_IW_SGA_BSCS.f_obt_hub(lc_stb.sid);
        n_indicador:=1;
        n_cantidad_stb :=lc_stb.cantidad;
        FOR n_indicador in 1 .. n_cantidad_stb LOOP
          n_cuenta_stb := n_cuenta_stb + 1;
          n_pid_cable_e :=  lc_stb.pid ||  n_cuenta_stb;
          IF L_VALDCODACT = 1 THEN
            v_codact := OPERACION.PQ_IW_SGA_BSCS.f_obt_codact(n_id_estado,v_codcli,
            n_pid_cable_e,2020, n_codsolot, 2|| n_cuenta_stb||lpad(n_codsolot,7,0));
          ELSE
            v_codact := NULL;
          END IF;

          OPERACION.PQ_IW_SGA_BSCS.P_INTERFACE_STB(v_codcli,n_pid_cable_e,lc_stb.pid,v_codact,
            v_cod_ext_stb,v_channelmap,v_configcrmid,n_cod_id,n_codsolot,
            n_SID_cable,v_sendtocontroler,v_mensaje,n_error);
          IF n_error < 0 THEN
            v_mensaje := 'p_interface_stb : ' || v_mensaje;
            RAISE error_general;
          END IF;

          n_cuenta:=0;
          v_tipsrv:= v_tipsrv;


          for lc_comple in c_complemento loop
            n_cuenta := n_cuenta + 1;
            v_pid_stb_fac := n_pid_cable_e || n_cuenta;
            Select count(1) into n_cont_VOD
            from configuracion_itw i
            where i.estado = 1 and i.tiposervicioitw = 6
            and i.codigo_ext = lc_comple.codigo_ext;
            if n_cont_VOD > 0 then
              OPERACION.PQ_IW_SGA_BSCS.p_interface_stb_vod(v_codcli,v_pid_stb_fac,
                lc_comple.pid,n_pid_cable_e,lc_comple.codigo_ext,n_cod_id,n_codsolot,n_SID_cable,
                v_mensaje,n_error);
              IF n_error <> 0 THEN
                v_mensaje := 'p_interface_stb_vod : ' || v_mensaje;
                RAISE error_general;
              END IF;
            else
              OPERACION.PQ_IW_SGA_BSCS.p_interface_stb_sa(v_codcli,v_pid_stb_fac,
                lc_comple.pid,n_pid_cable_e,lc_comple.codigo_ext,n_cod_id,n_codsolot,n_SID_cable,
                v_mensaje,n_error);
              IF n_error <> 0 THEN
                v_mensaje := 'p_interface_stb_sa : codact ' || v_mensaje;
                RAISE error_general;
              END IF;
            end if;
          end loop;
        END LOOP;
    END LOOP;
  EXCEPTION
    WHEN error_general THEN
      OPERACION.PQ_IW_SGA_BSCS.p_reg_log(v_codcli,n_customer_id,NULL,n_codsolot,null,n_error,v_mensaje,n_cod_id,'Generaci??eserva');--10.0
    WHEN OTHERS THEN
      v_mensaje := SQLERRM;
      OPERACION.PQ_IW_SGA_BSCS.p_reg_log(v_codcli,n_customer_id,NULL,n_codsolot,null,n_error,v_mensaje,n_cod_id,'Generaci??eserva');--10.0
END;

PROCEDURE SGASI_DESACTIVA_CONTRATO_CE(PI_IDTAREAWF IN NUMBER,
                                        PI_IDWF      IN NUMBER,
                                        PI_TAREA     IN NUMBER,
                                        PI_TAREADEF  IN NUMBER) IS

    LN_COD_ID      OPERACION.SOLOT.COD_ID%TYPE;
    LN_CUSTOMER_ID OPERACION.SOLOT.CUSTOMER_ID%TYPE;
    LN_CODSOLOT    OPERACION.SOLOT.CODSOLOT%TYPE;
    LN_REASON      NUMBER;
    LN_ERROR       NUMBER;
    LV_ERROR       VARCHAR2(4000);

  BEGIN

    SELECT S.COD_ID, S.CUSTOMER_ID, S.CODSOLOT
      INTO LN_COD_ID, LN_CUSTOMER_ID, LN_CODSOLOT
      FROM WF W, SOLOT S
     WHERE W.IDWF = PI_IDWF
       AND W.CODSOLOT = S.CODSOLOT
       AND W.VALIDO = 1;

    IF LN_COD_ID IS NOT NULL THEN

      select a.codigon
        into ln_reason
        from opedd a, tipopedd b, solot s
       where a.tipopedd = b.tipopedd
         and b.abrev = 'SGAREASONTIPMOTOT'
         and a.codigon_aux = s.tiptra
         and s.codsolot = LN_CODSOLOT
         and a.codigoc = '1';

      OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASS_DESACTIVA_CONTRATO_BSCS(LN_COD_ID,
                                                                      LN_REASON,
                                                                      LN_ERROR,
                                                                      LV_ERROR);
    operacion.pq_sga_bscs.p_reg_log(null,
                                    LN_CUSTOMER_ID,
                                    NULL,
                                    LN_CODSOLOT,
                                    null,
                                    LN_ERROR,
                                    LV_ERROR,
                                    LN_COD_ID,
                                    'Desactiva Contrato - Cambio Plan CE HFC');

    ELSE
      OPERACION.PQ_SIAC_CAMBIO_PLAN.SGASS_CIERRE_TAREA(PI_IDTAREAWF,
                                                       8,
                                                       LN_ERROR,
                                                       LV_ERROR);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      LN_ERROR := -10;
  LV_ERROR := 'ERROR en la desactivacion : ' || SQLERRM || ' - Linea (' ||
        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ')';
  operacion.pq_sga_bscs.p_reg_log(null,
                  LN_CUSTOMER_ID,
                  NULL,
                  LN_CODSOLOT,
                  null,
                  LN_ERROR,
                  LV_ERROR,
                  LN_COD_ID,
                  'Desactiva Contrato - Cambio Plan CE HFC');
  END SGASI_DESACTIVA_CONTRATO_CE;

  PROCEDURE UPDATE_INSSERV_CAMBIO_PLAN(L_CODSOT IN NUMBER,
                            P_ERROR   OUT NUMBER,
                            P_MENSAJE OUT VARCHAR2) IS

   L_CODSOT_OLD NUMBER := 0;
   L_NUMERO VARCHAR2(20);
   L_NUMERO_OLD VARCHAR2(20);
   L_SID NUMBER := 0;
   L_SID_OLD NUMBER := 0;

 BEGIN
   select OPERACION.PQ_SGA_IW.F_MAX_SOT_X_COD_ID(S.COD_ID_OLD)
   into L_CODSOT_OLD
   from solot s, wf w
   where s.codsolot = L_CODSOT
   and s.codsolot = w.codsolot
   and w.valido = 1;

   if operacion.pq_sga_janus.f_val_serv_tlf_sot(L_CODSOT) = 0 then
     P_ERROR := -1;
     P_MENSAJE := 'SOT ' || L_CODSOT || ' NO TIENE SERVICIO DE TELEFONIA';
     RETURN;
   end if;

   if operacion.pq_sga_janus.f_val_serv_tlf_sot(L_CODSOT_OLD) = 0 then
     P_ERROR := -1;
     P_MENSAJE := 'SOT ' || L_CODSOT_OLD || ' NO TIENE SERVICIO DE TELEFONIA';
     RETURN;
   end if;

   BEGIN
     select distinct ins.numero, ins.codinssrv
     into L_NUMERO, L_SID
     from inssrv ins, solotpto pto
     where ins.codinssrv = pto.codinssrv
     and pto.codsolot = L_CODSOT
     and ins.tipinssrv = 3;

     IF L_NUMERO IS NULL THEN
       P_ERROR := -1;
       p_MENSAJE := 'NUMERO TELEFONICO ASOCIADO A LA SOT ' || L_CODSOT ||' ES NULO';
       RETURN;
     END IF;

   EXCEPTION
     WHEN OTHERS THEN
     P_ERROR := -1;
     P_MENSAJE := 'NO SE ENCUENTRA SID DE LA SOT ' || L_CODSOT;
     RETURN;
   END;

   BEGIN
     select distinct ins.numero, ins.codinssrv
     into L_NUMERO_OLD, L_SID_OLD
     from inssrv ins, solotpto pto
     where ins.codinssrv = pto.codinssrv
     and pto.codsolot = L_CODSOT_OLD
     and ins.tipinssrv = 3;
   EXCEPTION
     WHEN OTHERS THEN
     P_ERROR := -1;
     P_MENSAJE := 'NO SE ENCUENTRA SID DE LA SOT ' || L_CODSOT_OLD;
     RETURN;
   END;

   IF L_NUMERO_OLD IS NULL THEN
       P_ERROR := -1;
       p_MENSAJE := 'NUMERO TELEFONICO ASOCIADO A LA SOT ' || L_CODSOT_OLD ||' ES NULO';
       RETURN;
   END IF;

   BEGIN
     IF L_NUMERO_OLD = L_NUMERO THEN
        UPDATE numtel SET codinssrv = L_SID_OLD where numero = L_NUMERO;
     ELSE
       P_ERROR := -1;
       P_MENSAJE := 'ERROR: LOS NUMEROS NO COINCIDEN';
       RETURN;
     END IF;
   EXCEPTION
     WHEN OTHERS THEN
     P_ERROR := -1;
     P_MENSAJE := 'NO SE PUDO ACTUALIZAR EL SID ' || L_SID_OLD || ' AL NUMERO ' || L_NUMERO;
     RETURN;
   END;

   P_ERROR := 0;
   P_MENSAJE := 'ACTUALIZACION EXITOSA!';
 END;
 
 -- INI 21.0
 FUNCTION get_pid(AN_CODSOLOT  IN NUMBER,
                  AN_CODINSSRV IN NUMBER,
                  AN_PIDSGA    IN NUMBER)
                  RETURN NUMBER IS
  
  LN_PIDSGA 	 NUMBER;            
  LC_TIPSRV 	 CHAR(4);           
    
  BEGIN
    select tipsrv into LC_TIPSRV from inssrv pp where pp.CODINSSRV = AN_CODINSSRV;
            
    IF LC_TIPSRV = '0004' THEN --TELEFONIA
                              select a.pid INTO LN_PIDSGA
                                from solotpto a, inssrv b, insprd p
                               where a.codsolot  = AN_CODSOLOT
                                 and b.codinssrv = a.codinssrv
                                 and b.tipsrv    = LC_TIPSRV --'0004' -- fnd_tipsrv_tel;
                                 and p.codinssrv = b.codinssrv
                                 and p.pid       = a.pid
                                 and p.flgprinc  = 1  ;

    ELSIF LC_TIPSRV = '0006' THEN	--INTERNET
                              select a.pid INTO LN_PIDSGA
                                from solotpto a, tystabsrv b, insprd p
                               where a.codsolot  = AN_CODSOLOT
                                 and b.codsrv    = a.codsrvnue
                                 and b.tipsrv    = LC_TIPSRV --'0006'--fnd_tipsrv_int
                                 and p.pid       = a.pid
                                 and p.codinssrv = a.codinssrv
                                 and p.flgprinc  = 1 ;

    ELSIF LC_TIPSRV = '0062' THEN	--CABLE                                     
                              select aa.pid INTO LN_PIDSGA
                                from solotpto aa, insprd pp
                               where aa.codsolot  = AN_CODSOLOT
                                 and aa.pid       = pp.pid
                                 and aa.codinssrv =  ( SELECT  NVL (( select a.codinssrv
                                                                        from solotpto a, tystabsrv c, tystipsrv d, insprd p
                                                                       where a.codsolot  = aa.codsolot
                                                                         and c.codsrv    = a.codsrvnue
                                                                         and d.tipsrv    = c.tipsrv
                                                                         and d.tipsrv    = LC_TIPSRV--'0062'--fnd_tipsrv_cab
                                                                         and p.pid       = a.pid
                                                                         and p.codinssrv = a.codinssrv
                                                                         and p.flgprinc  = 1
                                                                      UNION
                                                                      select distinct a.codinssrv
                                                                        from solotpto a, inssrv i, insprd p
                                                                       where a.codsolot  = aa.codsolot
                                                                         and i.codinssrv = a.codinssrv
                                                                         and i.tipsrv    = LC_TIPSRV--'0062'--fnd_tipsrv_cab
                                                                         and p.pid       = a.pid
                                                                         and p.codinssrv = a.codinssrv
                                                                       ),0) FROM DUAL
                                            )
                                and pp.flgprinc = 1 ;
    ELSE
        LN_PIDSGA := AN_PIDSGA ;
    END IF;
          
  RETURN LN_PIDSGA;
  
  END;
  -- FIN 21.0
  
END;
/
