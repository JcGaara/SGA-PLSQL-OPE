CREATE OR REPLACE PACKAGE BODY OPERACION.pq_tellin_alta IS
  /******************************************************************************
   PROPOSITO: ALTA TELLIN
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_linea linea;
  C_ALTA  int_servicio_plataforma.iddefope%TYPE := 1;
  /* ***************************************************************************/
  PROCEDURE alta IS
  BEGIN
    IF NOT operacion.pq_int_telefonia.existe_reserva() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ALTA: NO EXISTE RESERVA');
    END IF;
  
    g_linea := get_linea();
  
    crear_int_servicio_plataforma();
  
    crear_int_telefonia_log();
  
    operacion.pq_tellin_conexion.enviar_solicitud();
  
    operacion.pq_tellin.update_int_servicio_plataforma();
  
    operacion.pq_tellin.crear_tareawfseg();
  
    operacion.pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ALTA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT a.codsolot,
           e.codinssrv,
           b.pid,
           f.codnumtel,
           h.idplan,
           c.codsrv,
           e.codcli,
           e.numero,
           e.numslc
      INTO l_linea
      FROM solotpto    a,
           insprd      b,
           tystabsrv   c,
           wf          d,
           inssrv      e,
           numtel      f,
           solot       g,
           plan_redint h
     WHERE d.idwf = operacion.pq_int_telefonia.g_idwf
       AND a.codsolot = d.codsolot
       AND a.pid = b.pid
       AND e.tipinssrv = 3 --'Numero Telefonico'
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --'control', 'prepago'
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND e.codinssrv = f.codinssrv
       AND a.codsolot = g.codsolot;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_servicio_plataforma IS
    l_tellin int_servicio_plataforma%ROWTYPE;
  
  BEGIN
    l_tellin.codsolot  := g_linea.codsolot;
    l_tellin.idtareawf := operacion.pq_int_telefonia.g_idtareawf;
    l_tellin.codinssrv := g_linea.codinssrv;
    l_tellin.pid       := g_linea.pid;
    l_tellin.idplan    := g_linea.idplan;
    l_tellin.codnumtel := g_linea.codnumtel;
    l_tellin.iddefope  := C_ALTA;
    operacion.pq_tellin.insert_int_servicio_plataforma(l_tellin);
  
    operacion.pq_tellin.set_idseq(l_tellin.idseq);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.CREAR_INT_SERVICIO_PLATAFORMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log operacion.int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := operacion.pq_int_telefonia.get_id();
    l_log.plataforma       := 'TELLIN';
    l_log.codinssrv        := g_linea.codinssrv;
    l_log.numero           := g_linea.numero;
    l_log.pid              := g_linea.pid;
    l_log.idseq            := operacion.pq_tellin.get_idseq();
    operacion.pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    operacion.pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
END;
/
