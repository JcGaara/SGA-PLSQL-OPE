CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_PROCESOS IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_PROCESOS
     PURPOSE:    Ejecutar reenvios a BSCS
  
     REVISIONS:
     Ver        Date        Author           Solicitado por                  Description
     ---------  ----------  ---------------  --------------                  ----------------------
     1.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Ejecutar reenvios a BSCS
     2.0        20/02/2014  Eustaquio Gibaja Christian Riquelme             Adecuación de respuesta de BSCS
  ***************************************************************************************************/
  PROCEDURE main_reenvio_bscs IS
    c_error_conexion_ws     PLS_INTEGER := -1;
    c_error_datos_invalidos VARCHAR(20) := 'DATOS INVALIDOS';
    c_cantidad_envio        NUMBER;
  
    CURSOR tx_pendiente IS
      SELECT a.id        id_telefonia,
             b.id        id_log,
             b.idtrans   idtrans,
             c.action_id action_id,
             c.trama     trama
        FROM operacion.int_telefonia       a,
             operacion.int_telefonia_log   b,
             operacion.int_plataforma_bscs c
       WHERE a.id = b.int_telefonia_id
         AND b.idtrans = c.idtrans
         AND b.ws_envios <= c_cantidad_envio
         AND b.ws_error_id = c_error_conexion_ws
         AND b.idtrans IS NOT NULL
         AND b.ws_error_dsc <> c_error_datos_invalidos;
  
  BEGIN
    C_CANTIDAD_ENVIO := get_cantidad_envio();
  
    FOR c IN tx_pendiente LOOP
      set_globals(c.id_telefonia, c.id_log, c.idtrans, c.action_id, c.trama);
      BEGIN
        reenvio_solicitud();
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, 'Error en main_reenvio_bscs.');
  END;
  /* **********************************************************************************************/
  PROCEDURE set_globals(p_id_telefonia operacion.int_telefonia.id%TYPE,
                        p_idlog        operacion.int_telefonia_log.id%TYPE,
                        p_idtrans      operacion.int_plataforma_bscs.idtrans%TYPE,
                        p_action_id    operacion.int_plataforma_bscs.action_id%TYPE,
                        p_trama        operacion.int_plataforma_bscs.trama%TYPE) IS
  
  BEGIN
    g_id_telefonia            := p_id_telefonia;
    pq_int_telefonia_log.g_id := p_idlog;
    pq_janus.g_idtrans        := p_idtrans;
    pq_janus.g_action_id      := p_action_id;
    pq_janus.g_trama          := p_trama;
  END;
  /* **********************************************************************************************/
  FUNCTION get_cantidad_envio RETURN opedd.codigon%TYPE IS
    l_cantidad opedd.codigon%TYPE;
  
  BEGIN
    SELECT b.codigon
      INTO l_cantidad
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL'
       AND b.abreviacion = 'BSCS_CANT_ENVIO';
  
    RETURN l_cantidad;
  END;
  /* **********************************************************************************************/
  PROCEDURE reenvio_solicitud IS
  BEGIN
    pq_janus_conexion.enviar_solicitud();
    update_int_telefonia();
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia IS
    l_log operacion.int_telefonia%ROWTYPE;
  
  BEGIN
    IF operacion.pq_janus_conexion.g_codigo = 0 THEN
      SELECT t.*
        INTO l_log
        FROM operacion.int_telefonia t
       WHERE t.id = g_id_telefonia;
      l_log.error_id := 0;
      l_log.mensaje  := 'OK';
    
      UPDATE operacion.int_telefonia t SET ROW = l_log WHERE t.id = l_log.id;
    END IF;
  END;
  /* **********************************************************************************************/
  --cuando alcanza el limite de envios
  PROCEDURE send_mail_soporte_bscs(p_idlog operacion.int_telefonia_log.id%TYPE) IS
  
    l_asunto  cola_send_mail_job.subject%TYPE;
    l_destino cola_send_mail_job.destino%TYPE;
    l_mensaje cola_send_mail_job.cuerpo%TYPE;
    l_linea   linea;
  
  BEGIN
    l_linea := get_linea(p_idlog);
  
    l_asunto  := 'Soporte Transacción ' || TO_CHAR(l_linea.operation) ||
                 'en Plataforma JANUS, Número Solot :  ' ||
                 TO_CHAR(l_linea.codsolot);
    l_destino := get_email_soporte_envio_bscs();
  
    l_mensaje := NULL;
    l_mensaje := CHR(13) || l_mensaje || CHR(13) ||
                 'Se informa que la transacción ' || TO_CHAR(l_linea.tx_bscs);
    l_mensaje := l_mensaje || CHR(13) ||
                 ' no ha podido ser transaferida a BSCS ' || CHR(10);
  
    l_mensaje := l_mensaje || CHR(13) || ' idlog : ' || TO_CHAR(p_idlog);
  
    p_envia_correo_de_texto_att(l_asunto, l_destino, l_mensaje);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, 'Error en envio de correo soporte BSCS.');
  END;
  /* **********************************************************************************************/
  PROCEDURE send_mail_soporte_cierre_tarea(p_idlog operacion.int_telefonia_log.id%TYPE) IS
    l_linea   linea;
    l_asunto  cola_send_mail_job.subject%TYPE;
    l_destino cola_send_mail_job.destino%TYPE;
    l_mensaje cola_send_mail_job.cuerpo%TYPE;
  
  BEGIN
    l_linea := get_linea(p_idlog);
  
    l_asunto := 'Soporte Transacción ' || TO_CHAR(l_linea.operation) ||
                ' en Plataforma JANUS, Número Solot  ' ||
                TO_CHAR(l_linea.codsolot);
  
    l_destino := get_email_soporte_cerrar_janus();
  
    l_mensaje := NULL;
    l_mensaje := CHR(13) || l_mensaje || CHR(13) || 'Se informa que la tarea ' ||
                 TO_CHAR(l_linea.idtareawf);
    l_mensaje := l_mensaje || CHR(13) ||
                 'no ha podido cerrarse debido a que no ha sido ejecutada en Plataforma JANUS. requiere de cierre manual' ||
                 CHR(10);
  
    p_envia_correo_de_texto_att(l_asunto, l_destino, l_mensaje);
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              'Error en envio de correo soporte Tarea.');
  END;
  /* **********************************************************************************************/
  FUNCTION get_linea(p_idlog operacion.int_telefonia_log.id%TYPE) RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT b.operacion, b.codsolot, a.tx_bscs, b.idtareawf
      INTO l_linea
      FROM operacion.int_telefonia_log a, operacion.int_telefonia b
     WHERE a.int_telefonia_id = b.id
       AND a.id = p_idlog;
  
    RETURN l_linea;
  END;
  /* **********************************************************************************************/
  FUNCTION get_email_soporte_envio_bscs RETURN opedd.descripcion%TYPE IS
    l_correo opedd.descripcion%TYPE;
  
  BEGIN
    SELECT b.descripcion
      INTO l_correo
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL'
       AND b.abreviacion = 'BSCS_CORREO_SOPRTE';
  
    RETURN l_correo;
  END;
  /* **********************************************************************************************/
  FUNCTION get_email_soporte_cerrar_janus RETURN opedd.descripcion%TYPE IS
    l_correo opedd.descripcion%TYPE;
  
  BEGIN
    SELECT b.descripcion
      INTO l_correo
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL'
       AND b.abreviacion = 'CORREO_CERRAR_TAREA_JANUS';
  
    RETURN l_correo;
  END;
  /* **********************************************************************************************/
  FUNCTION get_horas_permitidas_janus RETURN opedd.codigon%TYPE IS
    l_horas opedd.codigon%TYPE;
  
  BEGIN
    SELECT b.Codigon
      INTO l_horas
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL'
       AND b.abreviacion = 'HORAS_SIN_CERRAR_TAREA_JANUS';
  
    RETURN l_horas;
  END;
  /* **********************************************************************************************/
  FUNCTION get_horas_sin_cerrar_janus(p_idwf wf.idwf%TYPE) RETURN NUMBER IS
    l_horas NUMBER;
  
  BEGIN
    SELECT TO_NUMBER(TRUNC((SYSDATE - a.fecini) * 24))
      INTO l_horas
      FROM tareawf a
     WHERE a.idwf = p_idwf
       AND a.idtareawf = g_idtareawf_valida_janus;
  
    RETURN l_horas;
  --ini 2.0
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  --fin 2.0
  END;
  /* **********************************************************************************************/
  FUNCTION get_envios_realizados(p_idlog operacion.int_telefonia_log.id%TYPE)
    RETURN operacion.int_telefonia_log.ws_envios%TYPE IS
    l_ws_envios operacion.int_telefonia_log.ws_envios%TYPE;
  
  BEGIN
    SELECT a.ws_envios
      INTO l_ws_envios
      FROM operacion.int_telefonia_log a
     WHERE a.id = p_idlog;
  
    RETURN l_ws_envios;
  END;
  /* **********************************************************************************************/
  PROCEDURE main_cerrar_tarea_janus IS
    l_estado_tx_janus        NUMBER;
    l_horas_permitidas       NUMBER;
    l_horas_sin_cerrar_janus NUMBER;
  
    CURSOR solicitud_bscs IS
      SELECT a.idtareawf, a.idwf, b.id, b.idtrans
        FROM operacion.int_telefonia a, operacion.int_telefonia_log b
       WHERE a.id = b.int_telefonia_id
         AND (a.plataforma_destino = 'JANUS' OR a.plataforma_origen = 'JANUS')
         AND b.tx_bscs IS NOT NULL
         AND (b.verificado = 0 OR b.verificado IS NULL);
  
  BEGIN
    FOR solicitud IN solicitud_bscs LOOP
      l_estado_tx_janus        := get_status_tx_janus(solicitud.idtrans);
      g_idtareawf_valida_janus := pq_janus_utl.get_idtareawf_valida_tx_janus(solicitud.idwf);
    
      --ini 2.0
      --IF l_estado_tx_janus = 1 THEN
      IF l_estado_tx_janus = get_estado_generada_bscs() THEN
      --fin 2.0
        update_int_telefonia_log(solicitud.id);
        opewf.pq_wf.p_chg_status_tareawf(g_idtareawf_valida_janus,
                                         4,
                                         4,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      ELSE
        l_horas_sin_cerrar_janus := get_horas_sin_cerrar_janus(solicitud.idwf);
        l_horas_permitidas       := get_horas_permitidas_janus();
      
        IF l_horas_permitidas <= l_horas_sin_cerrar_janus THEN
          send_mail_soporte_cierre_tarea(solicitud.id);
        END IF;
      END IF;
    END LOOP;
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              'Error en proceso de cierre automático de tareas JANUS.');
  END;
  /* **********************************************************************************************/
  FUNCTION get_status_tx_janus(p_idtrans operacion.int_telefonia_log.idtrans%TYPE)
    RETURN operacion.int_telefonia_log.verificado%TYPE IS
    l_estado_janus    operacion.int_telefonia_log.verificado%TYPE;
    l_transaccion     transaccion;
    l_respuesta       NUMBER(2);
    l_descripcion_rpt VARCHAR2(20);
  
  BEGIN
    g_idtrans := p_idtrans;
  
    l_transaccion := get_transaccion();
  
    tim.pp001_pkg_prov_janus.sp_estado_prov@DBL_BSCS_BF(l_transaccion.idtrans,
                                                        l_transaccion.action_id,
                                                        l_transaccion.co_id,
                                                        l_estado_janus,
                                                        l_respuesta,
                                                        l_descripcion_rpt);
    RETURN l_estado_janus;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_STATUS_TX_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/

  FUNCTION get_transaccion RETURN transaccion IS
    l_transaccion transaccion;
  
  BEGIN
    SELECT b.idtrans, b.action_id, b.co_id
      INTO l_transaccion
      FROM operacion.int_plataforma_bscs b
     WHERE b.idtrans = g_idtrans;
  
    RETURN l_transaccion;
  END;
  /* **********************************************************************************************/
  PROCEDURE valida_tx_janus(p_idtareawf tareawf.idtareawf%TYPE,
                            p_idwf      tareawf.idwf%TYPE,
                            p_tarea     tareawf.tarea%TYPE,
                            p_tareadef  tareawf.tareadef%TYPE,
                            p_tipesttar tareawf.tipesttar%TYPE,
                            p_esttarea  tareawf.esttarea%TYPE,
                            p_mottarchg tareawf.mottarchg%TYPE,
                            p_fecini    tareawf.fecini%TYPE,
                            p_fecfin    tareawf.fecfin%TYPE) IS
    l_tarea_cerrada   tareawf.esttarea%TYPE := 4;
    l_sot_generada    solot.codsolot%TYPE := 17;
    l_estado_sot      solot.codsolot%TYPE;
    l_estado_tx_janus NUMBER;
    error_tx_janus EXCEPTION;
  
    CURSOR solicitud_bscs IS
      SELECT b.id, b.idtrans
        FROM operacion.int_telefonia a, operacion.int_telefonia_log b
       WHERE a.id = b.int_telefonia_id
         AND (a.plataforma_destino = 'JANUS' OR a.plataforma_origen = 'JANUS')
         AND b.tx_bscs IS NOT NULL
         AND (b.verificado = 0 OR b.verificado IS NULL)
         AND a.idwf = p_idwf;
  
  BEGIN
    l_estado_sot := get_status_solot(p_idwf);
  
    IF l_estado_sot = l_sot_generada AND p_esttarea = l_tarea_cerrada THEN
      FOR solicitud IN solicitud_bscs LOOP
        l_estado_tx_janus := get_status_tx_janus(solicitud.idtrans);
       --ini 2.0
       --IF l_estado_tx_janus = 1 THEN
       IF l_estado_tx_janus = get_estado_generada_bscs() THEN
       --fin 2.0
          update_int_telefonia_log(solicitud.id);
        ELSE
          RAISE error_tx_janus;
        END IF;
      END LOOP;
    END IF;
  
  EXCEPTION
    WHEN error_tx_janus THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'La transacción en Plataforma Janus se encuentra Pendiente');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(p_idtareawf);
      DBMS_OUTPUT.PUT_LINE(p_tarea);
      DBMS_OUTPUT.PUT_LINE(p_tareadef);
      DBMS_OUTPUT.PUT_LINE(p_tipesttar);
      DBMS_OUTPUT.PUT_LINE(p_mottarchg);
      DBMS_OUTPUT.PUT_LINE(p_fecini);
      DBMS_OUTPUT.PUT_LINE(p_fecfin);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CERRAR_TAREA_VALIDA_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_status_solot(p_idwf wf.idwf%TYPE) RETURN solot.estsol%TYPE IS
    l_estado tareawf.esttarea%TYPE;
  
  BEGIN
    SELECT a.estsol
      INTO l_estado
      FROM solot a, wf b
     WHERE a.codsolot = b.codsolot
       AND b.idwf = p_idwf;
  
    RETURN l_estado;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_STATUS_TAREA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia_log(p_idlog operacion.int_telefonia_log.id%TYPE) IS
  BEGIN
    UPDATE operacion.int_telefonia_log t
       SET t.verificado = 1
     WHERE t.id = p_idlog;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  --ini 2.0
  FUNCTION get_estado_generada_bscs RETURN opedd.codigon%TYPE IS
    l_estado_generado opedd.codigon%TYPE;
  BEGIN
    SELECT b.Codigon
      INTO l_estado_generado
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'ESTADO_LINEA_BSCS'
       AND b.abreviacion = 'ESTADO_GENERADA';
  
    RETURN l_estado_generado;
  END;
/* **********************************************************************************************/
  --fin 2.0
END;
/