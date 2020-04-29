CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SIAC_CAMBIO_NUMERO IS
   /*******************************************************************************
  PROPOSITO: Realiza la creacion de SOT por el BIPEL y Las tareas automaticas son generadas
             por la Shell WF_CAMBIO_NUMERO

  Version  Fecha       Autor             Solicitado por     Descripcion
  -------  ----------  ----------------  ----------------   -----------
    1.0    16/05/2017  Juan Gonzales      Alfredo YI       Cambio de numero SIAC UNICO
                       Lidia Quispe
    2.0    27/10/2017  Juan Gonzales      Alfredo YI       Incidencia cambio numero
  *******************************************************************************/
  PROCEDURE SIACSI_CAMBIO_NUMERO(K_ID_TRANSACCION     SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                 K_CO_ID              SOLOT.COD_ID%TYPE,
                                 K_CUSTOMER_ID        SALES.CLIENTE_SISACT.CUSTOMER_ID%TYPE,
                                 K_TIPO               VARCHAR2,
                                 K_CODSOLOT           OUT SOLOT.CODSOLOT%TYPE,
                                 K_ERROR_CODE         OUT NUMBER,
                                 K_ERROR_MSG          OUT VARCHAR2) IS

  v_codcli            vtatabcli.codcli%TYPE;
  v_numslc            vtatabslcfac.numslc%TYPE;
  c_wfdef             wf.wfdef%TYPE;
  c_tiptra            tiptrabajo.tiptra%TYPE;
  v_error_config      EXCEPTION;
  v_error             CONSTANT VARCHAR2(100) := 'No se realizo la configuracion de cambio de número';

  BEGIN
  K_ERROR_CODE := 0;
  K_ERROR_MSG  := 'OK';
  g_idtransaccion := k_id_transaccion;

  SELECT s.tramn_idinteraccion,
         operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:',s.tramv_trama)
    INTO G_idinteraccion, G_tipotransaccion
    FROM sales.siact_util_trama s
   WHERE s.tramn_idtransaccion = g_idtransaccion;

  v_codcli := operacion.pq_siac_postventa.get_codcli(k_customer_id);
  v_numslc := operacion.pq_siac_postventa.get_numslc(k_co_id, v_codcli);

  BEGIN
    SELECT codigon, codigon_aux
      INTO c_tiptra, c_wfdef
      FROM tipopedd t, opedd o
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev = 'CAMBIO_NUMERO_SIAC_UNICO'
       AND o.CODIGOC = k_tipo;

  EXCEPTION
        WHEN NO_DATA_FOUND THEN
        K_ERROR_CODE := -2;
        K_ERROR_MSG  := 'NO EXISTE CONFIGURACION CAMBIO_NUMERO_SIAC_UNICO : ' ||
                        sqlcode || ' ' || sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';

        raise v_error_config;
  END;

  SIACSI_GENERA_SOLOT (v_codcli,c_tiptra,v_numslc,k_co_id,k_customer_id, k_tipo,k_codsolot);

  SIACSI_GENERA_SOLOTPTO(k_codsolot,v_numslc);

  UPDATE sales.siact_util_trama
     SET tramn_codsolot = k_codsolot
   WHERE tramn_idtransaccion = k_id_transaccion;

  EXCEPTION
    WHEN v_error_config THEN
          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(g_idtransaccion,
                                                               G_idinteraccion,
                                                               G_TIPOTRANSACCION,
                                                               null,
                                                               NULL,
                                                               k_ERROR_MSG,
                                                               v_error);
    WHEN OTHERS THEN
      K_ERROR_CODE := -1;
      K_ERROR_MSG  := $$PLSQL_UNIT || '.' ||'SIACSI_CAMBIO_NUMERO: ERROR AL CREAR SOT '||
                      sqlcode || ' ' || sqlerrm || ' (' ||
                      dbms_utility.format_error_backtrace || ')';

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_GENERA_SOLOT(K_CODCLI       IN VTATABCLI.CODCLI%TYPE,
                                K_TIPTRA       IN TIPTRABAJO.TIPTRA%TYPE,
                                K_NUMSLC_OLD   IN SOLOT.NUMSLC%TYPE,
                                K_CO_ID        IN SOLOT.CODSOLOT%TYPE,
                                K_CUSTOMER_ID  IN SOLOT.CUSTOMER_ID%TYPE,
                                K_TIPO         IN VARCHAR2,
                                K_CODSOLOT     OUT SOLOT.CODSOLOT%TYPE) IS
  c_solot           solot%rowtype;
  c_det             solot%rowtype;
  v_error           CONSTANT VARCHAR2(50) := 'Error al crear la SOT';
  v_mensaje         VARCHAR2(1000);
  v_error_msg       VARCHAR2(400);
  v_error_config    EXCEPTION;
  BEGIN

    select *
      into c_det
      from solot
     where codsolot = operacion.pq_sga_iw.f_max_sot_x_cod_id(K_CO_ID);

    k_codsolot          := c_det.codsolot;
    c_solot.tiptra      := k_tiptra;
    c_solot.tipsrv      := c_det.tipsrv;
    c_solot.estsol      := 11;
    c_solot.numpsp      := c_det.numpsp;
    c_solot.idopc       := c_det.idopc;
    c_solot.codcli      := k_codcli;
    c_solot.feccom      := sysdate;
    c_solot.cliint      := c_det.cliint;
    c_solot.direccion   := c_det.direccion;
    c_solot.codubi      := c_det.codubi;

    BEGIN
      SELECT codigon
        INTO c_solot.codmotot
        FROM tipopedd t, opedd o
       WHERE t.tipopedd = o.tipopedd
         AND t.abrev = 'MOTIVO_CAMBIO_NUMERO'
         AND o.ABREVIACION = k_tipo;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        v_error_msg  := 'NO EXISTE CONFIGURACION CAMBIO_NUMERO_SIAC_UNICO : ' ||
                        sqlcode || ' ' || sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';

        raise v_error_config;
    END;

    pq_solot.p_insert_solot(c_solot, k_codsolot);

    UPDATE solot SET cod_id = k_co_id , customer_id = k_customer_id WHERE codsolot = k_codsolot;

  EXCEPTION
    WHEN v_error_config THEN
         operacion.pkg_siac_postventa.siacsi_trazabilidad_log(g_idtransaccion,
                                                              g_idinteraccion,
                                                              g_tipotransaccion,
                                                              NULL,
                                                              NULL,
                                                              v_error_msg,
                                                              v_error);
         raise_application_error(-20000, v_error_msg);

    WHEN OTHERS THEN
      v_mensaje := $$PLSQL_UNIT || '.' ||'SIACSI_GENERA_SOLOT: '||
                   sqlcode || ' ' || sqlerrm || ' (' ||
                   dbms_utility.format_error_backtrace || ')';

      operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(g_idtransaccion,
                                                           g_idinteraccion,
                                                           g_tipotransaccion,
                                                           null,
                                                           NULL,
                                                           v_mensaje,
                                                           v_error);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACSI_GENERA_SOLOT: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_GENERA_SOLOTPTO (K_CODSOLOT      IN SOLOT.CODSOLOT%TYPE,
                                    K_NUMSLC        IN INSSRV.NUMSLC%TYPE) IS

  c_solotpto    solotpto%rowtype;
  v_punto       solotpto.punto%type;
  c_inssrv      inssrv%rowtype;
  c_error       CONSTANT VARCHAR2(50) := 'Error al crear la SOT';
  v_mensaje     VARCHAR2(1000);
  c_pid         insprd.pid%TYPE;

  BEGIN

    SELECT i.*
      INTO c_inssrv
      FROM inssrv i
     WHERE i.numslc = k_numslc
       AND i.tipsrv = g_telefonia
       AND i.estinssrv IN (1,2);

    BEGIN
      SELECT pr.pid
        INTO c_pid
        FROM insprd pr
       WHERE pr.codinssrv = c_inssrv.codinssrv
         AND pr.codsrv = c_inssrv.codsrv
         AND pr.flgprinc = 1;

    EXCEPTION
      WHEN OTHERS THEN
        c_pid:= null;
    END;

      c_solotpto.codsolot    := k_codsolot;
      c_solotpto.tiptrs      := null;
      c_solotpto.codsrvnue   := c_inssrv.codsrv;
      c_solotpto.bwnue       := c_inssrv.bw;
      c_solotpto.codinssrv   := c_inssrv.codinssrv;
      c_solotpto.cid         := c_inssrv.cid;
      c_solotpto.descripcion := c_inssrv.descripcion;
      c_solotpto.direccion   := c_inssrv.direccion;
      c_solotpto.tipo        := 2;
      c_solotpto.estado      := 1;
      c_solotpto.visible     := 1;
      c_solotpto.codubi      := c_inssrv.codubi;
      c_solotpto.codpostal   := c_inssrv.codpostal;
      c_solotpto.idplataforma:= c_inssrv.idplataforma;
      c_solotpto.pid         := c_pid;

      operacion.pq_solot.p_insert_solotpto(c_solotpto, v_punto);

  EXCEPTION
    WHEN OTHERS THEN
      v_mensaje := $$PLSQL_UNIT || '.' ||'SIACSI_GENERA_SOLOTPTO: '||
                   sqlcode || ' ' || sqlerrm || ' (' ||
                   dbms_utility.format_error_backtrace || ')';

      operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(g_idtransaccion,
                                                           g_idinteraccion,
                                                           g_tipotransaccion,
                                                           null,
                                                           NULL,
                                                           v_mensaje,
                                                           c_error);
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACSI_GENERA_SOLOTPTO: ' || SQLERRM);
  END;
 /* **********************************************************************************************/
 PROCEDURE SIACSI_ASIGNA_NUMERO( K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER) IS

  v_codsolot         solot.codsolot%TYPE;
  c_codinssrv        inssrv.codinssrv%TYPE;
  v_mensaje          varchar2(1000);
  v_numero           TELEFONIA.NUMTEL.NUMERO%TYPE;
  c_idtransaccion    sales.siact_util_trama.tramn_idtransaccion%TYPE;
  c_trama            sales.siact_util_trama.tramv_trama%TYPE;
  c_error            CONSTANT VARCHAR2(100) := 'Error al Asignar Número Telefonico en SGA';
  c_idinteraccion    sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_tipotransaccion  VARCHAR2(100);
  v_numero_old       inssrv.numero%TYPE;
  v_tipo             VARCHAR2(50);
  c_simcard          numtel.simcard%TYPE;
  c_codnumtel        numtel.codnumtel%TYPE;
  n_cod_error        NUMBER;
  v_msm_error        VARCHAR2(1000);
  c_codcli           inssrv.codcli%TYPE;

  BEGIN

  v_codsolot := siacfun_obtiene_sot (k_idwf);

  SELECT i.codinssrv,
         s.tramn_idtransaccion,
         s.tramv_trama,
         s.tramn_idinteraccion,
         operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', s.tramv_trama),
         operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_NUMERO:',s.tramv_trama),
         i.codcli
    into c_codinssrv,
         c_idtransaccion,
         c_trama,
         c_idinteraccion,
         v_tipotransaccion,
         v_tipo,
         c_codcli
    FROM solotpto pto, inssrv i, sales.siact_util_trama s
   WHERE pto.codinssrv = i.codinssrv
     AND pto.codsolot = s.tramn_codsolot
     AND i.tipsrv = g_telefonia
     AND pto.codsolot = v_codsolot;

  v_numero := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',c_trama);
  v_numero_old := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEF:',c_trama);
  -- Libera el Numero
  UPDATE numtel SET codinssrv = NULL , estnumtel = 6 WHERE numero = v_numero_old;

  -- Asigna el Numero

  SELECT n.codnumtel, n.simcard
    INTO c_codnumtel, c_simcard
    FROM telefonia.numtel n
   WHERE n.numero = v_numero;

  UPDATE inssrv SET numero = v_numero WHERE codinssrv = c_codinssrv;

  siacsu_update_numtel(c_simcard,c_codinssrv,2,1,c_codnumtel,1,n_cod_error,v_msm_error);

  IF n_cod_error <> 0 THEN
     raise_application_error(-20500, v_msm_error);
  END IF;

  SIACSI_INSERT_RESERVATEL(c_codnumtel,c_codinssrv,2,c_codcli,n_cod_error,v_msm_error);

  IF n_cod_error <> 0 THEN
     raise_application_error(-20500, v_msm_error);
  END IF;

  UPDATE solot
     SET observacion = 'Proceso de Cambio de Numero - Numero Antiguo: ' ||v_numero_old || ' Numero Nuevo: ' || v_numero
   WHERE codsolot = v_codsolot;


  EXCEPTION
      WHEN OTHERS THEN
        v_mensaje := $$PLSQL_UNIT || '.' ||'SIACSI_ASIGNA_NUMERO: '||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';

       operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(c_idtransaccion,
                                                            c_idinteraccion,
                                                            v_tipotransaccion,
                                                            v_codsolot,
                                                            k_tarea,
                                                            v_mensaje,
                                                            c_error) ;

       RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACSI_ASIGNA_NUMERO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_PROV_IL(K_IDTAREAWF IN NUMBER,
                           K_IDWF      IN NUMBER,
                           K_TAREA     IN NUMBER,
                           K_TAREADEF  IN NUMBER) IS

  v_codsolot               solot.codsolot%TYPE;
  v_co_id                  solot.cod_id%TYPE;
  v_customer_id            solot.customer_id%TYPE;
  v_error_general          EXCEPTION;
  v_cod_error              NUMBER;
  v_des_error              VARCHAR2(1000);
  v_error                  CONSTANT VARCHAR2(100) := 'Error al Realizar Provision a IL';
  v_idtransaccion          sales.siact_util_trama.tramn_idtransaccion%TYPE;
  v_idinteraccion          sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_trama                  sales.siact_util_trama.tramv_trama%TYPE;
  v_tipotransaccion        VARCHAR2(100);
  v_tipoprod               CONSTANT VARCHAR(20):='TELEFONIA';
  v_request                INTEGER;
  v_numero                 numtel.numero%TYPE;
  c_sm_serialnum           numtel.simcard%TYPE;

  BEGIN
    v_codsolot := siacfun_obtiene_sot (k_idwf);
    siacss_consulta_trama(v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_tipotransaccion:=operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', v_trama);

    tim.pp004_siac_lte.siacsi_provision_il@dbl_bscs_bf(v_co_id,v_customer_id,user,v_tipoprod,6,null,v_cod_error,v_des_error);

    IF v_cod_error < 0 THEN
        v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSI_PROV_IL: ' || v_des_error;
        RAISE v_error_general;
    END IF;

    v_request := to_number(v_des_error);

    UPDATE tim.lte_control_prov@dbl_bscs_bf
       SET SOT = v_codsolot
     WHERE request = v_request
       AND customer_id = v_customer_id
       AND co_id = v_co_id;

    SELECT sm.sm_serialnum INTO c_sm_serialnum
      FROM contr_devices@dbl_bscs_bf cd
     INNER JOIN port@dbl_bscs_bf p
        ON cd.port_id = p.port_id
     INNER JOIN storage_medium@dbl_bscs_bf sm
        ON p.sm_id = sm.sm_id
     WHERE cd.co_id = v_co_id
       AND cd.cd_seqno = (SELECT MAX(p.cd_seqno)
                            FROM contr_devices@dbl_bscs_bf p
                           WHERE p.co_id = cd.co_id);

    v_numero  := operacion.pkg_siac_postventa.siacfun_get_parameter('NRO_TELEFNUEV:',v_trama);

    UPDATE numtel SET simcard = c_sm_serialnum WHERE numero = v_numero;

  EXCEPTION
     WHEN v_error_general THEN

          operacion.pkg_siac_postventa.siacsi_trazabilidad_log(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_PROV_IL: ' || SQLERRM);
     WHEN OTHERS THEN
          v_des_error := $$PLSQL_UNIT || '.' ||'SIACSI_PROV_IL: '||
                         sqlcode || ' ' || sqlerrm || ' (' ||
                         dbms_utility.format_error_backtrace || ')';

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                   $$PLSQL_UNIT || '.' ||
                                   'SIACSI_PROV_IL: ' || SQLERRM);

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_PROV_JANUS(K_IDTAREAWF IN NUMBER,
                              K_IDWF      IN NUMBER,
                              K_TAREA     IN NUMBER,
                              K_TAREADEF  IN NUMBER) IS

  v_codsolot               solot.codsolot%TYPE;
  v_co_id                  solot.cod_id%TYPE;
  v_customer_id            solot.customer_id%TYPE;
  v_error_general          EXCEPTION;
  v_cod_error              NUMBER;
  v_des_error              VARCHAR2(1000);
  v_error                  CONSTANT VARCHAR2(100) := 'Error al Realizar Provision a Janus';
  v_idtransaccion          sales.siact_util_trama.tramn_idtransaccion%TYPE;
  v_idinteraccion          sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_trama                  sales.siact_util_trama.tramv_trama%TYPE;
  v_tipotransaccion        VARCHAR2(100);
  v_numero                 numtel.numero%TYPE;
  v_numero_old             numtel.numero%TYPE;
  v_tipo                   VARCHAR(20);

  BEGIN
    v_codsolot := siacfun_obtiene_sot (k_idwf);
    siacss_consulta_trama(v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_tipotransaccion := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', v_trama);
    v_numero          := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',v_trama);
    v_numero_old      := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEF:',v_trama);
    v_tipo            := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_NUMERO:',v_trama);

    tim.pp004_siac_lte.siacsi_provision_janus@dbl_bscs_bf(v_co_id,v_customer_id,v_tipo,v_numero_old,v_numero,v_cod_error,v_des_error);

    IF v_cod_error < 0 THEN
        v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSI_PROV_JANUS: ' || v_des_error;
        RAISE v_error_general;
    END IF;

  EXCEPTION
     WHEN v_error_general THEN

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_PROV_JANUS: ' || SQLERRM);
     WHEN OTHERS THEN
          v_des_error := $$PLSQL_UNIT || '.' ||'SIACSI_PROV_JANUS: '||v_des_error||' '||
                         sqlcode || ' ' || sqlerrm || ' (' ||
                         dbms_utility.format_error_backtrace || ')';

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                   $$PLSQL_UNIT || '.' ||
                                   'SIACSI_PROV_JANUS: ' || SQLERRM);

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_ASIG_NUM_BSCS(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER) IS

  v_codsolot               solot.codsolot%TYPE;
  v_co_id                  solot.cod_id%TYPE;
  v_customer_id            solot.customer_id%TYPE;
  v_error_general          EXCEPTION;
  v_cod_error              NUMBER;
  v_des_error              VARCHAR2(1000);
  v_error                  CONSTANT VARCHAR2(100) := 'Error al Asignar numero en BSCS';
  v_idtransaccion          sales.siact_util_trama.tramn_idtransaccion%TYPE;
  v_idinteraccion          sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_trama                  sales.siact_util_trama.tramv_trama%TYPE;
  v_tipotransaccion        VARCHAR2(100);
  v_numero                 numtel.numero%TYPE;

  BEGIN
    v_codsolot := siacfun_obtiene_sot (k_idwf);
    siacss_consulta_trama(v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_tipotransaccion := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', v_trama);
    v_numero := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',v_trama);

    tim.pp004_siac_lte.siacsu_cambio_num@dbl_bscs_bf(v_co_id,v_numero,user,v_cod_error,v_des_error);

    IF v_cod_error < 0 THEN
        v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_ASIG_NUM_BSCS: ' || v_des_error;
        RAISE v_error_general;
    END IF;

  EXCEPTION
     WHEN v_error_general THEN

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSU_ASIG_NUM_BSCS: ' || SQLERRM);
     WHEN OTHERS THEN
          v_des_error := $$PLSQL_UNIT || '.' ||'SIACSI_PROV_JANUS: '||
                         sqlcode || ' ' || sqlerrm || ' (' ||
                         dbms_utility.format_error_backtrace || ')';

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                   $$PLSQL_UNIT || '.' ||
                                   'SIACSI_PROV_JANUS: ' || SQLERRM);

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_POS_COBRO_OCC(K_IDTAREAWF IN NUMBER,
                                 K_IDWF      IN NUMBER,
                                 K_TAREA     IN NUMBER,
                                 K_TAREADEF  IN NUMBER) IS

  v_fideliza_locucion      VARCHAR2(5);
  v_codigo_occ_locucion    NUMBER;
  v_monto_occ_locucion     NUMBER(10,3);
  v_fideliza_transaccion   VARCHAR2(5);
  v_codigo_occ_transaccion NUMBER;
  v_monto_occ_transaccion  NUMBER(10,3);
  v_customer_id            NUMBER;
  v_cod_error              NUMBER;
  v_des_error              VARCHAR2(1000);
  v_remark                 VARCHAR2(200);
  v_codsolot               solot.codsolot%TYPE;
  v_idtransaccion          sales.siact_util_trama.tramn_idtransaccion%TYPE;
  v_trama                  sales.siact_util_trama.tramv_trama%TYPE;
  v_error_general          EXCEPTION;
  v_error                  CONSTANT VARCHAR2(100) := 'Error al Realizar Cobro OCC';
  v_idinteraccion          sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_tipotransaccion        VARCHAR2(100);
  v_co_id                  solot.cod_id%TYPE;
  v_flaglocucion           VARCHAR2(10);

  BEGIN

    v_codsolot := siacfun_obtiene_sot (k_idwf);
    SIACSS_CONSULTA_TRAMA (v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_tipotransaccion        := operacion.pkg_siac_postventa.SIACFUN_get_parameter('TIPO_TRANSACCION:',v_trama);
    v_fideliza_locucion      := operacion.pkg_siac_postventa.SIACFUN_get_parameter('FLAG_OCC_FIDEL_LOCU:',v_trama);
    v_codigo_occ_locucion    := TO_NUMBER(operacion.pkg_siac_postventa.SIACFUN_get_parameter('COD_OCC_LOCU:',v_trama));
    v_monto_occ_locucion     := TO_NUMBER(operacion.pkg_siac_postventa.SIACFUN_get_parameter('IMPORTE_OCC_LOCU:',v_trama),'99999.99');
    v_fideliza_transaccion   := operacion.pkg_siac_postventa.SIACFUN_get_parameter('FLAG_OCC_FIDEL_TRANS:',v_trama);
    v_codigo_occ_transaccion := TO_NUMBER(operacion.pkg_siac_postventa.SIACFUN_get_parameter('COD_OCC_TRANS:',v_trama));
    v_monto_occ_transaccion  := TO_NUMBER(operacion.pkg_siac_postventa.SIACFUN_get_parameter('IMPORTE_OCC_TRANS:',v_trama),'99999.99');
    v_flaglocucion           := operacion.pkg_siac_postventa.SIACFUN_get_parameter('FLAG_LOCU:',v_trama);

    IF v_fideliza_locucion = '0' AND v_flaglocucion = '1'THEN
       v_remark := 'CAMBIO DE NUMERO - COBRO POR LOCUCION';

       v_cod_error := TIM.TFUN026_REGISTRA_OCC@DBL_BSCS_BF(v_customer_id,
                                                          v_codigo_occ_locucion,
                                                          1,
                                                          v_monto_occ_locucion,
                                                          sysdate ,
                                                          v_remark,
                                                          v_cod_error,
                                                          v_des_error);

       IF v_cod_error < 0 THEN
          v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO - al Cobro de Locucion Cambio de Numero: ' || v_des_error;
          RAISE v_error_general;
       END IF;
    END IF;

    IF v_fideliza_transaccion = '0' THEN

       v_remark := 'CAMBIO DE NUMERO - COBRO POR LA TRANSACCION';

       v_cod_error :=TIM.TFUN026_REGISTRA_OCC@DBL_BSCS_BF(v_customer_id,
                                                          v_codigo_occ_transaccion,
                                                          1,
                                                          v_monto_occ_transaccion,
                                                          sysdate ,
                                                          v_remark,
                                                          v_cod_error,
                                                          v_des_error );

       IF v_cod_error < 0 THEN
          v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO Cobro de Fidelizacion de transaccion: ' || v_des_error;
          RAISE v_error_general;
       END IF;
    END IF;

   EXCEPTION
     WHEN v_error_general THEN

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);

          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_POS_COBRO_OCC: ' || SQLERRM);

     WHEN OTHERS THEN
          v_des_error := $$PLSQL_UNIT || '.' ||'SIACSI_POS_COBRO_OCC: '||
                         sqlcode || ' ' || sqlerrm || ' (' ||
                         dbms_utility.format_error_backtrace || ')';

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);

          RAISE_APPLICATION_ERROR(-20000,
                                  $$PLSQL_UNIT || '.' ||
                                  'SIACSI_POS_COBRO_OCC: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_LIBERA_IW_INCOG(K_IDTAREAWF IN NUMBER,
                                   K_IDWF      IN NUMBER,
                                   K_TAREA     IN NUMBER,
                                   K_TAREADEF  IN NUMBER) IS

  v_mensaje                VARCHAR2(1000);
  v_codsolot               solot.codsolot%TYPE;
  v_idtransaccion          sales.siact_util_trama.tramn_idtransaccion%TYPE;
  v_error                  CONSTANT VARCHAR2(100) := 'Error al Realizar la Reservación a Incognito';
  v_idinteraccion          sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_tipotransaccion        VARCHAR2(100);
  v_co_id                  solot.cod_id%TYPE;
  v_customer_id            solot.customer_id%TYPE;
  v_error_general          EXCEPTION;
  v_cod_error              NUMBER;
  v_des_error              VARCHAR2(3000);
  v_trama                  sales.siact_util_trama.tramv_trama%TYPE;
  v_numero_new             numtel.numero%TYPE;
  v_numero_old             numtel.numero%TYPE;
  v_tipo_serv              CONSTANT VARCHAR2(10) := 'TEP'; -- 2.0

  begin

    v_codsolot := siacfun_obtiene_sot (k_idwf);
    siacss_consulta_trama (v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_numero_new := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',v_trama);
    v_numero_old := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEF:',v_trama);
    v_tipotransaccion := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', v_trama);

    INTRAWAY.PQ_INT_CAMBIO_PLAN_SISACT.SGASI_CMB_NUMERO(v_numero_old,v_numero_new,v_co_id,v_codsolot,v_des_error,v_cod_error);

    IF v_cod_error < 0 THEN
        v_des_error := 'Error OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSI_LIBERA_IW_INCOG: ' || v_des_error;
        RAISE v_error_general;
    END IF;

    --INI 2.0
    --SE ACTUALIZA NUMERO EN BSCS PARA HFC

    UPDATE TIM.PF_HFC_DATOS_SERV@DBL_BSCS_BF
       SET CAMPO05 = V_NUMERO_NEW
     WHERE CO_ID = V_CO_ID
       AND TIPO_SERV = V_TIPO_SERV;
    --FIN 2.0

  EXCEPTION
     WHEN v_error_general THEN

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               v_codsolot,
                                                               k_tarea,
                                                               v_des_error,
                                                               v_error);
          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_LIBERA_IW_INCOG: ' || SQLERRM);
     WHEN OTHERS THEN
        v_mensaje := $$PLSQL_UNIT || '.' ||'SIACSI_LIBERA_IW_INCOG: '||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';

        operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                             v_idinteraccion,
                                                             v_tipotransaccion,
                                                             v_codsolot,
                                                             k_tarea,
                                                             v_mensaje,
                                                             v_error) ;



       RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_LIBERA_IW_INCOG: ' || SQLERRM);

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_PRE_ENVIO_CORREO(K_IDTAREAWF IN NUMBER,
                                    K_IDWF      IN NUMBER,
                                    K_TAREA     IN NUMBER,
                                    K_TAREADEF  IN NUMBER) is

    v_codsolot         solot.codsolot%type;
    v_co_id            solot.cod_id%type;
    v_error_general    EXCEPTION;
    c_telefono1        marketing.vtatabcli.telefono1%type;
    c_telefono2        marketing.vtatabcli.telefono2%type;
    c_ruc_dni          marketing.vtatabcli.ntdide%type;
    v_numero_new       operacion.inssrv.numero%type;
    v_numero_old       operacion.inssrv.numero%type;
    c_from             VARCHAR2(1000);
    c_to               VARCHAR2(1000);
    c_nomcli           vtatabcli.nomcli%TYPE;
    v_subject          VARCHAR2(100);
    v_mensaje          VARCHAR2(5000);
    v_idinteraccion    sales.siact_util_trama.tramn_idinteraccion%TYPE;
    v_error            CONSTANT VARCHAR2(100) := 'Error Envio de Correo al Area de Conmutación';
    v_idtransaccion    sales.siact_util_trama.tramn_idtransaccion%TYPE;
    v_tipotransaccion  VARCHAR2(100);
    v_flagocclocu      VARCHAR2(10);
    c_estsol           OPERACION.SOLOT.ESTSOL%TYPE;
    v_customer_id      solot.customer_id%TYPE;
    v_trama            sales.siact_util_trama.tramv_trama%TYPE;

  begin

    v_codsolot := siacfun_obtiene_sot (k_idwf);
    SIACSS_CONSULTA_TRAMA (v_codsolot,v_idtransaccion,v_idinteraccion,v_co_id,v_customer_id,v_trama);

    v_flagocclocu      := operacion.pkg_siac_postventa.SIACFUN_get_parameter('FLAG_LOCU:',v_trama);
    v_numero_new       := operacion.pkg_siac_postventa.SIACFUN_get_parameter('NRO_TELEFNUEV:',v_trama);
    v_numero_old       := operacion.PKG_SIAC_POSTVENTA.SIACFUN_get_parameter('NRO_TELEF:',v_trama);
    v_tipotransaccion  := operacion.pkg_siac_postventa.SIACFUN_get_parameter('TIPO_TRANSACCION:',v_trama);

    SELECT ESTSOL INTO c_estsol FROM solot WHERE codsolot = v_codsolot;
    IF to_number(v_flagocclocu) <> 1 then
       siacsu_estado_tarea(k_idwf,k_idtareawf,8);
       operacion.pq_solot.p_chg_estado_solot(v_codsolot, 12, c_estsol, null);

    ELSE

      select nomcli, ntdide, telefono1, telefono2
        into c_nomcli, c_ruc_dni, c_telefono1, c_telefono2
        from vtatabcli
       where codcli = ( select b.codcli
                          from wf a, solot b
                         where a.idwf = k_idwf
                           and a.codsolot = b.codsolot ) ;

      SELECT o.codigoc, o.descripcion
        INTO c_from, c_to
        FROM tipopedd t, opedd o
      WHERE o.tipopedd = t.tipopedd
        AND t.abrev = 'LOCUCION_SIAC_CAMBIONUMERO';
       -- ASUNTO DE LA NOTIFICACION
        v_subject := ' Locucion por cambio de Numero ';
       -- ARMAR NOTIFICACION Y ENVIAR A CADA APROBADOR
        v_mensaje := 'Sres. Conmutacin,'|| chr(13)|| chr(13);
        v_mensaje := v_mensaje ||'Su apoyo para ejecutar la Activacion de la locucion de voz.'|| chr(13)|| chr(13);
        v_mensaje := v_mensaje ||'Nombre / Razon Social del Titular: ' || c_nomcli|| chr(13)|| chr(13);
        v_mensaje := v_mensaje ||'DNI / RUC:  ' || c_ruc_dni || '. '|| chr(13)|| chr(13);
        v_mensaje := v_mensaje ||'Motivo: Locucion de Linea por Cambio de Numero'|| chr(13)|| chr(13);
        v_mensaje := v_mensaje || 'Numero Antiguo: ' ||v_numero_old|| chr(13)|| chr(13);
        v_mensaje := v_mensaje || 'Numero Nuevo: ' ||v_numero_new|| chr(13)|| chr(13);
        v_mensaje := v_mensaje || 'fecha Inicio de Locucion: ' || to_char(sysdate,'dd/mm/yyyy')|| chr(13)|| chr(13);
        v_mensaje := v_mensaje || 'fecha fin de Locucion: ' || to_char(sysdate + 30,'dd/mm/yyyy')|| chr(13)|| chr(13);
        v_mensaje := v_mensaje || 'Solot Generada: ' || to_char(v_codsolot)|| chr(13);
        v_mensaje := v_mensaje || chr(13);

        BEGIN
          opewf.pq_send_mail_job.p_send_mail(v_subject,
                                             c_to,
                                             v_mensaje,
                                             c_from);
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000,'Problemas al ENVIAR CORREO. ');
        END;

        if c_estsol <> 29 then
           operacion.pq_solot.p_chg_estado_solot(v_codsolot, 29, c_estsol, null);
        end if;

        update solot s
           set s.observacion = 'Observaciones: Cliente solicita la activación de locución para la línea ' ||
                               v_numero_old||' para que se comuniquen al nuevo número '||v_numero_new
         WHERE s.codsolot = v_codsolot;

      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        v_mensaje := $$PLSQL_UNIT || '.' ||'SIACSI_PRE_ENVIO_CORREO: '||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';

        operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                             v_idinteraccion,
                                                             v_tipotransaccion,
                                                             v_codsolot,
                                                             k_tarea,
                                                             v_mensaje,
                                                             v_error) ;
        RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_PRE_ENVIO_CORREO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_ESTADO_TAREA(K_IDWF      TAREAWF.IDWF%TYPE,
                                K_IDTAREAWF TAREAWF.IDTAREAWF%TYPE,
                                K_ESTADO    NUMBER) IS
  BEGIN

    UPDATE tareawf t
       SET t.esttarea = k_estado
     WHERE t.idwf = k_idwf
       AND t.idtareawf = k_idtareawf;
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_RESERVA_NUMERO(K_CO_ID        IN SOLOT.COD_ID%TYPE,
                                  K_CUSTOMER_ID  IN SOLOT.CUSTOMER_ID%TYPE,
                                  K_NUMERO       OUT NUMTEL.NUMERO%TYPE,
                                  K_ERROR_CODE   OUT NUMBER,
                                  K_ERROR_MSG    OUT VARCHAR2) IS

  v_error_general      EXCEPTION;
  v_codcli           vtatabcli.codcli%type;
  c_zona             number;
  v_numslc           inssrv.numslc%TYPE;

  cursor c_tel (lv_numslc varchar2)is
  select a.numslc, a.numpto, a.ubipto, a.codsuc, e.codcli, e.idsolucion
    from vtadetptoenl a, tystabsrv b, producto c, vtatabslcfac e
   where a.codsrv = b.codsrv
     and b.idproducto = c.idproducto
     and a.numslc = e.numslc
     and a.numslc = lv_numslc
     and c.idtipinstserv = 3
     and a.flgsrv_pri = 1
   order by a.numpto;

  BEGIN

    k_ERROR_CODE := 0;
    k_ERROR_MSG := 'OK';

    v_codcli := operacion.pq_siac_postventa.get_codcli(k_CUSTOMER_ID);
    v_numslc := operacion.pq_siac_postventa.get_numslc(k_co_id, v_codcli);
    SELECT to_number(valor) INTO c_zona FROM constante WHERE TRIM(constante) = 'ZONA3PLAY_AUT';

    FOR c_t IN c_tel (v_numslc)LOOP
      select F_GET_NUMERO_TEL_ITW(c_zona,c_t.ubipto) into k_numero from dummy_ope;
        if k_numero is null or k_numero = '0' then
          k_error_msg := 'No existe numero telefónico disponible.';
          k_error_code:= -1;
          raise v_error_general;
        end if;
    END LOOP;

    if k_numero is null or k_numero = '0' then
          k_error_msg := 'El contrato no esta asociado a un Proyecto';
          k_error_code:= -1;
          raise v_error_general;
    end if;
       -- Reserva Numero
    UPDATE numtel SET  estnumtel = 6 WHERE numero = k_numero;

  EXCEPTION
      WHEN v_error_general THEN

          RAISE_APPLICATION_ERROR(-20000,
                                  $$PLSQL_UNIT || '.' ||
                                  'SIACSI_RESERVA_NUMERO: ' || SQLERRM||' '||k_error_msg);
      WHEN OTHERS THEN

          RAISE_APPLICATION_ERROR(-20000,
                                $$PLSQL_UNIT || '.' ||
                                'SIACSI_RESERVA_NUMERO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_ROLLBACK_NUMERO(K_ID_TRANS     IN  SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                   K_NUMERO       IN  NUMTEL.NUMERO%TYPE,
                                   K_ERROR_CODE   OUT NUMBER,
                                   K_ERROR_MSG    OUT VARCHAR2) IS

  c_trama            sales.siact_util_trama.tramv_trama%TYPE;
  v_trama_new        sales.siact_util_trama.tramv_trama%TYPE;
  v_error            CONSTANT VARCHAR2(100) := 'Error al Realizar Rollback de Numero';
  c_idinteraccion    sales.siact_util_trama.tramn_idinteraccion%TYPE;
  v_tipotransaccion  VARCHAR2(100);
  v_idtransaccion    sales.siact_util_trama.tramn_idtransaccion%TYPE;

  BEGIN

    k_ERROR_CODE := 0;
    k_ERROR_MSG := 'OK';

    BEGIN
      SELECT s.tramv_trama,
             s.tramn_idinteraccion
        into c_trama,
             c_idinteraccion
        FROM sales.siact_util_trama s
       WHERE s.tramn_idtransaccion = k_id_trans;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
           v_idtransaccion :=0;
    END;

    IF  v_idtransaccion > 0 THEN
        v_tipotransaccion := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('TIPO_TRANSACCION:', c_trama);
        -- Borra de la Trama el numero Asignado
        v_trama_new := operacion.pkg_siac_postventa.SIACFUN_set_parameter('NRO_TELEFNUEV:','',k_id_trans);
        operacion.pkg_siac_postventa.SIACSU_UTIL_TRAMA(k_id_trans,v_trama_new);
    END IF;
    -- Se libera numero a Disponible

    --UPDATE numtel SET  estnumtel = 1 , codinssrv = NULL WHERE numero = k_numero;

  EXCEPTION
      WHEN OTHERS THEN
        k_error_msg := $$PLSQL_UNIT || '.' ||'SIACSU_ROLLBACK_NUMERO: '||
                     sqlcode || ' ' || sqlerrm || ' (' ||
                     dbms_utility.format_error_backtrace || ')';
       IF v_idtransaccion > 0 THEN
         operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(k_id_trans,
                                                              c_idinteraccion,
                                                              v_tipotransaccion,
                                                              NULL,
                                                              NULL,
                                                              k_error_msg,
                                                              v_error);
        END IF;

        RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACSI_RESERVA_NUMERO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_NUMTEL_LTE(K_NUMERO     IN INSSRV.NUMERO%TYPE,
                              K_SIMCARD    IN NUMTEL.SIMCARD%TYPE,
                              K_CODINSSRV  IN INSSRV.CODINSSRV%TYPE,
                              K_RESUL      OUT NUMBER,
                              K_MENSAJE    OUT VARCHAR2) IS

     c_codnumtel number;
     v_val_num   number;
     c_estnumtel telefonia.numtel.estnumtel%type;
     v_mensaje   VARCHAR2(3000);
     v_cant_num  number;


   BEGIN
     k_RESUL:=0;
     k_MENSAJE := 'OK';

     SELECT COUNT(1)
       INTO v_val_num
       FROM telefonia.numtel nt
      WHERE nt.numero = k_numero;

       IF v_val_num = 0  THEN
         --inserta en Numtel
         siacsi_insert_numtel(k_numero,
                              k_simcard,
                              k_codinssrv,
                              6,
                              1,
                              c_codnumtel,
                              k_resul,
                              k_mensaje);
         IF k_resul <> 0 THEN
           raise_application_error(-20500, k_mensaje);
         END IF;
       ELSE
         SELECT nt.estnumtel
           INTO c_estnumtel
           FROM telefonia.numtel nt
          WHERE nt.numero = k_numero;

          SELECT count(1) INTO v_cant_num FROM inssrv i WHERE i.numero = k_numero AND i.estinssrv IN (1,2);

         IF (c_estnumtel = 1 OR c_estnumtel = 6) AND v_cant_num = 0 THEN
             SELECT codnumtel
               INTO c_codnumtel
               FROM telefonia.numtel t
              WHERE t.numero = k_numero;

             siacsu_update_numtel(k_simcard,
                                  k_codinssrv,
                                  6,
                                  1,
                                  c_codnumtel,
                                  0,
                                  k_resul,
                                  k_mensaje);

         IF k_resul <> 0 THEN
           raise_application_error(-20500, k_mensaje);
         END IF;

         ELSE
           k_resul    := -1;
           v_mensaje := 'El numero ya se encuentra registrado';
           raise_application_error(-20500, v_mensaje);
         END IF;
       END IF;

   EXCEPTION
     when others then
       raise_application_error(-20001,
                               'Error en SIACSI_NUMTEL_LTE : ' || sqlerrm);
   END;
 /* **********************************************************************************************/
   PROCEDURE SIACSI_INSERT_NUMTEL(K_NUMERO    IN NUMTEL.NUMERO%TYPE,
                                  K_SIMCARD   IN NUMTEL.SIMCARD%TYPE,
                                  K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                  K_ESTNUMTEL IN NUMBER,
                                  K_TIPNUMTEL IN NUMBER,
                                  K_CODNUMTEL OUT NUMBER,
                                  K_COD       OUT NUMBER,
                                  K_MENSAJE   OUT VARCHAR2) IS
  BEGIN
    k_cod:=0;
    k_mensaje:='Exito';

    INSERT INTO telefonia.numtel
      (estnumtel,
       tipnumtel,
       numero,
       fecasg,
       fecusu,
       codusu,
       codinssrv,
       simcard)
    VALUES
      (k_estnumtel,
       k_tipnumtel,
       k_numero,
       SYSDATE,
       SYSDATE,
       USER,
       k_codinssrv,
       k_simcard)
    RETURNING codnumtel INTO k_codnumtel;
  EXCEPTION
    WHEN OTHERS THEN
      k_cod:=-1;
      k_mensaje:='Error al Insertar a la NUMTEL : ' || sqlerrm;
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_UPDATE_NUMTEL(K_SIMCARD   IN NUMTEL.SIMCARD%TYPE,
                                 K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                 K_ESTNUMTEL IN NUMBER,
                                 K_TIPNUMTEL IN NUMBER,
                                 K_CODNUMTEL IN NUMBER,
                                 K_PUBLICAR  IN NUMBER,
                                 K_COD       OUT NUMBER,
                                 K_MENSAJE   OUT VARCHAR2) is
  begin
    k_cod     := 0;
    k_mensaje := 'Exito';

    UPDATE telefonia.numtel nt
    SET nt.estnumtel = k_estnumtel,
        nt.tipnumtel = k_tipnumtel,
        nt.fecasg    = SYSDATE,
        nt.fecusu    = SYSDATE,
        nt.codusu    = USER,
        nt.codinssrv = k_codinssrv,
        nt.simcard   = k_simcard,
        nt.publicar =  k_publicar
    WHERE nt.codnumtel = k_codnumtel;
  EXCEPTION
    WHEN OTHERS THEN
      k_cod     := -1;
      k_mensaje := 'Error al realizar update a la NUMTEL : ' || sqlerrm;
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSI_INSERT_RESERVATEL(K_CODNUMTEL IN RESERVATEL.CODNUMTEL%TYPE,
                                     K_CODINSSRV IN INSSRV.CODINSSRV%TYPE,
                                     K_ESTNUMTEL IN NUMBER,
                                     K_CODCLI    IN INSSRV.CODCLI%TYPE,
                                     K_COD       OUT NUMBER,
                                     K_MENSAJE   OUT VARCHAR2) IS
  begin
    k_cod:=0;
    k_mensaje:='Exito';

    insert into telefonia.reservatel
      (codnumtel,
       numslc,
       numpto,
       valido,
       estnumtel,
       fecinires,
       codusures,
       codcli)
    values
      (k_codnumtel,
       (select i.numslc from operacion.insprd i where i.codinssrv=k_codinssrv and i.flgprinc=1 and i.estinsprd=1),
       (select i.numpto from operacion.insprd i where i.codinssrv=k_codinssrv and i.flgprinc=1 and i.estinsprd=1),
       0,
       k_estnumtel,
       SYSDATE,
       USER,
       k_codcli);
  EXCEPTION
    WHEN OTHERS THEN
      k_cod:=-1;
      k_mensaje:='Error al Asociar Numero : ' || sqlerrm;
  end;
  /* **********************************************************************************************/
  PROCEDURE SIACSS_CONSULTA_TRAMA(K_CODSOLOT      IN SOLOT.CODSOLOT%TYPE,
                                  K_IDTRANSACCION OUT SALES.SIACT_UTIL_TRAMA.TRAMN_IDTRANSACCION%TYPE,
                                  K_IDINTERACCION OUT SALES.SIACT_UTIL_TRAMA.TRAMN_IDINTERACCION%TYPE,
                                  K_CO_ID         OUT SALES.SIACT_UTIL_TRAMA.TRAMN_CO_ID%TYPE,
                                  K_CUSTOMER_ID   OUT SALES.SIACT_UTIL_TRAMA.TRAMN_CUSTOMER_ID%TYPE,
                                  K_TRAMA         OUT SALES.SIACT_UTIL_TRAMA.TRAMV_TRAMA%TYPE) IS
  BEGIN

   SELECT s.tramn_idtransaccion, s.tramn_idinteraccion, s.tramv_trama, s.tramn_co_id, s.tramn_customer_id
      INTO k_idtransaccion, k_idinteraccion, k_trama, k_co_id, k_customer_id
      FROM sales.siact_util_trama s
     WHERE s.tramn_codsolot = k_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACSS_CONSULTA_TRAMA: ' || 'No Existe CODSOLOT en la tabla SALES.SIACT_UTIL_TRAMA');
  END;
  /* **********************************************************************************************/
  FUNCTION SIACFUN_OBTIENE_SOT(K_IDWF      IN WF.IDWF%TYPE)
                               RETURN NUMBER IS
  c_codsolot solot.codsolot%TYPE;

  BEGIN

    SELECT codsolot INTO c_codsolot FROM wf WHERE idwf = k_idwf AND valido = 1;

    RETURN c_codsolot;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'siacfun_obtiene_sot: ' || 'SOT no tiene WF Asignado');

  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_ROLLBACK_ESTADO(K_CODSOLOT IN SOLOT.CODSOLOT%TYPE,
                                   K_COD_ERR  OUT NUMBER,
                                   K_MSN_ERR  OUT VARCHAR2) IS

    v_idtransaccion   sales.siact_util_trama.tramn_idtransaccion%TYPE;
    v_numero          numtel.numero%TYPE;
    v_trama           sales.siact_util_trama.tramv_trama%TYPE;
    v_dnid            NUMBER;
    v_error           CONSTANT VARCHAR2(100) := 'Error Anular la SOT';
    v_idinteraccion   sales.siact_util_trama.tramn_idinteraccion%TYPE;
    v_tipotransaccion VARCHAR2(100);
    v_cant_cn         NUMBER;
    v_co_id           solot.cod_id%TYPE;
    v_customer_id     solot.customer_id%TYPE;
    v_cant_wf         NUMBER;
    v_numero_old      NUMTEL.NUMERO%TYPE;
    c_codinssrv       INSSRV.CODINSSRV%TYPE;
    c_codcli          VTATABCLI.CODCLI%TYPE;
    c_codnumtel       NUMTEL.CODNUMTEL%TYPE;

  BEGIN
    k_COD_ERR := 0;
    k_MSN_ERR := 'OK';

    SELECT count(1)
      INTO v_cant_cn
      FROM tipopedd t, opedd o, solot s
     WHERE t.tipopedd = o.tipopedd
       AND t.abrev = 'CAMBIO_NUMERO_SIAC_UNICO'
       AND o.codigon = s.tiptra
       AND s.codsolot = k_codsolot;

    IF v_cant_cn > 0 THEN

      SIACSS_CONSULTA_TRAMA(k_codsolot,
                            v_idtransaccion,
                            v_idinteraccion,
                            v_co_id,
                            v_customer_id,
                            v_trama);

      SELECT count(*) INTO v_cant_wf FROM wf WHERE codsolot = k_codsolot;

      IF v_cant_wf > 0 THEN

         SELECT i.codinssrv, i.codcli, n.codnumtel
           into c_codinssrv, c_codcli, c_codnumtel
           FROM solotpto pto, inssrv i, sales.siact_util_trama s, numtel n
          WHERE pto.codinssrv = i.codinssrv
            AND pto.codsolot = s.tramn_codsolot
            AND i.tipsrv = g_telefonia
            AND i.numero = n.numero
            AND pto.codsolot = k_codsolot;

        v_numero_old := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEF:',v_trama);
        UPDATE inssrv SET numero = v_numero_old WHERE codinssrv = c_codinssrv;
        UPDATE numtel set estnumtel = 2 , codinssrv = c_codinssrv WHERE numero = v_numero_old;

        DELETE FROM telefonia.reservatel r
         WHERE r.codnumtel = c_codnumtel
           AND r.estnumtel = 2
           AND r.numslc = (select i.numslc
                             from operacion.insprd i
                            where i.codinssrv = c_codinssrv
                              and i.flgprinc = 1)
           AND r.numpto = (select i.numpto
                             from operacion.insprd i
                            where i.codinssrv = c_codinssrv
                              and i.flgprinc = 1)
           AND r.codcli = c_codcli;

      END IF;


      v_numero := operacion.pkg_siac_postventa.SIACFUN_GET_PARAMETER('NRO_TELEFNUEV:',v_trama);
      BEGIN

        SIACSU_ROLLBACK_NUMERO(v_idtransaccion,
                               v_numero,
                               k_cod_err,
                               k_msn_err);
      EXCEPTION
        WHEN OTHERS THEN
          k_msn_err := $$PLSQL_UNIT || '.' || 'SIACSU_ROLLBACK_NUMERO: ' ||
                        sqlcode || ' ' || sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';

          operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                               v_idinteraccion,
                                                               v_tipotransaccion,
                                                               k_codsolot,
                                                               NULL,
                                                               k_msn_err,
                                                               v_error);
          raise_application_error(-20001, k_msn_err);
      END;

      TIM.PP004_SIAC_LTE.SIACSU_LIBERA_LINEA@dbl_bscs_bf(v_numero,
                                                         v_dnid,
                                                         k_cod_err,
                                                         k_msn_err);
      IF k_cod_err < 0 THEN
        ROLLBACK;
        operacion.pkg_siac_postventa.SIACSI_TRAZABILIDAD_LOG(v_idtransaccion,
                                                             v_idinteraccion,
                                                             v_tipotransaccion,
                                                             k_codsolot,
                                                             NULL,
                                                             k_msn_err,
                                                             v_error);
        raise_application_error(-20001,
                                'Error SIACSI_TRAZABILIDAD_LOG: ' ||
                                k_msn_err);
      END IF;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      K_COD_ERR := -1;
  END;
  /* **********************************************************************************************/
  PROCEDURE SIACSU_VALIDA_NUMERO (K_NUMERO IN NUMTEL.NUMERO%TYPE) IS

  c_estnumtel      numtel.estnumtel%type;
  c_descripcion    estnumtel.descripcion%TYPE;
  c_dn_status      varchar2(5);
  v_dn_id          number(20);
  v_cod_err        number(5);
  v_msn_err        varchar(4000);
  v_error_general  EXCEPTION;
  V_VALOR          NUMBER(8);

  PRAGMA AUTONOMOUS_TRANSACTION;

  BEGIN
     BEGIN
        SELECT codigon
          INTO V_VALOR
          FROM opedd op
         WHERE op.abreviacion = 'ACT_CNUM'
           AND op.tipopedd =
               (SELECT tipopedd
                  FROM operacion.tipopedd b
                 WHERE B.ABREV = 'CONF_WLLSIAC_CP');
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            V_VALOR := 0;
    END;

    IF V_VALOR = 1 THEN
      /*VALIDAMOS ESTADO RESERVADO EN SGA*/
      BEGIN
       SELECT n.estnumtel INTO c_estnumtel FROM numtel n WHERE n.numero = k_numero;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             V_MSN_ERR := 'Numero '||k_numero|| ' no existe en la Numtel SGA - OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_VALIDA_NUMERO';
             raise v_error_general;
       END;

       IF c_estnumtel = 6 THEN
          /*VALIDAMOS ESTADO ASIGNADO EN BSCS*/
          BEGIN
            SELECT dn_status INTO c_dn_status FROM directory_number@DBL_BSCS_BF WHERE dn_num = k_numero;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
             V_MSN_ERR := 'Numero '||k_numero|| ' no existe en la directory_number BSCS - OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_VALIDA_NUMERO';
             raise v_error_general;
          END;
          IF c_dn_status = 'r' THEN

             tim.pp004_siac_lte.siacsu_asigna_linea@dbl_bscs_bf(k_numero, v_dn_id, v_cod_err, v_msn_err);
             IF v_cod_err <> 0 THEN
                v_msn_err := 'tim.pp004_siac_lte.siacsu_asigna_linea: '||v_msn_err||' - OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_VALIDA_NUMERO';
                raise v_error_general;
             END IF;
             COMMIT;
          END IF;
       ELSE
           SELECT e.descripcion INTO c_descripcion FROM estnumtel e WHERE e.estnumtel = c_estnumtel;
            V_MSN_ERR := 'Numero '||k_numero|| ' se encuenta en estado '||c_descripcion||'  - OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_VALIDA_NUMERO';
            raise v_error_general;
       END IF;
    END IF;

  EXCEPTION
    WHEN v_error_general THEN
       ROLLBACK;
         RAISE_APPLICATION_ERROR(-20000,v_msn_err);
    WHEN OTHERS THEN
   ROLLBACK;
     RAISE_APPLICATION_ERROR(-20000,$$PLSQL_UNIT || '.' || 'SIACSU_VALIDA_NUMERO' ||
                              ' -- ' || SQLERRM);
  END;
  /* **********************************************************************************************/

  FUNCTION SIACFUN_VALIDA_NUM(NUMERO_ANT IN VARCHAR,
                               CO_ID IN NUMBER)
                               RETURN NUMBER IS
          LN_VAL_NUMERO NUMBER;

     BEGIN

     select COUNT(1)
     INTO LN_VAL_NUMERO
     from contr_services_cap@Dbl_Bscs_Bf csc, directory_number@Dbl_Bscs_Bf dn
       where csc.DN_ID = DN.DN_ID
--       and csc.seqno = (select max(cs.seqno) from contr_services_cap@Dbl_Bscs_Bf cs where cs.co_id = csc.co_id) - 1
       and csc.co_id = CO_ID
       and dn.dn_num = NUMERO_ANT;


    RETURN LN_VAL_NUMERO;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.' ||
                              'SIACFUN_VALIDA_NUM: ' || 'OCURRIO UN ERROR EN LA FN');

  END;
END;
/
