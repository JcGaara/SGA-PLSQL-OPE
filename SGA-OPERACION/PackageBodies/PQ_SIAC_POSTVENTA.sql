CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SIAC_POSTVENTA IS
  /************************************************************************************************
    NOMBRE:     OPERACION.PQ_POSTVENTA_UNIFICADA
    PROPOSITO:  Generacion de Post Venta Automatica HFC

    REVISIONES:
     Version   Fecha          Autor             Solicitado por      Descripcion
     -------- ----------   ------------------   -----------------   -----------------------
     1.0      2013-09-11   Alex Alamo           Hector Huaman       Generar Cambio de Plan y Traslado Externo
                           Eustaquio Gibaja
                           Mauro Zegarra
     2.0      2014-02-25   Carlos Chamache      Hector Huaman       Creacion de Servicios POST-VENTA
     3.0      2014-05-14   Hector Huaman        Hector Huaman       Creacion de Servicios POST-VENTA (Adecuaciones)
     4.0      2014-05-21   Hector Huaman        Hector Huaman       Cargo del servicio
     5.0      2014-07-21   Alex Alamo           Hector Huaman       modificar Proceso Cambio de Plan
     6.0      2014-08-19   Hector Huaman        Hector Huaman       SD-1173230
     7.0      2014-11-25   Eustaquio Gibaja     Hector Huaman       Mejoras en el flujo de traslado ext. (reemplazar variables globales)
     8.0      2014-11-28   Eustaquio Gibaja     Hector Huaman       Mejoras en la generacion de contacto de cliente.
     9.0      2014-12-11   Edwin Vasquez        Hector Huaman       Deco Adicional
    10.0      2015-01-22   Freddy Gonzales      Hector Huaman       Registrar datos en la tabla sales.int_negocio_instancia
                                                                    al generar una Post Venta desde Deco Adicional.
    11.0      2015-03-04   Freddy Gonzales      Guillermo Salcedo   SDM 230032: Generar SOT de Translado Externo cuando el cliente viene
                                                                    anteriormente con Cambio de plan.
    12.0      2015-03-23   Luz Facundo                               p_validad_transaccion
    13.0      2015-05-13   Freddy Gonzales      Hector Huaman       SD-298641
    14.0      2015-11-13   Fernando Loza        Richard Medina      SD-522935 generar raise_application_error en caso de error
    15.0      2015-11-26   Leonardo Silvera     Paul Moya           PROY-17652 IDEA-22491 - ETAdirect
    16.0      2016-02-03   Carlos Terán        Karen Velezmoro    SD-596715 Se activa la facturación en SGA (Alineación )
    17.0      2016-02-23   Juan Olivares        Paul Moya           PROY-17652 IDEA-22491 - ETAdirect
    18.0      2016-04-01                                            SD-642508 Cambio de Plan
    19.0      2016-04-20   Diego Ramos          Paul Moya           PROY-17652 IDEA-22491 - ETAdirect.
    20.0      2017-07-10   Felipe Maguiña        Tito Huertas        PROY-27792
    21.0      2017-07-10   Felipe Maguiña      Tito Huertas    PROY-27792
    22.0      2017-06-07   Juan Gonzales        Alfredo Yi          PROY-27792 Traslado Externo
    23.0      11/01/2018   Luis Flores          Jose Meza           PROY-27792.INC000001040503
    24.0      30/07/2018   Hitss                                    TOA
    25.0      09/04/2019   Luis Flores          Luis Flores         INC000001416203
    26.0      31/10/2019  Steve Panduro         FTTH                Traslado Externo / Interno FTTH
    27.0      14/11/2019  Steve Panduro         FTTH                Traslado Externo / Interno FTTH
  /************************************************************************************************/
  C_ACTIVO CONSTANT marketing.vtatabcli.idestado%TYPE := 1;

  procedure p_genera_transaccion(p_id                 sales.sisact_postventa_det_serv_hfc.idinteraccion%type,
                                 v_cod_id             sales.sot_sisact.cod_id%type,
                                 v_customer_id        sales.cliente_sisact.customer_id%type,
                                 v_tipotrans          varchar2,
                                 v_codintercaso       varchar2,
                                 v_tipovia            inmueble.tipviap%type,
                                 v_nombrevia          inmueble.nomvia%type,
                                 v_numerovia          inmueble.numvia%type,
                                 v_tipourbanizacion   vtasuccli.idtipurb%type,
                                 v_nombreurbanizacion vtasuccli.nomurb%type,
                                 v_manzana            inmueble.manzana%type,
                                 v_lote               inmueble.lote%type,
                                 v_codubigeo          vtatabdst.ubigeo%type,
                                 v_codzona            vtasuccli.codzona%type,
                                 v_idplano            vtasuccli.idplano%type,
                                 v_codedif            varchar2,
                                 v_referencia         inmueble.referencia%type,
                                 v_observacion        SOLOT.OBSERVACION%type,
                                 v_fec_prog           date,
                                 v_franja_horaria     varchar2,
                                 v_numcarta           vtatabprecon.carta%type,
                                 v_operador           vtatabprecon.carrier%type,
                                 v_presuscrito        vtatabprecon.presusc%type,
                                 v_publicar           vtatabprecon.publicar%type,
                                 v_ad_tmcode          varchar2,
                                 v_lista_coser        varchar2,
                                 v_lista_spcode       varchar2,
                                 v_usuarioreg         solot.codusu%type,
                                 v_cargo              agendamiento.cargo%type,
                                 v_codsolot           out solot.codsolot%type,
                                 p_error_code         out number,
                                 p_error_msg          out varchar2) is

    p_postventa     postventa_in_type;
    p_postventa_out postventa_out_type;
    as_areasol      solot.areasol%type;
    as_numslc       vtatabslcfac.numslc%type;    as_codusu       varchar2(50);
    p_idprocess     operacion.siac_postventa_proceso.idprocess%type;
    ac_mensaje      varchar2(200);
    flag_eta        varchar2(3) := '';
    ln_flag_cp      number;
    
  begin
    insert into operacion.nota (observacion) values (v_observacion);
    p_postventa.cod_id             := v_cod_id;
    p_postventa.customer_id        := v_customer_id;
    p_postventa.tipotrans          := v_tipotrans;
    p_postventa.codintercaso       := v_codintercaso;
    p_postventa.tipovia            := v_tipovia;
    p_postventa.nombrevia          := v_nombrevia;
    p_postventa.numerovia          := v_numerovia;
    p_postventa.tipourbanizacion   := v_tipourbanizacion;
    p_postventa.nombreurbanizacion := v_nombreurbanizacion;
    p_postventa.manzana            := v_manzana;
    p_postventa.lote               := v_lote;
    p_postventa.codubigeo          := v_codubigeo;
    p_postventa.codzona            := v_codzona;
    p_postventa.idplano            := v_idplano;
    p_postventa.codedif            := v_codedif;
    p_postventa.referencia         := v_referencia;
    p_postventa.observacion        := v_observacion;
    p_postventa.fec_prog           := v_fec_prog;
    p_postventa.franja_horaria     := v_franja_horaria;
    p_postventa.numcarta           := v_numcarta;
    p_postventa.operador           := v_operador;
    p_postventa.presuscrito        := v_presuscrito;
    p_postventa.publicar           := v_publicar;
    p_postventa.ad_tmcode          := v_ad_tmcode;
    p_postventa.lista_coser        := v_lista_coser;
    p_postventa.lista_spcode       := v_lista_spcode;
    p_postventa.cargo              := v_cargo;

    p_error_code := -1;
    p_error_msg  := 'ERROR';

    p_idprocess := set_negocio_proceso(p_postventa);
    g_idprocess := p_idprocess;

    regla_negocio('PRE');

    /*Validamos CO_ID*/
    p_valida_trans_co_id(v_cod_id);

    p_validad_transaccion(v_customer_id,
                          p_error_code,
                          p_error_msg);

    if p_error_code = 0 then
      if p_postventa.tipotrans = 'SIAC-HFC-TRASLADO_EXT' or
         p_postventa.tipotrans = 'SIAC-FTTH-TRASLADO_EXT' then
        --26.0
        load_information_te(p_postventa);
        operacion.pq_siac_traslado_externo.execute_main(p_postventa);
        v_codsolot := pq_siac_traslado_externo.get_postventa_codsolot(p_idprocess);
        --Actualizar el co_id
        update solot
           set cod_id = v_cod_id, customer_id = v_customer_id
         where codsolot = v_codsolot; -- 16.0

      elsif p_postventa.tipotrans = 'SIAC-HFC-CAMBIO_PLAN' then
        --Ini 25.0
        ln_flag_cp := operacion.pq_sga_janus.f_get_constante_conf('CVALDOBCPHFC');
        if ln_flag_cp = 1 then
          p_valida_cp_idinteraccion(v_codintercaso, 
                                    v_cod_id, 
                                    v_codsolot, 
                                    p_error_code,
                                    p_error_msg);
         if p_error_code != 0 then
           return;
         end if;
        end if;
        --fin 25.0
        
        operacion.pq_siac_cambio_plan.execute_main(p_id,
                                                   p_postventa.cod_id,
                                                   load_information_cp(p_postventa));
        p_postventa_out := get_postventa_out(p_postventa.tipotrans);
        regla_negocio('POS');
        v_codsolot := p_postventa_out.codsolot;
      elsif p_postventa.tipotrans = 'SIAC-HFC-DECO_ADICIONAL' then
        v_codsolot := operacion.pq_deco_adicional.deco_adicional(p_idprocess,
                                                                 p_id,
                                                                 v_cod_id,
                                                                 v_cargo);
      else
        RAISE_APPLICATION_ERROR(-20000,
                                'Tipo de Transaccion no definida: ' ||
                                p_postventa.tipotrans);
        return;
      end if;

      begin
        select p.codigon_aux
          into p_postventa.codmotot
          from tipopedd t, opedd p
         where t.tipopedd = p.tipopedd
           and t.abrev = 'TRANS_POSTVENTA'
           and p.abreviacion = p_postventa.tipotrans;
      exception
        when others then
          p_postventa.codmotot := null;
      end;

      --Obtener Area
      p_obt_area_x_cod_id(v_cod_id, as_areasol);

      --Actualizar usuario solicitante
      update solot
         set codusu      = v_usuarioreg,
             areasol     = as_areasol,
             codmotot    = decode(p_postventa.tipotrans,   --20.0
                                  'SIAC-HFC-CAMBIO_PLAN',
                                  NVL(v_codedif, p_postventa.codmotot),
                                  p_postventa.codmotot),
             customer_id = v_customer_id,
             cod_id      = decode(p_postventa.tipotrans,
                                  'SIAC-HFC-TRASLADO_EXT',
                                  v_cod_id,
                                  'SIAC-FTTH-TRASLADO_EXT',
                                  v_cod_id, ---26.0
                                  cod_id),
             cod_id_old  = decode(p_postventa.tipotrans,
                                  'SIAC-HFC-CAMBIO_PLAN',
                                  v_cod_id,
                                  null),
             cargo       = v_cargo,
             observacion = p_postventa.observacion
       where codsolot = v_codsolot;

      if v_codsolot is not null then
        update sales.sisact_postventa_det_serv_hfc
           set codsolot = v_codsolot
         where idinteraccion = p_id;
      end if;
      p_error_code := 0;
      p_error_msg  := 'OK';
    end if;

  exception
    when others then
      p_error_code := -1;
      p_error_msg  := format_msg(sqlerrm);
      set_log_err(p_error_msg);

      --<INI 14.0>
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'p_genera_transaccion' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>

  end;
  ----------------------------------------------------------------------------------
  PROCEDURE execute_main(p_postventa postventa_in_type,
                         p_id        sales.sisact_postventa_det_serv_hfc.idinteraccion%TYPE, --2.0
                         --p_servicios     operacion.pq_siac_cambio_plan.servicios_type, --<2.0>
                         p_postventa_out OUT postventa_out_type,
                         p_error_code    OUT NUMBER,
                         p_error_msg     OUT VARCHAR2) IS

  BEGIN
    p_error_code := -1;
    p_error_msg  := 'ERROR';

    g_idprocess := set_negocio_proceso(p_postventa);

    regla_negocio('PRE');

    IF p_postventa.tipotrans = 'SIAC-HFC-TRASLADO_EXT' or
       p_postventa.tipotrans = 'SIAC-FTTH-TRASLADO_EXT' THEN--26.0
      load_information_te(p_postventa);
      operacion.pq_siac_traslado_externo.execute_main(p_postventa);

      p_postventa_out := get_postventa_out(p_postventa.tipotrans);
    ELSIF p_postventa.tipotrans = 'SIAC-HFC-CAMBIO_PLAN' THEN
      --BEGIN --5.0
      operacion.pq_siac_cambio_plan.execute_main( --p_postventa.lista_sncode, <2.0>
                                                 --p_postventa.lista_tipequ, <2.0>
                                                 --p_servicios, --<2.0>
                                                 p_id, --2.0
                                                 p_postventa.cod_id,
                                                 load_information_cp(p_postventa));
      -- EXCEPTION WHEN OTHERS THEN --5.0
      --        p_error_msg := SQLERRM ; --5.0
      --  RAISE_APPLICATION_ERROR(-20000,SQLERRM); --5.0

      --  END ;    --5.0
      p_postventa_out := get_postventa_out(p_postventa.tipotrans);

      regla_negocio('POS');
    ELSE
      RAISE_APPLICATION_ERROR(-20000,
                              'Tipo de Transaccion no definida: ' ||
                              p_postventa.tipotrans);
      RETURN;
    END IF;

    p_error_code := 0;
    p_error_msg  := 'OK';

  EXCEPTION
    WHEN OTHERS THEN
      p_error_code := -1;
      p_error_msg  := '**ERROR    :    ' || SQLERRM; -- format_msg(SQLERRM); -- 5.0
      --set_log_err(p_error_msg); --5.0

      --<INI 14.0>
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'execute_main  - p_id = ' || p_id || ' -- ' ||
                              SQLERRM);
      --<FIN 14.0>

  END;
  /* **********************************************************************************************/
  FUNCTION get_postventa_out(p_tipotrans VARCHAR2) RETURN postventa_out_type IS
    l_postventa_out postventa_out_type;

  BEGIN
    CASE p_tipotrans
      WHEN 'SIAC-HFC-TRASLADO_EXT' THEN
        --ini 7.0
        /* l_postventa_out.codsuc   := operacion.pq_siac_traslado_externo.g_codsuc;
        l_postventa_out.numslc   := operacion.pq_siac_traslado_externo.g_numslc_new;
        l_postventa_out.codsolot := operacion.pq_siac_traslado_externo.g_codsolot;*/
        NULL;
        --fin 7.0
        --INI 26.0
      WHEN 'SIAC-FTTH-TRASLADO_EXT' THEN 
        NULL;
        -- FIN 26.0
      WHEN 'SIAC-HFC-CAMBIO_PLAN' THEN
        l_postventa_out.codsuc   := NULL;
        l_postventa_out.numslc   := operacion.pq_siac_cambio_plan.g_numslc_new;
        l_postventa_out.codsolot := operacion.pq_siac_cambio_plan.g_codsolot;
        --l_postventa_out.numslc   := operacion.pq_siac_cambio_plan.g_numslc_old;     --5.0
    END CASE;

    RETURN l_postventa_out;

    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'get_postventa_out - p_tipotrans= ' ||
                              p_tipotrans || ' -- ' || SQLERRM);
      --<FIN 14.0>

  END;
  --------------------------------------------------------------------------------
  procedure load_information_te(p_postventa postventa_in_type) is
    l_codcli     vtatabcli.codcli%type;
    l_numslc_old vtatabslcfac.numslc%type;
    l_codcnt     vtatabcntcli.codcnt%type;

  begin
    l_codcli     := get_codcli(p_postventa.customer_id);
    l_numslc_old := get_numslc(p_postventa.cod_id, l_codcli);
    verificar_cliente_proyecto(l_numslc_old, l_codcli);
    l_codcnt := get_contacto(l_codcli);

    if l_codcnt is null then
      l_codcnt := insert_vtatabcntcli(l_codcli);
    end if;

    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'load_information_te' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  end;
  /* **********************************************************************************************/
  FUNCTION load_information_cp(p_postventa postventa_in_type)
    RETURN operacion.pq_siac_cambio_plan.precon_type IS
    l_precon_type operacion.pq_siac_cambio_plan.precon_type;

  BEGIN
    l_precon_type.obsaprofe := p_postventa.observacion;
    l_precon_type.carta     := p_postventa.numcarta;
    l_precon_type.carrier   := p_postventa.operador;
    l_precon_type.presusc   := p_postventa.presuscrito;
    l_precon_type.publicar  := p_postventa.publicar;

    RETURN l_precon_type;
    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'load_information_cp' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION get_codcli(p_customer_id sales.cliente_sisact.customer_id%TYPE)
    RETURN sales.cliente_sisact.codcli%TYPE IS
    l_codcli sales.cliente_sisact.codcli%TYPE;

  BEGIN
    SELECT codcli
      INTO l_codcli
      FROM sales.cliente_sisact
     WHERE customer_id = p_customer_id;

    RETURN l_codcli;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'El Cliente con CUSTOMERID: ' ||
                              p_customer_id ||
                              ' no se encuentra registrado en SGA');
    WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Se tiene mas de un Cliente con el CUSTOMERID: ' ||
                              p_customer_id || ' registrado en SGA');
      --<INI 14.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'get_codcli' || ' -- ' ||
                              SQLERRM);
      --<FIN 14.0>

  END;
  --------------------------------------------------------------------------------

  function get_numslc(p_cod_id sales.sot_sisact.cod_id%type,
                      p_codcli sales.vtatabslcfac.codcli%type)
    return sales.sot_sisact.numslc%type is
    c_instancia   sales.int_negocio_instancia.instancia%type := 'PROYECTO DE VENTA';
    c_instanciacp operacion.siac_instancia.tipo_instancia%type := 'PROYECTO DE POSTVENTA';
    l_numslc      sales.sot_sisact.cod_id%type;

  begin
    select max(instancia) -- Ini 16.0
      into l_numslc
      from vtatabslcfac a, operacion.siac_instancia b, inssrv c, solot e
     where a.codcli = p_codcli
       and a.numslc = b.instancia
       and b.tipo_instancia = c_instanciacp
       and a.numslc = c.numslc
       and e.numslc = b.instancia
       and c.estinssrv in (1, 2)
       and e.cod_id = p_cod_id;

    if l_numslc is not null then
      return l_numslc;
    end if; -- Fin 16.0

    if p_cod_id = 0 then

    raise_application_error(-20000,
                              'El Cliente: ' || p_cod_id ||
                              'no esta asociado al Proyecto ');

    else

    select a.numslc
      into l_numslc
      from sales.sot_sisact            a,
           sales.int_negocio_instancia b,
           sales.int_business_line_sel c,
           inssrv                      d
     where a.cod_id = p_cod_id
       and a.numslc = b.idinstancia
       and b.idprocess = c.idprocess
       and b.instancia = c_instancia
       and a.numslc = d.numslc
     group by a.numslc;

    return l_numslc;

    end if;
    
  exception
    when no_data_found then
      raise_application_error(-20000,
                              'El proyecto con COD_ID: ' || p_cod_id ||
                              ' no se encuentra registrado en SGA ');

    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_numslc(p_cod_id => ' ||
                              p_cod_id || ', p_codcli => ' || p_codcli || ') ' ||
                              sqlerrm);
  end;

  /* **********************************************************************************************/
  PROCEDURE verificar_cliente_proyecto(p_numslc vtatabslcfac.numslc%TYPE,
                                       p_codcli vtatabcli.codcli%TYPE) IS
    l_count NUMBER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM vtatabslcfac v
     WHERE v.numslc = p_numslc
       AND v.codcli = p_codcli;

    IF l_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'El Cliente : ' || /*g_codcli*/
                              p_codcli || --7.0
                              ' no esta asociado al proyecto: ' || /*g_numslc_old*/
                              p_numslc); --7.0
    END IF;
    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'verificar_cliente_proyecto - ' ||
                              'p_codcli= ' || p_codcli || ' - p_numslc= ' ||
                              p_numslc || ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION get_contacto(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcntcli.codcnt%TYPE IS
    l_codcnt  marketing.vtatabcntcli.codcnt%TYPE;
    l_tipdide marketing.vtatabcntcli.tipdide%TYPE;
    l_ntdide  marketing.vtatabcntcli.nidcnt%TYPE;

  BEGIN
    l_tipdide := get_tipdide(p_codcli);
    l_ntdide  := get_ntdide(p_codcli);

    SELECT MAX(codcnt)
      INTO l_codcnt
      FROM marketing.vtatabcntcli
     WHERE codcli = p_codcli
       AND tipdide = l_tipdide
       AND nidcnt = l_ntdide
       AND estado = c_activo;

    RETURN l_codcnt;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
      --<INI 14.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'get_contacto - p_codcli= ' || p_codcli ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION get_tipdide(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcli.tipdide%TYPE IS
    l_tipdide marketing.vtatabcli.tipdide%TYPE;

  BEGIN
    SELECT tipdide
      INTO l_tipdide
      FROM marketing.vtatabcli
     WHERE codcli = p_codcli
       AND idestado = c_activo;

    RETURN l_tipdide;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'El Cliente: ' || p_codcli ||
                              ' no presenta tipo de documento de identidad');
      --<INI 14.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'get_tipdide - p_codcli= ' || p_codcli ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION get_ntdide(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcli.ntdide%TYPE IS
    l_ntdide marketing.vtatabcli.ntdide%TYPE;

  BEGIN
    SELECT ntdide
      INTO l_ntdide
      FROM marketing.vtatabcli
     WHERE codcli = p_codcli
       AND idestado = c_activo;

    RETURN l_ntdide;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'El Cliente: ' || p_codcli ||
                              ' no presenta numero del tipo de documento de identidad');
      --<INI 14.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'get_ntdide - p_codcli= ' || p_codcli ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION insert_vtatabcntcli(p_codcli sales.cliente_sisact.codcli%TYPE)
    RETURN marketing.vtatabcntcli.codcnt%TYPE IS
    C_PROPIETARIO CONSTANT vtatabcntcli.tipcnt%TYPE := '08';
    l_vtatabcntcli marketing.vtatabcntcli%ROWTYPE;
    l_codcnt       marketing.vtatabcntcli.codcnt%TYPE;

  BEGIN
    SELECT apepatcli, apematcli, SUBSTR(nomcli, 0, 40) -- 8.0 nomcli
      INTO l_vtatabcntcli.apepat,
           l_vtatabcntcli.apemat,
           l_vtatabcntcli.nombre
      FROM marketing.vtatabcli
     WHERE codcli = p_codcli --g_codcli 7.0
       AND idestado = C_ACTIVO;

    l_vtatabcntcli.codcli  := p_codcli;
    l_vtatabcntcli.tipdide := get_tipdide(p_codcli);
    l_vtatabcntcli.nidcnt  := get_ntdide(p_codcli);
    l_vtatabcntcli.fecusu  := SYSDATE;
    l_vtatabcntcli.nomcnt  := l_vtatabcntcli.nomcnt || ' ' ||
                              l_vtatabcntcli.apepat || ' ' ||
                              l_vtatabcntcli.apemat;
    l_vtatabcntcli.tipcnt  := C_PROPIETARIO;
    l_vtatabcntcli.estado  := C_ACTIVO;

    l_vtatabcntcli.carcli      := 3;
    l_vtatabcntcli.carcnt      := get_dsccnt(c_propietario);
    l_vtatabcntcli.observacion := 'CONTACTO CREADO AUTOMATICAMENTE - POST VENTA';

    INSERT INTO vtatabcntcli
    VALUES l_vtatabcntcli
    RETURNING codcnt INTO l_codcnt;

    --COMMIT; --5.0

    RETURN l_codcnt;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Error al insertar contacto del cliente: ' ||
                              l_vtatabcntcli.codcli);
  END;
  /* **********************************************************************************************/
  FUNCTION get_dsccnt(p_tipcnt vtatabcntcli.tipcnt%TYPE)
    RETURN marketing.vtatipcnt.dsccnt%TYPE IS
    l_dsccnt marketing.vtatipcnt.dsccnt%TYPE;

  BEGIN
    SELECT dsccnt
      INTO l_dsccnt
      FROM marketing.vtatipcnt
     WHERE tipcnt = p_tipcnt;

    RETURN l_dsccnt;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'El tipo de contacto: ' || p_tipcnt ||
                              ' no existe o no presenta descripcion');

    --<INI 14.0>
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'get_dsccnt - p_tipcnt= ' || p_tipcnt ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  FUNCTION set_negocio_proceso(p_postventa postventa_in_type)
    RETURN sales.int_negocio_proceso.idprocess%TYPE IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    l_proceso   operacion.siac_postventa_proceso%ROWTYPE;
    l_idprocess operacion.siac_postventa_proceso.idprocess%TYPE;

  BEGIN
    l_proceso.cod_id        := p_postventa.cod_id;
    l_proceso.customer_id   := p_postventa.customer_id;
    l_proceso.tipo_trans    := p_postventa.tipotrans;
    l_proceso.cod_intercaso := p_postventa.codintercaso;
    l_proceso.tipo_via      := p_postventa.tipovia;
    l_proceso.nom_via       := p_postventa.nombrevia;
    l_proceso.num_via       := p_postventa.numerovia;
    l_proceso.tip_urb       := p_postventa.tipourbanizacion;
    l_proceso.nomurb        := p_postventa.nombreurbanizacion;
    l_proceso.manzana       := p_postventa.manzana;
    l_proceso.lote          := p_postventa.lote;
    l_proceso.ubigeo        := p_postventa.codubigeo;
    l_proceso.codzona       := p_postventa.codzona;
    l_proceso.codplano      := p_postventa.idplano;
    l_proceso.codedif       := NULL; --p_postventa.codedif;
    l_proceso.referencia    := p_postventa.referencia;
    l_proceso.observacion   := p_postventa.observacion;
    l_proceso.fec_prog      := p_postventa.fec_prog;
    l_proceso.franja_hor    := p_postventa.franja_horaria;
    l_proceso.num_carta     := p_postventa.numcarta;
    l_proceso.operador      := p_postventa.operador;
    l_proceso.presuscrito   := p_postventa.presuscrito;
    l_proceso.publicar      := p_postventa.publicar;
    l_proceso.tmcode        := p_postventa.ad_tmcode;
    --l_proceso.lst_tipequ    := p_postventa.lista_tipequ; <2.0>
    l_proceso.lst_coser := p_postventa.lista_coser;
    --l_proceso.lst_sncode    := p_postventa.lista_sncode; <2.0>
    l_proceso.lst_spcode := p_postventa.lista_spcode;

    INSERT INTO operacion.siac_postventa_proceso
    VALUES l_proceso
    RETURNING idprocess INTO l_idprocess;

    COMMIT;

    RETURN l_idprocess;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'set_negocio_proceso: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE regla_negocio(p_tipo_regla VARCHAR2) IS
    C_IDNEGOCIO CONSTANT PLS_INTEGER := 1;
    l_sql VARCHAR2(4000);

    CURSOR reglas_cur IS
      SELECT r.orden, r.sentencia
        FROM operacion.siac_negocio n, operacion.siac_negocio_regla r
       WHERE n.idnegocio = r.idnegocio
         AND r.flg_activo = 1
         AND n.idnegocio = C_IDNEGOCIO
         AND r.tipo = p_tipo_regla
       ORDER BY r.orden ASC;

  BEGIN
    FOR regla_rec IN reglas_cur LOOP
      l_sql := 'BEGIN ' || regla_rec.sentencia || '; END;';
      EXECUTE IMMEDIATE l_sql;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'regla_negocio: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_msg_error(p_valor      VARCHAR2,
                         p_key_detail operacion.config_det.key_detail%TYPE,
                         p_value      operacion.config_det.value%TYPE)
    RETURN VARCHAR2 IS
    l_tipotrans operacion.siac_postventa_proceso.tipo_trans%TYPE;
    l_msg       VARCHAR2(400);

  BEGIN
    SELECT s.tipo_trans
      INTO l_tipotrans
      FROM operacion.siac_postventa_proceso s
     WHERE s.idprocess = g_idprocess;

    IF p_valor IS NULL AND p_value = l_tipotrans THEN
      l_msg := 'ERROR: El valor del campo: ' || TO_CHAR(p_key_detail) ||
               ' es nulo; Para la transaccion:' || TO_CHAR(p_value);
    END IF;

    IF p_valor IS NULL AND p_value IS NULL THEN
      l_msg := 'ERROR: El valor del campo obligatorio: ' ||
               TO_CHAR(p_key_detail) || ' es nulo.';
    END IF;

    RETURN l_msg;

    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'get_msg_error' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END;
  /* **********************************************************************************************/
  PROCEDURE review_negocio_proceso IS
    l_value  VARCHAR2(4000);
    l_msg    VARCHAR2(400);
    l_column VARCHAR2(50);

    CURSOR column_cur IS
      SELECT d.*
        FROM operacion.config c, operacion.config_det d
       WHERE c.idconf = d.idconf
         AND d.status = 1
         AND c.key_master = 'EVALUA_CAMPOS'
       ORDER BY d.rowid ASC;

  BEGIN
    FOR column_rec IN column_cur LOOP
      IF column_rec.value = 'PK' THEN
        l_column := column_rec.key_detail;
      ELSE
        EXECUTE IMMEDIATE 'SELECT ' || column_rec.key_detail || ' FROM ' ||
                          column_rec.description || ' WHERE ' || l_column ||
                          ' = ' || g_idprocess
          INTO l_value;

        l_msg := get_msg_error(l_value,
                               column_rec.key_detail,
                               column_rec.value);

        IF l_msg IS NOT NULL THEN
          RAISE_APPLICATION_ERROR(-20000, l_msg);
        END IF;
      END IF;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.review_negocio_proceso: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION format_msg(p_msg_err operacion.siac_negocio_err.ora_text%TYPE)
    RETURN operacion.siac_negocio_err.ora_text%TYPE IS
    l_msg_formatted operacion.siac_negocio_err.ora_text%TYPE;

  BEGIN
    l_msg_formatted := REPLACE(p_msg_err, 'ORA', CHR(10) || 'ORA');
    l_msg_formatted := LTRIM(l_msg_formatted, CHR(10));

    RETURN l_msg_formatted;
  END;
  /* **********************************************************************************************/
  PROCEDURE set_log_err(p_msg_err operacion.siac_negocio_err.ora_text%TYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    l_error operacion.siac_negocio_err%ROWTYPE;

  BEGIN
    l_error.idprocess := g_idprocess;
    l_error.ora_text  := p_msg_err;
    l_error.usureg    := USER;
    l_error.fecreg    := SYSDATE;

    INSERT INTO operacion.siac_negocio_err VALUES l_error;

    COMMIT;

    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'set_log_err' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>

  END;
  /* **********************************************************************************************/
  FUNCTION get_inf_instancia RETURN instan_in_type IS
    l_instan instan_in_type;

  BEGIN
    SELECT s.tipo_trans, s.cod_id, i.instancia, r.numregistro
      INTO l_instan
      FROM operacion.siac_postventa_proceso s,
           operacion.siac_instancia         i,
           regvtamentab                     r
     WHERE s.idprocess = i.idprocess
       AND r.numslc = i.instancia
       AND i.tipo_instancia = 'PROYECTO DE POSTVENTA'
       AND s.idprocess = g_idprocess;

    RETURN l_instan;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'get_inf_instancia: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_hist_srv_cp IS
    l_instan           instan_in_type;
    l_siac_cambio_plan historico.siac_cambio_plan%ROWTYPE;

    CURSOR cp_cur IS
      SELECT 'B' est,
             b.pid,
             i.estinsprd,
             b.numslc,
             i.codsrv,
             (SELECT e.tipequ
                FROM equcomxope e
               WHERE e.codequcom = i.codequcom) tipequ
        FROM reginsprdbaja b, insprd i
       WHERE b.pid = i.pid
         AND b.numregistro = l_instan.numregistro
      UNION
      SELECT 'A' est,
             i.pid,
             i.estinsprd,
             i.numslc,
             i.codsrv,
             (SELECT e.tipequ
                FROM equcomxope e
               WHERE e.codequcom = i.codequcom) tipequ
        FROM insprd i
       WHERE i.numslc = l_instan.numslc;

  BEGIN
    l_instan := get_inf_instancia();

    IF 'SIAC-HFC-CAMBIO_PLAN' = l_instan.tipotrans THEN
      FOR cp_rec IN cp_cur LOOP
        l_siac_cambio_plan.cod_id      := l_instan.cod_id;
        l_siac_cambio_plan.pid         := cp_rec.pid;
        l_siac_cambio_plan.estinsprd   := cp_rec.estinsprd;
        l_siac_cambio_plan.codsrv      := cp_rec.codsrv;
        l_siac_cambio_plan.tipequ      := cp_rec.tipequ;
        l_siac_cambio_plan.numregistro := l_instan.numregistro;
        l_siac_cambio_plan.numslc      := cp_rec.numslc;
        l_siac_cambio_plan.tipo        := cp_rec.est;
        l_siac_cambio_plan.idprocess   := g_idprocess;

        INSERT INTO historico.siac_cambio_plan VALUES l_siac_cambio_plan;

      --COMMIT; --5.0

      END LOOP;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'set_hist_srv_cp: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE has_active_services IS
    l_count PLS_INTEGER;

  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.siac_postventa_proceso p, sales.sot_sisact s, inssrv i
     WHERE p.idprocess = g_idprocess
       AND p.cod_id = s.cod_id
       AND s.numslc = i.numslc
       AND i.estinssrv IN (1, 2);

    IF l_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'EL PROYECTO DE ORIGEN NO TIENE SERVICIOS');
    END IF;
  END;
  /* **********************************************************************************************/
  PROCEDURE p_lista_operador(ac_prob_cur OUT gc_salida) IS
    lc_solu_cur gc_salida;
  BEGIN

    OPEN lc_solu_cur FOR
      SELECT IDCARRIER, DESCRIPCION OPERADOR
        FROM PRECARRIER
       ORDER BY IDCARRIER;

    ac_prob_cur := lc_solu_cur;

    --<INI 14.0>
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'p_lista_operador' ||
                              ' -- ' || SQLERRM);
      --<FIN 14.0>
  END p_lista_operador;
  /* **********************************************************************************************/

  procedure p_validad_transaccion(v_customer_id    in operacion.solot.customer_id%type,
                                  an_codigo_error  out number,
                                  av_mensaje       out varchar2) is
    lv_valida     number;
    ln_resultado   number;
    lv_mensaje     varchar2(900);
    ex_error      exception;

  begin

    ln_resultado    := 0;
    lv_mensaje      := 'Exito';
    an_codigo_error := ln_resultado;
    av_mensaje      := lv_mensaje;

    select count(*)
      into lv_valida
      from solot s, estsol e
     where s.customer_id = v_customer_id
              and s.tiptra in (select o.codigon
                          from opedd o, tipopedd t
                         where o.tipopedd = t.tipopedd
                           and t.abrev = 'TIPO_TRANS_SIAC'
                           and o.codigoc = '1')
       and s.estsol = e.estsol
       and e.estsol not in (select d.codigon
                              from tipopedd c, opedd d
                             where c.abrev = 'ESTADO_SOT'
                               and c.tipopedd = d.tipopedd);

    if lv_valida > 0 then
      ln_resultado := 3;
      lv_mensaje   := 'Ya existe una transacción en proceso, SOT';
      raise ex_error;
    end if;

  exception
  when ex_error then
    an_codigo_error := ln_resultado;
    av_mensaje      := lv_mensaje;
  when others then
    an_codigo_error := -1;
    av_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm || ' Linea (' ||
                     dbms_utility.format_error_backtrace || ')';

  end;
  ----------------------------------------------------------------------------------
  procedure set_siac_instancia(p_idprocess      siac_instancia.idprocess%type,
                               p_tipo_postventa siac_instancia.tipo_postventa%type,
                               p_tipo_instancia siac_instancia.tipo_instancia%type,
                               p_instancia      siac_instancia.instancia%type) is

    l_instancia siac_instancia%rowtype;

  begin
    l_instancia.idprocess      := p_idprocess;
    l_instancia.tipo_postventa := p_tipo_postventa;
    l_instancia.tipo_instancia := p_tipo_instancia;
    l_instancia.instancia      := p_instancia;

    insert_siac_instancia(l_instancia);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.set_siac_instancia(p_idprocess => ' ||
                              p_idprocess || ', p_tipo_postventa => ' ||
                              p_tipo_postventa || ', p_tipo_instancia => ' ||
                              p_tipo_instancia || ', p_instancia => ' ||
                              p_instancia || ') ' || sqlerrm);
  end;
  ----------------------------------------------------------------------------------
  procedure insert_siac_instancia(p_siac_instancia siac_instancia%rowtype) is

  begin
    insert into operacion.siac_instancia
      (idinstancia, idprocess, tipo_postventa, tipo_instancia, instancia)
    values
      (p_siac_instancia.idinstancia,
       p_siac_instancia.idprocess,
       p_siac_instancia.tipo_postventa,
       p_siac_instancia.tipo_instancia,
       p_siac_instancia.instancia);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' ||
                              'insert_siac_instancia' || sqlerrm);
  end;
  ----------------------------------------------------------------------------------
  procedure set_int_negocio_instancia(p_idprocess   sales.int_negocio_instancia.idprocess%type,
                                      p_instancia   sales.int_negocio_instancia.instancia%type,
                                      p_idinstancia sales.int_negocio_instancia.idinstancia%type) is

    l_instancia sales.int_negocio_instancia%rowtype;

  begin
    l_instancia.idprocess   := p_idprocess;
    l_instancia.instancia   := p_instancia;
    l_instancia.idinstancia := p_idinstancia;
    l_instancia.tipo        := 'N';
    l_instancia.origen      := 'SIAC';

    insert_int_negocio_instancia(l_instancia);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.set_int_negocio_instancia(p_idprocess => ' ||
                              p_idprocess || ', p_instancia => ' ||
                              p_instancia || ', p_idinstancia => ' ||
                              p_idinstancia || ') ' || sqlerrm);
  end;
  ----------------------------------------------------------------------------------
  procedure insert_int_negocio_instancia(p_int_negocio_instancia sales.int_negocio_instancia%rowtype) is

  begin
    insert into sales.int_negocio_instancia
      (idprocess, instancia, idinstancia, tipo, origen)
    values
      (p_int_negocio_instancia.idprocess,
       p_int_negocio_instancia.instancia,
       p_int_negocio_instancia.idinstancia,
       p_int_negocio_instancia.tipo,
       p_int_negocio_instancia.origen);

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.' ||
                              'insert_int_negocio_instancia' || sqlerrm);
  end;
  ----------------------------------------------------------------------------------
  procedure p_valida_trans_co_id(p_cod_id sales.sot_sisact.cod_id%type) is

    ln_max_codsolot operacion.solot.codsolot%type;
    ln_customer_id  operacion.solot.customer_id%type;
    ln_numslc       operacion.solot.numslc%type;
    ln_ccodsolot1   number;
    ln_mcodsolot2   operacion.solot.codsolot%type;
    ln_cont         number;
    ls_codubi       inssrv.codubi%type;
    ls_direccion    inssrv.direccion%type;
    pragma autonomous_transaction;
  begin

    ln_max_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(p_cod_id);

    if ln_max_codsolot != 0 then

      select s.customer_id, s.numslc
        into ln_customer_id, ln_numslc
        from solot s
       where s.codsolot = ln_max_codsolot;

      select count(s.codsolot)
        into ln_cont
        from sales.sot_siac s
       where s.cod_id = p_cod_id;

      if ln_cont > 0 then
        -- Validamos si existe la SOT registrada en la tabla
        select count(s.codsolot)
          into ln_ccodsolot1
          from sales.sot_siac s
         where s.cod_id = p_cod_id
           and s.codsolot = ln_max_codsolot;

        if ln_ccodsolot1 = 0 then

          insert into sales.sot_siac
            (cod_id, codsolot, cod_error, msg_error, customer_id)
          values
            (p_cod_id,
             ln_max_codsolot,
             0,
             'Transaccion ejecutada correctamente.',
             ln_customer_id);

        end if;

      else

        begin
          select s.codsolot
            into ln_mcodsolot2
            from sales.sot_sisact s
           where s.cod_id = p_cod_id;
        exception
          when no_data_found then
            insert into sales.sot_sisact
              (cod_id, codsolot, numslc)
            values
              (p_cod_id, ln_max_codsolot, ln_numslc);

          when too_many_rows then

            select min(s.codsolot)
              into ln_mcodsolot2
              from sales.sot_sisact s
             where s.cod_id = p_cod_id;

            delete from sales.sot_sisact so
             where so.cod_id = p_cod_id
               and so.codsolot != ln_mcodsolot2;

        end;

        if ln_max_codsolot != ln_mcodsolot2 then

          insert into sales.sot_siac
            (cod_id, codsolot, cod_error, msg_error, customer_id)
          values
            (p_cod_id,
             ln_max_codsolot,
             0,
             'Transaccion ejecutada correctamente.',
             ln_customer_id);

        end if;
      end if;

      begin
        select distinct codubi, direccion
          into ls_codubi, ls_direccion
          from inssrv
         where numslc = ln_numslc;
      exception
        when too_many_rows then
          update inssrv i
             set i.direccion =
                 (select ins.direccion
                    from inssrv ins
                   where ins.numslc = ln_numslc
                     and rownum = 1)
           where i.numslc = ln_numslc;
      end;
      commit;
    end if;
  end;
 
  procedure p_obt_area_x_cod_id(an_cod_id  in sales.sot_sisact.cod_id%type,
                                an_areasol out solot.areasol%type) is
    ln_codsolot number;
    av_codusu   varchar2(100);

  begin

    ln_codsolot := f_max_sot_siac_sisact(an_cod_id);

    select s.usureg
      into av_codusu
      from sales.v_sales_postventa_siac s
     where s.codsolot = ln_codsolot
       and s.cod_id = an_cod_id;

    select area
      into an_areasol
      from usuarioope
     where usuarioope.usuario = av_codusu;

  exception
    when others then
      select a.valor
        into an_areasol
        from constante a
       where constante = 'AREAUSUARIO';
  end;

  function f_max_sot_siac_sisact(an_cod_id sales.sot_sisact.cod_id%type)
    return number is
    ln_codsolot number;
  begin

    select max(s.codsolot)
      into ln_codsolot
      from sales.v_sales_postventa_siac s
     where s.cod_id = an_cod_id;

    return ln_codsolot;
  end;

  -- Cambio de Plan, Traslado Externo y Traslado Interno
  function g_get_is_hfc_siac(av_numslc varchar2, av_param varchar2)
    return number is

    ln_val_hfc_siac number;

  begin

    if av_param = 'SOLUCION' then

      select count(v.numslc)
        into ln_val_hfc_siac
        from vtatabslcfac v, soluciones s
       where v.idsolucion = s.idsolucion
         and v.numslc = av_numslc
         and exists (select 1
                from tipopedd t, opedd o
               where t.tipopedd = o.tipopedd
                 and t.abrev = 'CONFSERVADICIONAL'
                 and o.abreviacion = 'SOLUCION_HFC_SIAC_TIPTRA'
                 and o.codigon = s.idsolucion
                 and o.codigoc = av_param);

    else

      select o.codigon
        into ln_val_hfc_siac
        from tipopedd t, opedd o
       where t.tipopedd = o.tipopedd
         and t.abrev = 'CONFSERVADICIONAL'
         and o.abreviacion = 'SOLUCION_HFC_SIAC_TIPTRA'
         and o.codigoc = av_param;

    end if;

    return ln_val_hfc_siac;
  end;

  procedure p_actualizar_trrsolot_siac(a_idtareawf in number,
                                       a_idwf      in number,
                                       a_tarea     in number,
                                       a_tareadef  in number) is
    ln_val_tip_sol number;
    ln_codsolot    number;

    ln_codinssrv_nt number;
    ln_estnumtel    number;
    cursor c_lineas(ll_codsolot number) is
      select distinct ins.codinssrv, ins.numero
        from solotpto pto, inssrv ins
       where pto.codinssrv = ins.codinssrv
         and ins.tipinssrv = 3
         and pto.codsolot = ll_codsolot
         and ins.numero is not null;

  begin

    select a.codsolot
      into ln_codsolot
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot
       and a.valido = 1;

    ln_val_tip_sol := operacion.pkg_asignar_wf2.f_valida_tipo_solucion(ln_codsolot);

    if ln_val_tip_sol > 0 then

      update trssolot t
         set t.flgbil = 2, t.esttrs = 2
       where t.codsolot = ln_codsolot;

    end if;

    for l in c_lineas(ln_codsolot) loop

      select nvl(n.codinssrv, 0), n.estnumtel
        into ln_codinssrv_nt , ln_estnumtel
        from numtel n
       where n.numero = l.numero;

      if ln_codinssrv_nt != l.codinssrv or ln_estnumtel != 2 then

        update numtel n
           set n.codinssrv = l.codinssrv, n.estnumtel = 2
         where n.numero = l.numero;

      end if;

    end loop;

  end;

  procedure p_ejecuta_transaccion_te_siac(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number) is

    ln_codsolot    solot.codsolot%type;
    ln_coid        solot.cod_id%type;
    ln_customer_id solot.customer_id%type;
    lv_codcli      solot.codcli%type;
    ln_coderror    number;
    lv_menerror    varchar2(4000);

    error_general exception;

    ln_monto_occ operacion.SHFCT_DET_TRAS_EXT.SHFCV_MONTO%type;
    lv_codocc    operacion.SHFCT_DET_TRAS_EXT.SHFCV_CODOCC%type;
    lv_coment    operacion.SHFCT_DET_TRAS_EXT.SHFCV_OBSERVACION%type;
    lv_numcuotas operacion.SHFCT_DET_TRAS_EXT.SHFCV_NUMERO_CUOTA%type;

    lv_direccion      operacion.SHFCT_DET_TRAS_EXT.SHFCV_DIRECCION_FACTURACION%type;
    lv_NotasDireccion operacion.SHFCT_DET_TRAS_EXT.SHFCV_NOTAS_DIRECCION%type;
    lv_Distrito       operacion.SHFCT_DET_TRAS_EXT.SHFCV_DISTRITO%type;
    lv_Provincia      operacion.SHFCT_DET_TRAS_EXT.SHFCV_PROVINCIA%type;
    lv_CodigoPostal   operacion.SHFCT_DET_TRAS_EXT.SHFCV_CODIGO_POSTAL%type;
    lv_Departamento   operacion.SHFCT_DET_TRAS_EXT.SHFCV_DEPARTAMENTO%type;
    lv_Pais           operacion.SHFCT_DET_TRAS_EXT.SHFCV_PAIS%type;
    ln_flag_fact      number;
    ln_flag_occ       number;
    ln_result         number;
    lv_id_plano       varchar2(10);
    lv_ubigeo         varchar2(10);
    v_cant_te         number;--22.0

  begin

    select a.codsolot, b.cod_id, b.customer_id, b.codcli
      into ln_codsolot, ln_coid, ln_customer_id, lv_codcli
      from wf a, solot b
     where a.idwf = a_idwf
       and a.codsolot = b.codsolot
       and a.valido = 1;

    select h.SHFCV_MONTO,
           h.SHFCV_CODOCC,
           h.SHFCV_OBSERVACION,
           h.SHFCV_NUMERO_CUOTA,
           substr(h.SHFCV_DIRECCION_FACTURACION,1,40),
           substr(h.SHFCV_NOTAS_DIRECCION,1,40),
           h.SHFCV_DISTRITO,
           h.SHFCV_PROVINCIA,
           h.SHFCV_CODIGO_POSTAL,
           h.SHFCV_DEPARTAMENTO,
           h.SHFCV_PAIS,
           h.SHFCV_FLAG_DIRECC_FACT,
           h.SHFCV_FLAG_COBRO_OCC
      into ln_monto_occ,
           lv_codocc,
           lv_coment,
           lv_numcuotas,
           lv_direccion,
           lv_NotasDireccion,
           lv_Distrito,
           lv_Provincia,
           lv_CodigoPostal,
           lv_Departamento,
           lv_Pais,
           ln_flag_fact,
           ln_flag_occ
      from operacion.SHFCT_DET_TRAS_EXT h
     where h.SHFCN_CODSOLOT = ln_codsolot;

    if ln_flag_fact = 1 then

      tim.pp005_siac_trx.SGASU_CAMB_DIREC_FACT@dbl_bscs_bf(ln_customer_id,--22.0
                                                           lv_direccion,
                                                           lv_NotasDireccion,
                                                           lv_Distrito,
                                                           lv_Provincia,
                                                           lv_CodigoPostal,
                                                           lv_Departamento,
                                                           lv_Pais,
                                                           ln_result);

      if ln_result != 1 then
        lv_menerror := 'Error en la ejecucion del proceso tim.pp005_siac_trx.sp_cambio_direccion_postal ';
        raise error_general;
      end if;
   -- INI 22.0
    end if;

    SELECT count(1)
      INTO v_cant_te
      FROM tipopedd t, opedd o, solot s
     WHERE t.tipopedd = o.tipopedd
       AND o.codigon = s.tiptra
       AND t.abrev = 'CAMBIO_DIRECCION_TE'
       AND o.codigon_aux = 1
       AND s.codsolot = ln_codsolot;

    IF v_cant_te>0 THEN -- FIN 22.0
      BEGIN
        select distinct d.idplano, e.ubigeo
          into lv_id_plano, lv_ubigeo
          from solotpto b, inssrv c, vtasuccli d, vtatabdst e
         where b.codinssrv = c.codinssrv
           and c.codubi = e.codubi
           and c.codsuc = d.codsuc
           and b.codsolot = ln_codsolot;

        tim.pp004_siac_hfc.sp_chg_direccion_instal@dbl_bscs_bf(ln_customer_id,
                                                               lv_direccion,
                                                               lv_id_plano,
                                                               lv_ubigeo,
                                                               lv_NotasDireccion,
                                                               ln_result);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          lv_menerror := 'TIM.PP004_SIAC_HFC.SP_CHG_DIRECCION_INSTAL@DBL_BSCS_BF - PARAMETROS:
           ERROR:' || SQLERRM || ' Linea (' ||
                         dbms_utility.format_error_backtrace || ')';

          raise error_general;

        WHEN OTHERS THEN
          lv_menerror := 'TIM.PP004_SIAC_HFC.SP_CHG_DIRECCION_INSTAL@DBL_BSCS_BF - PARAMETROS:
           ERROR:' || SQLERRM || ' Linea (' ||
                         dbms_utility.format_error_backtrace || ')';

          raise error_general;

      END;
    end if;

    if ln_flag_occ = 1 then
      tim.pp005_siac_trx.sp_insert_occ@dbl_bscs_bf(ln_customer_id,
                                                   lv_codocc,
                                                   to_char(sysdate,
                                                           'YYYYMMDD'),
                                                   lv_numcuotas,
                                                   ln_monto_occ,
                                                   lv_coment,
                                                   ln_result);
      if ln_result < 0 then
        lv_menerror := 'Error en la ejecucion del proceso tim.pp005_siac_trx.sp_insert_occ ';
        raise error_general;
      end if;
    end if;

    ln_coderror := 1;
    lv_menerror := 'Operacion Exitoso';

    operacion.pq_sga_iw.p_reg_log(lv_codcli,
                                  ln_customer_id,
                                  NULL,
                                  ln_codsolot,
                                  null,
                                  ln_coderror,
                                  lv_menerror,
                                  ln_coid,
                                  'Traslado Externo HFC');
  exception
    when error_general then
      ln_coderror := -1;
      operacion.pq_sga_iw.p_reg_log(lv_codcli,
                                    ln_customer_id,
                                    NULL,
                                    ln_codsolot,
                                    null,
                                    ln_coderror,
                                    lv_menerror,
                                    ln_coid,
                                    'Traslado Externo HFC');
      --ini 22.0
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'P_EJECUTA_TRANSACCION_TE_SIAC' ||
                              ' -- ' || lv_menerror);
      --fin 22.0
    when others then
      ln_coderror := -1;
      lv_menerror := 'ERROR al ejecutar TE : ' || SQLERRM || ' Linea (' ||
                     dbms_utility.format_error_backtrace || ')';
      operacion.pq_sga_iw.p_reg_log(lv_codcli,
                                    ln_customer_id,
                                    NULL,
                                    ln_codsolot,
                                    null,
                                    ln_coderror,
                                    lv_menerror,
                                    ln_coid,
                                    'Traslado Externo HFC');
      --ini 22.0
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'P_EJECUTA_TRANSACCION_TE_SIAC' ||
                              ' -- ' || lv_menerror);
      --fin 22.0
  end;

  procedure p_asignacion_numero_siac(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is

    l_codsolot     solot.codsolot%type;
    l_numero       inssrv.numero%type;
    ln_tiptra      solot.tiptra%type;
    lv_transaccion opedd.codigoc%type;
    lv_codcli      solot.codcli%type;
    ln_customer_id solot.customer_id%type;
    ln_coid        solot.cod_id%type;
    lv_menerror    operacion.log_trs_interface_iw.texto%type;
    CURSOR c_solot(an_codsolot number) IS
      select s.codinssrv, s.codinssrv_tra
        from solotpto s, inssrv i, tystabsrv t
       where s.codinssrv = i.codinssrv
         and t.codsrv = s.codsrvnue
         and i.numero is null
         and i.tipinssrv = 3
         and s.codsolot = an_codsolot;

  BEGIN

    select s.codsolot, s.tiptra, s.codcli, s.customer_id, s.cod_id
      into l_codsolot, ln_tiptra, lv_codcli, ln_customer_id, ln_coid
      from wf f, solot s
     where f.idwf = a_idwf
       and f.codsolot = s.codsolot
       and f.valido = 1;

    select distinct o.codigoc
      into lv_transaccion
      from tipopedd t, opedd o
     where t.tipopedd = o.tipopedd
       and t.abrev = 'CONFSERVADICIONAL'
       and o.abreviacion = 'SOLUCION_HFC_SIAC_TIPTRA'
       and o.codigon = ln_tiptra
       and o.codigon_aux = 10;

    if lv_transaccion = 'FLUJO_EXT' then

      for r_det in c_solot(l_codsolot) loop

        if r_det.codinssrv_tra is not null then

          select numero
            into l_numero
            from inssrv
           where codinssrv = r_det.codinssrv_tra;

          update inssrv
             set numero = l_numero
           where codinssrv = r_det.codinssrv;

        end if;
      end loop;

    elsif lv_transaccion = 'FLUJO_CP' then
      operacion.pq_siac_wf_cambio_plan.asigna_numero_siac_cp(a_idtareawf,
                                                             a_idwf,
                                                             a_tarea,
                                                             a_tareadef);
    end if;
  exception
    when others then
      lv_menerror := 'ERROR Asignacion de Numero TE/CP : ' || SQLERRM ||
                     ' Linea (' || dbms_utility.format_error_backtrace || ')';
      operacion.pq_sga_iw.p_reg_log(lv_codcli,
                                    ln_customer_id,
                                    NULL,
                                    l_codsolot,
                                    null,
                                    -1,
                                    lv_menerror,
                                    ln_coid,
                                    'Asignacion de Numero HFC');
  END;

  /*********************************************************************************************
      Nombre Package:  PKG_DETALLE_TRASLADO
      PROPOSITO     :  Registrar la dirección y cobro del cliente luego del SOT
      INPUT         :
      OUTPUT        :
      Creado Por    :  TS-RCR
      Fec Creacion  :  10/11/2016
      Fec Actualizacion: --
  ********************************************************************************************/
  procedure SHFCSI_DIR_EXT(PCODSOLOT              IN NUMBER,
                           PCUSTOMER_ID           IN INTEGER,
                           PDIRECCION_FACTURACION IN VARCHAR2,
                           PNOTAS_DIRECCION       IN VARCHAR2,
                           PDISTRITO              IN VARCHAR2,
                           PPROVINCIA             IN VARCHAR2,
                           PCODIGO_POSTAL         IN VARCHAR2,
                           PDEPARTAMENTO          IN VARCHAR2,
                           PPAIS                  IN VARCHAR2,
                           PFLAG_DIRECC_FACT      IN NUMBER,
                           PUSUARIO_REG           IN VARCHAR2,
                           PFECHA_REG             IN DATE,
                           PRESULTADO             OUT INTEGER,
                           PMSGERR                OUT VARCHAR2) is
    nsigno number;
  Begin
    PRESULTADO := 0;
    PMSGERR    := 'OK';

    -- INSERTAR
    INSERT INTO OPERACION.SHFCT_DET_TRAS_EXT
      (SHFCN_CODSOLOT,
       SHFCI_CUSTOMER_ID,
       SHFCV_DIRECCION_FACTURACION,
       SHFCV_NOTAS_DIRECCION,
       SHFCV_DISTRITO,
       SHFCV_PROVINCIA,
       SHFCV_CODIGO_POSTAL,
       SHFCV_DEPARTAMENTO,
       SHFCV_PAIS,
       SHFCV_FLAG_DIRECC_FACT,
       SHFCV_USUARIO_REG,
       SHFCV_FECHA_REG)
    VALUES
      (PCODSOLOT,
       PCUSTOMER_ID,
       PDIRECCION_FACTURACION,
       PNOTAS_DIRECCION,
       PDISTRITO,
       PPROVINCIA,
       PCODIGO_POSTAL,
       PDEPARTAMENTO,
       PPAIS,
       PFLAG_DIRECC_FACT,
       PUSUARIO_REG,
       PFECHA_REG);
    Commit;
  EXCEPTION
    WHEN OTHERS THEN
      PRESULTADO := -1;
      PMSGERR    := SQLERRM;

  End;

  procedure SHFCSU_OCC_EXT(PCODSOLOT       IN NUMBER,
                           PCUSTOMER_ID    IN INTEGER,
                           PFECVIG         IN DATE,
                           PMONTO          IN FLOAT,
                           POBSERVACION    IN VARCHAR2,
                           PFLAG_COBRO_OCC IN INTEGER,
                           PAPLICACION     IN VARCHAR2,
                           PUSUARIO_ACT    IN VARCHAR2,
                           PFECHA_ACT      IN DATE,
                           PCOD_ID         sales.sot_sisact.cod_id%type,
                           PRESULTADO      OUT INTEGER,
                           PMSGERR         OUT VARCHAR2) is
    ln_tmcode      integer;
    lv_plan        varchar2(128);
    lv_periodo     integer;
    lv_concepto_id integer;
    ln_tiptra      operacion.SOLOT.TIPTRA%TYPE;
    ln_pto_adicional operacion.SOLOT.TIPTRA%TYPE;
    lv_servicio    operacion.opedd.codigoc%type;
    lv_descripcion operacion.opedd.descripcion%type;
    ln_tiptra_TI_FTTH integer;  --27.0
    ln_tiptra_TE_FTTH integer;  --27.0
  Begin
    PRESULTADO := 0;
    PMSGERR    := 'OK';
    
    --27.0 Ini
    begin
      select tiptra into ln_tiptra_TI_FTTH from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO INTERNO' ;
    exception
      when NO_DATA_FOUND then
        ln_tiptra_TI_FTTH := 0;
    end;
    begin
      select tiptra into ln_tiptra_TE_FTTH from operacion.tiptrabajo where descripcion = 'FTTH/SIAC - TRASLADO EXTERNO' ;
    exception
      when NO_DATA_FOUND then
        ln_tiptra_TE_FTTH := 0;
    end;
    --27.0 Fin
    
    SELECT COUNT(A.SHFCN_CODSOLOT)
      INTO PRESULTADO
      FROM OPERACION.SHFCT_DET_TRAS_EXT A
     WHERE A.SHFCN_CODSOLOT = PCODSOLOT;

    IF PRESULTADO = 1 THEN
      select tiptra into ln_tiptra from SOLOT where codsolot = PCODSOLOT;
      
    select d.codigon, d.codigoc, d.descripcion 
      INTO ln_pto_adicional, lv_servicio, lv_descripcion
     from opedd d, tipopedd t
    where d.tipopedd = t.tipopedd
      and t.abrev = 'PUNTOS_ADICIONALES_WLL_SIAC'
      and d.abreviacion = 'PUNTOS_ADICIONALES_WLL_SIAC';      
                              
      if ln_tiptra = 693 then
        --TE
        Select tmcode
          into ln_tmcode
          from contract_all@dbl_bscs_bf
         where plcode = 1000
           and sccode = 6
           and co_id = PCOD_ID;

        select valor4
          into lv_plan
          from tim.tim_parametros@dbl_bscs_bf
         where upper(campo) like upper('%HFC_MASIVO%')
           and cast(valor1 as int) = ln_tmcode;

        Select Concepto_id, Periodo
          into lv_concepto_id, lv_periodo
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) like
               upper('%traslado%' || '%' || lv_plan || '%')
           and TIPO_SERVICIO = 'HFC';
      elsif ln_tiptra = 694 then
        --TI
        Select Concepto_id, Periodo
          into lv_concepto_id, lv_periodo
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) = upper('Traslado Interno')
           and TIPO_SERVICIO = 'HFC';
      
      ELSIF (LN_TIPTRA = ln_pto_adicional or ln_tiptra = 700) THEN
        --Puntos Adicionales
        Select Concepto_id, Periodo
          into lv_concepto_id, lv_periodo
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) = upper(lv_descripcion)
           and TIPO_SERVICIO = lv_servicio;
	  
      --27.0 Ini
      elsif ln_tiptra = ln_tiptra_TI_FTTH then
        --Modificar cuando siga el flujo propio de FTTH
        Select Concepto_id, Periodo
          into lv_concepto_id, lv_periodo
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) = upper('Traslado Interno')
           and TIPO_SERVICIO = 'HFC';
      
      elsif ln_tiptra = ln_tiptra_TE_FTTH then
        --Modificar cuando siga el flujo propio de FTTH
           Select tmcode
             into ln_tmcode
             from contract_all@dbl_bscs_bf
            where plcode = 1000
              and sccode = 6
              and co_id = PCOD_ID;

          select valor4
            into lv_plan
            from tim.tim_parametros@dbl_bscs_bf
           where upper(campo) like upper('%HFC_MASIVO%')
             and cast(valor1 as int) = ln_tmcode;

        Select Concepto_id, Periodo
          into lv_concepto_id, lv_periodo
          from usrsiac.SIAC_CONCEPTO@DBL_COBSDB
         where upper(descripcion) like
               upper('%traslado%' || '%' || lv_plan || '%')
           and TIPO_SERVICIO = 'HFC';
      --27.0 Fin
      end if;

      -- ACTUALIZAR
      UPDATE OPERACION.SHFCT_DET_TRAS_EXT
         SET SHFCV_CODOCC         = lv_concepto_id,
             SHFCV_FECVIG         = PFECVIG,
             SHFCV_NUMERO_CUOTA   = lv_periodo,
             SHFCV_MONTO          = PMONTO,
             SHFCV_OBSERVACION    = POBSERVACION,
             SHFCV_FLAG_COBRO_OCC = PFLAG_COBRO_OCC,
             SHFCV_APLICACION     = PAPLICACION,
             SHFCV_USUARIO_ACT    = PUSUARIO_ACT,
             SHFCV_FECHA_ACT      = PFECHA_ACT
       WHERE SHFCN_CODSOLOT = PCODSOLOT;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      PRESULTADO := -1;
      PMSGERR    := SQLERRM;

  End;

  --ini 21.00

  PROCEDURE SGASS_TIP_TRAB_CONFIP(a_cursor OUT gc_salida)
  IS
  BEGIN

    OPEN a_cursor FOR
      SELECT TT.TIPTRA      AS TIPTRA,
             TT.DESCRIPCION AS DESCRIPCION,
             O.CODIGON_AUX  AS FLAG_ACTIVA,
             O.CODIGOC      AS TIPO_SERV
        FROM TIPOPEDD T, OPEDD O, TIPTRABAJO TT
       WHERE T.TIPOPEDD = O.TIPOPEDD
         AND T.ABREV = 'CONFSERVADICIONAL'
         AND TT.TIPTRA = O.CODIGON
         AND O.ABREVIACION = 'DROPDOWN';

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SGASS_TIP_TRAB_CONFIPP' ||
                              ' -- ' || SQLERRM);
  END;


  PROCEDURE SGASS_TIPO_CONFIP(an_tiptrabajo IN NUMBER,
                               a_cursor OUT gc_salida)
  IS
  BEGIN

    OPEN a_cursor FOR
      SELECT T.CODIGON, T.DESCRIPCION || ' (' || T.ABREVIACION || ')' AS DESCRIP
        FROM OPEDD T
       WHERE T.TIPOPEDD = 1435
         AND T.CODIGON_AUX IN (an_tiptrabajo);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SGASS_TIPO_CONFIPP' ||
                              ' -- ' || SQLERRM);
  END;


  PROCEDURE SGASS_SUCURSALES_CLIENTE(an_customer_id IN NUMBER,
                                     a_cursor OUT gc_salida)
  IS

  BEGIN

    OPEN a_cursor FOR
      SELECT DISTINCT S.CODSOLOT,
                      S.TIPTRA,
                      T.DESCRIPCION,
                      SUC.NOMSUC || '  (' || SUC.DIRSUC || ')' AS SUCURSAL,
                      NVL(S.CUSTOMER_ID, S.CODCLI) AS CODCLIENTE,
                      NVL(S.COD_ID, NULL) AS CONTRATO,
                      SUC.REFERENCIA AS NOTAS,
                      SUC.IDPLANO PLANO,
                      UBI.UBIGEO UBIGEO,
                      UBI.nomdepa DEPARTAMENTO,
                      UBI.nomprov PROVINCIA,
                      UBI.nomdst DISTRITO
        FROM INSSRV     INS,
             SOLOTPTO   PTO,
             SOLOT      S,
             VTASUCCLI  SUC,
             TIPTRABAJO T,
             INSPRD     PID,
             VTATABDST  UBI
       WHERE INS.CODINSSRV = PTO.CODINSSRV
         AND PTO.CODSOLOT = S.CODSOLOT
         AND SUC.CODSUC = INS.CODSUC
         AND UBI.CODUBI = SUC.UBISUC
         AND PID.PID = PTO.PID
         AND INS.ESTINSSRV = 1
         AND T.TIPTRA = S.TIPTRA
         AND T.TIPTRS = 1
         AND PID.FLGPRINC = 1
         AND EXISTS (SELECT 1
                       FROM TIPOPEDD T, OPEDD O
                      WHERE T.TIPOPEDD = O.TIPOPEDD
                        AND T.ABREV = 'CONFSERVADICIONAL'
                        AND O.ABREVIACION = 'TIPTRAVAL'
                        AND O.CODIGON = T.TIPTRA)
         AND EXISTS (SELECT 1
                       FROM TIPOPEDD T, OPEDD O
                      WHERE T.TIPOPEDD = O.TIPOPEDD
                        AND T.ABREV = 'CONFSERVADICIONAL'
                        AND O.ABREVIACION = 'ESTSOL_MAXALTA'
                        AND O.CODIGON = S.ESTSOL)
         AND S.CUSTOMER_ID = an_customer_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' || 'SGASS_SUCURSALES_CLIENTE' ||
                              ' -- ' || SQLERRM);
  END;

  --fin 21.00
  --ini 25.0
 procedure p_valida_cp_idinteraccion(av_idinteraccion in operacion.siac_postventa_proceso.cod_intercaso%type,
                                     an_cod_id        in solot.cod_id%type,
                                     an_codsolot      out solot.codsolot%type,
                                     an_error         out number,
                                     av_mensaje       out varchar2) is
   lv_valida    number;
   ln_resultado number;
   lv_mensaje   varchar2(900);
   lv_codsolot  operacion.siac_instancia.instancia%type;
   ln_codsolot  operacion.solot.codsolot%type;
   ex_error exception;
   lv_estado_sot estsol.descripcion%type;
 begin
 
   ln_resultado := 0;
   lv_mensaje   := 'Exito';
   an_error     := ln_resultado;
   av_mensaje   := lv_mensaje;
 
   begin
     select distinct si.instancia
       into lv_codsolot
       from operacion.siac_postventa_proceso i, operacion.siac_instancia si
      where i.cod_id = an_cod_id
        and i.cod_intercaso = av_idinteraccion
        and i.idprocess = si.idprocess
        and si.tipo_instancia = 'SOT';
   exception
     when others then
       BEGIN
         select distinct si.instancia
           into lv_codsolot
           from operacion.siac_postventa_proceso i,
                operacion.siac_instancia         si
          where i.cod_id = an_cod_id
            and i.cod_intercaso = av_idinteraccion
            and i.idprocess = si.idprocess
            and si.tipo_instancia = 'SOT'
            and ROWNUM = 1;
       exception
         when others then
           lv_codsolot := 0;
       end;
   end;
 
   ln_codsolot := to_number(lv_codsolot);
 
   begin
     
     select e.descripcion
       into lv_estado_sot
       from solot s, estsol e
      where s.codsolot = ln_codsolot
        and s.estsol = e.estsol
        and e.tipestsol not in (5, 7); -- No Rechazadas, Ni Anuladas
        
     lv_valida := 1;
     
   exception
     when no_data_found then
       lv_valida     := 0;
       lv_estado_sot := 'Sin SOT';
     when others then
       lv_valida     := 0;
       lv_estado_sot := 'Sin SOT';
   end;
 
   if lv_valida > 0 then
	 an_codsolot := ln_codsolot;
     ln_resultado := 3;
     lv_mensaje   := 'La Interaccion ('||av_idinteraccion||') ya tiene una SOT Generada ('||lv_codsolot||') con estado ('||lv_estado_sot||')';
     raise ex_error;
   end if;
 exception
   when ex_error then
     an_error   := ln_resultado;
     av_mensaje := lv_mensaje;
   when others then
     an_error   := -10;
     av_mensaje := 'Error en la validacion por IDINTERACCION : ' || SQLERRM;
   
 end;
 --25.0
END;
/