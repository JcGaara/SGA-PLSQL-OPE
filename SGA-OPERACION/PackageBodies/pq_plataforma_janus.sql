CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_PLATAFORMA_JANUS IS
  /***********************************************************************************************************
   PROPOSITO: Plataformas Telefonica
  
   REVISIONES:
   Version  Fecha       Autor          Solicitado por            Descripcion
   -------  -----       -----          --------------            -----------
   1.0      12/03/2014  Jose Soto Guevara  Christian Riquelme  Proceso de Susp.Corte  y Reconexion en JANUS
   2.0      30/05/2014  Jose Soto Guevara  Christian Riquelme  Inclusion de Validacion de WF - HFC
   3.0      04/06/2014  Jose Soto Guevara  Christian Riquelme  Mejoras
  /* **********************************************************************************************************/
  PROCEDURE p_error_tarea IS
    xs_tipesttar opewf.esttarea.tipesttar%TYPE;
  
  BEGIN
    SELECT tipesttar
      INTO xs_tipesttar
      FROM opewf.esttarea
     WHERE esttarea = CN_ESTTAREA_ERROR;
  
    opewf.pq_wf.p_chg_status_tareawf(pq_int_telefonia.g_idtareawf,
                                     xs_tipesttar,
                                     CN_ESTTAREA_ERROR,
                                     0,
                                     SYSDATE,
                                     SYSDATE);
  END p_error_tarea;
  /*************************************************************/
  PROCEDURE p_inserta_tarea(an_idtareawf tareawf.idtareawf%TYPE,
                            as_texto     VARCHAR2) IS
  
  BEGIN
    INSERT INTO opewf.tareawfseg
      (idtareawf, observacion)
    VALUES
      (an_idtareawf, as_texto);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.P_INSERTA_TAREA: ' || SQLERRM);
  END;
  /*************************************************************/
  PROCEDURE p_update_telef IS
  BEGIN
    UPDATE operacion.int_telefonia i
       SET i.error_id = 0
     WHERE i.id = gn_id_telefonia;
  END;
  /*************************************************************/
  PROCEDURE p_update_bscs(an_id        NUMBER,
                          an_resultado NUMBER,
                          as_mensaje   VARCHAR2) IS
  
  BEGIN
    UPDATE operacion.int_plataforma_bscs
       SET resultado = an_resultado, message_resul = as_mensaje
     WHERE idtrans = an_id;
  END;
  /*************************************************************/
  PROCEDURE p_update_log(an_id        NUMBER,
                         an_resultado NUMBER,
                         as_mensaje   VARCHAR2) IS
  
  BEGIN
    UPDATE operacion.int_telefonia i
       SET i.mensaje = as_mensaje
     WHERE i.id = gn_id_telefonia;
  
    UPDATE operacion.int_telefonia_log a
       SET a.ws_error_id = an_resultado, a.ws_error_dsc = as_mensaje
     WHERE a.idtrans = an_id;
  END;
  /*************************************************************/
  FUNCTION f_valida_janus(an_idwf NUMBER) RETURN NUMBER IS
    xn_es_janus NUMBER := 0;
  
  BEGIN
    dbms_output.put_line(an_idwf);
  
    IF operacion.pq_int_telefonia.es_janus() THEN
      xn_es_janus := 1;
    END IF;
  
    RETURN xn_es_janus;
  END;
  /*************************************************************/
  FUNCTION f_get_codclie_janus(an_sot NUMBER) RETURN VARCHAR2 IS
    xs_codclie operacion.solot.codcli%TYPE;
  
  BEGIN
    SELECT DISTINCT s.codcli
      INTO xs_codclie
      FROM solot s
     WHERE s.codsolot = an_sot;
  
    RETURN xs_codclie;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_GET_CODCLIE_JANUS: ' ||
                              SQLERRM);
  END;
  /*************************************************************/
  FUNCTION f_prefijo RETURN VARCHAR2 IS
    xs_prefijo VARCHAR2(100);
  
  BEGIN
  
    xs_prefijo := operacion.pq_janus.get_conf('P_HCTR');
  
    RETURN xs_prefijo;
  
  END;
  /*************************************************************/
  /** ini 2.0  **/
  PROCEDURE p_inserta_int_telefonia(as_operacion VARCHAR2,
                                    an_idtareawf NUMBER,
                                    an_idwf      NUMBER,
                                    an_tarea     NUMBER,
                                    an_tareadef  NUMBER,
                                    as_origen    VARCHAR2,
                                    as_destino   VARCHAR2,
                                    an_sot       NUMBER,
                                    as_platf     VARCHAR2,
                                    an_innsrv    NUMBER,
                                    as_numero    VARCHAR2,
                                    /**** ini 3.0    ****/
                                    -- an_pid
                                    /***  fin 3.0   ***/
                                    an_janus   NUMBER,
                                    as_tx_bscs VARCHAR2,
                                    an_sga_id  NUMBER,
                                    as_sga_dsc VARCHAR2) IS
    an_id NUMBER;
  
  BEGIN
    BEGIN
      INSERT INTO operacion.int_telefonia
        (operacion,
         idtareawf,
         idwf,
         tarea,
         tareadef,
         plataforma_origen,
         plataforma_destino,
         codsolot)
      VALUES
        (as_operacion,
         an_idtareawf,
         an_idwf,
         an_tarea,
         an_tareadef,
         as_origen,
         as_destino,
         an_sot)
      RETURNING id INTO an_id;
    END;
  
    BEGIN
      INSERT INTO operacion.int_telefonia_log
        (int_telefonia_id,
         plataforma,
         codinssrv,
         numero,
         /**** ini 3.0    ****/
         -- an_pid
         /***  fin 3.0   ***/
         idtrans,
         tx_bscs,
         sga_error_id,
         sga_error_dsc)
      VALUES
        (an_id,
         as_platf,
         an_innsrv,
         as_numero,
         /**** ini 3.0    ****/
         -- an_pid
         /***  fin 3.0   ***/
         an_janus,
         as_tx_bscs,
         an_sga_id,
         as_sga_dsc);
    
      gn_id_telefonia := an_id;
    
      pq_int_telefonia_log.g_id := an_id;
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.P_INSERTA_INT_TELEFONIA: ' ||
                              SQLERRM);
  END;
  /** fin 2.0  **/
  /*************************************************************/
  PROCEDURE p_suspension_janus(an_idtareawf tareawf.idtareawf%TYPE,
                               an_idwf      tareawf.idwf%TYPE,
                               an_tarea     tareawf.tarea%TYPE,
                               an_tareadef  tareawf.tareadef%TYPE) IS
    an_sot       NUMBER;
    xn_resultado NUMBER;
    xs_mensaje   VARCHAR2(200);
    xn_valida    NUMBER;
    xs_codclie   operacion.solot.codcli%TYPE;
    xs_numero    operacion.inssrv.numero%TYPE;
    xn_codinssrv operacion.inssrv.codinssrv%TYPE;
    xs_codinssrv VARCHAR2(15);
    /***  ini 3.0   ***/
    --xn_pid       number;
    /***  fin 3.0 ***/
    xn_action_id  NUMBER;
    xs_apeclie    vtatabcli.nomclires%TYPE;
    xs_nomclie    vtatabcli.nomclires%TYPE;
    xs_co_id      VARCHAR2(15);
    xs_imsi       VARCHAR2(15);
    xs_trama      VARCHAR2(1500);
    xn_idtrans_ws NUMBER;
    xs_prefijo    VARCHAR2(20);
    xs_suspension VARCHAR2(50);
  
  BEGIN
    /** ini 2.0  **/
    operacion.pq_int_telefonia.set_globals(an_idtareawf,
                                           an_idwf,
                                           an_tarea,
                                           an_tareadef);
  
    IF NOT operacion.pq_int_telefonia.es_telefonia() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
  
    IF NOT operacion.pq_int_telefonia.es_masivo_hfc() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
    /** fin 2.0 **/
    an_sot    := f_get_sot(an_idwf);
    xn_valida := f_valida_janus(an_idwf);
  
    IF xn_valida > 0 THEN
      -- Validando si existen servicios Janus
      xs_codclie := f_get_codclie_janus(an_sot);
      gs_imsi    := f_imsi();
    
      BEGIN
        SELECT vt.nomcli, vt.apepat || ' ' || vt.apmat
          INTO xs_nomclie, xs_apeclie
          FROM vtatabcli vt
         WHERE vt.codcli = xs_codclie;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NOMBRE DE CLIENTE NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NOMBRE DE CLIENTE ENCONTRADO');
      END;
    
      BEGIN
        SELECT i.numero, i.codinssrv
          INTO xs_numero, xn_codinssrv
          FROM operacion.inssrv i
         WHERE i.tipinssrv = 3
           AND i.codinssrv IN
               (SELECT sp.codinssrv FROM solotpto sp WHERE sp.codsolot = an_sot);
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NUMERO TELEFONICO NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NUMERO TELEFONICO ENCONTRADO');
      END;
    
      xs_suspension := f_operacion_susp();
      /***  ini 3.0   ***/
      -- xn_pid               := f_get_pid(gs_numslc) ;
      /***  fin 3.0   ***/
      xs_codinssrv := TO_CHAR(xn_codinssrv);
      xs_prefijo   := operacion.pq_janus.get_conf('P_HCTR');
      xs_co_id     := xs_prefijo || xs_codinssrv;
      xs_imsi      := gs_imsi || xs_numero;
      xn_action_id := f_action_id(xs_suspension);
      xs_trama     := xs_numero || '|' || xs_imsi || '|' || xs_co_id;
    
      p_inserta_plataforma_bscs(xs_codclie,
                                xs_nomclie,
                                xs_apeclie,
                                xs_co_id,
                                xn_action_id,
                                xs_trama,
                                xs_imsi,
                                xn_idtrans_ws);
      /*** ini 2.0  ***/
      p_inserta_int_telefonia(xs_suspension,
                              an_idtareawf, -- se agrego para eliminar warning
                              an_idwf, -- se agrego para eliminar warning
                              an_tarea, -- se agrego para eliminar warning
                              an_tareadef, -- se agrego para eliminar warning
                              f_trs_operacion,
                              f_trs_operacion,
                              an_sot,
                              f_trs_operacion,
                              xn_codinssrv,
                              xs_numero,
                              /***  ini 3.0**/
                              -- xn_pid,
                              /****  fin 3.0   ***/
                              xn_idtrans_ws,
                              xs_suspension,
                              0,
                              f_ok);
    
      /** *fin 2.0  ***/
      operacion.pq_janus_comunicacion.enviar_solicitud(xn_idtrans_ws,
                                                       xn_action_id,
                                                       xs_trama);
    
      xn_resultado := operacion.pq_janus_comunicacion.g_codigo;
      xs_mensaje   := operacion.pq_janus_comunicacion.g_mensaje;
    
      -- Actualiza BSCS
      p_update_bscs(xn_idtrans_ws, xn_resultado, xs_mensaje);
      --  Inserta Tareas
      p_inserta_tarea(an_idtareawf, xs_mensaje);
      -- Actualizando log
      p_update_log(gn_id_telefonia, xn_resultado, xs_mensaje);
      -- Actualiza cabecera
      p_update_telef();
    ELSE
      operacion.pq_int_telefonia.no_interviene();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logger(SQLERRM);
  END;
  /*************************************************************/
  PROCEDURE p_inserta_plataforma_bscs(as_codcli    IN VARCHAR2,
                                      as_nombre    IN VARCHAR2,
                                      as_apellido  IN VARCHAR2,
                                      as_co_id     IN VARCHAR2,
                                      an_action_id IN NUMBER,
                                      as_trama     IN VARCHAR2,
                                      as_imsi      IN VARCHAR2,
                                      an_idtrans   OUT NUMBER) IS
  
  BEGIN
    INSERT INTO operacion.int_plataforma_bscs
      (codigo_cliente, nombre, apellidos, co_id, action_id, trama, imsi)
    VALUES
      (as_codcli,
       as_nombre,
       as_apellido,
       as_co_id,
       an_action_id,
       as_trama,
       as_imsi)
    
    RETURNING idtrans INTO an_idtrans;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.P_INSERTA_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /*************************************************************/
  PROCEDURE p_corte_janus(an_idtareawf tareawf.idtareawf%TYPE,
                          an_idwf      tareawf.idwf%TYPE,
                          an_tarea     tareawf.tarea%TYPE,
                          an_tareadef  tareawf.tareadef%TYPE) IS
    exception_actv EXCEPTION;
    an_sot NUMBER;
    --- variables miscelaneos
    xn_resultado NUMBER;
    xs_mensaje   VARCHAR2(200);
    xn_valida    NUMBER;
    xs_codclie   operacion.solot.codcli%TYPE;
    xs_numero    operacion.inssrv.numero%TYPE;
    xn_codinssrv operacion.inssrv.codinssrv%TYPE;
    xs_codinssrv VARCHAR2(15);
    /**** ini 3.0  **/
    -- xn_pid       number;
    /***  fin 3.0   ***/
    -- Variables tabla transaccional BSCS
    xn_action_id  NUMBER;
    xs_apeclie    VARCHAR2(200);
    xs_nomclie    vtatabcli.nomclires%TYPE;
    xs_co_id      VARCHAR2(15);
    xs_imsi       VARCHAR2(15);
    xs_trama      VARCHAR2(1500);
    xn_idtrans_ws NUMBER;
    xs_prefijo    VARCHAR2(20);
    xs_corte      VARCHAR2(50);
  
  BEGIN
    /*** ini 2.0  ***/
    operacion.pq_int_telefonia.set_globals(an_idtareawf,
                                           an_idwf,
                                           an_tarea,
                                           an_tareadef);
  
    IF NOT operacion.pq_int_telefonia.es_telefonia() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
  
    IF NOT operacion.pq_int_telefonia.es_masivo_hfc() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
    /***  fin 2.0  ***/
    an_sot    := f_get_sot(an_idwf);
    xn_valida := f_valida_janus(an_idwf);
  
    IF xn_valida > 0 THEN
      -- Validando si existen servicios Janus    
      xs_codclie := f_get_codclie_janus(an_sot);
      gs_imsi    := f_imsi();
    
      -- buscamos los servcios y el proyecto de Alta al que pertenecen    
      BEGIN
        SELECT i.numero, i.codinssrv
          INTO xs_numero, xn_codinssrv
          FROM inssrv i
         WHERE i.tipinssrv = 3 --telefonia
           AND i.codinssrv IN
               (SELECT sp.codinssrv FROM solotpto sp WHERE sp.codsolot = an_sot);
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NUMERO TELEFONICO NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NUMERO TELEFONICO ENCONTRADO');
      END;
    
      xs_corte     := f_operacion_cort();
      xs_codinssrv := TO_CHAR(xn_codinssrv);
      xs_prefijo   := operacion.pq_janus.get_conf('P_HCTR');
      xs_co_id     := xs_prefijo || xs_codinssrv;
      xs_imsi      := gs_imsi || xs_numero;
      xn_action_id := f_action_id(xs_corte);
      xs_trama     := xs_numero || '|' || xs_imsi || '|' || xs_co_id;
    
      --xn_pid := f_get_pid(gs_numslc) ;  /****  modificado 04.06 ***/
    
      BEGIN
        SELECT vt.nomcli, vt.apepat || ' ' || vt.apmat
          INTO xs_nomclie, xs_apeclie
          FROM vtatabcli vt
         WHERE vt.codcli = xs_codclie;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NOMBRE DE CLIENTE NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NOMBRE DE CLIENTE ENCONTRADO');
      END;
    
      p_inserta_plataforma_bscs(xs_codclie,
                                xs_nomclie,
                                xs_apeclie,
                                xs_co_id,
                                xn_action_id,
                                xs_trama,
                                xs_imsi,
                                xn_idtrans_ws);
    
      /** ini  2.0  ***/
      p_inserta_int_telefonia(xs_corte,
                              an_idtareawf,
                              an_idwf,
                              an_tarea,
                              an_tareadef,
                              f_trs_operacion(),
                              f_trs_operacion(),
                              an_sot,
                              f_trs_operacion(),
                              xn_codinssrv,
                              xs_numero,
                              -- xn_pid,   /****  04.06 **/
                              xn_idtrans_ws,
                              xs_corte,
                              0,
                              f_ok);
      /** fin 2.0  ***/
    
      operacion.pq_janus_comunicacion.enviar_solicitud(xn_idtrans_ws,
                                                       xn_action_id,
                                                       xs_trama);
    
      xn_resultado := operacion.pq_janus_comunicacion.g_codigo;
      xs_mensaje   := operacion.pq_janus_comunicacion.g_mensaje;
    
      -- Actualiza BSCS
      p_update_bscs(xn_idtrans_ws, xn_resultado, xs_mensaje);
      -- Inserta Tareas
      p_inserta_tarea(an_idtareawf, xs_mensaje);
      -- Actualizando log
      p_update_log(gn_id_telefonia, xn_resultado, xs_mensaje);
      -- Actualiza cabecera
      p_update_telef();
    ELSE
      operacion.pq_int_telefonia.no_interviene();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logger(SQLERRM);
  END;
  /*********************************************************/
  PROCEDURE p_reconexion_janus(an_idtareawf tareawf.idtareawf%TYPE,
                               an_idwf      tareawf.idwf%TYPE,
                               an_tarea     tareawf.tarea%TYPE,
                               an_tareadef  tareawf.tareadef%TYPE) IS
    an_sot       NUMBER;
    xn_resultado NUMBER;
    xs_mensaje   VARCHAR2(200);
    xn_valida    NUMBER;
    xs_codclie   operacion.solot.codcli%TYPE;
    xs_numero    operacion.inssrv.numero%TYPE;
    xn_codinssrv operacion.inssrv.codinssrv%TYPE;
    xs_codinssrv VARCHAR2(15);
    /***  ini 3.0  ***/
    --- xn_pid        number;
    /**** fin 3.0 ***/
    xn_action_id  NUMBER;
    xs_apeclie    VARCHAR2(200);
    xs_nomclie    vtatabcli.nomclires%TYPE;
    xs_co_id      VARCHAR2(15);
    xs_imsi       VARCHAR2(15);
    xs_trama      VARCHAR2(1500);
    xn_idtrans_ws NUMBER;
    xs_prefijo    VARCHAR2(20);
    xs_recon      VARCHAR2(50);
  
  BEGIN
    /*** ini 2.0  ***/
    operacion.pq_int_telefonia.set_globals(an_idtareawf,
                                           an_idwf,
                                           an_tarea,
                                           an_tareadef);
  
    IF NOT operacion.pq_int_telefonia.es_telefonia() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
  
    IF NOT operacion.pq_int_telefonia.es_masivo_hfc() THEN
      operacion.pq_int_telefonia.no_interviene();
      RETURN;
    END IF;
  
    /***  fin 2.0  ***/
    an_sot    := f_get_sot(an_idwf);
    xn_valida := f_valida_janus(an_idwf);
  
    IF xn_valida > 0 THEN
      -- Validando si existen servicios a reconectar son Janus    
      xs_codclie := f_get_codclie_janus(an_sot);
      gs_imsi    := f_imsi();
    
      BEGIN
        SELECT vt.nomcli, vt.apepat || ' ' || vt.apmat
          INTO xs_nomclie, xs_apeclie
          FROM vtatabcli vt
         WHERE vt.codcli = xs_codclie;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NOMBRE DE CLIENTE NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NOMBRE DE CLIENTE ENCONTRADO');
      END;
    
      --- buscamos los servcios y el proyecto de Alta al que pertenecen
      BEGIN
        SELECT i.numero, i.codinssrv
          INTO xs_numero, xn_codinssrv
          FROM operacion.inssrv i
         WHERE i.tipinssrv = 3
           AND i.codinssrv IN
               (SELECT sp.codinssrv FROM solotpto sp WHERE sp.codsolot = an_sot);
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20000, 'NUMERO TELEFONICO NO ENCONTRADO');
        WHEN TOO_MANY_ROWS THEN
          RAISE_APPLICATION_ERROR(-20000,
                                  'MAS DE UN NUMERO TELEFONICO ENCONTRADO');
      END;
    
      xs_recon := f_operacion_recn();
      /**** ini 3.0    ****/
      ---xn_pid       := f_get_pid(gs_numslc) ;
      /****  fin 3.0  ***/
    
      xs_codinssrv := to_char(xn_codinssrv);
      xs_prefijo   := operacion.pq_janus.get_conf('P_HCTR');
      xs_co_id     := xs_prefijo || xs_codinssrv;
      xs_imsi      := gs_imsi || xs_numero;
      xn_action_id := f_action_id(xs_recon);
      xs_trama     := xs_numero || '|' || xs_imsi || '|' || xs_co_id;
    
      p_inserta_plataforma_bscs(xs_codclie,
                                xs_nomclie,
                                xs_apeclie,
                                xs_co_id,
                                xn_action_id,
                                xs_trama,
                                xs_imsi,
                                xn_idtrans_ws);
      /** ini 2.0  **/
      p_inserta_int_telefonia(xs_recon,
                              an_idtareawf,
                              an_idwf,
                              an_tarea,
                              an_tareadef,
                              f_trs_operacion(),
                              f_trs_operacion(),
                              an_sot,
                              f_trs_operacion(),
                              xn_codinssrv,
                              xs_numero,
                              xn_idtrans_ws,
                              xs_recon,
                              0,
                              f_ok());
    
      /** fin 2.0  **/
      operacion.pq_janus_comunicacion.enviar_solicitud(xn_idtrans_ws,
                                                       xn_action_id,
                                                       xs_trama);
    
      xn_resultado := operacion.pq_janus_comunicacion.g_codigo;
      xs_mensaje   := operacion.pq_janus_comunicacion.g_mensaje;
    
      -- Actualiza BSCS
      p_update_bscs(xn_idtrans_ws, xn_resultado, xs_mensaje);
      --  Inserta Tareas
      p_inserta_tarea(an_idtareawf, xs_mensaje);
      -- Actualizando log
      p_update_log(gn_id_telefonia, xn_resultado, xs_mensaje);
      -- Actualiza cabecera
      p_update_telef();
    ELSE
      operacion.pq_int_telefonia.no_interviene();
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      operacion.pq_int_telefonia_log.logger(SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_get_pid(as_numslc VARCHAR2)
  
   RETURN NUMBER IS
  
    xn_pid NUMBER;
  
  BEGIN
  
    SELECT ip.pid
      INTO xn_pid
      FROM operacion.insprd ip
     WHERE ip.numslc = as_numslc
       AND ip.codsrv IN
           (SELECT ty.codsrv
              FROM sales.tystabsrv ty
             WHERE ty.idplan IN (SELECT idplan
                                   FROM telefonia.plan_redint
                                  WHERE idplataforma = 6));
  
    RETURN xn_pid;
  
  END f_get_pid;
  /***********************************************/
  FUNCTION f_action_id(as_operacion VARCHAR2) RETURN NUMBER IS
    xn_action NUMBER;
  
  BEGIN
    SELECT o.codigon
      INTO xn_action
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.codigoc = as_operacion;
  
    RETURN xn_action;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_ACTION_ID: ' || SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_operacion_susp RETURN VARCHAR2 IS
    xs_tipo VARCHAR2(50);
  
  BEGIN
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'JANUS_SUSP';
  
    RETURN xs_tipo;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OPERACION_SUSP: ' || SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_operacion_recn RETURN VARCHAR2 IS
    xs_tipo VARCHAR2(50);
  
  BEGIN
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'JANUS_RECN';
  
    RETURN xs_tipo;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OPERACION_RECN: ' || SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_trs_operacion RETURN VARCHAR2 IS
    xs_tipo operacion.opedd.codigoc%TYPE;
  BEGIN
  
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'JANUS';
  
    RETURN xs_tipo;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_TRS_OPERACION: ' || SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_imsi RETURN VARCHAR2 IS
    xs_tipo operacion.opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'JANUS_IMSI';
  
    RETURN xs_tipo;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.F_IMSI: ' || SQLERRM);
  END;
  /***********************************************/

  FUNCTION f_ok RETURN VARCHAR2 IS
    xs_tipo operacion.opedd.codigoc%TYPE;
  BEGIN
  
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'OKJANUS';
  
    RETURN xs_tipo;
  
  END f_ok;
  /***********************************************/
  FUNCTION f_operacion_cort RETURN VARCHAR2 IS
    xs_tipo operacion.opedd.codigoc%TYPE;
  
  BEGIN
    SELECT o.codigoc
      INTO xs_tipo
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND o.abreviacion = 'JANUS_CORT';
  
    RETURN xs_tipo;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_OPERACION_CORT: ' || SQLERRM);
  END;
  /***********************************************/
  FUNCTION f_get_numslc(an_sot NUMBER) RETURN VARCHAR2 IS
  
    xs_numslc operacion.inssrv.numslc%TYPE;
  
  BEGIN
  
    SELECT DISTINCT a2.numslc
      INTO xs_numslc
      FROM operacion.inssrv a2, sales.tystabsrv ty
     WHERE a2.codinssrv IN (SELECT a1.codinssrv
                              FROM operacion.solotpto a1
                             WHERE a1.codsolot = an_sot)
       AND a2.codsrv = ty.codsrv
       AND ty.idproducto IN
           (SELECT pp.idproducto
              FROM telefonia.plan_redint p, telefonia.planxproducto pp
             WHERE p.idplan = pp.idplan
               AND p.idplataforma = 6);
  
    RETURN xs_numslc;
  
  END f_get_numslc;
  /***********************************************/
  FUNCTION f_get_sot(an_idwf tareawf.idwf%TYPE) RETURN NUMBER IS
    xn_sot operacion.solot.codsolot%TYPE;
  
  BEGIN
    SELECT s.codsolot INTO xn_sot FROM opewf.wf s WHERE s.idwf = an_idwf;
  
    RETURN xn_sot;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.F_GET_SOT: ' || SQLERRM);
  END;
  /***********************************************/
END;
/
