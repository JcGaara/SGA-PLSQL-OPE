CREATE OR REPLACE PACKAGE BODY OPERACION.pq_tellin IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  g_idseq    int_servicio_plataforma.idseq%TYPE;
  g_iddefope int_operacion_tareadef.iddefope%TYPE;
  /* ***************************************************************************/
  FUNCTION find_iddefope RETURN int_operacion_tareadef.iddefope%TYPE IS
    l_operacion VARCHAR2(30);
  
  BEGIN
    l_operacion := operacion.pq_int_telefonia.g_operacion;
  
    IF l_operacion = 'ALTA' THEN
      RETURN 1;
    ELSIF l_operacion = 'CAMBIO_PLAN' THEN
      RETURN 45;
    ELSIF l_operacion = 'BAJA' THEN
      RETURN 4;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.FIND_IDDEFOPE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_servicio_plataforma IS
  BEGIN
    UPDATE int_servicio_plataforma t
       SET t.idlote = operacion.pq_tellin_conexion.get_idlote(), t.estado = 1 --enviado
     WHERE t.idseq = g_idseq;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.UPDATE_INT_SERVICIO_PLATAFORMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_tareawfseg IS
    l_tareawfseg tareawfseg%ROWTYPE;
  BEGIN
    l_tareawfseg.idtareawf   := operacion.pq_int_telefonia.g_idtareawf;
    l_tareawfseg.observacion := operacion.pq_tellin_conexion.g_mensaje;
    operacion.pq_int_telefonia.insert_tareawfseg(l_tareawfseg);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_TAREAWFSEG: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE insert_int_servicio_plataforma(p_tellin IN OUT int_servicio_plataforma%ROWTYPE) IS
  BEGIN
    p_tellin.estado := 0;
    p_tellin.usureg := USER;
    p_tellin.fecreg := SYSDATE;
    p_tellin.usumod := USER;
    p_tellin.fecmod := SYSDATE;
  
    INSERT INTO int_servicio_plataforma
    VALUES p_tellin
    RETURNING idseq INTO p_tellin.idseq;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT ||
                              '.INSERT_INT_SERVICIO_PLATAFORMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_iddefope RETURN int_operacion_tareadef.iddefope%TYPE IS
  BEGIN
    IF g_iddefope IS NULL THEN
      g_iddefope := find_iddefope();
    END IF;
  
    RETURN g_iddefope;
  END;
  /* ***************************************************************************/
  FUNCTION get_idseq RETURN int_servicio_plataforma.idseq%TYPE IS
  BEGIN
    RETURN g_idseq;
  END;
  /* ***************************************************************************/
  PROCEDURE set_idseq(p_idseq operacion.int_servicio_plataforma.idseq%TYPE) IS
  BEGIN
    g_idseq := p_idseq;
  END;
  /* ***************************************************************************/
END;
/
