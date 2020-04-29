CREATE OR REPLACE PACKAGE BODY OPERACION.pq_int_telefonia_log IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por      Descripcion
     -------  -----       -----          --------------      -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
  /* ***************************************************************************/
  PROCEDURE logger(p_msg VARCHAR2) IS
    l_msg VARCHAR2(4000);
  
  BEGIN
    l_msg := formart_msg(p_msg);
    set_msg(l_msg);
  
    con_error();
  
    COMMIT;
  
    RAISE_APPLICATION_ERROR(-20000, l_msg);
  END;
  /* ***************************************************************************/
  FUNCTION formart_msg(p_msg VARCHAR2) RETURN VARCHAR2 IS
    l_msg VARCHAR2(4000);
  
  BEGIN
    l_msg := REPLACE(p_msg, 'ORA-20000: ', CHR(13) || '>>');
    l_msg := LTRIM(l_msg, CHR(13));
  
    RETURN l_msg;
  END;
  /* ***************************************************************************/
  PROCEDURE set_msg(p_msg VARCHAR2) IS
    l_log operacion.int_telefonia%ROWTYPE;
  
  BEGIN
    SELECT t.*
      INTO l_log
      FROM operacion.int_telefonia t
     WHERE t.id = operacion.pq_int_telefonia.get_id();
  
    l_log.idtareawf          := operacion.pq_int_telefonia.g_idtareawf;
    l_log.idwf               := operacion.pq_int_telefonia.g_idwf;
    l_log.tarea              := operacion.pq_int_telefonia.g_tarea;
    l_log.tareadef           := operacion.pq_int_telefonia.g_tareadef;
    l_log.codsolot           := operacion.pq_int_telefonia.get_codsolot();
    l_log.operacion          := operacion.pq_int_telefonia.g_operacion;
    l_log.plataforma_origen  := operacion.pq_int_telefonia.g_origen;
    l_log.plataforma_destino := operacion.pq_int_telefonia.g_destino;
    l_log.error_id           := -1;
    l_log.mensaje            := p_msg;
  
    UPDATE operacion.int_telefonia t SET ROW = l_log WHERE t.id = l_log.id;
  END;
  /* ***************************************************************************/
  PROCEDURE con_error IS
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(operacion.pq_int_telefonia.g_idtareawf,
                                     2, --En ejecucion
                                     19, --Con errores
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  END;
  /* ***************************************************************************/
  FUNCTION get_id RETURN operacion.int_telefonia_log.id%TYPE IS
  BEGIN
    RETURN g_id;
  END;
  /* ***************************************************************************/
END;
/
