CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_conexion IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      26/02/2014  Mauro Zegarra    Christian Riquelme  version inicial
     2.0      29/05/2014  Mauro Zegarra    Christian Riquelme  Mejoras
     3.0      18/05/2014  Eustaquio Gibaja Christian Riquelme  Mejoras
  /* ***************************************************************************/
  G_ENVIOS int_telefonia_log.ws_envios%TYPE;
  /* ***************************************************************************/
  PROCEDURE enviar_solicitud IS
    l_metodo opedd.codigoc%TYPE;
  
  BEGIN
    l_metodo := get_metodo();
  
    IF l_metodo = 'WS' THEN
      enviar_x_ws();
    ELSIF l_metodo = 'DBLINK' THEN
      enviar_x_dblink();
    END IF;
  END;
  /* ***************************************************************************/
  FUNCTION get_metodo RETURN VARCHAR2 IS
    l_conf opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO l_conf
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev = 'PLAT_JANUS'
       AND o.abreviacion = 'CONEXION_JANUS'
       AND o.codigon = 1;
  
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
    SELECT o.descripcion
      INTO l_config
      FROM tipopedd t, opedd o
     WHERE t.abrev = 'PLAT_JANUS'
       AND t.tipopedd = o.tipopedd
       AND o.abreviacion = 'URL_JANUS'
       AND o.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_URL: ' || SQLERRM);
  END;
  /* ****************************************************************************/
  --ini 2.0
  FUNCTION get_url_metodo RETURN opedd.descripcion%TYPE IS
    l_config opedd.descripcion%TYPE;
  
  BEGIN
    SELECT o.descripcion
      INTO l_config
      FROM tipopedd t, opedd o
     WHERE t.abrev = 'PLAT_JANUS'
       AND t.tipopedd = o.tipopedd
       AND o.abreviacion = 'URL_JANUS_METODO'
       AND o.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_URL_METODO: ' || SQLERRM);
  END;
  --fin 2.0
  /* ***************************************************************************/
  PROCEDURE enviar_x_ws IS
    l_xml_rpta VARCHAR2(32767);
  
  BEGIN
    l_xml_rpta := call_webservice(armar_xml(), get_url());
  
    get_rpta_ws(l_xml_rpta);
  
    update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ENVIAR_X_WS ' || SQLERRM); --3.0
  END;
  /* ***************************************************************************/
  PROCEDURE enviar_x_dblink IS
    l_trama     VARCHAR2(2000);
    l_resultado VARCHAR2(2);
    l_mensaje   VARCHAR2(200);
  
  BEGIN
    l_trama := pq_janus.g_trama;
    tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(pq_janus.g_idtrans,
                                                          pq_janus.g_action_id,
                                                          l_trama,
                                                          l_resultado,
                                                          l_mensaje);
    g_codigo  := l_resultado;
    g_mensaje := l_mensaje;
    update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ENVIAR_X_DBLINK: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_telefonia_log IS
    l_log int_telefonia_log%ROWTYPE;
  
  BEGIN
    SELECT t.*
      INTO l_log
      FROM int_telefonia_log t
     WHERE t.id = pq_int_telefonia_log.g_id;
  
    l_log.ws_envios    := NVL(l_log.ws_envios, 0) + 1;
    l_log.ws_error_id  := g_codigo;
    l_log.ws_error_dsc := g_mensaje;
  
    UPDATE int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;
  END;
  /* ***************************************************************************/
  FUNCTION armar_xml RETURN VARCHAR2 IS
    l_ip  VARCHAR2(100);
    l_xml VARCHAR2(32767);
  
  BEGIN
    l_ip := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
  
    l_xml := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ';
    /* ini 2.0
    l_xml := l_xml ||
             'xmlns:ejec="http://claro.com.pe/eai/ebs/ws/dsEjecutaAccionesFija/ejecutarAccionesFija/">';
    */
    l_xml := l_xml || 'xmlns:ejec="' || get_url_metodo() || '">';
    --fin 2.0
 
    l_xml := l_xml || '<soapenv:Header/>';
    l_xml := l_xml || '<soapenv:Body>';
    l_xml := l_xml || '<ejec:ejecutarAccionesFijaRequest>';
    l_xml := l_xml || '<ejec:audit>';
    l_xml := l_xml || '<ejec:idTransaccion>' || pq_janus.g_idtrans ||
             '</ejec:idTransaccion>';
    l_xml := l_xml || '<ejec:ipAplicacion>' || l_ip || '</ejec:ipAplicacion>';
    l_xml := l_xml || '<ejec:nombreAplicacion>EAI</ejec:nombreAplicacion>';
    l_xml := l_xml || '<ejec:usuario>' || USER || '</ejec:usuario>';
    l_xml := l_xml || '</ejec:audit>';
    l_xml := l_xml || '<ejec:ActionId>' || pq_janus.g_action_id ||
             '</ejec:ActionId>';
    l_xml := l_xml || '<ejec:TramaEntrada>' || pq_janus.g_trama ||
             '</ejec:TramaEntrada>';
    l_xml := l_xml || '<ejec:listaOpcionalRequest>';
    l_xml := l_xml || '<!--Zero or more repetitions:-->';
    l_xml := l_xml || '<ejec:RequestOpcional>';
    l_xml := l_xml || '<ejec:clave></ejec:clave>';
    l_xml := l_xml || '<ejec:valor></ejec:valor>';
    l_xml := l_xml || '</ejec:RequestOpcional>';
    l_xml := l_xml || '</ejec:listaOpcionalRequest>';
    l_xml := l_xml || '</ejec:ejecutarAccionesFijaRequest>';
    l_xml := l_xml || '</soapenv:Body>';
    l_xml := l_xml || '</soapenv:Envelope>';
     --ini 2.0
    UPDATE  operacion.int_telefonia_log a SET a.ws_xml = l_xml
    WHERE a.id = pq_int_telefonia_log.g_id;
     --fin 2.0
    RETURN l_xml;
    
  END;
  /* ***************************************************************************/
  FUNCTION call_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2 IS
    l_data     VARCHAR2(32767);
    l_request  utl_http.req;
    l_response utl_http.resp;
  
  BEGIN
    l_request := UTL_HTTP.BEGIN_REQUEST(p_url, 'POST', 'HTTP/1.1');
    UTL_HTTP.SET_HEADER(l_request, 'Content-Type', 'text/xml');
    UTL_HTTP.SET_HEADER(l_request, 'Content-Length', LENGTH(p_xml));
    UTL_HTTP.WRITE_TEXT(l_request, p_xml);
    l_response := UTL_HTTP.GET_RESPONSE(l_request);
    UTL_HTTP.READ_TEXT(l_response, l_data);
    UTL_HTTP.END_RESPONSE(l_response);
  
    RETURN l_data;
  
  EXCEPTION
    WHEN OTHERS THEN
      UTL_HTTP.END_RESPONSE(l_response); --3.0
      guardar_error_cx(SQLERRM);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CALL_WEBSERVICE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE guardar_error_cx(p_error VARCHAR2) IS
    l_id int_telefonia_log.id%TYPE;
  
  BEGIN
    l_id := pq_int_telefonia_log.g_id;
  
    UPDATE int_telefonia_log t
       SET t.ws_envios    = NVL(t.ws_envios, 0) + 1,
           t.ws_error_id  = -1,
           t.ws_error_dsc = p_error
     WHERE t.id = pq_int_telefonia_log.g_id;
  
    IF pq_janus_procesos.get_envios_realizados(l_id) = G_ENVIOS + 1 THEN
      pq_janus_procesos.send_mail_soporte_bscs(l_id);
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE get_rpta_ws(p_xml VARCHAR2) IS
  BEGIN
    g_codigo  := get_atributo(p_xml, 'codigoRespuesta');
    g_mensaje := get_atributo(p_xml, 'mensajeRespuesta');
  
    IF g_codigo <> 0 THEN
      guardar_error_rpta();
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_RPTA_WS: ' || g_mensaje);
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE guardar_error_rpta IS
  BEGIN
    UPDATE int_telefonia_log t
       SET t.ws_envios    = NVL(t.ws_envios, 0) + 1,
           t.ws_error_id  = g_codigo,
           t.ws_error_dsc = g_mensaje
     WHERE t.id = pq_int_telefonia_log.g_id;
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
    G_ENVIOS := pq_janus_procesos.get_cantidad_envio();
  
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
