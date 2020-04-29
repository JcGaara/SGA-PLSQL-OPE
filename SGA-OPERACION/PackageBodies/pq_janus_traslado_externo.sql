CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_traslado_externo IS
  /****************************************************************************************************
     NAME:       PQ_JANUS_SOT_TRASLADO_EXTERNO
     PURPOSE:    Ejecutar proceso traslado externo en plataforma JANUS

     REVISIONS:
     Ver        Date        Author            Solicitado por      Description
     ---------  ----------  ---------------   --------------      ----------------------
     1.0        20/02/2014  Eustaquio Gibaja  Christian Riquelme  Version inicial
     2.0        18/02/2014  Eustaquio Gibaja  Christian Riquelme  Mejoras
     3.0        11/07/2014  Juan Gonzales     Christian Riquelme  Cambio de Orden de transacciones 1 - Baja / 2 - Alta
     4.0        28/01/2015  Eustaquio Giabaja Christian Riquelme  Mejoras en la obtencion del WF de origen
  ***************************************************************************************************/

  PROCEDURE EXECUTE(p_idtareawf IN NUMBER,
                    p_idwf      IN NUMBER,
                    p_tarea     IN NUMBER,
                    p_tareadef  IN NUMBER) IS

  BEGIN
    pq_int_telefonia.set_globals(p_idtareawf, p_idwf, p_tarea, p_tareadef);

    IF NOT pq_int_telefonia.es_telefonia() THEN
      RETURN;
    END IF;
    --ini 3.0
    /*alta_telefonia();

    IF pq_int_telefonia.es_janus() THEN
      baja();
      update_int_telefonia();
    END IF;*/

    IF pq_int_telefonia.es_janus() THEN
      baja();
      operacion.pq_janus.timer(get_timer());
    END IF;

    alta_telefonia();
    update_int_telefonia();
    --fin 3.0
    operacion.pq_janus.crear_tareawfseg();

  EXCEPTION
    WHEN OTHERS THEN
      cambio_status_tarea_error();
      pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* **********************************************************************************************/
  --ini 3.0
  FUNCTION get_timer RETURN opedd.codigon%TYPE IS
    l_config opedd.codigon%TYPE;

  BEGIN
    SELECT d.codigon
      INTO l_config
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = 'TIMER';

    RETURN l_config;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_TIMER: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  --fin 3.0
  PROCEDURE alta_telefonia IS

  BEGIN

    IF NOT pq_int_telefonia.es_masivo_hfc() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ALTA: NO ES MASIVO HFC');
    END IF;

    IF pq_int_telefonia.esta_registrado('ALTA') THEN
      RETURN;
    END IF;
    --ini 3.0
    --pq_int_telefonia.crear_int_telefonia();
    IF NOT pq_int_telefonia.es_janus() THEN
      pq_int_telefonia.crear_int_telefonia();
    END IF;
    --fin 3.0
    pq_int_telefonia.g_operacion := 'ALTA';
    pq_int_telefonia.g_origen    := pq_int_telefonia.get_plataforma();
    pq_int_telefonia.g_destino   := pq_int_telefonia.g_origen;

    IF pq_int_telefonia.g_origen = 'JANUS' THEN
      pq_janus_utl.set_globals(pq_int_telefonia.g_idwf);
      alta();
    ELSIF pq_int_telefonia.g_origen = 'TELLIN' THEN
      operacion.pq_tellin_alta.alta();
    ELSIF pq_int_telefonia.g_origen = 'ABIERTA' THEN
      operacion.pq_abierta.alta();
    END IF;

    pq_int_telefonia.update_int_telefonia();

  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logger(SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE alta IS

  BEGIN

    pq_janus_utl.crear_int_plataforma_bscs_alta();

    crear_int_telefonia_log();

    pq_janus_conexion.enviar_solicitud();

    pq_janus.update_int_plataforma_bscs();

    operacion.pq_int_telefonia.update_int_telefonia_log();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ALTA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/

  PROCEDURE baja IS

    l_idwf_ori tareawfcpy.idwf%TYPE;

  BEGIN

    l_idwf_ori := get_idwf_origen();
    pq_janus_utl.set_globals(l_idwf_ori);

    pq_int_telefonia.crear_int_telefonia(); --3.0

    pq_janus_utl.crear_int_plataforma_bscs_baja();

    crear_int_telefonia_log();

    pq_janus_conexion.enviar_solicitud();

    pq_janus.update_int_plataforma_bscs();

    pq_int_telefonia.update_int_telefonia_log();

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.BAJA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  FUNCTION get_idwf_origen RETURN tareawfcpy.idwf%TYPE IS

    p_idwf_origen tareawfcpy.idwf%TYPE;
    --ini 2.0
    p_tiptra_desact tiptrabajo.tiptra%TYPE := 7;
    --fin 2.0
  BEGIN

    SELECT y.idwf
      INTO p_idwf_origen
      FROM solot x, wf y
     WHERE x.codsolot = y.codsolot
       AND x.numslc IN (SELECT c.numslc_ori
                          FROM wf a, solot b, sales.regvtamentab c
                         WHERE a.codsolot = b.codsolot
                           AND b.numslc = c.numslc
                           AND a.idwf = pq_int_telefonia.g_idwf)
          --ini 2.0
       AND x.tiptra <> p_tiptra_desact
       AND Y.VALIDO=1; --4.0
    --fin 2.0

    RETURN p_idwf_origen;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_IDWF_ORIGEN: ' || SQLERRM);
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

    SELECT a.id
      INTO l_id_int_telefonia
      FROM operacion.int_telefonia a
     WHERE a.idwf = pq_int_telefonia.g_idwf;

    RETURN l_id_int_telefonia;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_ID_TELEFONIA: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE update_int_telefonia IS
    l_tel operacion.int_telefonia%ROWTYPE;

  BEGIN

    SELECT t.*
      INTO l_tel
      FROM operacion.int_telefonia t
     WHERE t.id = get_id_telefonia();

    l_tel.operacion := 'TRASLADO_EXTERNO';
    l_tel.error_id  := 0;

    UPDATE operacion.int_telefonia t SET ROW = l_tel WHERE t.id = l_tel.id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.UPDATE_INT_TELEFONIA: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE cambio_status_tarea_error IS

    l_esttarea_error opewf.esttarea.esttarea%TYPE := 15; --error envío plataforma
    l_tipesttar      opewf.esttarea.tipesttar%TYPE;

  BEGIN

    SELECT tipesttar
      INTO l_tipesttar
      FROM esttarea
     WHERE esttarea = l_esttarea_error;

    OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(pq_int_telefonia.g_idtareawf,
                                     l_tipesttar,
                                     l_esttarea_error,
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CAMBIO_STATUS_TAREA_ERROR: ' ||
                              SQLERRM);
  END;
  /* **********************************************************************************************/
END;
/
