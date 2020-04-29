CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_JANUS_CE_PROCESOS IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_CE_PROCESOS
     PURPOSE:    Ejecutar reenvios a BSCS

     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      2014-06-26  Cesar Quispe    Christian Riquelme  version inicial
     2.0      2014-06-26  Cesar Quispe    Christian Riquelme  Adecuacion respuesta de BSCS
     3.0      2014-11-24  Eustaquio Gibaja Christian Riquelme  Mejoras en recepcion de respuesta de BSCS
     4.0      2014-12-24  Edwin Vasquez    Christian Riquelme  Claro Empresas WiMAX
  ***************************************************************************************************/
  PROCEDURE main_reenvio_bscs IS
    c_error_conexion_ws     PLS_INTEGER := -1;
    c_error_datos_invalidos VARCHAR(30) := 'Datos ingresados invalidos';
    c_error_ejec_sql        VARCHAR(30) := 'Error al ejecutar SQL';
    c_cantidad_envio        NUMBER;

    CURSOR tx_pendiente IS
      SELECT a.id_telefonia_ce     id_telefonia,
             a.idtareawf           idtareawf,
             b.id_telefonia_ce_det id_telefonia_ce_det,
             b.idtrans             idtrans,
             c.action_id           action_id,
             c.trama               trama,
             a.operacion           operacion
        FROM operacion.telefonia_ce        a,
             operacion.telefonia_ce_det    b,
             operacion.int_plataforma_bscs c
       WHERE a.id_telefonia_ce = b.id_telefonia_ce
         AND b.idtrans = c.idtrans
         AND NVL(b.ws_envios,0)<= c_cantidad_envio
         AND NVL(b.id_ws_error, c_error_conexion_ws) = c_error_conexion_ws
         AND b.idtrans IS NOT NULL
         AND NVL(b.ws_error_dsc, '%') NOT IN
             (c_error_datos_invalidos, c_error_ejec_sql)
       ORDER BY b.id_telefonia_ce_det ASC;

    CURSOR tx_pendiente_alta IS
      SELECT a.id_telefonia_ce id_telefonia_ce,
             a.operacion       operacion,
             a.idtareawf       idtareawf,
             a.idwf            idwf,
             a.tarea           tarea,
             a.tareadef        tareadef
        FROM operacion.telefonia_ce a
       WHERE id_error = c_error_conexion_ws
         AND (SELECT COUNT(*)
                FROM operacion.telefonia_ce_det
               WHERE id_telefonia_ce = a.id_telefonia_ce) = 0
       ORDER BY a.id_telefonia_ce ASC;

  BEGIN
    C_CANTIDAD_ENVIO := get_cantidad_envio();

    FOR c IN tx_pendiente LOOP
      /*set_globals(c.id_telefonia,
                  c.id_telefonia_ce_det,
                  c.idtrans,
                  c.action_id,
                  c.trama);*/
      BEGIN
        reenvio_solicitud(c.idtrans,
                          c.id_telefonia_ce_det,
                          c.id_telefonia,
                          c.operacion);
        cambiar_estado_tareawf(c.idtareawf);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

    FOR r IN tx_pendiente_alta LOOP
      --operacion.pq_telefonia_ce.g_operacion := r.operacion;
      /*operacion.pq_telefonia_ce.set_globals(r.idtareawf,
                                            r.idwf,
                                            r.tarea,
                                            r.tareadef);
      --operacion.pq_telefonia_ce.g_id_telefonia_ce := r.id_telefonia_ce;*/
      BEGIN
        IF r.operacion = 1 THEN
          operacion.pq_janus_ce_alta.alta(r.idtareawf,
                                          r.idwf,
                                          r.tarea,
                                          r.tareadef);
        ELSIF r.operacion = 2 THEN
          operacion.pq_janus_ce_baja.baja(r.idtareawf,
                                          r.idwf,
                                          r.tarea,
                                          r.tareadef);
        elsif r.operacion = 16 then
          operacion.pq_janus_ce_cambio_plan.cambio_plan(r.idtareawf,
                                                        r.idwf,
                                                        r.tarea,
                                                        r.tareadef);     
        END IF;
        update_telefonia_ce(r.id_telefonia_ce, r.operacion); --operacion.pq_telefonia_ce.update_telefonia_ce();
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
  /*********************************************************************
   PROCEDIMIENTO: Setea las variables globales utilizadas para el envío a BSCS
   PARAMETROS:
      Entrada:
        - p_id_telefonia: Id de la tabla telefonia_ce
        - p_idlog: Id de la tabla telefonia_ce_det
        - p_idtrans: Id de la tabla int_plataforma_bscs
        - p_action_id: Acción a realizar en BSCS
        - p_trama: Trama enviada al WebService
  *********************************************************************/
  /*PROCEDURE set_globals(p_id_telefonia        telefonia_ce.id_telefonia_ce%TYPE,
                        p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%TYPE,
                        p_idtrans             int_plataforma_bscs.idtrans%TYPE,
                        p_action_id           int_plataforma_bscs.action_id%TYPE,
                        p_trama               int_plataforma_bscs.trama%TYPE) IS

  BEGIN
    null;
    g_id_telefonia                            := p_id_telefonia;
    pq_telefonia_ce_det.g_id_telefonia_ce_det := p_id_telefonia_ce_det;
    pq_janus_ce.g_idtrans                     := p_idtrans;
    pq_janus_ce.g_action_id                   := p_action_id;
    pq_janus_ce.g_trama                       := p_trama;

    exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.set_globals(p_id_telefonia => ' ||
                              p_id_telefonia || ', p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ', p_idtrans => ' ||
                              p_idtrans || ', p_action_id => ' || p_action_id ||
                              ', p_trama => ' || p_trama || ') ' || sqlerrm);
  END;*/
  /*********************************************************************
   PROCEDIMIENTO: Obtiene número máximo de reenvío.
   PARAMETROS:
      Salida:
        - l_cantidad: Número máximo de reenvíos configurado.
  *********************************************************************/
  FUNCTION get_cantidad_envio RETURN opedd.codigon%TYPE IS
    l_cantidad opedd.codigon%TYPE;

  BEGIN
    SELECT b.codigon
      INTO l_cantidad
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL_CE'
       AND b.abreviacion = 'BSCS_CANT_ENVIO';

    RETURN l_cantidad;

    exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_cantidad_envio() ' ||
                              sqlerrm);
  END;
  /*********************************************************************
   PROCEDIMIENTO: Ejecuta el proceso de envío a BSCS
  *********************************************************************/
  PROCEDURE reenvio_solicitud(p_idtrans             int_plataforma_bscs.idtrans%type,
                              p_id_telefonia_ce_det telefonia_ce_det.id_telefonia_ce_det%type,
                              p_id_telefonia_ce     telefonia_ce.id_telefonia_ce%type,
                              p_operacion           telefonia_ce.operacion%type) IS
  BEGIN
    operacion.pq_janus_ce_conexion.enviar_solicitud(p_idtrans,
                                                    p_id_telefonia_ce_det);
    update_telefonia_ce(p_id_telefonia_ce, p_operacion);
  END;
  /*********************************************************************
   PROCEDIMIENTO: Actualiza la cabecera del registro de envios
  *********************************************************************/
  PROCEDURE update_telefonia_ce(p_id_telefonia_ce telefonia_ce.id_telefonia_ce%type,
                                p_operacion       telefonia_ce.operacion%type) IS
    --l_log               operacion.telefonia_ce%ROWTYPE;
    l_idtareawf         operacion.telefonia_ce.idtareawf%type;
    l_envios_pendientes NUMBER;

  BEGIN
    SELECT t.idtareawf--t.*
      INTO l_idtareawf --l_log
      FROM operacion.telefonia_ce t
     WHERE t.id_telefonia_ce = p_id_telefonia_ce/*g_id_telefonia*/;

    l_envios_pendientes := get_cantidad_enviospendientes(l_idtareawf/*l_log.idtareawf*/);
    IF l_envios_pendientes = 0 THEN
      /*l_log.id_error := 0;
      l_log.mensaje  := 'OK';*/

      UPDATE operacion.telefonia_ce t
         SET id_error = 0, mensaje = 'Registro satisfactorio'/*'OK'*/, operacion = p_operacion--ROW = l_log
       WHERE t.id_telefonia_ce = p_id_telefonia_ce/*l_log.id_telefonia_ce*/;
    END IF;
  END;
  /*********************************************************************
   PROCEDIMIENTO: Envía notificación de correo si ocurre un error de webservice
                  al superar el máximo permitido de reintentos
   PARAMETROS:
      Entrada:
        - p_idlog: id de la tabla telefonia_ce_det (registro que obtiene el error)
  *********************************************************************/
  --cuando alcanza el limite de envios
  PROCEDURE send_mail_soporte_bscs(p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE) IS
    l_asunto       cola_send_mail_job.subject%TYPE;
    l_destino      cola_send_mail_job.destino%TYPE;
    l_mensaje      cola_send_mail_job.cuerpo%TYPE;
    l_ws_error_dsc operacion.telefonia_ce_det.ws_error_dsc%TYPE;
    l_linea        linea;

  BEGIN
    SELECT ws_error_dsc
      INTO l_ws_error_dsc
      FROM operacion.telefonia_ce_det
     WHERE id_telefonia_ce_det = p_id_telefonia_ce_det;

    l_linea := get_linea(p_id_telefonia_ce_det);

    l_asunto  := 'Soporte Transacción ' || TO_CHAR(l_linea.operation) ||
                 'en Plataforma JANUS, Número Solot :  ' ||
                 TO_CHAR(l_linea.codsolot);
    l_destino := get_email_soporte_envio_bscs();

    l_mensaje := NULL;
    l_mensaje := CHR(13) || l_mensaje || CHR(13) ||
                 'Se informa que la transacción ' || TO_CHAR(l_linea.tx_bscs);
    l_mensaje := l_mensaje || CHR(13) ||
                 ' no ha podido ser transaferida a BSCS ' || CHR(10);

    l_mensaje := l_mensaje || CHR(13) || ' idlog : ' || to_char(p_id_telefonia_ce_det);
    l_mensaje := l_mensaje || CHR(13) || ' Mensaje de error : ' ||
                 l_ws_error_dsc;

    p_envia_correo_de_texto_att(l_asunto, l_destino, l_mensaje);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, 
                               $$plsql_unit ||
                              '.send_mail_soporte_bscs(p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ') ' || sqlerrm);

  END;
  /*********************************************************************
   PROCEDIMIENTO: Envía notificación de correo un registro enviado a BSCS no ha sido
                  transferido a Janus y supera el máximo de horas permitidas.
   PARAMETROS:
      Entrada:
        - p_idlog: id de la tabla telefonia_ce_det (registro que supera el máximo de horas sin transferir a Janus)
  *********************************************************************/
  PROCEDURE send_mail_soporte_cierre_tarea(p_idlog operacion.telefonia_ce.id_telefonia_ce%TYPE) IS
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
  /*********************************************************************/
  FUNCTION get_linea(p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE)
    RETURN linea IS
    l_linea linea;

  BEGIN
    SELECT b.operacion, b.codsolot, a.idtrans, b.idtareawf
      INTO l_linea
      FROM operacion.telefonia_ce_det a, operacion.telefonia_ce b
     WHERE a.id_telefonia_ce = b.id_telefonia_ce
       AND a.id_telefonia_ce_det = p_id_telefonia_ce_det;

    RETURN l_linea;

   exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_linea(p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ') ' || sqlerrm);
  END;
  /*********************************************************************/
  FUNCTION get_email_soporte_envio_bscs RETURN opedd.descripcion%TYPE IS
    l_correo opedd.descripcion%TYPE;

  BEGIN
    SELECT b.descripcion
      INTO l_correo
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL_CE'
       AND b.abreviacion = 'BSCS_CORREO_SOPRTE';

    RETURN l_correo;

    exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_email_soporte_envio_bscs() ' || sqlerrm);
  END;
  /* **********************************************************************************************/
  FUNCTION get_email_soporte_cerrar_janus RETURN opedd.descripcion%TYPE IS
    l_correo opedd.descripcion%TYPE;

  BEGIN
    SELECT b.descripcion
      INTO l_correo
      FROM tipopedd a, opedd b
     WHERE a.tipopedd = b.tipopedd
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL_CE'
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
       AND a.abrev = 'BSCS_SHELL_PLAT_TEL_CE'
       AND b.abreviacion = 'HORAS_SIN_CERRAR_TAREA_JANUS';

    RETURN l_horas;
  END;
  /* **********************************************************************************************/
  FUNCTION get_horas_sin_cerrar_janus(p_idwf wf.idwf%TYPE,
                                      p_idtareawf operacion.telefonia_ce.idtareawf%type) 
    RETURN NUMBER IS
    l_horas NUMBER;

  BEGIN
    SELECT TO_NUMBER(TRUNC((SYSDATE - a.fecini) * 24))
      INTO l_horas
      FROM tareawf a
     WHERE a.idwf = p_idwf
       AND a.idtareawf = p_idtareawf/*g_idtareawf_valida_janus*/;

    RETURN l_horas;
  END;
  /* **********************************************************************************************/
  FUNCTION get_envios_realizados(p_id_telefonia_ce_det operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE)
    RETURN operacion.telefonia_ce_det.ws_envios%TYPE IS
    l_ws_envios operacion.telefonia_ce_det.ws_envios%TYPE;

  BEGIN
    SELECT a.ws_envios
      INTO l_ws_envios
      FROM operacion.telefonia_ce_det a
     WHERE a.id_telefonia_ce_det = p_id_telefonia_ce_det;

    RETURN l_ws_envios;

    exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              '.get_envios_realizados(p_id_telefonia_ce_det => ' ||
                              p_id_telefonia_ce_det || ') ' || sqlerrm);
  END;
  /* **********************************************************************************************/
  PROCEDURE main_cerrar_tarea_janus IS
    l_idwf                   wf.idwf%TYPE; --2.0
    ln_tramas_pendientes     NUMBER;
    l_estado_tx_janus        NUMBER;
    --l_horas_permitidas       NUMBER;
    --l_horas_sin_cerrar_janus NUMBER;
    --c_error_datos_invalidos  VARCHAR(30) := 'Datos ingresados invalidos';
    --c_error_ejec_sql         VARCHAR(30) := 'Error al ejecutar SQL';
    l_idtrans operacion.telefonia_ce_det.idtrans%type;

    --ini 2.0
    --CURSOR solicitud_bscs IS
    --SELECT a.idtareawf, a.idwf, b.id_telefonia_ce_det, b.idtrans
    CURSOR c_verifica_cabecera IS
      SELECT DISTINCT a.idwf
      --fin 2.0
        FROM operacion.telefonia_ce a, operacion.telefonia_ce_det b
       WHERE a.id_telefonia_ce = b.id_telefonia_ce
         AND b.idtrans IS NOT NULL
            --ini 3.0
            /*AND NVL(b.ws_error_dsc, '%') NOT IN
            (c_error_datos_invalidos, c_error_ejec_sql)*/
         and b.ws_error_dsc ='Registro satisfactorio'
            --fin 3.0
         AND (b.verificado = 0 OR b.verificado IS NULL);
    --ini 2.0
    CURSOR c_verifica_detalle IS --<2.0>
      SELECT a.idtareawf, a.idwf, b.id_telefonia_ce_det, b.idtrans
        FROM operacion.telefonia_ce a, operacion.telefonia_ce_det b
       WHERE a.id_telefonia_ce = b.id_telefonia_ce
         AND b.idtrans IS NOT NULL
            --ini 3.0
            /*         AND NVL(b.ws_error_dsc, '%') NOT IN
            (c_error_datos_invalidos, c_error_ejec_sql)*/
         and b.ws_error_dsc ='Registro satisfactorio'
            --fin 3.0
         AND (b.verificado = 0 OR b.verificado IS NULL)
         AND a.idwf = l_idwf;
    --fin 2.0

  BEGIN
    /*ini 2.0
    ln_tramas_pendientes := 0;
      FOR solicitud IN solicitud_bscs LOOP
        l_estado_tx_janus        := get_status_tx_janus(solicitud.idtrans);
        g_idtareawf_valida_janus := solicitud.idtareawf;

        IF l_estado_tx_janus = 1 THEN
          update_telefonia_ce_det(solicitud.id_telefonia_ce_det);
        ELSE
          ln_tramas_pendientes     := ln_tramas_pendientes + 1;
          l_horas_sin_cerrar_janus := get_horas_sin_cerrar_janus(solicitud.idwf);
          l_horas_permitidas       := get_horas_permitidas_janus();

          IF l_horas_permitidas <= l_horas_sin_cerrar_janus THEN
            send_mail_soporte_cierre_tarea(solicitud.id_telefonia_ce_det);
          END IF;
        END IF;

      END LOOP;

      IF ln_tramas_pendientes = 0 THEN
        opewf.pq_wf.p_chg_status_tareawf(g_idtareawf_valida_janus,
                                         4,
                                         4,
                                         0,
                                         SYSDATE,
                                         SYSDATE);
      END IF;

      COMMIT;
    */
    FOR solicitud_cabecera IN c_verifica_cabecera LOOP
      BEGIN--3.0
        l_idwf               := solicitud_cabecera.Idwf;
        ln_tramas_pendientes := 0;
        FOR solicitud_detalle IN c_verifica_detalle LOOP

          l_estado_tx_janus        := get_status_tx_janus(solicitud_detalle.idtrans);
          l_idtrans /*g_idtareawf_valida_janus*/ := solicitud_detalle.idtareawf;

          IF l_estado_tx_janus = pq_janus_procesos.get_estado_generada_bscs() THEN
            update_telefonia_ce_det(solicitud_detalle.id_telefonia_ce_det);
          ELSE
            ln_tramas_pendientes := ln_tramas_pendientes + 1;

            --ini 3.0
            /* l_horas_sin_cerrar_janus := get_horas_sin_cerrar_janus(solicitud_detalle.idwf, l_idtrans);
            l_horas_permitidas       := get_horas_permitidas_janus();

            IF l_horas_permitidas <= l_horas_sin_cerrar_janus THEN
              send_mail_soporte_cierre_tarea(solicitud_detalle.id_telefonia_ce_det);
            END IF;*/
            --fin 3.0
          END IF;

        END LOOP;

        IF ln_tramas_pendientes = 0 THEN
          opewf.pq_wf.p_chg_status_tareawf(l_idtrans /*g_idtareawf_valida_janus*/,
                                           4,
                                           4,
                                           0,
                                           SYSDATE,
                                           SYSDATE);

        END IF;

        COMMIT;
        --ini 3.0
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --fin 3.0
    END LOOP;
    --fin 2.0

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              'Error en proceso de cierre automático de tareas JANUS.');
  END;
  /* **********************************************************************************************/
  FUNCTION get_status_tx_janus(p_idtrans operacion.telefonia_ce_det.idtrans%TYPE)
    RETURN operacion.telefonia_ce_det.verificado%TYPE IS
    l_estado_janus    operacion.telefonia_ce_det.verificado%TYPE;
    l_transaccion     transaccion;
    l_respuesta       NUMBER(2);
    l_descripcion_rpt VARCHAR2(200);

  BEGIN
    --g_idtrans := p_idtrans;

    l_transaccion := get_transaccion(p_idtrans);
    tim.pp001_pkg_prov_janus.sp_estado_prov@DBL_BSCS_BF(l_transaccion.idtrans,
                                                        l_transaccion.action_id,
                                                        l_transaccion.co_id,
                                                        l_estado_janus,
                                                        l_respuesta,
                                                        l_descripcion_rpt);

    --l_estado_janus := 5;

    RETURN l_estado_janus;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_STATUS_TX_JANUS: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/

  FUNCTION get_transaccion(p_idtrans operacion.telefonia_ce_det.idtrans%type) 
    RETURN transaccion IS
    l_transaccion transaccion;

  BEGIN
    SELECT b.idtrans, b.action_id, b.co_id
      INTO l_transaccion
      FROM operacion.int_plataforma_bscs b
     WHERE b.idtrans = p_idtrans/*g_idtrans*/;

    RETURN l_transaccion;
  END;
  /* **********************************************************************************************/
  PROCEDURE update_telefonia_ce_det(p_idlog operacion.telefonia_ce_det.id_telefonia_ce_det%TYPE) IS
  BEGIN
    UPDATE operacion.telefonia_ce_det t
       SET t.verificado = 1
     WHERE t.id_telefonia_ce_det = p_idlog;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA_CE_DET: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE cerrar_tarea_linea_c(p_idtareawf tareawf.idtareawf%TYPE,
                                 p_idwf      tareawf.idwf%TYPE,
                                 p_tarea     tareawf.tarea%TYPE,
                                 p_tareadef  tareawf.tareadef%TYPE,

                                 a_tipesttar tareawf.tipesttar%TYPE,
                                 a_esttarea  tareawf.esttarea%TYPE,
                                 a_mottarchg tareawf.mottarchg%TYPE,
                                 a_fecini    tareawf.feccom%TYPE,
                                 a_fecfin    tareawf.fecfin%TYPE) IS

    l_tramas_pendientes NUMBER;
    l_estado_tx_janus   NUMBER;
    l_estado_tarea      NUMBER;
    error_tramas_pendientes EXCEPTION;

    CURSOR solicitud_bscs IS
      SELECT a.idtareawf, a.idwf, b.id_telefonia_ce_det, b.idtrans
        FROM operacion.telefonia_ce a, operacion.telefonia_ce_det b
       WHERE a.id_telefonia_ce = b.id_telefonia_ce
         AND b.idtrans IS NOT NULL
         AND (b.verificado = 0 OR b.verificado IS NULL)
         AND a.idwf = p_idwf;
  BEGIN
    l_tramas_pendientes := 0;
    l_estado_tarea      := get_estadotarea(p_idtareawf);

    IF l_estado_tarea IN (1, 2) AND a_esttarea = 4 THEN
      FOR solicitud IN solicitud_bscs LOOP
        l_estado_tx_janus := get_status_tx_janus(solicitud.idtrans);
        --ini 2.0
        --IF l_estado_tx_janus = 1 THEN
        IF l_estado_tx_janus = pq_janus_procesos.get_estado_generada_bscs() THEN
          --fin 2.0
          update_telefonia_ce_det(solicitud.id_telefonia_ce_det);
        ELSE
          l_tramas_pendientes := l_tramas_pendientes + 1;
        END IF;
      END LOOP;

      /*IF l_tramas_pendientes <> 0 THEN
        RAISE error_tramas_pendientes;
      END IF;*/
    END IF;
  EXCEPTION
    WHEN error_tramas_pendientes THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'No es posible cerrar la tarea ya que existen ' ||
                              to_char(l_tramas_pendientes) ||
                              ' envíos a la plataforma BSCS pendientes de confirmar.');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.P_CERRAR_TAREA_MANUAL: ' ||
                              SQLERRM);

  END;
  /* **********************************************************************************************/
  FUNCTION get_estadotarea(p_idtareawf tareawf.idtareawf%TYPE) RETURN NUMBER IS
    l_estado_tarea NUMBER;
  BEGIN
    SELECT esttarea
      INTO l_estado_tarea
      FROM tareawf
     WHERE idtareawf = p_idtareawf;

    RETURN l_estado_tarea;
  END;
  /* **********************************************************************************************/
  PROCEDURE cambiar_estado_tareawf(p_idtareawf tareawf.idtareawf%TYPE) IS
    l_envios_pendientes NUMBER;
  BEGIN
    l_envios_pendientes := get_cantidad_enviospendientes(p_idtareawf);
    IF l_envios_pendientes = 0 THEN
      UPDATE tareawf SET esttarea = 2 WHERE idtareawf = p_idtareawf;
    END IF;
  END;
  /* **********************************************************************************************/
  FUNCTION get_cantidad_enviospendientes(p_idtareawf tareawf.idtareawf%TYPE)
    RETURN NUMBER IS
    l_envios_pendientes NUMBER;
    c_error_conexion_ws PLS_INTEGER := -1;
  BEGIN
    SELECT COUNT(*)
      INTO l_envios_pendientes
      FROM operacion.telefonia_ce a, operacion.telefonia_ce_det b
     WHERE a.id_telefonia_ce = b.id_telefonia_ce
       AND NVL(b.id_ws_error, c_error_conexion_ws) = c_error_conexion_ws
       AND b.idtrans IS NOT NULL
       AND a.idtareawf = p_idtareawf;

    IF l_envios_pendientes IS NULL THEN
      l_envios_pendientes := 0;
    END IF;

    RETURN l_envios_pendientes;
  END;
  /* **********************************************************************************************/
END;
/