CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_cambio_plan IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_linea     linea;
  g_linea_old int_plataforma_bscs%ROWTYPE;
  /* ***************************************************************************/
  PROCEDURE cambio_plan IS
    l_origen  tystabsrv.codsrv%TYPE;
    l_destino tystabsrv.codsrv%TYPE;
  
  BEGIN
    IF NOT pq_int_telefonia.existe_reserva() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: NO EXISTE RESERVA');
    END IF;
  
    g_linea   := get_linea();
    l_origen  := get_codsrv_origen();
    l_destino := get_codsrv_destino();
  
    IF l_origen = l_destino THEN
      pq_int_telefonia.no_interviene();
    END IF;
  
    IF l_origen <> l_destino THEN
      janus_janus();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT s.codsolot,
           e.codinssrv,
           i.pid,
           s.pid_old,
           t.idplan,
           i.codsrv,
           e.codcli,
           e.numslc,
           e.numero,
           p.plan,
           p.plan_opcional
      INTO l_linea
      FROM wf w, solotpto s, insprd i, inssrv e, tystabsrv t, plan_redint p
     WHERE w.idwf = pq_int_telefonia.g_idwf
       AND w.codsolot = s.codsolot
       AND s.pid = i.pid
       AND i.flgprinc = 1
       AND i.codinssrv = e.codinssrv
       AND e.tipinssrv = 3
       AND i.codsrv = t.codsrv
       AND t.tipsrv = '0004'
       AND t.idplan = p.idplan;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_codsrv_origen RETURN tystabsrv.codsrv%TYPE IS
    l_codsrv tystabsrv.codsrv%TYPE;
  
  BEGIN
    SELECT a.codsrv
      INTO l_codsrv
      FROM insprd a, tystabsrv b, plan_redint c
     WHERE a.pid = g_linea.pid_old
       AND a.codsrv = b.codsrv
       AND b.idplan = c.idplan
       AND c.idtipo IN (2, 3);
  
    RETURN l_codsrv;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CODSRV_ORIGEN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_codsrv_destino RETURN tystabsrv.codsrv%TYPE IS
    l_codsrv tystabsrv.codsrv%TYPE;
  
  BEGIN
    SELECT a.codsrv
      INTO l_codsrv
      FROM insprd a, tystabsrv b, plan_redint c
     WHERE a.pid = g_linea.pid
       AND a.codsrv = b.codsrv
       AND b.idplan = c.idplan
       AND c.idtipo IN (2, 3);
  
    RETURN l_codsrv;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CODSRV_DESTINO: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE janus_janus IS
  BEGIN
    crear_int_plataforma_bscs();
  
    crear_int_telefonia_log();
  
    pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    pq_janus.crear_tareawfseg();
  
    pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.JANUS_JANUS: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := pq_int_telefonia.get_id();
    l_log.plataforma       := 'JANUS';
    l_log.codinssrv        := g_linea.codinssrv;
    l_log.numero           := g_linea.numero;
    l_log.pid              := g_linea.pid;
    l_log.idtrans          := pq_janus.g_idtrans;
    l_log.tx_bscs          := pq_janus.g_tx_bscs;
    pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs IS
    C_CAMBIO_PLAN CONSTANT PLS_INTEGER := 16;
    l_int_bscs int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    g_linea_old := get_linea_old();
  
    l_int_bscs.co_id             := pq_janus.get_conf('P_HCTR') ||
                                    g_linea.codinssrv;
    l_int_bscs.numero            := g_linea.numero;
    l_int_bscs.numero_old        := g_linea_old.numero;
    l_int_bscs.action_id         := C_CAMBIO_PLAN;
    l_int_bscs.trama             := armar_trama();
    l_int_bscs.plan_base         := g_linea.plan;
    l_int_bscs.plan_opcional     := g_linea.plan_opcional;
    l_int_bscs.plan_old          := g_linea_old.plan_base;
    l_int_bscs.plan_opcional_old := g_linea_old.plan_opcional;
    l_int_bscs.imsi              := pq_janus.get_conf('P_IMSI') ||
                                    g_linea.numero;
    l_int_bscs.imsi_old          := g_linea_old.imsi;
    pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    pq_janus.g_trama     := l_int_bscs.trama;
    pq_janus.g_idtrans   := l_int_bscs.idtrans;
    pq_janus.g_tx_bscs   := pq_janus.set_tx_bscs(C_CAMBIO_PLAN);
    pq_janus.g_action_id := C_CAMBIO_PLAN;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION armar_trama RETURN VARCHAR2 IS
    l_trama VARCHAR2(32767);
  
  BEGIN
    l_trama := g_linea.numero || '|';
    l_trama := l_trama || pq_janus.get_conf('P_HCTR') || g_linea.codinssrv || '|';
    l_trama := l_trama || g_linea.plan || '|';
    l_trama := l_trama || g_linea.plan_opcional || '|';
    l_trama := l_trama || g_linea_old.plan_base || '|';
    l_trama := l_trama || g_linea_old.plan_opcional;
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea_old RETURN int_plataforma_bscs%ROWTYPE IS
    l_linea_old int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    SELECT b.*
      INTO l_linea_old
      FROM int_plataforma_bscs b
     WHERE b.idtrans = (SELECT MAX(b.idtrans)
                          FROM int_plataforma_bscs b
                         WHERE b.numero = g_linea.numero);
  
    RETURN l_linea_old;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_OLD: ' || SQLERRM);
  END;
  /* ***************************************************************************/
END;
/
