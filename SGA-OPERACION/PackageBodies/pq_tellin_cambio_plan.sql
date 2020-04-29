CREATE OR REPLACE PACKAGE BODY OPERACION.pq_tellin_cambio_plan IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      17/03/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_linea       linea;
  C_CAMBIO_PLAN int_servicio_plataforma.iddefope%TYPE := 45;
  /* ***************************************************************************/
  PROCEDURE cambio_plan IS
    l_origen  tystabsrv.codsrv%TYPE;
    l_destino tystabsrv.codsrv%TYPE;
  
  BEGIN
    IF esta_registrado() THEN
      RETURN;
    END IF;
  
    IF NOT pq_int_telefonia.existe_reserva() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: NO EXISTE RESERVA');
    END IF;
  
    l_origen  := get_codsrv_origen();
    l_destino := get_codsrv_destino();
  
    IF l_origen = l_destino THEN
      pq_int_telefonia.no_interviene();
    END IF;
  
    IF l_origen <> l_destino THEN
      tellin_tellin();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_PLAN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION esta_registrado RETURN BOOLEAN IS
    l_count PLS_INTEGER;
  
  BEGIN
    g_linea := get_linea();
  
    SELECT COUNT(*)
      INTO l_count
      FROM int_servicio_plataforma
     WHERE codsolot = g_linea.codsolot
       AND idtareawf = pq_int_telefonia.g_idtareawf
       AND codinssrv = g_linea.codinssrv
       AND pid = g_linea.pid
       AND codnumtel = g_linea.codnumtel
       AND iddefope = C_CAMBIO_PLAN
       AND estado NOT IN (4);
  
    RETURN l_count > 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ESTA_REGISTRADO: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT a.codsolot,
           e.codinssrv,
           b.pid,
           a.pid_old,
           f.codnumtel,
           c.idplan,
           b.codsrv,
           e.codcli,
           e.numslc,
           e.numero
      INTO l_linea
      FROM solotpto a, insprd b, tystabsrv c, wf d, inssrv e, numtel f
     WHERE d.idwf = pq_int_telefonia.g_idwf
       AND a.codsolot = d.codsolot
       AND a.pid = b.pid
       AND e.codinssrv = b.codinssrv
       AND e.codinssrv = f.codinssrv
       AND e.tipinssrv = 3
       AND b.codsrv = c.codsrv
       AND c.tipsrv = '0004'
       AND b.flgprinc = 1;
  
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
  PROCEDURE tellin_tellin IS
  BEGIN
    crear_int_servicio_plataforma();
  
    crear_int_telefonia_log();
  
    pq_tellin_conexion.enviar_solicitud();
  
    pq_tellin.update_int_servicio_plataforma();
  
    pq_tellin.crear_tareawfseg();
  
    pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.TELLIN_TELLIN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_servicio_plataforma IS
    l_tellin int_servicio_plataforma%ROWTYPE;
  
  BEGIN
    l_tellin.codsolot  := g_linea.codsolot;
    l_tellin.idtareawf := pq_int_telefonia.g_idtareawf;
    l_tellin.codinssrv := g_linea.codinssrv;
    l_tellin.pid       := g_linea.pid;
    l_tellin.idplan    := g_linea.idplan;
    l_tellin.codnumtel := g_linea.codnumtel;
    l_tellin.iddefope  := C_CAMBIO_PLAN;
    pq_tellin.insert_int_servicio_plataforma(l_tellin);
  
    pq_tellin.set_idseq(l_tellin.idseq);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := pq_int_telefonia.get_id();
    l_log.plataforma       := 'TELLIN';
    l_log.codinssrv        := g_linea.codinssrv;
    l_log.numero           := g_linea.numero;
    l_log.pid              := g_linea.pid;
    l_log.idseq            := pq_tellin.get_idseq();
    pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    pq_int_telefonia_log.g_id := l_log.id;
  END;
  /* ***************************************************************************/
END;
/
