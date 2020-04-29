CREATE OR REPLACE PACKAGE BODY OPERACION.pq_janus_alta IS
  /******************************************************************************
   PROPOSITO:
  
   REVISIONES:
     Version  Fecha       Autor            Solicitado por      Descripcion
     -------  -----       -----            --------------      -----------
     1.0      26/02/2014  Mauro Zegarra    Christian Riquelme  version inicial
     2.0      08/07/2014  Juan Gonzales    Christian Riquelme  agregar validacion de envio de sucursal
  /* ***************************************************************************/
  g_linea    linea;
  g_cliente  cliente;
  g_sucursal sucursal%ROWTYPE;
  g_plan     plan%ROWTYPE;
  /* ***************************************************************************/
  PROCEDURE alta IS
  BEGIN
    IF NOT pq_int_telefonia.existe_reserva() THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Existe servicios que no tienen asignado numero ' ||
                              'telefonico, realizar asignacion y luego cambiar ' ||
                              'la tarea a estado Generada.');
    END IF;
  
    g_linea := get_linea();
  
    crear_int_plataforma_bscs();
  
    crear_int_telefonia_log();
  
    pq_janus_conexion.enviar_solicitud();
  
    pq_janus.update_int_plataforma_bscs();
  
    pq_janus.crear_tareawfseg();
  
    pq_int_telefonia.update_int_telefonia_log();
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.ALTA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_telefonia_log IS
    l_log int_telefonia_log%ROWTYPE;
  
  BEGIN
    l_log.int_telefonia_id := pq_int_telefonia.get_id();
    l_log.plataforma       := 'JANUS';
    l_log.codinssrv        := g_linea.codinssrv;
    l_log.numero           := g_linea.numero;
    l_log.pid              := g_linea.pid;
    l_log.idtrans          := pq_janus.g_idtrans;
    l_log.tx_bscs          := pq_janus.g_tx_bscs;
    pq_int_telefonia.insert_int_telefonia_log(l_log);
  
    pq_int_telefonia_log.g_id := l_log.id;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_TELEFONIA_LOG: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  PROCEDURE crear_int_plataforma_bscs IS
    C_ALTA CONSTANT int_plataforma_bscs.action_id%TYPE := 1;
    l_bscs int_plataforma_bscs%ROWTYPE;
  
  BEGIN
    g_cliente  := get_cliente();
    g_sucursal := get_sucursal();
    g_plan     := get_plan();
  
    l_bscs.codigo_cliente := pq_janus.get_conf('P_HCON') || g_linea.codcli;
    l_bscs.codigo_cuenta  := pq_janus.get_conf('P_HCCD') || g_linea.codcli;
    l_bscs.ruc            := g_cliente.ruc;
    l_bscs.nombre         := g_cliente.nomclires;
    l_bscs.apellidos      := g_cliente.apellidos;
    l_bscs.tipdide        := g_cliente.tipdide;
    l_bscs.ntdide         := g_cliente.ntdide;
    l_bscs.razon          := g_cliente.razon;
    l_bscs.telefonor1     := g_cliente.telefono1;
    l_bscs.telefonor2     := g_cliente.telefono2;
    l_bscs.email          := get_nomemail();
    l_bscs.direccion      := g_sucursal.dirsuc;
    l_bscs.referencia     := g_sucursal.referencia;
    l_bscs.distrito       := g_sucursal.nomdst;
    l_bscs.provincia      := g_sucursal.nompvc;
    l_bscs.departamento   := g_sucursal.nomest;
    l_bscs.co_id          := g_linea.codinssrv;
    l_bscs.numero         := g_linea.numero;
    l_bscs.imsi           := pq_janus.get_conf('P_IMSI') || g_linea.numero;
    l_bscs.ciclo          := get_fecini(g_linea.numslc);
    l_bscs.action_id      := C_ALTA;
    l_bscs.trama          := armar_trama();
    l_bscs.plan_base      := g_plan.plan;
    l_bscs.plan_opcional  := g_plan.plan_opcional;
    pq_janus.insert_int_plataforma_bscs(l_bscs);
  
    pq_janus.g_trama     := l_bscs.trama;
    pq_janus.g_idtrans   := l_bscs.idtrans;
    pq_janus.g_tx_bscs   := pq_janus.set_tx_bscs(C_ALTA);
    pq_janus.g_action_id := C_ALTA;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.CREAR_INT_PLATAFORMA_BSCS: ' ||
                              SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_linea RETURN linea IS
    l_linea linea;
  
  BEGIN
    SELECT e.codcli,
           e.numslc,
           h.idplan,
           e.codinssrv,
           e.numero,
           g.codsolot,
           b.pid
      INTO l_linea
      FROM wf          d,
           solotpto    a,
           insprd      b,
           tystabsrv   c,
           inssrv      e,
           solot       g,
           plan_redint h
     WHERE d.idwf = pq_int_telefonia.g_idwf
       AND a.codsolot = d.codsolot
       AND a.pid = b.pid
       AND e.tipinssrv = 3
       AND c.idplan = h.idplan
       AND h.idtipo IN (2, 3) --control, prepago
       AND b.codsrv = c.codsrv
       AND e.codinssrv = b.codinssrv
       AND a.codsolot = g.codsolot;
  
    RETURN l_linea;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_LINEA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_cliente RETURN cliente IS
    l_cliente cliente;
  
  BEGIN
    SELECT vc.tipdide,
           vc.ntdide,
           REPLACE(vc.apepatcli, '|', ' ') || ' ' ||
           REPLACE(vc.apematcli, '|', ' ') apellidos,
           REPLACE(vc.nomclires, '|', ' '),
           DECODE(vc.tipdide, '001', vc.ntdide, NULL) AS ruc,
           REPLACE(vc.nomcli, '|', ' ') AS razon,
           vc.telefono1,
           vc.telefono2
      INTO l_cliente
      FROM vtatabcli vc
     WHERE vc.codcli = g_linea.codcli;
  
    RETURN l_cliente;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_CLIENTE: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_sucursal RETURN sucursal%ROWTYPE IS
    l_sucursal sucursal%ROWTYPE;
  
  BEGIN
    SELECT REPLACE(vsuc.dirsuc, '|', ' ') dirsuc,
           REPLACE(vsuc.referencia, '|', ' ') referencia,
           vu.nomdst,
           vu.nompvc,
           vu.nomest
      INTO l_sucursal
      FROM vtasuccli vsuc,
           (SELECT DISTINCT codsuc
              FROM vtadetptoenl vdet
             WHERE vdet.numslc = g_linea.numslc) vv,
           v_ubicaciones vu
     WHERE vsuc.codsuc = vv.codsuc
       AND vsuc.ubisuc = vu.codubi(+);
  
    RETURN l_sucursal;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_SUCURSAL: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_plan RETURN plan%ROWTYPE IS
    l_plan plan%ROWTYPE;
  
  BEGIN
    SELECT t.plan, t.plan_opcional
      INTO l_plan
      FROM plan_redint t
     WHERE t.idplan = g_linea.idplan;
  
    RETURN l_plan;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000, $$PLSQL_UNIT || '.GET_PLAN: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_nomemail RETURN vtaafilrecemail.nomemail%TYPE IS
    l_nomemail vtaafilrecemail.nomemail%TYPE;
  
  BEGIN
    SELECT z.nomemail
      INTO l_nomemail
      FROM (SELECT v.nomemail
              FROM marketing.vtaafilrecemail v
             WHERE v.codcli = g_linea.codcli
             ORDER BY v.fecusu DESC) z
     WHERE ROWNUM = 1;
  
    RETURN l_nomemail;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_NOMEMAIL: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_fecini(p_numslc vtatabslcfac.numslc%TYPE) RETURN VARCHAR2 IS
    l_dia    NUMBER;
    l_cicfac NUMBER;
  
  BEGIN
    l_dia    := pq_transfer_billing.f_get_dia_inicio(p_numslc);
    l_cicfac := pq_transfer_billing.f_obtiene_ciclo(6, l_dia);
  
    RETURN get_fecini(l_cicfac);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.GET_FECINI: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  FUNCTION get_fecini(p_cicfac fechaxciclo.cicfac%TYPE) RETURN VARCHAR2 IS
    l_fecini_cicfac VARCHAR2(2);
  
  BEGIN
    SELECT DISTINCT (TO_CHAR(fecini, 'DD'))
      INTO l_fecini_cicfac
      FROM fechaxciclo
     WHERE cicfac = p_cicfac;
  
    RETURN l_fecini_cicfac;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN '01';
  END;
  /* ***************************************************************************/
  FUNCTION armar_trama RETURN VARCHAR2 IS
    l_trama VARCHAR2(32767);
  
  BEGIN
    l_trama := pq_janus.get_conf('P_HCON') || g_linea.codcli || '|';
    l_trama := l_trama || pq_janus.get_conf('P_HCCD') || g_linea.codcli || '|';
    l_trama := l_trama || g_cliente.ruc || '|';
    l_trama := l_trama || g_cliente.nomclires || '|';
    l_trama := l_trama || g_cliente.apellidos || '|';
    l_trama := l_trama || g_cliente.tipdide || '|';
    l_trama := l_trama || g_cliente.ntdide || '|';
    l_trama := l_trama || g_cliente.razon || '|';
    l_trama := l_trama || g_cliente.telefono1 || '|';
    l_trama := l_trama || g_cliente.telefono2 || '|';
    l_trama := l_trama || get_nomemail() || '|';
    l_trama := l_trama || trim_dato('DIRSUC', g_sucursal.dirsuc) || '|'; --2.0
    l_trama := l_trama || trim_dato('REFERENCIA', g_sucursal.referencia) || '|'; --2.0
    l_trama := l_trama || g_sucursal.nomdst || '|';
    l_trama := l_trama || g_sucursal.nompvc || '|';
    l_trama := l_trama || g_sucursal.nomest || '|';
    l_trama := l_trama || g_linea.codinssrv || '|';
    l_trama := l_trama || g_linea.numero || '|';
    l_trama := l_trama || pq_janus.get_conf('P_IMSI') || g_linea.numero || '|';
    l_trama := l_trama || get_fecini(g_linea.numslc) || '|';
    l_trama := l_trama || g_plan.plan || '|';
    l_trama := l_trama || g_plan.plan_opcional;
  
    encode(l_trama); --2.0
  
    RETURN l_trama;
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.ARMAR_TRAMA: ' || SQLERRM);
  END;
  /* ***************************************************************************/
  --ini 2.0
  FUNCTION trim_dato(p_dato VARCHAR2, p_string VARCHAR2) RETURN VARCHAR2 IS
    l_length opedd.codigon%TYPE;
  
  BEGIN
    SELECT d.codigon
      INTO l_length
      FROM tipopedd c, opedd d
     WHERE c.abrev = 'PLAT_JANUS'
       AND c.tipopedd = d.tipopedd
       AND d.abreviacion = p_dato;
  
    RETURN SUBSTR(p_string, 1, l_length);
  
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,
                              $$PLSQL_UNIT || '.TRIM_DATO: ' || SQLERRM);
  END;
  /* **********************************************************************************************/
  PROCEDURE encode(p_string IN OUT VARCHAR2) IS
  BEGIN
    p_string := REPLACE(p_string, chr(209), chr(78));
    p_string := REPLACE(p_string, chr(38), chr(32));
    p_string := CONVERT(p_string, 'US7ASCII', 'WE8ISO8859P1');
  END;
  /* **********************************************************************************************/
--fin 2.0
END;
/
