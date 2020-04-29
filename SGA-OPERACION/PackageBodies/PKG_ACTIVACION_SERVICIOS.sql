CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_ACTIVACION_SERVICIOS IS
  /****************************************************************
  '* Nombre Package : OPERACION.PKG_ACTIVACION_SERVICIOS
  '* Propósito : Agrupar funcionalidades para los procesos de Activación de servicios para Postventa Masivo y CE
  '* Input : --
  '* Output : --
  '* Creado por : Equipo de proyecto TOA
  '* Féc. Creación : 27/08/2018  
  '* Féc. Actualización : 18/12/2018
  '* Versión      Fecha       Autor            Solicitado por      Descripción
  '* ---------  ----------  ---------------    ------------------  ------------------------------------------
  '* 1.0         12-12-2018  Abel Ojeda        Abel Ojeda          Correccion para la baja automatica en Cambio de Plan y Traslado Externo
  '* 2.0         18-12-2018  Abel Ojeda        Javier Cornejo      Actualizacion de registros multiples y solo validacion por numero de proyecto
  '****************************************************************/

  /****************************************************************
  '* Nombre SP : SGASS_SERVICIOS_SOT
  '* Propósito : Recuperar los datos de servicios ha dar de baja.
  '* Input : <pi_codsolot_alta>   - SOT de alta
  <pi_codsolot_baja>     - SOT de baja
  <pi_co_id_old> - Contrato BSCS antiguo
  <pi_customer_id> - ID BSCS del cliente
  <pi_codcli>     - Código de cliente SGA
  '* Output :<po_dato> - Cursor con servicios del cliente
  '* Creado por : Equipo de proyecto HFC Masivo CE
  '* Fec Creación : 23/08/2018
  '* Fec Actualización : 10/09/2018
  '****************************************************************/
  PROCEDURE sgass_servact_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                              pi_codsolot_baja operacion.solot.codsolot%TYPE,
                              pi_co_id_old     NUMBER,
                              pi_customer_id   NUMBER, --variable de contingencia ante posible error
                              pi_codcli        VARCHAR2,
                              po_dato          OUT SYS_REFCURSOR) IS
    lv_numslc_new   VARCHAR2(10);
    lv_numslc_old   VARCHAR2(10);
    ln_codsolot_old NUMBER;
    ln_codsolot_ref NUMBER;
    ln_flj          NUMBER;
  BEGIN
  
    SELECT intraway.pq_provision_itw.f_valdflujo(pi_codsolot_alta)
      INTO ln_flj
      FROM dual; --1 BSCS, 0 SGA
  
    IF ln_flj = 0 THEN
      IF nvl(pi_codsolot_baja, 0) = 0 THEN
        SELECT s.numslc
          INTO lv_numslc_new
          FROM operacion.solot s
         WHERE s.codsolot = pi_codsolot_alta
           AND s.codcli = pi_codcli;
      
        BEGIN
          SELECT spp.prorv_numslc_ori
            INTO lv_numslc_old
            FROM operacion.sgat_postv_proyecto_origen spp
           WHERE spp.prorv_numslc_new = lv_numslc_new;
        
          SELECT s.codsolot
            INTO ln_codsolot_old
            FROM operacion.solot s
           WHERE s.numslc = lv_numslc_old
             AND s.codcli = pi_codcli;
        EXCEPTION
          WHEN no_data_found THEN
            ln_codsolot_ref := 0; --ERROR, DEBE COLOCAR SOT DE BAJA EN VENTANA
        END;
      
        ln_codsolot_ref := ln_codsolot_old;
      ELSE
        ln_codsolot_ref := pi_codsolot_baja;
      END IF;
    ELSIF ln_flj = 1 THEN
      ln_codsolot_ref := operacion.pq_sga_iw.f_max_sot_x_cod_id(pi_co_id_old);
    END IF;
  
    OPEN po_dato FOR
      SELECT ip.pid,
             spo.cid,
             spo.codinssrv,
             ip.codsrv,
             ty.dscsrv,
             ip.cantidad,
             ip.codequcom,
             ip.iddet,
             ln_codsolot_ref codsolot
        FROM operacion.insprd ip
       INNER JOIN (SELECT DISTINCT codinssrv, codsolot, pid, cid
                     FROM operacion.solotpto) spo
          ON ip.codinssrv = spo.codinssrv
         AND ip.pid = spo.pid
       INNER JOIN sales.tystabsrv ty
          ON ip.codsrv = ty.codsrv
       WHERE ip.estinsprd IN (1, 2) -- Valida si esta activo o suspendido
         AND ip.codequcom IS NULL
         AND spo.codsolot = ln_codsolot_ref;
  END sgass_servact_sot;

  /****************************************************************
  '* Nombre SP : sgass_equact_sot
  '* Propósito : Recuperar los datos de servicios ha dar de baja.
  '* Input : <pi_codsolot_alta>   - SOT de alta
  <pi_codsolot_baja>     - SOT de baja
  <pi_co_id_old> - Contrato BSCS antiguo
  <pi_customer_id> - ID BSCS del cliente
  <pi_codcli>     - Código de cliente SGA
  '* Output :<po_dato> - Cursor con servicios del cliente
  '* Creado por : Equipo de proyecto HFC Masivo CE
  '* Fec Creación : 23/08/2018
  '* Fec Actualización : 10/09/2018
  '****************************************************************/
  PROCEDURE sgass_equact_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                             pi_codsolot_baja operacion.solot.codsolot%TYPE,
                             pi_co_id_old     NUMBER,
                             pi_customer_id   NUMBER, --variable de contingencia ante posible error
                             pi_codcli        VARCHAR2,
                             po_dato          OUT SYS_REFCURSOR) IS
    lv_numslc_new   VARCHAR2(10);
    lv_numslc_old   VARCHAR2(10);
    ln_codsolot_old NUMBER;
    ln_codsolot_ref NUMBER;
    ln_flj          NUMBER;
  BEGIN
  
    SELECT intraway.pq_provision_itw.f_valdflujo(pi_codsolot_alta)
      INTO ln_flj
      FROM dual; --1 BSCS, 0 SGA
  
    IF ln_flj = 0 THEN
      IF nvl(pi_codsolot_baja, 0) = 0 THEN
        SELECT s.numslc
          INTO lv_numslc_new
          FROM operacion.solot s
         WHERE s.codsolot = pi_codsolot_alta
           AND s.codcli = pi_codcli;
      
        BEGIN
          SELECT spp.prorv_numslc_ori
            INTO lv_numslc_old
            FROM operacion.sgat_postv_proyecto_origen spp
           WHERE spp.prorv_numslc_new = lv_numslc_new;
        
          SELECT s.codsolot
            INTO ln_codsolot_old
            FROM operacion.solot s
           WHERE s.numslc = lv_numslc_old
             AND s.codcli = pi_codcli;
        EXCEPTION
          WHEN no_data_found THEN
            ln_codsolot_ref := 0; --ERROR, DEBE COLOCAR SOT DE BAJA EN VENTANA
        END;
      
        ln_codsolot_ref := ln_codsolot_old;
      ELSE
        ln_codsolot_ref := pi_codsolot_baja;
      END IF;
    ELSIF ln_flj = 1 THEN
      ln_codsolot_ref := operacion.pq_sga_iw.f_max_sot_x_cod_id(pi_co_id_old);
    END IF;
  
    OPEN po_dato FOR
      SELECT ip.pid,
             spo.cid,
             spo.codinssrv,
             ip.codsrv,
             ty.dscsrv,
             ip.cantidad,
             ip.codequcom,
             ip.iddet,
             ln_codsolot_ref codsolot
        FROM operacion.insprd ip
       INNER JOIN (SELECT DISTINCT codinssrv, codsolot, pid, cid
                     FROM operacion.solotpto) spo
          ON ip.codinssrv = spo.codinssrv
         AND ip.pid = spo.pid
       INNER JOIN sales.tystabsrv ty
          ON ip.codsrv = ty.codsrv
       WHERE ip.estinsprd IN (1, 2) -- Valida si esta activo o suspendido
         AND ip.codequcom IS NOT NULL
         AND spo.codsolot = ln_codsolot_ref;
  END sgass_equact_sot;

  /****************************************************************
  '* Nombre SP : sgass_servnew_sot
  '* Propósito : Recuperar los datos de servicios ha dar de baja.
  '* Input : <pi_codsolot_alta>   - SOT de alta
  <pi_codsolot_baja>     - SOT de baja
  <pi_co_id_old> - Contrato BSCS antiguo
  <pi_customer_id> - ID BSCS del cliente
  <pi_codcli>     - Código de cliente SGA
  '* Output :<po_dato> - Cursor con servicios del cliente
  '* Creado por : Equipo de proyecto HFC Masivo CE
  '* Fec Creación : 23/08/2018
  '* Fec Actualización : 10/09/2018
  '****************************************************************/
  PROCEDURE sgass_servnew_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                              pi_co_id_old     NUMBER,
                              pi_customer_id   NUMBER, --variable de contingencia ante posible error
                              pi_codcli        VARCHAR2,
                              po_dato          OUT SYS_REFCURSOR) IS
    lv_numslc_new   VARCHAR2(10);
    lv_numslc_old   VARCHAR2(10);
    ln_codsolot_old NUMBER;
    ln_codsolot_ref NUMBER;
    ln_flj          NUMBER;
  BEGIN
    ln_codsolot_ref := pi_codsolot_alta;
  
    OPEN po_dato FOR
      SELECT ip.pid,
             spo.cid,
             spo.codinssrv,
             ip.codsrv,
             ty.dscsrv,
             ip.cantidad,
             ip.codequcom,
             ip.iddet,
             ln_codsolot_ref codsolot
        FROM operacion.insprd ip
       INNER JOIN (SELECT DISTINCT codinssrv, codsolot, pid, cid
                     FROM operacion.solotpto) spo
          ON ip.codinssrv = spo.codinssrv
         AND ip.pid = spo.pid
       INNER JOIN sales.tystabsrv ty
          ON ip.codsrv = ty.codsrv
       WHERE ip.codequcom IS NULL
         AND spo.codsolot = ln_codsolot_ref;
  END sgass_servnew_sot;

  /****************************************************************
  '* Nombre SP : sgass_equnew_sot
  '* Propósito : Recuperar los datos de servicios ha dar de baja.
  '* Input : <pi_codsolot_alta>   - SOT de alta
  <pi_codsolot_baja>     - SOT de baja
  <pi_co_id_old> - Contrato BSCS antiguo
  <pi_customer_id> - ID BSCS del cliente
  <pi_codcli>     - Código de cliente SGA
  '* Output :<po_dato> - Cursor con servicios del cliente
  '* Creado por : Equipo de proyecto HFC Masivo CE
  '* Fec Creación : 23/08/2018
  '* Fec Actualización : 10/09/2018
  '****************************************************************/
  PROCEDURE sgass_equnew_sot(pi_codsolot_alta operacion.solot.codsolot%TYPE,
                             pi_co_id_old     NUMBER,
                             pi_customer_id   NUMBER, --variable de contingencia ante posible error
                             pi_codcli        VARCHAR2,
                             po_dato          OUT SYS_REFCURSOR) IS
    lv_numslc_new   VARCHAR2(10);
    lv_numslc_old   VARCHAR2(10);
    ln_codsolot_old NUMBER;
    ln_codsolot_ref NUMBER;
    ln_flj          NUMBER;
  BEGIN
    ln_codsolot_ref := pi_codsolot_alta;
  
    OPEN po_dato FOR
      SELECT ip.pid,
             spo.cid,
             spo.codinssrv,
             ip.codsrv,
             ty.dscsrv,
             ip.cantidad,
             ip.codequcom,
             ip.iddet,
             ln_codsolot_ref codsolot
        FROM operacion.insprd ip
       INNER JOIN (SELECT DISTINCT codinssrv, codsolot, pid, cid
                     FROM operacion.solotpto) spo
          ON ip.codinssrv = spo.codinssrv
         AND ip.pid = spo.pid
       INNER JOIN sales.tystabsrv ty
          ON ip.codsrv = ty.codsrv
       WHERE ip.codequcom IS NOT NULL
         AND spo.codsolot = ln_codsolot_ref;
  END sgass_equnew_sot;

  /****************************************************************
  '* Nombre SP : SGASI_BAJA_EQSRV_INC
  '* Propósito : Recuperar los datos de servicios ha dar de baja.
  '* Input : <pi_codsolot> - SOT para dar de baja
  '*         <pi_envio>    - Parámetro de envío
  '* Output :<po_iderr> - ID del error
  '*         <po_mserr> - Mensaje del error
  '* Creado por : Equipo de proyecto Agendamiento
  '* Fec Creación : 19/10/2018
  '* Fec Actualización : 19/10/2018
  '****************************************************************/
  PROCEDURE sgasi_baja_eqsrv_inc(pi_codsolot operacion.solot.codsolot%TYPE,
                                 pi_envio    NUMBER,
                                 po_iderr    OUT NUMBER,
                                 po_mserr    OUT VARCHAR2) IS
    ln_iderr NUMBER;
    ls_mserr VARCHAR2(500);
    ln_envio NUMBER;
  BEGIN
    ln_iderr := 0;
    ls_mserr := 'OK';
    ln_envio := pi_envio;
  
    IF nvl(ln_envio, 0) = 0 THEN
      ln_envio := 1;
    END IF;
  
    intraway.pq_provision_itw.p_int_ejecbaja(pi_codsolot,
                                             ln_iderr,
                                             ls_mserr,
                                             ln_envio);
  
    IF ln_iderr = 1 THEN
      intraway.pq_provision_itw.p_insertxsecenvio(pi_codsolot,
                                                  4,
                                                  ln_iderr,
                                                  ls_mserr);
    END IF;
  
    po_iderr := ln_iderr;
    po_mserr := ls_mserr;
  EXCEPTION
    WHEN OTHERS THEN
      po_iderr := -1;
      po_mserr := SQLERRM;
    
  END sgasi_baja_eqsrv_inc;
  /****************************************************************
  '* Nombre Fn : SGAFUN_ATRIBUTO_VALOR
  '* Propósito : Recuperar el valor de un dato de la tabla de parametros de acuerdo a un atributo.
  '* Input : <n_idtrs>     - Id de Transaccion
  <v_atributo>  - Atributo
  '* Output :<v_valor> - Valor obtenido de acuredo al atributo
  '* Creado por : Equipo de Agendamiento
  '* Fec Creación : 27/09/2018
  '* Fec Actualización : 27/09/2018
  '****************************************************************/
  FUNCTION sgafun_atributo_valor(n_idtrs NUMBER, v_atributo VARCHAR2)
    RETURN VARCHAR2 IS
    v_valor VARCHAR2(50);
  BEGIN
    SELECT d.valor
      INTO v_valor
      FROM operacion.trs_interface_iw_det d
     WHERE idtrs = n_idtrs
       AND d.atributo = v_atributo;
  
    RETURN(v_valor);
  
  EXCEPTION
    WHEN no_data_found THEN
      RETURN '';
  END sgafun_atributo_valor;

  --SGASS_RESERVA_PRODUCT
  /****************************************************************
  '* Nombre SP : SGASS_PRODUCTOS_RESERVA
  '* Propósito : Recuperar los productos para Reserva.
  '* Input : <pi_codsolot>     - Numero de SOT
  '* Output :<po_dato> - Cursor con Lista de Reservas de Productos del cliente
  '* Creado por : Equipo de Agendamiento
  '* Fec Creación : 27/09/2018
  '* Fec Actualización : 27/09/2018
  '****************************************************************/
  PROCEDURE sgass_productos_reserva(pi_codsolot operacion.solot.codsolot%TYPE,
                                    po_dato     OUT SYS_REFCURSOR) IS
  
  BEGIN
  
    OPEN po_dato FOR
      SELECT 0 sel,
             (CASE i.tip_interfase
               WHEN 'TLF' THEN
                i.tip_interfase
               WHEN 'INT' THEN
                i.tip_interfase
               WHEN 'CTV' THEN
                i.tip_interfase
               ELSE
                '   ' || i.tip_interfase
             END) tip_interfase,
             i.id_producto,
             i.id_producto_padre,
             i.id_interfase,
             decode(i.id_interfase,
                    2020,
                    (SELECT v.modeloequitw
                       FROM insprd p
                      INNER JOIN vtaequcom v
                         ON v.codequcom = p.codequcom
                      WHERE p.pid = i.pidsga
                        AND p.codequcom IS NOT NULL),
                    i.modelo) modelo,
             i.mac_address,
             i.codsolot,
             i.cod_id,
             i.unit_address,
             1 cantidad,
             i.idtrs,
             '' b_rel,
             i.estado_iw,
             estado_iw,
             i.estado_bscs estado_bscs,
             i.trs_prov_bscs trs_prov_bscs,
             i.codinssrv,
             i.pidsga,
             operacion.pkg_activacion_servicios.sgafun_atributo_valor(i.idtrs,
                                                                      'activationCode') AS activationcode,
             operacion.pkg_activacion_servicios.sgafun_atributo_valor(i.idtrs,
                                                                      'defaultProductCRMId') AS productcrmid,
             operacion.pkg_activacion_servicios.sgafun_atributo_valor(i.idtrs,
                                                                      'channelMapCRMId') AS channelmap,
             operacion.pkg_activacion_servicios.sgafun_atributo_valor(i.idtrs,
                                                                      'defaultConfigCRMId') AS configcrmid
        FROM operacion.trs_interface_iw i
       WHERE i.codsolot = pi_codsolot
         AND i.id_interfase IN (620, 820, 2020, 2030, 2050);
  
  END sgass_productos_reserva;
  
  /****************************************************************
  '* Nombre SP : SGASI_PREPA_BAJA_AUTO
  '* Propósito : Prepara la baja automática para cambio de plan con el projecto válido
  '*             anterior.
  '* Input : <a_idtareawf>     - Id tarea wf 
  '* Input : <a_idwf>          - Id wf
  '* Input : <a_tarea>         - Tarea
  '* Input : <a_tareadef>      - Tarea def
  '* Creado por : Equipo de TOA
  '* Fec Creación : 27/09/2018
  '* Fec Actualización : 18/12/2018
  '****************************************************************/
  PROCEDURE sgasi_prepa_baja_auto(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER) IS
    v_codcli      operacion.solot.codcli%TYPE;
    v_numslc      operacion.solot.numslc%TYPE;
    v_numregistro sales.reginsprdbaja.numregistro%TYPE;
    v_codsolot    operacion.solot.codsolot%TYPE;
    ex_error EXCEPTION;
    v_srvpri    sales.regvtamentab.srvpri%TYPE := 'CE - CAMBIO DE PLAN';
    v_obssolfac sales.regvtamentab.obssolfac%TYPE := 'TIPO DE VENTA: CAMBIO DE PLAN';
    v_deserror  VARCHAR2(500);
    --Ini v1.0    
    v_numslc_old   operacion.solot.numslc%TYPE;
    v_tiptra       operacion.solot.tiptra%TYPE;    
    v_tiptra_cp    operacion.solot.tiptra%TYPE;
    v_tiptra_ex    operacion.solot.tiptra%TYPE;    
    --Fin v1.0
    --Ini v2.0
    v_abrev_cp    VARCHAR2(20) := 'CEHFC_CP';
    v_abrev_ex    VARCHAR2(20) := 'CEHFC_TRSEXT';
    --Fin v2.0
  BEGIN
    --Ini v1.0    
    v_numslc_old := '';

    --OBTIENE EL TIPO DE TRABAJO PARA CAMBIO DE PLAN
    SELECT codigon INTO v_tiptra_cp
    FROM opedd o
    WHERE o.tipopedd = (SELECT tipopedd
                        FROM operacion.tipopedd
                        WHERE descripcion = cv_desc_trx_postv
                        AND abrev = cv_abrv_trx_postv)
    AND abreviacion = v_abrev_cp;

    --OBTIENE EL TIPO DE TRABAJO PARA TRASLADO EXTERNO
    SELECT codigon INTO v_tiptra_ex
    FROM opedd o
    WHERE o.tipopedd = (SELECT tipopedd
                        FROM operacion.tipopedd
                        WHERE descripcion = cv_desc_trx_postv
                        AND abrev = cv_abrv_trx_postv)
    AND abreviacion = v_abrev_ex;
    --Fin v1.0
    SELECT codsolot INTO v_codsolot FROM wf WHERE idwf = a_idwf;  
    BEGIN
      SELECT a.codcli, a.numslc, a.tiptra
        INTO v_codcli, v_numslc, v_tiptra
        FROM operacion.solot a
       WHERE a.codsolot = v_codsolot;
    EXCEPTION
      WHEN no_data_found THEN
        v_deserror := 'ERROR: NO SE ENCONTRO CLIENTE/NUMSLC ASOCIADO A LA SOT INGRESADA';
        RAISE ex_error;
    END;
    
    --Ini v1.0    
    BEGIN
      SELECT prorv_numslc_ori INTO v_numslc_old 
      FROM operacion.sgat_postv_proyecto_origen 
      WHERE prorv_numslc_new = v_numslc and prorv_codcli = v_codcli;
    EXCEPTION
      WHEN no_data_found THEN
       v_deserror := 'ERROR: NO SE ENCONTRO ULTIMO PROYECTO ANTERIOR ACTIVO';
       RAISE ex_error;
      WHEN too_many_rows THEN
       --Ini v2.0
       SELECT X.prorv_numslc_ori INTO v_numslc_old 
       FROM (SELECT prorv_numslc_ori 
             FROM operacion.sgat_postv_proyecto_origen
             WHERE prorv_numslc_new = v_numslc
             AND prorv_codcli = v_codcli        
             ORDER BY to_number(nvl(prorv_numslc_new,'0')) DESC) X
       WHERE rownum = 1;
       --Fin v2.0
    END;
    
    IF v_tiptra = v_tiptra_cp THEN
     v_srvpri := 'CE - CAMBIO DE PLAN';
     v_obssolfac := 'TIPO DE VENTA: CAMBIO DE PLAN';     
    ELSE 
      IF v_tiptra = v_tiptra_ex THEN
       v_srvpri := 'CE - TRASLADO EXTERNO';
       v_obssolfac := 'TIPO DE VENTA: TRASLADO EXTERNO';       
      END IF;
    END IF;
    --Fin v1.0
    INSERT INTO sales.regvtamentab
      (codcli, numslc, srvpri, obssolfac, codsolot)
    VALUES
      (v_codcli, v_numslc, v_srvpri, v_obssolfac, v_codsolot)
    RETURNING numregistro INTO v_numregistro;
  
    INSERT INTO sales.reginsprdbaja
    (pid, numregistro, numslc, codinssrv)
    SELECT DISTINCT p.pid, v_numregistro, v_numslc, p.codinssrv
    FROM inssrv s, insprd p
    WHERE s.codinssrv = p.codinssrv     
     AND s.numslc = v_numslc_old --v1.0     
     AND p.estinsprd IN (c_activo, c_suspendido, c_pendiente_x_activar)
     AND p.fecfin IS NULL;
  EXCEPTION
    WHEN ex_error THEN
      raise_application_error(-20001, v_deserror);
    WHEN OTHERS THEN
      raise_application_error(-20001,
                              $$PLSQL_UNIT || '.' ||
                              'SGASI_PREPA_BAJA_AUTO: ' || SQLERRM ||
                              ' - Linea (' ||
                              dbms_utility.format_error_backtrace || ')');
  END sgasi_prepa_baja_auto;

-- Inicio de Mejora
END PKG_ACTIVACION_SERVICIOS;
/