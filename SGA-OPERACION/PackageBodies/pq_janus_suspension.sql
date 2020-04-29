CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_SUSPENSION IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SUSPENSION
     PURPOSE:    Ejecutar proceso DE SUSPENSION EN JANUS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014                    Christian Riquelme            Ejecutar proceso DE SUSPENSION EN JANUS
  ***************************************************************************************************/

  PROCEDURE suspension_padre(p_idtareawf tareawf.idtareawf%TYPE,
                             p_idwf      tareawf.idwf%TYPE,
                             p_tarea     tareawf.tarea%TYPE,
                             p_tareadef  tareawf.tareadef%TYPE) IS
  BEGIN
    operacion.pq_int_telefonia.set_globals(p_idtareawf,
                                           p_idwf,
                                           p_tarea,
                                           p_tareadef);
  
    IF NOT pq_int_telefonia.es_masivo_hfc() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SUSPENSION_PADRE: NO ES MASIVO');
    END IF;
  
    suspension();
  
  EXCEPTION
    WHEN OTHERS THEN
      pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE suspension IS
  BEGIN
  
    set_contexto();
  
    pq_int_telefonia.crear_int_telefonia();
  
    crea_int_plataforma_bscs();
  
    crea_int_telefonia_log();
  
    pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    operacion.pq_janus.crear_tareawfseg();
  
    pq_int_telefonia.update_int_telefonia_log();
    pq_int_telefonia.update_int_telefonia();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SUSPENSION: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT b.codinssrv,
           b.numero,
           (SELECT MAX(x.pid)
              FROM insprd x
             WHERE x.codinssrv = b.codinssrv
               AND x.flgprinc = 1
               AND x.codinssrv = b.codinssrv
               AND x.codsrv = a.codsrvnue)
      INTO l_linea
      FROM wf d, solotpto a, inssrv b, solot g
     WHERE d.idwf = operacion.pq_int_telefonia.g_idwf
       AND g.codsolot = d.codsolot
       AND a.codsolot = g.codsolot
       AND b.tipinssrv = 3
       AND b.codinssrv = a.codinssrv;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_contexto IS
  BEGIN
  
    operacion.pq_int_telefonia.g_operacion := 'SUSPENSION';
    operacion.pq_int_telefonia.g_origen    := 'JANUS';
    operacion.pq_int_telefonia.g_destino   := 'JANUS';
  
  END;
  /* ***************************************************************************/
  FUNCTION get_codsolot RETURN solot.codsolot%TYPE IS
    l_codsolot solot.codsolot%TYPE;
  
  BEGIN
    SELECT t.codsolot
      INTO l_codsolot
      FROM wf t
     WHERE t.idwf = operacion.pq_int_telefonia.g_idwf;
    RETURN l_codsolot;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CODSOLOT: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crea_int_plataforma_bscs IS
    C_SUSPENSION CONSTANT PLS_INTEGER := 4;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
    l_linea    linea;
  
  BEGIN
  
    l_linea := get_linea();
  
    l_int_bscs.co_id := operacion.pq_janus.get_conf('P_HCTR') ||
                        l_linea.codinssrv;
  
    l_int_bscs.numero := l_linea.numero;
  
    l_int_bscs.imsi := operacion.pq_janus.get_conf('P_IMSI') || l_linea.numero;
  
    l_int_bscs.action_id := C_SUSPENSION;
  
    l_int_bscs.trama := armar_trama;
  
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := pq_janus.set_tx_bscs(C_SUSPENSION);
    operacion.pq_janus.g_action_id := C_SUSPENSION;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREA_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;

  /* **********************************************************************************************/
  FUNCTION armar_trama RETURN VARCHAR2 IS
    l_linea linea;
    l_trama VARCHAR2(32767);
  
  BEGIN
    l_linea := get_linea;
  
    l_trama := l_linea.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_IMSI') ||
               l_linea.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_HCTR') ||
               l_linea.codinssrv;
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_codinssrv RETURN inssrv.codinssrv%TYPE IS
    l_linea linea;
  BEGIN
    l_linea     := get_linea();
    g_codinssrv := l_linea.codinssrv;
  
    RETURN l_linea.codinssrv;
  END; /* **********************************************************************************************/
  FUNCTION get_numero RETURN numtel.numero%TYPE IS
    l_linea linea;
  BEGIN
    l_linea  := get_linea();
    g_numero := l_linea.numero;
  
    RETURN l_linea.numero;
  END;
  /* **********************************************************************************************/
  FUNCTION get_pid RETURN insprd.pid%TYPE IS
    l_linea linea;
  BEGIN
    l_linea := get_linea();
    g_pid   := l_linea.pid;
  
    RETURN l_linea.pid;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  /* **********************************************************************************************/
  PROCEDURE crea_int_telefonia_log IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := get_id_telefonia();
    l_log.plataforma       := 'JANUS';
    l_log.codinssrv        := get_codinssrv();
    l_log.numero           := get_numero();
    l_log.pid              := get_pid();
    l_log.idtrans          := operacion.pq_janus.g_idtrans;
    l_log.tx_bscs          := operacion.pq_janus.g_tx_bscs;
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREA_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE IS
    l_id_telefonia operacion.int_telefonia.id%TYPE;
    l_codsolot     solot.codsolot%TYPE;
  BEGIN
  
    l_id_telefonia := pq_int_telefonia.get_id();
  
    IF l_id_telefonia IS NULL THEN
    
      l_codsolot := pq_int_telefonia.get_codsolot();
    
      SELECT a.id
        INTO l_id_telefonia
        FROM operacion.int_telefonia a
       WHERE a.codsolot = l_codsolot;
    
    END IF;
  
    RETURN l_id_telefonia;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_ID_TELEFONIA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
END;
/
