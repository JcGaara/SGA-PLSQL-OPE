CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_CE_CONEXION IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      2014-06-26  Eustaquio Gibaja Christian Riquelme  version inicial
     2.0      2014-10-22  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  --G_ENVIOS telefonia_ce_det.ws_envios%TYPE;
  /* ***************************************************************************/
  PROCEDURE enviar_solicitud(p_idtrans             int_plataforma_bscs.idtrans%type,
                             p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type) IS
    l_metodo opedd.codigoc%TYPE;
    l_action telefonia_ce_det.action_id%type;

  BEGIN

    select action_id
      into l_action
      from operacion.telefonia_ce_det
     where id_telefonia_ce_det = p_id_telefonia_ce_det;

    l_metodo := get_metodo(l_action);
  
    IF l_metodo = 'WS' THEN
      enviar_x_ws(p_idtrans, p_id_telefonia_ce_det);
    ELSIF l_metodo = 'MOCK' THEN
      enviar_x_mock(p_idtrans, p_id_telefonia_ce_det);
    END IF;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.enviar_solicitud(p_idtrans => ' ||
                              p_idtrans || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  FUNCTION get_metodo(p_action telefonia_ce_det.action_id%type) RETURN VARCHAR2 IS
    l_conf opedd.codigoc%TYPE;
  
  BEGIN
    select d.codigoc
         into l_conf
         from tipopedd c, opedd d
        where c.abrev = 'PLAT_JANUS_CE'
          and c.tipopedd = d.tipopedd
          and d.abreviacion = 'CONEXION_JANUS_PROCESO'
          AND CODIGON = p_action
          and d.codigon_AUX = 1; 
 
    /*SELECT d.codigoc
      INTO l_conf
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS_CE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'CONEXION_JANUS'
       AND d.codigon = 1;*/
  
    RETURN l_conf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_METODO: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_url RETURN opedd.descripcion%TYPE IS
    l_config opedd.descripcion%TYPE;
  
  BEGIN
    SELECT d.descripcion
      INTO l_config
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS_CE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'URL_JANUS'
       AND d.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_URL: ' || SQLERRM);
  END;
  /* ****************************************************************************/
  FUNCTION get_url_metodo RETURN opedd.descripcion%TYPE IS
    l_config opedd.descripcion%TYPE;
  
  BEGIN
    SELECT d.descripcion
      INTO l_config
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS_CE'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'URL_JANUS_METODO'
       AND d.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_URL_METODO: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE enviar_x_mock(p_idtrans             int_plataforma_bscs.idtrans%type,
                          p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type) IS

    l_xml      varchar2(32767);
    l_xml_rpta varchar2(32767);
    l_response t_response;

  BEGIN
    --g_codigo  := '0';
    --g_mensaje := 'REGISTRO SATISFACTORIO';
  
    --update_telefonia_ce_det();

    l_xml := armar_xml(p_idtrans);
  
    l_xml_rpta := armar_xml_rpta(p_idtrans);
  
    update telefonia_ce_det t
       set t.ws_xml = l_xml, t.ws_xml_rpta = l_xml_rpta
     where t.id_telefonia_ce_det = p_id_telefonia_ce_det;
  
    l_response := get_rpta_ws(p_id_telefonia_ce_det, l_xml_rpta);
  
    update_telefonia_ce_det(p_id_telefonia_ce_det, l_response);
  
    update int_plataforma_bscs
       set resultado = l_response.codigo, message_resul = l_response.mensaje
     where idtrans = p_idtrans;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.enviar_x_mock(p_idtrans => ' ||
                              p_idtrans || ', p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ') ' || sqlerrm);
  END;
  /* **********************************************************************************************/
  PROCEDURE enviar_x_ws(p_idtrans             int_plataforma_bscs.idtrans%type,
                        p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type) IS
    l_xml      VARCHAR2(32767);
    l_xml_rpta varchar2(32767);
    l_response t_response;

  BEGIN
    l_xml := armar_xml(p_idtrans);
  
    update telefonia_ce_det t
       set t.ws_xml = l_xml
     where t.id_telefonia_ce_det = p_id_telefonia_ce_det;
 
    l_xml_rpta := call_webservice(p_id_telefonia_ce_det, l_xml, get_url());
    
    update telefonia_ce_det t
       set t.ws_xml_rpta = l_xml_rpta
     where t.id_telefonia_ce_det = p_id_telefonia_ce_det;

    l_response := get_rpta_ws(p_id_telefonia_ce_det, l_xml_rpta);
  
    update_telefonia_ce_det(p_id_telefonia_ce_det, l_response);

    update int_plataforma_bscs
       set resultado = l_response.codigo, message_resul = l_response.mensaje
     where idtrans = p_idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              --$$PLSQL_UNIT || '.ENVIAR_X_WS: ' || SQLERRM);
                              $$plsql_unit || '.enviar_x_ws(p_idtrans => ' ||
                              p_idtrans || ', p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  PROCEDURE update_telefonia_ce_det(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                                    p_response            t_response) IS
    l_log operacion.telefonia_ce_det%ROWTYPE;

  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.telefonia_ce_det t
     WHERE t.id_telefonia_ce_det =
           p_id_telefonia_ce_det/*operacion.pq_telefonia_ce_det.g_id_telefonia_ce_det*/;
  
    l_log.ws_envios     := NVL(l_log.ws_envios, 0) + 1;
    l_log.id_ws_error   := p_response.codigo/*g_codigo*/;
    l_log.ws_error_dsc  := p_response.mensaje/*g_mensaje*/;
    l_log.id_sga_error  := 0;
    l_log.sga_error_dsc := 'OK';
    l_log.verificado    := 0;
  
    UPDATE operacion.telefonia_ce_det t
       SET ROW = l_log
     WHERE t.id_telefonia_ce_det = l_log.id_telefonia_ce_det;
  END;
  /* ***************************************************************************/
  FUNCTION armar_xml(p_idtrans int_plataforma_bscs.idtrans%type) RETURN VARCHAR2 IS
    l_int_plataforma_bscs int_plataforma_bscs%rowtype;
    l_ip                  VARCHAR2(100);
    l_xml                 VARCHAR2(32767);
  
  BEGIN
    l_int_plataforma_bscs := pq_janus_ce.get(p_idtrans);

    l_ip := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
  
    l_xml := '<?xml version="1.0" encoding="ISO-8859-1"?>';
    l_xml := l_xml ||
             '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ';
    l_xml := l_xml || 'xmlns:ejec="' || get_url_metodo() || '">';
    l_xml := l_xml || '<soapenv:Header/>';
    l_xml := l_xml || '<soapenv:Body>';
    l_xml := l_xml || '<ejec:ejecutarAccionesFijaCorpRequest>';
    l_xml := l_xml || '<ejec:audit>';
    l_xml := l_xml || '<ejec:idTransaccion>' || l_int_plataforma_bscs.idtrans/*operacion.pq_janus_ce.g_idtrans*/ ||
             '</ejec:idTransaccion>';
    l_xml := l_xml || '<ejec:ipAplicacion>' || l_ip || '</ejec:ipAplicacion>';
    l_xml := l_xml || '<ejec:nombreAplicacion>EAI</ejec:nombreAplicacion>';
    l_xml := l_xml || '<ejec:usuario>' || USER || '</ejec:usuario>';
    l_xml := l_xml || '</ejec:audit>';
    l_xml := l_xml || '<ejec:ActionId>' || l_int_plataforma_bscs.action_id/*operacion.pq_janus_ce.g_action_id*/ ||
             '</ejec:ActionId>';
    l_xml := l_xml || '<ejec:TramaEntrada>' || l_int_plataforma_bscs.trama/*operacion.pq_janus_ce.g_trama*/ ||
             '</ejec:TramaEntrada>';
    l_xml := l_xml || '<ejec:listaOpcionalRequest>';
    l_xml := l_xml || '<!--Zero or more repetitions:-->';
    l_xml := l_xml || '<ejec:RequestOpcional>';
    l_xml := l_xml || '<ejec:clave></ejec:clave>';
    l_xml := l_xml || '<ejec:valor></ejec:valor>';
    l_xml := l_xml || '</ejec:RequestOpcional>';
    l_xml := l_xml || '</ejec:listaOpcionalRequest>';
    l_xml := l_xml || '</ejec:ejecutarAccionesFijaCorpRequest>';
    l_xml := l_xml || '</soapenv:Body>';
    l_xml := l_xml || '</soapenv:Envelope>';
  
    /*UPDATE operacion.telefonia_ce_det a
       SET a.ws_xml = l_xml
     WHERE a.id_telefonia_ce_det =
           operacion.pq_telefonia_ce_det.g_id_telefonia_ce_det;*/
  
    RETURN l_xml;

exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.armar_xml(p_idtrans => ' ||
                              p_idtrans || ') ' || sqlerrm);
  END;
  /* ***************************************************************************/
  function armar_xml_rpta(p_idtrans int_plataforma_bscs.idtrans%type)
    return varchar2 is
    l_xml varchar2(32767);
  
  begin
    l_xml := '<?xml version="1.0" encoding="UTF-8"?>';
    l_xml := l_xml ||
             '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">';
    l_xml := l_xml || '<S:Body>';
    l_xml := l_xml || '<ejecutarAccionesFijaCorpResponse xmlns="' ||
             get_url_metodo() || '">';
    l_xml := l_xml || '<idTransaccion>' || p_idtrans || '</idTransaccion>';
    l_xml := l_xml || '<codigoRespuesta>0</codigoRespuesta>';
    l_xml := l_xml ||
             '<mensajeRespuesta>Registro satisfactorio</mensajeRespuesta>';
    l_xml := l_xml ||
             '</ejecutarAccionesFijaCorpResponse></S:Body></S:Envelope>';
  
    return l_xml;
  
  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.armar_xml_rpta(p_idtrans => ' ||
                              p_idtrans || ') ' || sqlerrm);
  end;
  /* ***************************************************************************/
  FUNCTION call_webservice(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                           p_xml                 varchar2,
                           p_url                 varchar2) RETURN VARCHAR2 IS
    l_data     VARCHAR2(32767);
    l_request  utl_http.req;
    l_response utl_http.resp;
  
  BEGIN
    l_request := UTL_HTTP.begin_request(p_url, 'POST', 'HTTP/1.1');
    UTL_HTTP.set_header(l_request, 'Content-Type', 'text/xml');
    UTL_HTTP.set_header(l_request, 'Content-Length', LENGTH(p_xml));
    UTL_HTTP.write_text(l_request, p_xml);
    l_response := UTL_HTTP.get_response(l_request);
    UTL_HTTP.read_text(l_response, l_data);
    UTL_HTTP.end_response(l_response);
  
    RETURN l_data;
  
  EXCEPTION
    WHEN OTHERS THEN
      UTL_HTTP.end_response(l_response);
      guardar_error_cx(p_id_telefonia_ce_det,SQLERRM);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CALL_WEBSERVICE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE guardar_error_cx(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                             p_error VARCHAR2) IS
    --l_id              operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE;
    C_DATOS_INVALIDOS VARCHAR(30) := 'Datos ingresados invalidos';
    C_EJECUTAR_SQL    VARCHAR(30) := 'Error al ejecutar SQL';
    l_envios          telefonia_ce_det.ws_envios%type;

  BEGIN
    --l_id := operacion.pq_telefonia_ce_det.g_id_telefonia_ce_det;
  
    UPDATE telefonia_ce_det t
       SET t.ws_envios    = NVL(t.ws_envios, 0) + 1,
           t.id_ws_error  = -1,
           t.ws_error_dsc = p_error
     WHERE t.id_telefonia_ce_det = p_id_telefonia_ce_det/*l_id*/;
  
    l_envios := pq_janus_ce_procesos.get_cantidad_envio();

    IF operacion.pq_janus_ce_procesos.get_envios_realizados(p_id_telefonia_ce_det/*l_id*/) =
       l_envios/*G_ENVIOS*/ + 1 OR p_error IN (C_DATOS_INVALIDOS, C_EJECUTAR_SQL) THEN
      operacion.pq_janus_ce_procesos.send_mail_soporte_bscs(p_id_telefonia_ce_det/*l_id*/);
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE get_rpta_ws(p_xml VARCHAR2) IS
  BEGIN
    null;
    /*g_codigo  := get_atributo(p_xml, 'codigoRespuesta');
    g_mensaje := get_atributo(p_xml, 'mensajeRespuesta');
  
    IF g_codigo <> 0 THEN
      guardar_error_rpta();
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_RPTA_WS: ' || g_mensaje);
    END IF;*/
  END;
  /* ***************************************************************************/
  function get_rpta_ws(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                       p_xml                 varchar2) return t_response is
    l_response  t_response;
    l_respuesta varchar2(40);
  
  begin
    if INSTR(p_xml, 'codigoRespuesta') > 0 and
       INSTR(p_xml, 'mensajeRespuesta') > 0 then
      l_response.codigo  := get_atributo(p_xml, 'codigoRespuesta');
      l_response.mensaje := get_atributo(p_xml, 'mensajeRespuesta');
    
      if l_response.codigo <> 0 then
        guardar_error_rpta(p_id_telefonia_ce_det,
                           l_response.codigo,
                           l_response.mensaje);
        raise_application_error(-20000,
                                $$plsql_unit || '.get_rpta_ws() ' ||
                                l_response.mensaje);
      end if;
    else
      if INSTR(p_xml, 'codigoRespuesta') <= 0 then
        l_respuesta := l_respuesta || '-"codigoRespuesta"';
      end if;
    
      if INSTR(p_xml, 'mensajeRespuesta') <= 0 then
        l_respuesta := l_respuesta || '-"mensajeRespuesta"';
      end if;
    
      l_respuesta := substr(l_respuesta, 2);
    
      raise_application_error(-20000,
                              $$plsql_unit || '.get_rpta_ws() ' ||
                              'No se encuentran las Claves necesarias de la Rpta: ' ||
                              l_respuesta);
    end if;
  
    return l_response;
  end;
  /* ***************************************************************************/
  PROCEDURE guardar_error_rpta(p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                               p_codigo              telefonia_ce_det.id_ws_error%type,
                               p_mensaje             telefonia_ce_det.ws_error_dsc%type) IS
  BEGIN
    UPDATE operacion.telefonia_ce_det t
       SET t.ws_envios    = NVL(t.ws_envios, 0) + 1,
           t.id_ws_error  = p_codigo/*g_codigo*/,
           t.ws_error_dsc = p_mensaje/*g_mensaje*/
     WHERE t.id_telefonia_ce_det =
           p_id_telefonia_ce_det/*operacion.pq_telefonia_ce_det.g_id_telefonia_ce_det*/;
  END;
  /* ***************************************************************************/
  FUNCTION get_atributo(p_xml VARCHAR2, p_atributo VARCHAR2) RETURN VARCHAR2 IS
    l_xml VARCHAR2(32767);
  
  BEGIN
    l_xml := p_xml;
    l_xml := SUBSTR(l_xml, INSTR(l_xml, p_atributo) + LENGTH(p_atributo) + 1);
    l_xml := SUBSTR(l_xml, 1, INSTR(l_xml, '<') - 1);
  
    RETURN l_xml;
  END;
  /* ***************************************************************************/
  PROCEDURE inicializar IS
  BEGIN
    null;
    --G_ENVIOS := operacion.pq_janus_ce_procesos.get_cantidad_envio();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INICIALIZAR: ' || SQLERRM);
  END;
  /* ***************************************************************************/
BEGIN
  inicializar();
END;
/