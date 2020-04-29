CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_baja IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_linea linea;
  /* ***************************************************************************/
  PROCEDURE baja IS
  BEGIN
    g_linea := get_linea();
  
    crear_int_plataforma_bscs();
  
    crear_int_telefonia_log();
  
    operacion.pq_janus_conexion.enviar_solicitud();
  
    operacion.pq_janus.update_int_plataforma_bscs();
  
    operacion.pq_janus.crear_tareawfseg();
  
    operacion.pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.BAJA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := operacion.pq_int_telefonia.get_id();
    l_log.plataforma       := 'JANUS';
    l_log.codinssrv        := g_linea.codinssrv;
    l_log.numero           := g_linea.numero;
    l_log.pid              := g_linea.pid;
    l_log.idtrans          := operacion.pq_janus.g_idtrans;
    l_log.tx_bscs          := operacion.pq_janus.g_tx_bscs;
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs IS
    C_BAJA CONSTANT PLS_INTEGER := 2;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    l_int_bscs.co_id     := operacion.pq_janus.get_conf('P_HCTR') ||
                            g_linea.codinssrv;
    l_int_bscs.numero    := g_linea.numero;
    l_int_bscs.imsi      := operacion.pq_janus.get_conf('P_IMSI') ||
                            g_linea.numero;
    l_int_bscs.action_id := C_BAJA;
    l_int_bscs.trama     := armar_trama();
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_BAJA);
    operacion.pq_janus.g_action_id := C_BAJA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea    linea;
    l_idwf_ori wf.idwf%TYPE;
  
  BEGIN
    SELECT a.codsolot, f.pid, ins.numero, f.codinssrv
      INTO l_linea
      FROM wf a,
           tystabsrv b,
           plan_redint d,
           (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
              FROM solotpto a, inssrv b, insprd c
             WHERE a.codinssrv = b.codinssrv
               AND b.tipinssrv = 3
               AND b.codinssrv = c.codinssrv
               AND c.flgprinc = 1
            --  AND c.estinsprd <> 4
            --  AND c.fecini IS NOT NULL
             GROUP BY a.codsolot, b.codinssrv) e,
           insprd f,
           inssrv ins
     WHERE a.idwf = operacion.pq_int_telefonia.g_idwf
       AND a.codsolot = e.codsolot
       AND f.codinssrv = e.codinssrv
       AND f.pid = e.pid
       AND f.codsrv = b.codsrv
       AND b.idplan = d.idplan
       AND d.idtipo IN (2, 3)
       AND e.codinssrv = ins.codinssrv;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    
      l_idwf_ori := get_idwf_origen();
    
      SELECT a.codsolot, f.pid, ins.numero, f.codinssrv
        INTO l_linea
        FROM wf a,
             tystabsrv b,
             plan_redint d,
             (SELECT a.codsolot, b.codinssrv, MAX(c.pid) pid
                FROM solotpto a, inssrv b, insprd c
               WHERE a.codinssrv = b.codinssrv
                 AND b.tipinssrv = 3
                 AND b.codinssrv = c.codinssrv
                 AND c.flgprinc = 1
                 AND c.estinsprd <> 4
                 AND c.fecini IS NOT NULL
               GROUP BY a.codsolot, b.codinssrv) e,
             insprd f,
             inssrv ins
       WHERE a.idwf = l_idwf_ori
         AND a.codsolot = e.codsolot
         AND f.codinssrv = e.codinssrv
         AND f.pid = e.pid
         AND f.codsrv = b.codsrv
         AND b.idplan = d.idplan
         AND d.idtipo IN (2, 3)
         AND e.codinssrv = ins.codinssrv;
    
      RETURN l_linea;
    
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION armar_trama RETURN VARCHAR2 IS
    l_trama VARCHAR2(32767);
  
  BEGIN
    l_trama := g_linea.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_IMSI') ||
               g_linea.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_HCTR') ||
               g_linea.codinssrv;
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE IS
  
    p_idwf_origen tareawfcpy.idwf%TYPE;
  BEGIN
  
    SELECT y.idwf
      INTO p_idwf_origen
      FROM solot x, wf y
     WHERE x.codsolot = y.codsolot
       AND x.numslc IN (SELECT c.numslc_ori
                          FROM wf a, solot b, sales.regvtamentab c
                         WHERE a.codsolot = b.codsolot
                           AND b.numslc = c.numslc
                           AND a.idwf = pq_int_telefonia.g_idwf);
  
    RETURN p_idwf_origen;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDWF_ORIGEN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
END;
/
