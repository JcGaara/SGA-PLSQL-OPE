CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_UTL IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_UTL
     PURPOSE:    Ejecutar procesos generales para conexion Janus
  
     REVISIONS:
     Ver        Date        Author            Solicitado por      Description
     ---------  ----------  ---------------   --------------      ----------------------
     1.0        20/02/2014  Eustaquio Gibaja  Christian Riquelme  Ejecutar procesos generales para conexion Janus
     2.0        08/07/2014  Juan Gonzales     Christian Riquelme  agregar validacion de envio de sucursal
  ***************************************************************************************************/
  PROCEDURE crear_int_plataforma_bscs_baja IS
    C_BAJA CONSTANT PLS_INTEGER := 2;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
    l_linea    linea;
  
  BEGIN
    g_linea := get_linea_baja();
    l_linea := g_linea;
  
    l_int_bscs.co_id     := operacion.pq_janus.get_conf('P_HCTR') ||
                            l_linea.codinssrv;
    l_int_bscs.numero    := l_linea.numero;
    l_int_bscs.imsi      := operacion.pq_janus.get_conf('P_IMSI') ||
                            l_linea.numero;
    l_int_bscs.action_id := C_BAJA;
    l_int_bscs.trama     := armar_trama_baja;
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_BAJA);
    operacion.pq_janus.g_action_id := C_BAJA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_PLATAFORMA_BSCS_BAJA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_plataforma_bscs_alta IS
    C_ALTA CONSTANT operacion.int_plataforma_bscs.action_id%TYPE := 1;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
    l_linea    linea;
    l_cliente  cliente;
    l_sucursal sucursal%ROWTYPE;
    l_plan     plan%ROWTYPE;
  
  BEGIN
    g_linea    := get_linea_alta();
    l_linea    := g_linea;
    l_cliente  := get_cliente;
    l_sucursal := get_sucursal;
    l_plan     := get_plan;
  
    l_int_bscs.codigo_cliente := operacion.pq_janus.get_conf('P_HCON') ||
                                 l_linea.codcli;
    l_int_bscs.codigo_cuenta  := operacion.pq_janus.get_conf('P_HCCD') ||
                                 l_linea.codcli;
    l_int_bscs.ruc            := l_cliente.ruc;
    l_int_bscs.nombre         := l_cliente.nomclires;
    l_int_bscs.apellidos      := l_cliente.apellidos;
    l_int_bscs.tipdide        := l_cliente.tipdide;
    l_int_bscs.ntdide         := l_cliente.ntdide;
    l_int_bscs.razon          := l_cliente.razon;
    l_int_bscs.telefonor1     := l_cliente.telefono1;
    l_int_bscs.telefonor2     := l_cliente.telefono2;
    l_int_bscs.email          := get_nomemail;
    l_int_bscs.direccion      := l_sucursal.dirsuc;
    l_int_bscs.referencia     := l_sucursal.referencia;
    l_int_bscs.distrito       := l_sucursal.nomdst;
    l_int_bscs.provincia      := l_sucursal.nompvc;
    l_int_bscs.departamento   := l_sucursal.nomest;
    l_int_bscs.co_id          := operacion.pq_janus.get_conf('P_HCTR') ||
                                 l_linea.codinssrv;
    l_int_bscs.numero         := l_linea.numero;
    l_int_bscs.imsi           := operacion.pq_janus.get_conf('P_IMSI') ||
                                 l_linea.numero;
    l_int_bscs.ciclo          := pq_janus_alta.get_fecini(l_linea.numslc);
    l_int_bscs.action_id      := C_ALTA;
    l_int_bscs.trama          := armar_trama_alta();
    l_int_bscs.plan_base      := l_plan.plan;
    l_int_bscs.plan_opcional  := l_plan.plan_opcional;
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_ALTA);
    operacion.pq_janus.g_action_id := C_ALTA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_PLATAFORMA_BSCS_ALTA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs_cp IS
    C_CAMBIO_PLAN CONSTANT PLS_INTEGER := 16;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    g_linea_old := get_linea_tx();
  
    l_int_bscs.co_id             := g_linea_old.codinssrv;
    l_int_bscs.numero            := g_linea_old.numero;
    l_int_bscs.numero_old        := g_linea_old.numero_old;
    l_int_bscs.action_id         := C_CAMBIO_PLAN;
    l_int_bscs.trama             := g_linea_old.trama;
    l_int_bscs.plan_base         := g_linea_old.plan_base;
    l_int_bscs.plan_opcional     := g_linea_old.plan_opcional;
    l_int_bscs.plan_old          := g_linea_old.plan_old;
    l_int_bscs.plan_opcional_old := g_linea_old.plan_opcional_old;
    l_int_bscs.imsi              := operacion.pq_janus.get_conf('P_IMSI') ||
                                    g_linea_old.numero;
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_CAMBIO_PLAN);
    operacion.pq_janus.g_action_id := C_CAMBIO_PLAN;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS_CP: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_plataforma_bscs_rech IS
    C_BAJA CONSTANT PLS_INTEGER := 2;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
    l_linea    linea;
  
  BEGIN
    g_linea := get_linea_x_rechazo();
    l_linea := g_linea;
  
    l_int_bscs.co_id     := operacion.pq_janus.get_conf('P_HCTR') ||
                            l_linea.codinssrv;
    l_int_bscs.numero    := l_linea.numero;
    l_int_bscs.imsi      := operacion.pq_janus.get_conf('P_IMSI') ||
                            l_linea.numero;
    l_int_bscs.action_id := C_BAJA;
    l_int_bscs.trama     := armar_trama_baja;
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_BAJA);
    operacion.pq_janus.g_action_id := C_BAJA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_PLATAFORMA_BSCS_RECH: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_plat_bscs_cp_rech IS
    C_CAMBIO_PLAN CONSTANT PLS_INTEGER := 16;
    l_int_bscs operacion.int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    g_linea     := get_linea_cp();
    g_linea_old := get_linea_old();
  
    l_int_bscs.co_id             := operacion.pq_janus.get_conf('P_HCTR') ||
                                    g_linea_old.codinssrv;
    l_int_bscs.numero            := g_linea_old.numero;
    l_int_bscs.numero_old        := g_linea.numero;
    l_int_bscs.action_id         := C_CAMBIO_PLAN;
    l_int_bscs.trama             := armar_trama_cp();
    l_int_bscs.plan_base         := g_linea_old.plan_base;
    l_int_bscs.plan_opcional     := g_linea_old.plan_opcional;
    l_int_bscs.plan_old          := g_linea.plan;
    l_int_bscs.plan_opcional_old := g_linea.plan_opcional;
    operacion.pq_janus.insert_int_plataforma_bscs(l_int_bscs);
  
    operacion.pq_janus.g_trama     := l_int_bscs.trama;
    operacion.pq_janus.g_idtrans   := l_int_bscs.idtrans;
    operacion.pq_janus.g_tx_bscs   := operacion.pq_janus.set_tx_bscs(C_CAMBIO_PLAN);
    operacion.pq_janus.g_action_id := C_CAMBIO_PLAN;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLAT_BSCS_CP_RECH: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_baja RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT a.codsolot,
           f.codinssrv,
           f.pid,
           NULL,
           b.idplan,
           b.codsrv,
           ins.codcli,
           ins.numslc,
           ins.numero,
           NULL,
           NULL
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
     WHERE a.idwf = g_idwf
       AND a.codsolot = e.codsolot
       AND f.codinssrv = e.codinssrv
       AND f.pid = e.pid
       AND f.codsrv = b.codsrv
       AND b.idplan = d.idplan
       AND d.idtipo IN (2, 3)
       AND e.codinssrv = ins.codinssrv;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_BAJA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_alta RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT g.codsolot,
           e.codinssrv,
           b.pid,
           a.pid_old,
           h.idplan,
           b.codsrv,
           e.codcli,
           e.numslc,
           e.numero,
           h.plan,
           h.plan_opcional
      INTO l_linea
      FROM wf          d,
           solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           plan_redint h
     WHERE d.idwf = g_idwf
       AND a.codsolot = d.codsolot
       AND a.pid = b.pid
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_ALTA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_x_rechazo RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT a.codsolot,
           f.codinssrv,
           f.pid,
           NULL,
           b.idplan,
           b.codsrv,
           ins.codcli,
           ins.numslc,
           ins.numero,
           NULL,
           NULL
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
             GROUP BY a.codsolot, b.codinssrv) e,
           insprd f,
           inssrv ins
     WHERE a.idwf = g_idwf
       AND a.codsolot = e.codsolot
       AND f.codinssrv = e.codinssrv
       AND f.pid = e.pid
       AND f.codsrv = b.codsrv
       AND b.idplan = d.idplan
       AND d.idtipo IN (2, 3)
       AND e.codinssrv = ins.codinssrv;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_X_RECHAZO: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_cp RETURN linea IS
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
     WHERE w.idwf = operacion.pq_int_telefonia.g_idwf
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
                              $$PLSQL_UNIT || '.GET_LINEA_CP: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_old RETURN linea_old IS
    l_linea_old linea_old;
  BEGIN
    l_linea_old := get_tx_bscs();
  
    RETURN l_linea_old;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_OLD: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_tx_bscs RETURN linea_old IS
    l_linea_old linea_old;
  
  BEGIN
    SELECT a.plan_base,
           a.plan_opcional,
           a.plan_old,
           a.plan_opcional_old,
           a.numero,
           a.numero_old,
           a.imsi,
           b.codinssrv,
           a.trama
      INTO l_linea_old
      FROM operacion.int_plataforma_bscs a, operacion.int_telefonia_log b
     WHERE a.idtrans = b.idtrans
       AND b.pid IN (SELECT a.pid_old
                       FROM solotpto a
                      WHERE a.pid = g_linea.pid
                        AND a.codinssrv = g_linea.codinssrv);
  
    RETURN l_linea_old;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TX_BSCS: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea_tx RETURN linea_old IS
    l_idtrans   operacion.int_plataforma_bscs.idtrans%TYPE;
    l_linea_old linea_old;
  
  BEGIN
    l_idtrans := get_idtrans_cp();
  
    SELECT b.plan_base,
           b.plan_opcional,
           b.plan_old,
           b.plan_opcional_old,
           b.numero,
           b.numero_old,
           b.imsi,
           b.co_id,
           b.trama
      INTO l_linea_old
      FROM operacion.int_plataforma_bscs b
     WHERE b.co_id = g_linea.codinssrv
       AND b.idtrans = l_idtrans;
  
    RETURN l_linea_old;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA_TX: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_idtrans_cp RETURN operacion.int_plataforma_bscs.idtrans%TYPE IS
    l_idtrans operacion.int_plataforma_bscs.idtrans%TYPE;
  
  BEGIN
    g_linea := get_linea_cp;
  
    SELECT MAX(b.idtrans)
      INTO l_idtrans
      FROM operacion.int_telefonia_log b
     WHERE b.numero = g_linea.numero
       AND b.pid = g_linea.pid
       AND b.tx_bscs = 'CAMBIO_PLAN';
  
    RETURN l_idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDTRANS_CP: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia(p_id_telefonia operacion.int_telefonia.id%TYPE) IS
    l_tel operacion.int_telefonia%ROWTYPE;
  
  BEGIN
    SELECT t.*
      INTO l_tel
      FROM operacion.int_telefonia t
     WHERE t.id = p_id_telefonia;
    l_tel.error_id := 0;
  
    UPDATE operacion.int_telefonia t SET ROW = l_tel WHERE t.id = l_tel.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia_log(p_idlog operacion.int_telefonia_log.id%TYPE) IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.int_telefonia_log t
     WHERE t.id = p_idlog;
    l_log.sga_error_id  := 0;
    l_log.sga_error_dsc := 'OK';
  
    UPDATE operacion.int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION es_janus(p_idwf tareawfcpy.idwf%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM tystabsrv t, solotpto s, wf w
     WHERE w.idwf = p_idwf
       AND w.codsolot = s.codsolot
       AND s.codsrvnue = t.codsrv
       AND t.idproducto IN (SELECT pp.idproducto
                              FROM plan_redint p, planxproducto pp
                             WHERE p.idplan = pp.idplan
                               AND p.idplan = t.idplan
                               AND p.idplataforma = 6) --janus
       AND t.flag_lc = 1;
  
    IF l_count > 0 THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ES_JANUS: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION es_janus_py_origen RETURN BOOLEAN IS
    l_idwf_py_origen tareawfcpy.idwf%TYPE;
  BEGIN
  
    l_idwf_py_origen := pq_janus_rechazo.get_idwf_origen();
    IF es_janus(l_idwf_py_origen) THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ES_JANUS_PY_ORIGEN: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION armar_trama_baja RETURN VARCHAR2 IS
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
                              $$PLSQL_UNIT || '.ARMAR_TRAMA_BAJA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION armar_trama_cp RETURN VARCHAR2 IS
    l_trama VARCHAR2(32767);
  
  BEGIN
    l_trama := g_linea_old.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_HCTR') ||
               g_linea_old.codinssrv || '|';
    l_trama := l_trama || g_linea_old.plan_base || '|';
    l_trama := l_trama || g_linea_old.plan_opcional || '|';
    l_trama := l_trama || g_linea.plan || '|';
    l_trama := l_trama || g_linea.plan_opcional;
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA_CP: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION armar_trama_alta RETURN VARCHAR2 IS
    l_linea    linea;
    l_cliente  cliente;
    l_trama    VARCHAR2(32767);
    l_sucursal sucursal%ROWTYPE;
    l_plan     plan%ROWTYPE;
  
  BEGIN
    l_linea    := g_linea;
    l_cliente  := get_cliente;
    l_sucursal := get_sucursal;
    l_plan     := get_plan;
  
    l_trama := operacion.pq_janus.get_conf('P_HCON') || l_linea.codcli || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_HCCD') ||
               l_linea.codcli || '|';
    l_trama := l_trama || l_cliente.ruc || '|';
    l_trama := l_trama || l_cliente.nomclires || '|';
    l_trama := l_trama || l_cliente.apellidos || '|';
    l_trama := l_trama || l_cliente.tipdide || '|';
    l_trama := l_trama || l_cliente.ntdide || '|';
    l_trama := l_trama || l_cliente.razon || '|';
    l_trama := l_trama || l_cliente.telefono1 || '|';
    l_trama := l_trama || l_cliente.telefono2 || '|';
    l_trama := l_trama || get_nomemail || '|';
    l_trama := l_trama || operacion.pq_janus_alta.trim_dato('DIRSUC', l_sucursal.dirsuc) || '|'; --2.0
    l_trama := l_trama || operacion.pq_janus_alta.trim_dato('REFERENCIA', l_sucursal.referencia) || '|'; --2.0
    l_trama := l_trama || l_sucursal.nomdst || '|';
    l_trama := l_trama || l_sucursal.nompvc || '|';
    l_trama := l_trama || l_sucursal.nomest || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_HCTR') ||
               l_linea.codinssrv || '|';
    l_trama := l_trama || l_linea.numero || '|';
    l_trama := l_trama || operacion.pq_janus.get_conf('P_IMSI') ||
               l_linea.numero || '|';
    l_trama := l_trama || pq_janus_alta.get_fecini(l_linea.numslc) || '|';
    l_trama := l_trama || l_plan.plan || '|';
    l_trama := l_trama || l_plan.plan_opcional;
  
    operacion.pq_janus_alta.encode(l_trama); --2.0
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA_ALTA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_codsrv_origen RETURN tystabsrv.codsrv%TYPE IS
    l_codsrv tystabsrv.codsrv%TYPE;
    l_linea  linea;
  
  BEGIN
    l_linea := get_linea_cp();
    SELECT a.codsrv
      INTO l_codsrv
      FROM insprd a, tystabsrv b, plan_redint c
     WHERE a.pid = l_linea.pid_old
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
    l_linea  linea;
  
  BEGIN
    l_linea := get_linea_cp();
    SELECT a.codsrv
      INTO l_codsrv
      FROM insprd a, tystabsrv b, plan_redint c
     WHERE a.pid = l_linea.pid
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
  /* **********************************************************************************************/
  FUNCTION get_codsolot RETURN solot.codsolot%TYPE IS
    l_codsolot solot.codsolot%TYPE;
  
  BEGIN
    SELECT t.codsolot INTO l_codsolot FROM wf t WHERE t.idwf = g_idwf;
    RETURN l_codsolot;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CODSOLOT: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_nomemail RETURN vtaafilrecemail.nomemail%TYPE IS
    l_nomemail vtaafilrecemail.nomemail%TYPE;
  
  BEGIN
    SELECT z.nomemail
      INTO l_nomemail
      FROM (SELECT v.nomemail
              FROM marketing.vtaafilrecemail v
             WHERE v.codcli = g_linea.codcli
             ORDER BY v.fecusu DESC) z
     WHERE ROWNUM = 1;
  
    RETURN l_nomemail;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_NOMEMAIL: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_cliente RETURN cliente IS
    l_cliente cliente;
  
  BEGIN
    SELECT vc.tipdide,
           vc.ntdide,
           REPLACE(vc.apepatcli, '|', ' ') || ' ' ||
           REPLACE(vc.apematcli, '|', ' ') apellidos,
           REPLACE(vc.nomclires, '|', ' '),
           DECODE(vc.tipdide, '001', vc.ntdide, NULL) AS ruc,
           REPLACE(vc.nomcli, '|', ' ') AS razon,
           vc.telefono1,
           vc.telefono2
      INTO l_cliente
      FROM vtatabcli vc
     WHERE vc.codcli = g_linea.codcli;
  
    RETURN l_cliente;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CLIENTE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_sucursal RETURN sucursal%ROWTYPE IS
    l_sucursal sucursal%ROWTYPE;
  
  BEGIN
    SELECT REPLACE(vsuc.dirsuc, '|', ' ') dirsuc,
           REPLACE(vsuc.referencia, '|', ' ') referencia,
           vu.nomdst,
           vu.nompvc,
           vu.nomest
      INTO l_sucursal
      FROM vtasuccli vsuc,
           (SELECT DISTINCT codsuc
              FROM vtadetptoenl vdet
             WHERE vdet.numslc = g_linea.numslc) vv,
           v_ubicaciones vu
     WHERE vsuc.codsuc = vv.codsuc
       AND vsuc.ubisuc = vu.codubi(+);
  
    RETURN l_sucursal;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_SUCURSAL: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_plan RETURN plan%ROWTYPE IS
    l_plan plan%ROWTYPE;
  
  BEGIN
    SELECT t.plan, t.plan_opcional
      INTO l_plan
      FROM plan_redint t
     WHERE t.idplan = g_linea.idplan;
  
    RETURN l_plan;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_PLAN: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_codinssrv RETURN inssrv.codinssrv%TYPE IS
  BEGIN
    RETURN g_linea.codinssrv;
  END;
  /* **********************************************************************************************/
  FUNCTION get_pid RETURN insprd.pid%TYPE IS
  BEGIN
    RETURN g_linea.pid;
  END;
  /* **********************************************************************************************/
  FUNCTION get_pid_old RETURN insprd.pid%TYPE IS
  BEGIN
    RETURN g_linea.pid_old;
  END;
  /* **********************************************************************************************/
  FUNCTION get_numero RETURN numtel.numero%TYPE IS
  BEGIN
    RETURN g_linea.numero;
  END;
  /* **********************************************************************************************/
  FUNCTION get_wfdef(p_idwf tareawfcpy.idwf%TYPE) RETURN wfdef.wfdef%TYPE IS
    l_wfdef wfdef.wfdef%TYPE;
  BEGIN
    SELECT a.wfdef
      INTO l_wfdef
      FROM wf a, solot b
     WHERE a.codsolot = b.codsolot
       AND a.idwf = p_idwf;
  
    RETURN l_wfdef;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_WFDEF: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
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
                           AND a.idwf = g_idwf);
  
    RETURN p_idwf_origen;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDWF_ORIGEN: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE IS
    l_id_int_telefonia operacion.int_telefonia.id%TYPE;
  
  BEGIN
    SELECT MAX(a.id)
      INTO l_id_int_telefonia
      FROM operacion.int_telefonia a
     WHERE a.idwf = g_idwf;
  
    RETURN l_id_int_telefonia;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_ID_TELEFONIA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_tarea_janus(p_idwf tareawf.idwf%TYPE) RETURN tareawfdef.tarea%TYPE IS
    l_tarea_janus tareawfdef.tarea%TYPE;
    l_wfdef       wf.wfdef%TYPE;
  
  BEGIN
    l_wfdef := get_wfdef(p_idwf);
  
    SELECT b.codigon_aux
      INTO l_tarea_janus
      FROM operacion.tipopedd a, operacion.opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'JANUS_SOT_RECHAZO'
       AND b.codigon = l_wfdef;
  
    RETURN l_tarea_janus;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TAREA_JANUS: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_idtareawf RETURN tareawfcpy.idtareawf%TYPE IS
    l_idtareawf tareawfcpy.idtareawf%TYPE;
    l_tareadef  tareawfcpy.tareadef%TYPE;
  
  BEGIN
    l_tareadef := get_tarea_janus(g_idwf);
  
    SELECT idtareawf
      INTO l_idtareawf
      FROM tareawfcpy
     WHERE idwf = g_idwf
       AND tareadef = l_tareadef;
  
    RETURN l_idtareawf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDTAREAWF: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := get_id_telefonia();
    l_log.plataforma       := pq_int_telefonia.get_plataforma();
    l_log.codinssrv        := pq_janus_utl.get_codinssrv;
    l_log.numero           := pq_janus_utl.get_numero;
    l_log.pid              := pq_janus_utl.get_pid;
    l_log.idtrans          := pq_janus.g_idtrans;
    l_log.tx_bscs          := pq_janus.g_tx_bscs;
    l_log.verificado       := 0;
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_telefonia_log_cp IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := get_id_telefonia();
    l_log.plataforma       := pq_int_telefonia.get_plataforma();
    l_log.codinssrv        := pq_janus_utl.get_codinssrv;
    l_log.numero           := pq_janus_utl.get_numero;
    l_log.pid              := pq_janus_utl.get_pid_old;
    l_log.idtrans          := pq_janus.g_idtrans;
    l_log.tx_bscs          := pq_janus.g_tx_bscs;
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG_CP: ' ||
                              SQLERRM);
    
  END;
  /* **********************************************************************************************/
  FUNCTION caso_sot_rechazo(p_idwf tareawfcpy.idwf%TYPE)
    RETURN operacion.opedd.abreviacion%TYPE IS
    l_abrev_cab    operacion.tipopedd.abrev%TYPE := 'JANUS_SOT_RECHAZO';
    l_tipo_proceso operacion.opedd.abreviacion%TYPE;
    l_wfdef        wfdef.wfdef%TYPE;
  
  BEGIN
    l_wfdef := get_wfdef(p_idwf);
  
    SELECT DISTINCT (b.abreviacion)
      INTO l_tipo_proceso
      FROM operacion.tipopedd a, operacion.opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = l_abrev_cab
       AND b.codigon = l_wfdef;
  
    RETURN l_tipo_proceso;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CASO_SOT_RECHAZO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_tx_janus_pendiente(p_codsolot solot.codsolot%TYPE) RETURN NUMBER IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.int_telefonia a, operacion.int_telefonia_log b
     WHERE a.id = b.int_telefonia_id
       AND (a.plataforma_destino = 'JANUS' OR a.plataforma_origen = 'JANUS')
       AND b.tx_bscs IS NOT NULL
       AND a.codsolot = p_codsolot
       AND (b.verificado = 0 OR b.verificado IS NULL);
  
    IF l_count > 0 THEN
      RETURN 1; -- se realizo solicitud BSCS y aun no se efectua en JANUS
    ELSE
      RETURN 0; -- Plat. JANUS no interviene O tx JANUS ejecutadas O aun no se ejecuta tarea linea control
    END IF;
  END;
  /* **********************************************************************************************/
  FUNCTION es_tx_janus_ejecutada(p_codsolot solot.codsolot%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.int_telefonia a
     WHERE a.codsolot = p_codsolot
       AND (a.plataforma_destino = 'JANUS' OR a.plataforma_origen = 'JANUS');
  
    IF l_count > 0 THEN
      IF get_tx_janus_pendiente(p_codsolot) = 1 THEN
        RETURN FALSE; --Plat. JANUS interviene y aun no se efectua la tx
      ELSE
        RETURN TRUE; --Plat. JANUS interviene y se efectuo tx
      END IF;
    ELSE
      RETURN FALSE; --Plat. JANUS no interviene O  aun no se ejecuta tarea linea control
    END IF;
  END;
  /* **********************************************************************************************/
  FUNCTION exist_janus_rechazo(p_idwf wf.idwf%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM operacion.int_telefonia b, operacion.int_telefonia_log c
     WHERE b.id = c.Int_Telefonia_Id
       AND (b.plataforma_destino = 'JANUS' OR b.plataforma_origen = 'JANUS')
       AND c.id IN (SELECT MAX(x.id)
                      FROM operacion.int_telefonia_log x
                     WHERE x.int_telefonia_id = b.id)
       AND c.chg_estado_sot = 7
       AND b.idwf = p_idwf;
  
    IF l_count > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
  /* **********************************************************************************************/
  FUNCTION existe_tx_janus(p_idwf tareawfcpy.idwf%TYPE) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM wf w, operacion.int_telefonia s, operacion.int_telefonia_log t
     WHERE w.idwf = p_idwf
       AND w.codsolot = s.codsolot
       AND s.id = t.int_telefonia_id
       AND t.plataforma = 'JANUS';
  
    IF l_count > 0 THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  
  END;
  /* **********************************************************************************************/
  FUNCTION get_tarea_janus(p_idwf wf.idwf%TYPE) RETURN tareadef.tareadef%TYPE IS
    l_tarea tareadef.tareadef%TYPE;
  
  BEGIN
    SELECT b.codigon_aux
      INTO l_tarea
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'JANUS_SOT_RECHAZO'
       AND b.codigon = p_idwf;
  
    RETURN l_tarea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TAREA_JANUS: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_idtareawf_valida_tx_janus(p_idwf tareawf.idwf%TYPE)
    RETURN tareawfcpy.idtareawf%TYPE IS
    l_idtareawf tareawfcpy.idtareawf%TYPE;
    l_tareadef  tareawfcpy.tareadef%TYPE;
  
  BEGIN
    l_tareadef := get_tarea_valida_tx_janus;
  
    SELECT a.idtareawf
      INTO l_idtareawf
      FROM tareawfcpy a
     WHERE a.tareadef = l_tareadef
       AND a.idwf = p_idwf;
  
    RETURN l_idtareawf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.GET_IDTAREAWF_VALIDA_TX_JANUS: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_tarea_valida_tx_janus RETURN tareawfcpy.tarea%TYPE IS
    l_tarea tareawfcpy.tareadef%TYPE;
  
  BEGIN
    SELECT b.codigon
      INTO l_tarea
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'JANUS_VERIFICA_TX'
       AND b.abreviacion = 'JANUS_VERIFICA_TX';
  
    RETURN l_tarea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TAREA_VALIDA_TX_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE cerrar_tarea_valida_janus(p_idtareawf tareawf.idtareawf%TYPE,
                                      p_idwf      tareawf.idwf%TYPE,
                                      p_tarea     tareawf.tarea%TYPE,
                                      p_tareadef  tareawf.tareadef%TYPE) IS
    l_idtareawf tareawfcpy.idtareawf%TYPE;
  
  BEGIN
  
      IF NOT existe_tx_janus(p_idwf) THEN
      l_idtareawf := get_idtareawf_valida_tx_janus(p_idwf);
      opewf.pq_wf.p_chg_status_tareawf(l_idtareawf,
                                       4, --Cerrada
                                       8, --No interviene
                                       0,
                                       SYSDATE,
                                       SYSDATE);
    END IF;
  
    DBMS_OUTPUT.PUT_LINE(p_idtareawf);
    DBMS_OUTPUT.PUT_LINE(p_tarea);
    DBMS_OUTPUT.PUT_LINE(p_tareadef);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CERRAR_TAREA_VALIDA_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_globals(p_idwf tareawf.idwf%TYPE) IS
  BEGIN
    g_idwf := p_idwf;
  END;
  /* **********************************************************************************************/
END;
/
