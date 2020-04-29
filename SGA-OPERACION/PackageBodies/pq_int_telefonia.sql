CREATE OR REPLACE PACKAGE BODY OPERACION.pq_int_telefonia IS
  /******************************************************************************
   PROPOSITO: Centralizar los procesos de tipo interfaz con las plataformas
              telefonicas
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
     2.0      24/07/2014  Eustaquio Gibaja  Christian Riquelme  Cambio de estado tarea No interviene
  /* ***************************************************************************/
  g_int_telefonia_id int_telefonia.id%TYPE;
  g_tipestsol        tipestsol.tipestsol%TYPE;
  /* ***************************************************************************/
  PROCEDURE alta(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE) IS
  BEGIN
    set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);
  
    IF NOT es_telefonia() THEN
      no_interviene();
      RETURN;
    END IF;
  
    IF NOT es_masivo_hfc() THEN
      --ini 2.0
      /*RAISE_APPLICATION_ERROR(-20000,
             $$PLSQL_UNIT || '.ALTA: NO ES MASIVO HFC');*/
      no_interviene();
      RETURN;
      --fin 2.0
    
    END IF;
  
    IF esta_registrado('ALTA') THEN
      RETURN;
    END IF;
  
    crear_int_telefonia();
  
    g_operacion := 'ALTA';
    g_origen    := get_plataforma();
    g_destino   := g_origen;
  
    IF g_origen = 'JANUS' THEN
      pq_janus_alta.alta();
    ELSIF g_origen = 'TELLIN' THEN
      pq_tellin_alta.alta();
    ELSIF g_origen = 'ABIERTA' THEN
      pq_abierta.alta();
    END IF;
  
    update_int_telefonia();
  
  EXCEPTION
    WHEN OTHERS THEN
      pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE baja(p_idtareawf tareawf.idtareawf%TYPE,
                 p_idwf      tareawf.idwf%TYPE,
                 p_tarea     tareawf.tarea%TYPE,
                 p_tareadef  tareawf.tareadef%TYPE) IS
  BEGIN
    set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);
  
    IF NOT es_telefonia() THEN
      no_interviene();
      RETURN;
    END IF;
  
    IF NOT es_masivo_hfc() THEN
      --ini 2.0
      /*RAISE_APPLICATION_ERROR(-20000,
               $$PLSQL_UNIT || '.BAJA: NO ES MASIVO HFC');*/
      no_interviene();
      RETURN;
      --fin 2.0
    END IF;
  
    IF esta_registrado('BAJA') THEN
      RETURN;
    END IF;
  
    crear_int_telefonia();
  
    g_operacion := 'BAJA';
    g_origen    := get_plataforma();
    g_destino   := g_origen;
  
    IF g_origen = 'JANUS' THEN
      pq_janus_baja.baja();
    ELSIF g_origen = 'TELLIN' THEN
      pq_tellin_baja.baja();
    ELSIF g_origen = 'ABIERTA' THEN
      pq_abierta.baja();
    END IF;
  
    update_int_telefonia();
  
  EXCEPTION
    WHEN OTHERS THEN
      pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE cambio_plan(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE) IS
  
  BEGIN
    set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);
  
    IF NOT es_masivo_hfc() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: NO ES MASIVO HFC');
    END IF;
  
    IF esta_registrado('CAMBIO_PLAN') THEN
      RETURN;
    END IF;
  
    crear_int_telefonia();
  
    g_operacion := 'CAMBIO_PLAN';
    g_origen    := get_plataforma_origen();
    g_destino   := get_plataforma_destino();
  
    IF g_origen = g_destino THEN
      cambio_plan_plataforma(g_origen);
    ELSIF g_origen <> g_destino THEN
      alta_plataforma_destino(g_destino);
      baja_plataforma_origen(g_origen);
    END IF;
  
    update_int_telefonia();
  
  EXCEPTION
    WHEN OTHERS THEN
      pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION esta_registrado(p_operacion VARCHAR2) RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    g_tipestsol := get_tipestsol();
  
    SELECT COUNT(*)
      INTO l_count
      FROM int_telefonia t
     WHERE t.idtareawf = g_idtareawf
       AND t.operacion = p_operacion
       AND t.tipestsol = g_tipestsol;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE set_globals(p_idtareawf tareawf.idtareawf%TYPE,
                        p_idwf      tareawf.idwf%TYPE,
                        p_tarea     tareawf.tarea%TYPE,
                        p_tareadef  tareawf.tareadef%TYPE) IS
  BEGIN
    g_idtareawf := p_idtareawf;
    g_idwf      := p_idwf;
    g_tarea     := p_tarea;
    g_tareadef  := p_tareadef;
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia IS
    l_tel int_telefonia%ROWTYPE;
  
  BEGIN
    l_tel.idtareawf := g_idtareawf;
    l_tel.idwf      := g_idwf;
    l_tel.tarea     := g_tarea;
    l_tel.tareadef  := g_tareadef;
    insert_int_telefonia(l_tel);
  
    g_int_telefonia_id := l_tel.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_telefonia IS
    l_tel int_telefonia%ROWTYPE;
  
  BEGIN
    SELECT t.* INTO l_tel FROM int_telefonia t WHERE t.id = g_int_telefonia_id;
  
    l_tel.operacion          := g_operacion;
    l_tel.plataforma_origen  := g_origen;
    l_tel.plataforma_destino := g_destino;
    l_tel.codsolot           := get_codsolot();
    l_tel.error_id           := 0;
    l_tel.mensaje            := 'OK';
    l_tel.tipestsol          := g_tipestsol;
  
    UPDATE int_telefonia t SET ROW = l_tel WHERE t.id = l_tel.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
  /* ***************************************************************************/
  FUNCTION get_tipestsol RETURN tipestsol.tipestsol%TYPE IS
    l_tipestsol tipestsol.tipestsol%TYPE;
  
  BEGIN
    SELECT t.tipestsol
      INTO l_tipestsol
      FROM wf w, solot s, estsol e, tipestsol t
     WHERE w.idwf = g_idwf
       AND w.codsolot = s.codsolot
       AND s.estsol = e.estsol
       AND e.tipestsol = t.tipestsol;
  
    RETURN l_tipestsol;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TIPESTSOL: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_telefonia_log IS
    l_log int_telefonia_log%ROWTYPE;
  
  BEGIN
    SELECT t.*
      INTO l_log
      FROM int_telefonia_log t
     WHERE t.id = pq_int_telefonia_log.g_id;
    l_log.sga_error_id  := 0;
    l_log.sga_error_dsc := 'OK';
    l_log.verificado    := 0;
  
    UPDATE int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE cambio_plan_plataforma(p_plataforma VARCHAR2) IS
  BEGIN
    IF p_plataforma = 'JANUS' THEN
      pq_janus_cambio_plan.cambio_plan();
    ELSIF p_plataforma = 'TELLIN' THEN
      pq_tellin_cambio_plan.cambio_plan();
    ELSIF p_plataforma = 'ABIERTA' THEN
      pq_abierta.cambio_plan();
    ELSIF p_plataforma = 'NINGUNO' THEN
      no_interviene();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN_PLATAFORMA: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
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
  /* ***************************************************************************/
  FUNCTION get_plataforma_origen RETURN VARCHAR2 IS
    l_idwf_act tareawf.idwf%TYPE;
    l_origen   VARCHAR2(30);
  
  BEGIN
    --almacena temporalmente el idwf actual
    l_idwf_act := g_idwf;
    --sobreescribe el idwf actual por el idwf origen
    g_idwf := get_idwf_origen();
    --obtiene la plataforma del proyecto origen a partir del idwf origen
    l_origen := get_plataforma();
    --reestablece el idwf actual
    g_idwf := l_idwf_act;
  
    RETURN l_origen;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_PLATAFORMA_ORIGEN: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_plataforma_destino RETURN VARCHAR2 IS
  BEGIN
    RETURN get_plataforma();
  END;
  /* ***************************************************************************/
  FUNCTION get_idwf_origen RETURN wf.idwf%TYPE IS
    l_idwf wf.idwf%TYPE;
  
  BEGIN
    SELECT tt.idwf
      INTO l_idwf
      FROM wf t, solot s, regvtamentab r, solot ss, wf tt
     WHERE t.idwf = g_idwf
       AND t.codsolot = s.codsolot
       AND s.numslc = r.numslc
       AND r.numslc_ori = ss.numslc
       AND ss.codsolot = tt.codsolot;
  
    RETURN l_idwf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDWF_ORIGEN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_plataforma RETURN VARCHAR2 IS
  BEGIN
    IF es_janus() THEN
      RETURN 'JANUS';
    ELSIF es_tellin() THEN
      RETURN 'TELLIN';
    ELSIF es_abierta() THEN
      RETURN 'ABIERTA';
    ELSE
      RETURN 'NINGUNO';
    END IF;
  END;
  /* ***************************************************************************/
  FUNCTION es_masivo_hfc RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM wf a, solot b
     WHERE a.idwf = g_idwf
       AND a.codsolot = b.codsolot
       AND a.valido = 1
       AND b.tipsrv = '0061'; --"Paquetes Masivos"
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  FUNCTION existe_reserva RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM inssrv a, solotpto b, tystabsrv c, plan_redint d, wf e, numtel f
     WHERE e.idwf = g_idwf
       AND b.codsolot = e.codsolot
       AND a.codinssrv = b.codinssrv
       AND b.codsrvnue = c.codsrv
       AND c.idplan = d.idplan
       AND d.idtipo IN (2, 3) --control, prepago
       AND a.codinssrv = f.codinssrv;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE alta_plataforma_destino(p_plataforma VARCHAR2) IS
  BEGIN
    IF p_plataforma = 'JANUS' THEN
      pq_janus_alta.alta();
    ELSIF p_plataforma = 'TELLIN' THEN
      pq_tellin_alta.alta();
    ELSIF p_plataforma = 'ABIERTA' THEN
      pq_abierta.alta();
    END IF;
  END;
  /* ***************************************************************************/
  PROCEDURE baja_plataforma_origen(p_plataforma VARCHAR2) IS
  BEGIN
    IF p_plataforma = 'JANUS' THEN
      pq_janus_baja.baja();
    ELSIF p_plataforma = 'TELLIN' THEN
      pq_tellin_baja.baja();
    ELSIF p_plataforma = 'ABIERTA' THEN
      pq_abierta.baja();
    END IF;
  END;
  /* ***************************************************************************/
  FUNCTION es_janus RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM tystabsrv t, solotpto s, wf w
     WHERE w.idwf = g_idwf
       AND w.codsolot = s.codsolot
       AND s.codsrvnue = t.codsrv
       AND t.idproducto IN (SELECT pp.idproducto
                              FROM plan_redint p, planxproducto pp
                             WHERE p.idplan = pp.idplan
                               AND p.idplan = t.idplan
                               AND p.idplataforma = 6) --janus
       AND t.flag_lc = 1;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  FUNCTION es_tellin RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM tystabsrv t, solotpto s, wf w
     WHERE w.idwf = g_idwf
       AND w.codsolot = s.codsolot
       AND s.codsrvnue = t.codsrv
       AND t.idproducto IN (SELECT pp.idproducto
                              FROM plan_redint p, planxproducto pp
                             WHERE p.idplan = pp.idplan
                               AND p.idplan = t.idplan
                               AND p.idplataforma = 3) --tellin
       AND t.flag_lc = 1;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  FUNCTION es_abierta RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM wf t, solotpto s, tystabsrv ty
     WHERE t.idwf = g_idwf
       AND t.codsolot = s.codsolot
       AND s.codsrvnue = ty.codsrv
       AND ty.tipsrv = '0004'
       AND (ty.flag_lc IS NULL OR ty.flag_lc = 0);
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE insert_tareawfseg(p_tareawfseg IN OUT NOCOPY tareawfseg%ROWTYPE) IS
  BEGIN
    p_tareawfseg.fecusu := SYSDATE;
    p_tareawfseg.codusu := USER;
    p_tareawfseg.flag   := 0;
  
    INSERT INTO tareawfseg VALUES p_tareawfseg;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_TAREAWFSEG: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE insert_int_telefonia(p_telef IN OUT NOCOPY int_telefonia%ROWTYPE) IS
  BEGIN
    p_telef.usureg := USER;
    p_telef.fecreg := SYSDATE;
  
    INSERT INTO int_telefonia VALUES p_telef RETURNING id INTO p_telef.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_INT_TELEFONIA: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE insert_int_telefonia_log(p_log IN OUT NOCOPY int_telefonia_log%ROWTYPE) IS
  BEGIN
    p_log.usureg := USER;
    p_log.fecreg := SYSDATE;
  
    INSERT INTO int_telefonia_log VALUES p_log RETURNING id INTO p_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE chg_alta(p_idtareawf tareawf.idtareawf%TYPE,
                     p_idwf      tareawf.idwf%TYPE,
                     p_tarea     tareawf.tarea%TYPE,
                     p_tareadef  tareawf.tareadef%TYPE,
                     p_tipesttar tareawf.tipesttar%TYPE,
                     p_esttarea  tareawf.esttarea%TYPE,
                     p_mottarchg tareawf.mottarchg%TYPE,
                     p_fecini    tareawf.fecini%TYPE,
                     p_fecfin    tareawf.fecfin%TYPE) IS
    C_CON_ERRORES CONSTANT esttarea.esttarea%TYPE := 19;
    C_CERRADA     CONSTANT esttarea.esttarea%TYPE := 4;
  
  BEGIN
    IF find_esttarea(p_idtareawf) = C_CON_ERRORES AND p_esttarea = C_CERRADA THEN
      alta(p_idtareawf, p_idwf, p_tarea, p_tareadef);
    END IF;
  
    DBMS_OUTPUT.PUT_LINE(p_tipesttar || p_mottarchg || p_fecini || p_fecfin);
  END;
  /* ***************************************************************************/
  PROCEDURE chg_cambio_plan(p_idtareawf tareawf.idtareawf%TYPE,
                            p_idwf      tareawf.idwf%TYPE,
                            p_tarea     tareawf.tarea%TYPE,
                            p_tareadef  tareawf.tareadef%TYPE,
                            p_tipesttar tareawf.tipesttar%TYPE,
                            p_esttarea  tareawf.esttarea%TYPE,
                            p_mottarchg tareawf.mottarchg%TYPE,
                            p_fecini    tareawf.fecini%TYPE,
                            p_fecfin    tareawf.fecfin%TYPE) IS
    C_CON_ERRORES CONSTANT esttarea.esttarea%TYPE := 19;
    C_CERRADA     CONSTANT esttarea.esttarea%TYPE := 4;
  
  BEGIN
    IF find_esttarea(p_idtareawf) = C_CON_ERRORES AND p_esttarea = C_CERRADA THEN
      cambio_plan(p_idtareawf, p_idwf, p_tarea, p_tareadef);
    END IF;
  
    DBMS_OUTPUT.PUT_LINE(p_tipesttar || p_mottarchg || p_fecini || p_fecfin);
  END;
  /* ***************************************************************************/
  PROCEDURE chg_baja(p_idtareawf tareawf.idtareawf%TYPE,
                     p_idwf      tareawf.idwf%TYPE,
                     p_tarea     tareawf.tarea%TYPE,
                     p_tareadef  tareawf.tareadef%TYPE,
                     p_tipesttar tareawf.tipesttar%TYPE,
                     p_esttarea  tareawf.esttarea%TYPE,
                     p_mottarchg tareawf.mottarchg%TYPE,
                     p_fecini    tareawf.fecini%TYPE,
                     p_fecfin    tareawf.fecfin%TYPE) IS
    C_CON_ERRORES CONSTANT esttarea.esttarea%TYPE := 19;
    C_CERRADA     CONSTANT esttarea.esttarea%TYPE := 4;
  
  BEGIN
    IF find_esttarea(p_idtareawf) = C_CON_ERRORES AND p_esttarea = C_CERRADA THEN
      baja(p_idtareawf, p_idwf, p_tarea, p_tareadef);
    END IF;
  
    DBMS_OUTPUT.PUT_LINE(p_tipesttar || p_mottarchg || p_fecini || p_fecfin);
  END;
  /* ***************************************************************************/
  FUNCTION find_esttarea(p_idtareawf tareawf.idtareawf%TYPE)
    RETURN tareawf.esttarea%TYPE IS
    l_esttarea tareawf.esttarea%TYPE;
  
  BEGIN
    SELECT esttarea INTO l_esttarea FROM tareawf WHERE idtareawf = p_idtareawf;
  
    RETURN l_esttarea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.FIND_ESTTAREA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION es_telefonia RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM wf w, solotpto s, inssrv i
     WHERE w.idwf = g_idwf
       AND w.codsolot = s.codsolot
       AND s.codinssrv = i.codinssrv
       AND i.tipinssrv = 3;
  
    RETURN l_count > 0;
  END;
  /* ***************************************************************************/
  PROCEDURE no_interviene IS
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(pq_int_telefonia.g_idtareawf,
                                     4, --Cerrada
                                     8, --No interviene
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.NO_INTERVIENE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_id RETURN int_telefonia.id%TYPE IS
  BEGIN
    RETURN g_int_telefonia_id;
  END;
  /* ***************************************************************************/
END;
/
