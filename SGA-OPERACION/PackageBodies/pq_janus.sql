CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor          Solicitado por   Descripcion
     -------  -----       -----          --------------   -----------
     1.0      26/02/2014  Mauro Zegarra  Christian Riquelme  version inicial
     2.0      14/07/2014  Juan Gonzales  Christian Riquelme  Retardar transaccion
  /* ***************************************************************************/
  PROCEDURE insert_int_plataforma_bscs(p_int_bscs IN OUT int_plataforma_bscs%ROWTYPE) IS
  BEGIN
    p_int_bscs.codusu := USER;
    p_int_bscs.fecusu := SYSDATE;
  
    INSERT INTO int_plataforma_bscs
    VALUES p_int_bscs
    RETURNING idtrans INTO p_int_bscs.idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.INSERT_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_tareawfseg IS
    l_tareawfseg tareawfseg%ROWTYPE;
  BEGIN
    l_tareawfseg.idtareawf   := pq_int_telefonia.g_idtareawf;
    l_tareawfseg.observacion := pq_janus_conexion.g_mensaje;
    pq_int_telefonia.insert_tareawfseg(l_tareawfseg);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_TAREAWFSEG: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION set_tx_bscs(p_action_id int_plataforma_bscs.action_id%TYPE)
    RETURN VARCHAR2 IS
  BEGIN
    IF p_action_id = 1 THEN
      RETURN 'ALTA';
    ELSIF p_action_id = 2 THEN
      RETURN 'BAJA';
    ELSIF p_action_id = 16 THEN
      RETURN 'CAMBIO_PLAN';
    ELSIF p_action_id = 3 THEN
      RETURN 'RECONEXION';
    ELSIF p_action_id = 4 THEN
      RETURN 'SUSPENSION';
    END IF;
  END;
  /* ***************************************************************************/
  FUNCTION get_conf(p_param VARCHAR2) RETURN opedd.codigoc%TYPE IS
    l_conf opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO l_conf
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev LIKE '%PAR_PLATAF_JANUS%'
       AND TRIM(o.abreviacion) = TRIM(p_param);
  
    RETURN l_conf;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_CONF: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE update_int_plataforma_bscs IS
  BEGIN
    UPDATE int_plataforma_bscs
       SET resultado     = pq_janus_conexion.g_codigo,
           message_resul = pq_janus_conexion.g_mensaje
     WHERE idtrans = g_idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_config(p_param opedd.abreviacion%TYPE) RETURN opedd.codigoc%TYPE IS
    l_config opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO l_config
      FROM tipopedd t, opedd o
     WHERE t.abrev = 'PLAT_JANUS'
       AND t.tipopedd = o.tipopedd
       AND o.abreviacion = p_param
       AND o.codigon = 1;
  
    RETURN l_config;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CONFIG: ' || SQLERRM);
  END;
  --ini 2.0
  /* ***************************************************************************/
  PROCEDURE timer(p_sec NUMBER) IS
    l_now DATE := SYSDATE;
  
  BEGIN
    LOOP
      EXIT WHEN l_now +(p_sec * (1 / 86400)) = SYSDATE;
    END LOOP;
  END;
  --fin 2.0
  /* ***************************************************************************/
END;
/