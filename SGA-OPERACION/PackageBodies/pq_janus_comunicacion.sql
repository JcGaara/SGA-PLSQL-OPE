CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_comunicacion IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_COMUNICACION
     PURPOSE:    Envía trama de datos a plataforma JANUS
  
     REVISIONS:
     Ver  Date        Author            Solicitado por      Description
     ---  ----------  ---------------   --------------      ----------------------------
     1.0  20/02/2014  Eustaquio Gibaja  Christian Riquelme  Envía trama de datos a plataforma JANUS
     2.0  30/02/2014  Eustaquio Gibaja  Christian Riquelme  Mejoras envío de trama
     3.0  21/07/2014  Eustaquio Gibaja  Christian Riquelme  Guardar xml de envío a BSCS
  ***************************************************************************************************/

  PROCEDURE enviar_solicitud(p_idtrans   operacion.int_plataforma_bscs.idtrans%TYPE,
                             p_action_id operacion.int_plataforma_bscs.action_id%TYPE,
                             p_trama     operacion.int_plataforma_bscs.trama%TYPE) IS
  
    l_metodo opedd.codigoc%TYPE;
  
  BEGIN
  
    g_idtrans   := p_idtrans;
    g_action_id := p_action_id;
    g_trama     := p_trama;
  
    l_metodo := get_metodo();
  
    IF l_metodo = 'WS' THEN
      enviar_x_ws();
    ELSIF l_metodo = 'DBLINK' THEN
      enviar_x_dblink();
    ELSIF l_metodo = 'MOCK' THEN
      NULL;
    END IF;
  
  END;

  PROCEDURE enviar_solicitud IS
    l_metodo opedd.codigoc%TYPE;
  
  BEGIN
    l_metodo := get_metodo();
  
    IF l_metodo = 'WS' THEN
      enviar_x_ws();
    ELSIF l_metodo = 'DBLINK' THEN
      enviar_x_dblink();
      -- ELSIF l_metodo = 'MOCK' THEN
      --enviar_x_mock();
    END IF;
  END;
  /* **********************************************************************************************/
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
  
    /*EXCEPTION
    WHEN OTHERS THEN
     -- operacion.pq_int_telefonia_log. logit('get_metodo');*/
  END;
  /* **********************************************************************************************/
  PROCEDURE enviar_x_ws IS
  
    l_xml      VARCHAR2(32767);
    l_xml_rpta VARCHAR2(32767);
    l_url      VARCHAR2(32767);
  
  BEGIN
    --ini 2.0
  
    --l_url      := 'http://172.19.72.177:7909/dsEjecutaAccionesFija/ebsdsEjecutaAccionesFijaSB12?WSDL';
    l_url := operacion.pq_janus_conexion.get_url();
  
    --fin 2.0
    l_xml      := armar_xml();
    l_xml_rpta := call_webservice(l_xml, l_url);
  
    set_rpta(l_xml_rpta);
  
    update_int_telefonia_log(g_idtrans);
  END;
  /* **********************************************************************************************/
  PROCEDURE enviar_x_dblink IS
    l_trama     VARCHAR2(2000);
    l_resultado VARCHAR2(2);
    l_mensaje   VARCHAR2(200);
  
  BEGIN
    l_trama := operacion.pq_janus.g_trama;
    tim.pp001_pkg_prov_janus.sp_reg_prov_ctrl@DBL_BSCS_BF(g_idtrans,
                                                          g_action_id,
                                                          l_trama,
                                                          l_resultado,
                                                          l_mensaje);
    g_codigo  := l_resultado;
    g_mensaje := l_mensaje;
    update_int_telefonia_log(g_idtrans);
  
    /* EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logit('enviar_x_dblink');*/
  END;
  /* **********************************************************************************************/
  FUNCTION armar_xml RETURN VARCHAR2 IS
    l_ip     VARCHAR2(100);
    l_xml    VARCHAR2(32767);
    l_id_log operacion.int_telefonia_log.id%TYPE; --3.0
  
  BEGIN
    l_ip := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
  
    l_xml := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ';
    l_xml := l_xml ||
             'xmlns:ejec="http://claro.com.pe/eai/ebs/ws/dsEjecutaAccionesFija/ejecutarAccionesFija/">';
    l_xml := l_xml || '<soapenv:Header/>';
    l_xml := l_xml || '<soapenv:Body>';
    l_xml := l_xml || '<ejec:ejecutarAccionesFijaRequest>';
    l_xml := l_xml || '<ejec:audit>';
    l_xml := l_xml || '<ejec:idTransaccion>' || g_idtrans ||
             '</ejec:idTransaccion>';
    l_xml := l_xml || '<ejec:ipAplicacion>' || l_ip || '</ejec:ipAplicacion>';
    l_xml := l_xml || '<ejec:nombreAplicacion>EAI</ejec:nombreAplicacion>';
    l_xml := l_xml || '<ejec:usuario>' || USER || '</ejec:usuario>';
    l_xml := l_xml || '</ejec:audit>';
    l_xml := l_xml || '<ejec:ActionId>' || g_action_id || '</ejec:ActionId>';
    l_xml := l_xml || '<ejec:TramaEntrada>' || g_trama ||
             '</ejec:TramaEntrada>';
    l_xml := l_xml || '<ejec:listaOpcionalRequest>';
    l_xml := l_xml || '<!--Zero or more repetitions:-->'; --todo: comentario?
    l_xml := l_xml || '<ejec:RequestOpcional>';
    l_xml := l_xml || '<ejec:clave></ejec:clave>';
    l_xml := l_xml || '<ejec:valor></ejec:valor>';
    l_xml := l_xml || '</ejec:RequestOpcional>';
    l_xml := l_xml || '</ejec:listaOpcionalRequest>';
    l_xml := l_xml || '</ejec:ejecutarAccionesFijaRequest>';
    l_xml := l_xml || '</soapenv:Body>';
    l_xml := l_xml || '</soapenv:Envelope>';
  
    --ini 3.0    
    --ini 2.0
    /*UPDATE  operacion.int_telefonia_log a SET a.ws_xml = l_xml
    WHERE a.id = pq_int_telefonia_log.g_id;*/
    --fin 2.0
  
    l_id_log := get_id_log(g_idtrans);
  
    UPDATE operacion.int_telefonia_log a
       SET a.ws_xml = l_xml
     WHERE a.id = l_id_log;
    --fin 3.0
  
    RETURN l_xml;
  END;
  /* **********************************************************************************************/
  FUNCTION call_webservice(p_xml VARCHAR2, p_url VARCHAR2) RETURN VARCHAR2 IS
    TIME_OUT   PLS_INTEGER := -12535;
    l_response VARCHAR2(32767);
    http_req   utl_http.req;
    http_resp  utl_http.resp;
  
  BEGIN
    http_req := utl_http.begin_request(p_url, 'POST', 'HTTP/1.1');
    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
    utl_http.set_header(http_req, 'Content-Length', LENGTH(p_xml));
    utl_http.write_text(http_req, p_xml);
    http_resp := utl_http.get_response(http_req);
    utl_http.read_text(http_resp, l_response);
    utl_http.end_response(http_resp);
  
    RETURN l_response;
  
  EXCEPTION
    WHEN UTL_HTTP.END_OF_BODY THEN
      UTL_HTTP.END_RESPONSE(http_resp);
    WHEN OTHERS THEN
      IF SQLCODE = TIME_OUT THEN
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.CALL_WEBSERVICE: TIME_OUT' ||
                                SQLERRM);
      ELSE
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.CALL_WEBSERVICE: ' || SQLERRM);
      END IF;
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia_log(p_idtrans operacion.int_plataforma_bscs.idtrans%TYPE) IS
    l_log    operacion.int_telefonia_log%ROWTYPE;
    l_id_log operacion.int_telefonia_log.id%TYPE;
  
  BEGIN
  
    l_id_log := get_id_log(p_idtrans);
  
    SELECT t.*
      INTO l_log
      FROM operacion.int_telefonia_log t
     WHERE t.id = l_id_log;
  
    l_log.ws_envios    := NVL(l_log.ws_envios, 0) + 1;
    l_log.ws_error_id  := g_codigo;
    l_log.ws_error_dsc := g_mensaje;
  
    UPDATE operacion.int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;
  END;
  /* **********************************************************************************************/
  FUNCTION get_id_log(p_idtrans operacion.int_plataforma_bscs.idtrans%TYPE)
    RETURN operacion.int_telefonia_log.id%TYPE IS
  
    l_id_log operacion.int_telefonia_log.id%TYPE;
  BEGIN
    SELECT a.id
      INTO l_id_log
      FROM operacion.int_telefonia_log a
     WHERE a.idtrans = p_idtrans;
    --WHERE a.janus_id = p_idtrans;
  
    RETURN l_id_log;
  END;
  /* **********************************************************************************************/
  PROCEDURE set_rpta(p_xml VARCHAR2) IS
  BEGIN
    g_codigo  := get_atributo(p_xml, 'codigoRespuesta');
    g_mensaje := get_atributo(p_xml, 'mensajeRespuesta');
  END;
  /* **********************************************************************************************/
  FUNCTION get_atributo(p_xml VARCHAR2, p_atributo VARCHAR2) RETURN VARCHAR2 IS
    l_xml VARCHAR2(32767);
  
  BEGIN
    l_xml := p_xml;
    l_xml := SUBSTR(l_xml, INSTR(l_xml, p_atributo) + LENGTH(p_atributo) + 1);
    l_xml := SUBSTR(l_xml, 1, INSTR(l_xml, '<') - 1);
  
    RETURN l_xml;
  END;
  /* **********************************************************************************************/
END;
/