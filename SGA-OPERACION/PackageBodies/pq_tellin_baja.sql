CREATE OR REPLACE PACKAGE BODY OPERACION.pq_tellin_baja IS
  /******************************************************************************
   PROPOSITO: BAJA TELLIN
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_linea linea;
  C_BAJA  int_servicio_plataforma.iddefope%TYPE := 4;
  /* ***************************************************************************/
  PROCEDURE baja IS
  BEGIN
    IF esta_registrado() THEN
      RETURN;
    END IF;
  
    crear_int_servicio_plataforma();
  
    crear_int_telefonia_log();
  
    operacion.pq_tellin_conexion.enviar_solicitud();
  
    operacion.pq_tellin.update_int_servicio_plataforma();
  
    operacion.pq_tellin.crear_tareawfseg();
  
    operacion.pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.BAJA: ' || SQLERRM);
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
       AND idtareawf = operacion.pq_int_telefonia.g_idtareawf
       AND codinssrv = g_linea.codinssrv
       AND pid = g_linea.pid
       AND codnumtel = g_linea.codnumtel
       AND iddefope = C_BAJA;
  
    RETURN l_count <> 0;
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT a.codsolot,
           f.codinssrv,
           f.pid,
           c.codnumtel,
           b.idplan,
           b.codsrv,
           ins.codcli,
           ins.numslc,
           ins.numero
      INTO l_linea
      FROM wf a,
           tystabsrv b,
           numtel c,
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
     WHERE a.idwf = operacion.pq_int_telefonia.g_idwf
       AND a.codsolot = e.codsolot
       AND f.codinssrv = e.codinssrv
       AND f.pid = e.pid
       AND f.codinssrv = c.codinssrv
       AND f.codsrv = b.codsrv
       AND b.idplan = d.idplan
       AND d.idtipo IN (2, 3)
       AND e.codinssrv = ins.codinssrv;
  
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
    l_tellin.iddefope  := C_BAJA;
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
