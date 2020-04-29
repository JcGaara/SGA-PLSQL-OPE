CREATE OR REPLACE PACKAGE BODY OPERACION.pq_tellin_conexion IS
  /******************************************************************************
   PROPOSITO:

   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_idlote int_servicio_plataforma.idlote%TYPE;
  /* ***************************************************************************/
  PROCEDURE enviar_solicitud IS
    l_metodo opedd.codigoc%TYPE;

  BEGIN
    l_metodo := get_metodo();

    IF l_metodo = 'WS' THEN
      enviar_x_ws();
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ENVIAR_SOLICITUD: ' || SQLERRM);
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
       AND o.abreviacion = 'CONEXION_TELLIN'
       AND o.codigon = 1;

    RETURN l_conf;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_METODO: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE enviar_x_ws IS
    l_resultado VARCHAR2(4000);
    l_idlote    NUMBER(10);

  BEGIN
    pq_int_comando_plataforma.p_generar_lote_comando(operacion.pq_tellin.get_iddefope(),
                                                     get_param(),
                                                     operacion.pq_tellin.get_idseq(),
                                                     l_resultado,
                                                     l_idlote);

    g_idlote  := l_idlote;
    g_mensaje := 'Se genero IDLOTE: ' || l_idlote;
    update_int_telefonia_log();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ENVIAR_X_WS: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_telefonia_log IS
    l_log operacion.int_telefonia_log%ROWTYPE;

  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.int_telefonia_log t
     WHERE t.id = operacion.pq_int_telefonia_log.g_id;

    l_log.ws_envios    := NVL(l_log.ws_envios, 0) + 1;
    l_log.ws_error_id  := 0;
    l_log.ws_error_dsc := g_mensaje;

    UPDATE operacion.int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_param RETURN VARCHAR2 IS
    l_param CHAR(1);

  BEGIN
    SELECT TO_CHAR(codigon)
      INTO l_param
      FROM int_definicion_parametro
     WHERE UPPER(codigoc) = UPPER('IDSEQ');

    RETURN l_param;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_PARAM: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_idlote RETURN int_servicio_plataforma.idlote%TYPE IS
  BEGIN
    RETURN g_idlote;
  END;
  /* ***************************************************************************/
END;
/