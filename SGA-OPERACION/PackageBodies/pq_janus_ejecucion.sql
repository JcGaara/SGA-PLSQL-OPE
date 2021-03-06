CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_EJECUCION IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SOT_EJECUCION
     PURPOSE:    Retomar proceso para las  transacciones con JANUS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Retomar proceso para las  transacciones con JANUS
  ***************************************************************************************************/

  PROCEDURE execute_proceso(p_idwf tareawfcpy.idwf%TYPE) IS
  
    l_proceso operacion.opedd.abreviacion%TYPE;
  
  BEGIN
  
    set_globals(p_idwf);
    l_proceso := pq_janus_utl.caso_sot_rechazo(p_idwf);
  
    IF l_proceso = c_alta_hfc THEN
      alta();
    ELSIF l_proceso = c_baja_hfc THEN
      baja();
    ELSIF l_proceso = c_cambio_plan_hfc THEN
      cambio_plan();
    ELSIF l_proceso = c_reconexion_hfc THEN
      reconexion();
    ELSIF l_proceso = c_suspension_hfc THEN
      suspension();
    ELSIF l_proceso = c_corte_hfc THEN
      suspension();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_globals(p_idwf tareawf.idwf%TYPE) IS
  BEGIN
    operacion.pq_int_telefonia.g_idwf := p_idwf;
    pq_janus_utl.set_globals(p_idwf);
    g_codsolot := pq_janus_utl.get_codsolot();
  END;
  /* **********************************************************************************************/
  PROCEDURE alta IS
  BEGIN
  
    pq_janus_utl.crear_int_plataforma_bscs_alta();
  
    pq_janus_utl.crear_int_telefonia_log();
  
    operacion.pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    registrar_chg_sot();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ALTA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE baja IS
  
  BEGIN
  
    pq_janus_utl.crear_int_plataforma_bscs_baja();
  
    pq_janus_utl.crear_int_telefonia_log();
  
    pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    registrar_chg_sot();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.BAJA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE suspension IS
  BEGIN
  
    pq_janus_suspension.set_contexto();
  
    pq_janus_suspension.crea_int_plataforma_bscs();
  
    pq_janus_suspension.crea_int_telefonia_log();
  
    operacion.pq_janus_conexion.enviar_solicitud();
  
    operacion.pq_janus.update_int_plataforma_bscs();
  
    registrar_chg_sot();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.SUSPENSION: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE reconexion IS
  BEGIN
  
    pq_janus_reconexion.set_contexto();
  
    pq_janus_reconexion.crea_int_plataforma_bscs();
  
    pq_janus_reconexion.crea_int_telefonia_log();
  
    pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    registrar_chg_sot();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.RECONEXION: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE cambio_plan IS
    l_origen  VARCHAR2(30);
    l_destino VARCHAR2(30);
  BEGIN
  
    l_origen  := pq_int_telefonia.get_plataforma_origen();
    l_destino := pq_int_telefonia.get_plataforma();
  
    IF l_origen = 'JANUS' AND l_destino = 'JANUS' THEN
      cambio_plan_janus_janus();
    ELSIF l_origen = 'TELLIN' AND l_destino = 'JANUS' THEN
      alta();
      baja_tellin();
    ELSIF l_origen = 'ABIERTA' AND l_destino = 'JANUS' THEN
      alta();
    ELSIF l_origen = 'JANUS' AND l_destino = 'ABIERTA' THEN
      baja();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE cambio_plan_janus_janus IS
  BEGIN
  
    IF NOT operacion.pq_int_telefonia.existe_reserva() THEN
      pq_int_telefonia_log.logger(SQLERRM);
    END IF;
  
    IF pq_janus_utl.get_codsrv_origen() <> pq_janus_utl.get_codsrv_destino() THEN
    
      pq_janus_utl.crear_int_plataforma_bscs_cp();
    
      pq_janus_utl.crear_int_telefonia_log();
    
      operacion.pq_janus_conexion.enviar_solicitud();
    
      operacion.pq_janus.update_int_plataforma_bscs();
    
      operacion.pq_int_telefonia.update_int_telefonia_log();
    
      registrar_chg_sot();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN_JANUS_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE baja_tellin IS
  BEGIN
  
    set_tipo();
  
    crear_int_servicio_plataforma();
  
    crear_int_telefonia_log_tellin();
  
    operacion.pq_tellin_conexion.enviar_solicitud();
  
    operacion.pq_tellin.update_int_servicio_plataforma();
  
    operacion.pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.BAJA_TELLIN: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE set_tipo IS
  BEGIN
    operacion.pq_int_telefonia.g_operacion := 'BAJA';
    operacion.pq_int_telefonia.g_tareadef  := pq_janus_utl.get_tarea_janus(pq_janus_utl.g_idwf);
    operacion.pq_int_telefonia.g_idwf      := pq_janus_utl.get_idwf_origen(); --idwf origen
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_servicio_plataforma IS
    l_tellin int_servicio_plataforma%ROWTYPE;
  
    linea pq_tellin_baja.linea;
  BEGIN
  
    linea              := pq_tellin_baja.get_linea();
    l_tellin.codsolot  := g_codsolot;
    l_tellin.idtareawf := NULL; --pq_janus_utl.get_idtareawf();
    l_tellin.codinssrv := linea.codinssrv;
    l_tellin.pid       := linea.pid;
    l_tellin.idplan    := linea.idplan;
    l_tellin.codnumtel := linea.codnumtel;
    l_tellin.iddefope  := operacion.pq_tellin.get_iddefope();
    operacion.pq_tellin.insert_int_servicio_plataforma(l_tellin);
  
    operacion.pq_tellin.set_idseq(l_tellin.idseq);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_SERVICIO_PLATAFORMA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE crear_int_telefonia_log_tellin IS
    l_log              operacion.int_telefonia_log%ROWTYPE;
    linea              pq_tellin_baja.linea;
    l_estado_ejecucion estsol.estsol%TYPE := 6;
  BEGIN
  
    linea                  := pq_tellin_baja.get_linea();
    l_log.int_telefonia_id := pq_janus_utl.get_id_telefonia();
    l_log.plataforma       := 'TELLIN';
    l_log.codinssrv        := linea.codinssrv;
    l_log.numero           := linea.numero;
    l_log.pid              := linea.pid;
    l_log.idseq            := operacion.pq_tellin.get_idseq();
    l_log.chg_estado_sot   := l_estado_ejecucion;
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_TELEFONIA_LOG_TELLIN: ' || SQLERRM);
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
  FUNCTION get_id_telefonia RETURN operacion.int_telefonia.id%TYPE IS
  
    l_id_int_telefonia operacion.int_telefonia.id%TYPE;
  
  BEGIN
  
    SELECT MAX(a.id)
      INTO l_id_int_telefonia
      FROM operacion.int_telefonia a
     WHERE a.codsolot = g_codsolot;
  
    RETURN l_id_int_telefonia;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_ID_TELEFONIA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE registrar_chg_sot IS
  BEGIN
    registrar_chg_sot_cabecera();
    registrar_chg_sot_detalle();
  END;
  /* **********************************************************************************************/
  PROCEDURE registrar_chg_sot_cabecera IS
    l_id operacion.int_telefonia.id%TYPE;
  BEGIN
    l_id := pq_janus_utl.get_id_telefonia();
    UPDATE operacion.int_telefonia a SET a.tipestsol = 6 WHERE a.id = l_id;
  END;
  /* **********************************************************************************************/
  PROCEDURE registrar_chg_sot_detalle IS
    l_log              operacion.int_telefonia_log%ROWTYPE;
    l_estado_ejecucion estsol.estsol%TYPE := 6;
  
  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.int_telefonia_log t
     WHERE t.id = pq_int_telefonia_log.g_id;
    l_log.sga_error_id   := 0;
    l_log.sga_error_dsc  := 'OK';
    l_log.chg_estado_sot := l_estado_ejecucion;
  
    UPDATE operacion.int_telefonia_log t SET ROW = l_log WHERE t.id = l_log.id;
  END;
  /* **********************************************************************************************/
END;
/
