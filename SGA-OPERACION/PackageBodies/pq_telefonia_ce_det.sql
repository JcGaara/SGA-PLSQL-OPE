CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_TELEFONIA_CE_DET IS
  /******************************************************************************
   PROPOSITO:  Registrar y guardar detalle de error
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----             --------------      -----------
     1.0    2014-06-26    Eustaquio Gibaja  Christian Riquelme  version inicial
     2.0      2014-12-26  Edwin Vasquez     Christian Riquelme  Claro Empresas WiMAX
  /* ***************************************************************************/
  PROCEDURE logger(p_idtareawf tareawf.idtareawf%type, p_msg VARCHAR2) IS
    l_msg VARCHAR2(4000);
  
  BEGIN
    l_msg := formart_msg(p_msg);
    set_msg(p_idtareawf, l_msg);
    commit;

    con_error(p_idtareawf);
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
  PROCEDURE set_msg(p_idtareawf tareawf.idtareawf%type, p_msg VARCHAR2) IS
    /*l_log operacion.telefonia_ce%ROWTYPE;*/
    l_id_telefonia_ce telefonia_ce.id_telefonia_ce%type;
  
  BEGIN
    /*SELECT t.*
      INTO l_log
      FROM operacion.telefonia_ce t
     WHERE t.id_telefonia_ce = operacion.pq_telefonia_ce.get_id();*/

      select max(t.id_telefonia_ce)
      into l_id_telefonia_ce
      from operacion.telefonia_ce t
     where t.idtareawf = p_idtareawf;
  
    /*l_log.idtareawf := operacion.pq_telefonia_ce.g_idtareawf;
    l_log.idwf      := operacion.pq_telefonia_ce.g_idwf;
    l_log.tarea     := operacion.pq_telefonia_ce.g_tarea;
    l_log.tareadef  := operacion.pq_telefonia_ce.g_tareadef;
    l_log.codsolot  := operacion.pq_telefonia_ce.get_codsolot();
    l_log.operacion := operacion.pq_telefonia_ce.g_operacion;
    l_log.id_error  := -1;
    l_log.mensaje   := p_msg;*/
  
    UPDATE operacion.telefonia_ce t
       SET t.id_error = -1, t.mensaje = p_msg
     WHERE t.id_telefonia_ce = l_id_telefonia_ce;
  END;
  /* ***************************************************************************/
  PROCEDURE con_error(p_idtareawf tareawf.idtareawf%type) is
    c_en_ejecucion constant tareawf.tipesttar%type := 2;
    c_con_errores  constant tareawf.esttarea%type := 19;
  BEGIN
    opewf.pq_wf.p_chg_status_tareawf(p_idtareawf,
                                     c_en_ejecucion,
                                     c_con_errores,
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  END;
  /* ***************************************************************************/
  /*FUNCTION get_id RETURN operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE IS
  BEGIN
    RETURN g_id_telefonia_ce_det;
  END;*/
  /* ***************************************************************************/
END;
/